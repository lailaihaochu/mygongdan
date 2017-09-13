package com.jinbang.gongdan.modules.wo.service;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.modules.sys.dao.UserDao;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.dao.*;
import com.jinbang.gongdan.modules.wo.entity.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.common.utils.StringUtils;

/**
 * 工单相关Service
 * @author 许江辉
 * @version 2016-07-05
 */
@Service
@Transactional(readOnly = true)
public class WoWorksheetService extends CrudService<WoWorksheetDao, WoWorksheet> {

	@Autowired
	private WoWorkDetailDao woWorkDetailDao;

	@Autowired
	private WoMsgRecordDao woMsgRecordDao;

	@Autowired
	private WorksheetFilesDao worksheetFilesDao;

	@Autowired
	private WoStatusLogDao woStatusLogDao;

	@Autowired
	private WoFeeItemDao woFeeItemDao;

	@Autowired
	private UserDao userDao;
	@Autowired
	private PoRecordDao poRecordDao;

	@Autowired
	private WoDeviceDao woDeviceDao;

	public WoWorksheet get(String id) {
		WoWorksheet woWorksheet = super.get(id);
		woWorksheet.setDetailList(woWorkDetailDao.findList(new WoWorkDetail(woWorksheet)));
		woWorksheet=getEngineers(woWorksheet);//获取运维人员
		woWorksheet=getDevices(woWorksheet);//获取关联设备
		return woWorksheet;
	}
	public WoWorksheet getEngineers(WoWorksheet woWorksheet){
		List<User> unCheckedList =userDao.findUserByWorkSheetId(woWorksheet.getId(),"0");
		List<User> checkedList =userDao.findUserByWorkSheetId(woWorksheet.getId(),"1");
		woWorksheet.setCheckedUsers(checkedList);
		woWorksheet.setUnCheckedUsers(unCheckedList);
		return woWorksheet;
	}
	public WoWorksheet getDevices(WoWorksheet woWorksheet){
		List<WoDevice> deviceList = Lists.newArrayList();
		List<String> deviceIdList =dao.findDeviceIdsByWorkSheetId(woWorksheet.getId());
		if (deviceIdList .size() > 0) {
			for (int i = 0; i < deviceIdList.size(); i++) {
				/*WoDevice dev = new WoDevice();
				dev.setId(deviceIdList.get(i));*/
				WoDevice dev = woDeviceDao.get(deviceIdList.get(i));
				if(dev != null){
					deviceList.add(dev);
				}
			}
		}
		woWorksheet.setDeviceList(deviceList);
		return woWorksheet;
	}
	public WoWorksheet getMsgRecords(WoWorksheet woWorksheet){
		List<WoMsgRecord> msgRecords=woMsgRecordDao.findByWorksheet(woWorksheet.getId());
		woWorksheet.setMsgRecords(msgRecords);
		return woWorksheet;
	}
	public List<WoWorksheet> findList(WoWorksheet woWorksheet) {
		return super.findList(woWorksheet);
	}
	
	public Page<WoWorksheet> findPage(Page<WoWorksheet> page, WoWorksheet woWorksheet) {
		// 设置默认时间范围，
		if (woWorksheet.getEndDate() != null){
			woWorksheet.setEndDate(DateUtils.getDateEnd(woWorksheet.getEndDate()));
		}
		if (woWorksheet.getBeginDate() != null){
			woWorksheet.setBeginDate(DateUtils.getDateStart(woWorksheet.getBeginDate()));
		}
		return super.findPage(page, woWorksheet);
	}
	public List<WoStatusLog> getStatusLogs(WoWorksheet woWorksheet){
		WoStatusLog statusLog=new WoStatusLog();
		statusLog.setWoWorksheet(woWorksheet);
		return woStatusLogDao.findList(statusLog);
	}
	@Transactional(readOnly = false)
	public void saveStatusLog(WoStatusLog woStatusLog){
		woStatusLog.preInsert();
		woStatusLogDao.insert(woStatusLog);
	}

	@Transactional(readOnly = false)
	public void save(WoWorksheet woWorksheet) {
		super.save(woWorksheet);
		for (WoWorkDetail detail : woWorksheet.getDetailList()){
			if (detail.getId() == null){
				continue;
			}
			if (detail.DEL_FLAG_NORMAL.equals(detail.getDelFlag())){
				if (StringUtils.isBlank(detail.getId())){
					detail.setWoWorksheet(woWorksheet);
					detail.preInsert();
					woWorkDetailDao.insert(detail);
				}else{
					detail.preUpdate();
					woWorkDetailDao.update(detail);
				}
			}else{
				woWorkDetailDao.delete(detail);
			}
		}
		// 更新工单与设备关联

		//dao.deleteWorksheetDevice(woWorksheet);
		saveWorksheetDevices(woWorksheet.getId(),woWorksheet.getDeviceIds());
//		if (woWorksheet.getDeviceList().size() > 0){
//			dao.insertWorksheetDevice(woWorksheet);
//		}
	}

	@Transactional(readOnly = false)
	public void updateWoNo(WoWorksheet woWorksheet){
		super.save(woWorksheet);
	}
	@Transactional(readOnly = false)
	public void delete(WoWorksheet woWorksheet) {
		super.delete(woWorksheet);
	}
	@Transactional(readOnly = false)
	public Boolean outUserInWorkSheet(WoWorksheet woWorksheet, User user) {
		int isTrue=dao.deleteEngineerInWorkSheet(woWorksheet,user);
		return isTrue==1;
	}

	@Transactional(readOnly = false)
	public User assignUserToWorkSheet(WoWorksheet woWorksheet, User user) {
		if (user == null){
			return null;
		}
		woWorksheet=getEngineers(woWorksheet);
		List<String> engineerIds=woWorksheet.getEngineerIdList();
		if(engineerIds.contains(user.getId())){
			return null;
		}
		if("2".equals(woWorksheet.getEnvStatus())){
			woWorksheet.setEnvStatus("0");
			super.save(woWorksheet);
		}
		if(woWorksheet.getWoStatus().equals("1")){
			woWorksheet.setWoStatus("2");//已指派
			woWorksheet.setAssignTime(new Date());
			super.save(woWorksheet);//
			// 记录状态流转日志
		}
		dao.insertEngineerInWorkSheet(woWorksheet,user);
		WoStatusLog woStatusLog=new WoStatusLog();
		woStatusLog.setOperator(UserUtils.getUser());
		woStatusLog.setOpDate(new Date());
		woStatusLog.setOpLog("工单指派给工程师【"+user.getName()+"】");
		woStatusLog.setOpStatus(woWorksheet.getWoStatus());
		woStatusLog.setWoWorksheet(woWorksheet);
		saveStatusLog(woStatusLog);
		return user;
	}

	public List<WoWorksheet> findListByAssignedEngineer(String userId) {
		return dao.findListByAssignedEngineer(userId);
	}

	@Transactional(readOnly = false)
	public void acceptWorksheet(WoWorksheet woWorksheet,User user){
		dao.saveEngineerCheck(woWorksheet,user);
	}

	public WoWorkDetail getDetail(String id) {
		return woWorkDetailDao.get(id);
	}

	@Transactional(readOnly = false)
	public void saveDetail(WoWorkDetail detail) {
		detail.preUpdate();
		woWorkDetailDao.update(detail);
	}

	public List<WoWorkDetail> findDetailList(WoWorksheet woWorksheet) {
		WoWorkDetail woWorkDetail=new WoWorkDetail();
		woWorkDetail.setWoWorksheet(woWorksheet);
		return woWorkDetailDao.findList(woWorkDetail);
	}

	public WorksheetFiles getAttachFile(String id) {
		return worksheetFilesDao.get(id);
	}

	public List<WorksheetFiles> findAttachFiles(WoWorksheet worksheet) {
		WorksheetFiles worksheetFiles=new WorksheetFiles();
		worksheetFiles.setWorksheet(worksheet);
		return worksheetFilesDao.findList(worksheetFiles);
	}

	@Transactional(readOnly = false)
	public void saveAttachFile(WorksheetFiles worksheetFiles) {
		if(worksheetFiles.getIsNewRecord()){
			worksheetFiles.preInsert();
			worksheetFilesDao.insert(worksheetFiles);
		}else {
			worksheetFiles.preUpdate();
			worksheetFilesDao.update(worksheetFiles);
		}

	}
	@Transactional(readOnly = false)
	public void deleteAttchFile(WorksheetFiles worksheetFiles) {
		worksheetFilesDao.delete(worksheetFiles);
	}


	public WoWorksheet getBySn(String snNo) {
		return dao.getBySn(snNo);
	}

	@Transactional(readOnly = false)
	public void saveFeeItem(WoWorksheet woWorksheet){
		super.save(woWorksheet);
		int i=1;
		for(WoFeeItem item:woWorksheet.getFeeItemList()){
			item.setSort(i++);
			item.setWoWorksheet(woWorksheet);
			if(!"1".equals(item.getDelFlag())&&(item.getCost()==null||item.getCost()== BigDecimal.ZERO))
				continue;
			if(item.getIsNewRecord()&&"0".equals(item.getDelFlag())){
				item.preInsert();
				woFeeItemDao.insert(item);
			}else if(!item.getIsNewRecord()&&"0".equals(item.getDelFlag())){
				item.preUpdate();
				woFeeItemDao.update(item);
			}else if(!item.getIsNewRecord()&&"1".equals(item.getDelFlag())){
				item.preUpdate();
				woFeeItemDao.delete(item);
			}

		}
	}
	public List<WoFeeItem> findByWorksheet(WoWorksheet woWorksheet){
		WoFeeItem item=new WoFeeItem();
		item.setWoWorksheet(woWorksheet);
		return woFeeItemDao.findByWorksheet(item);
	}

	public Page<WoWorksheet> findPageForPO(Page<WoWorksheet> page, WoWorksheet woWorksheet) {
		// 设置默认时间范围，
		/*if (woWorksheet.getEndDate() == null){
			woWorksheet.setEndDate(DateUtils.getDateEnd(new Date()));
		}else{
			woWorksheet.setEndDate(DateUtils.getDateEnd(woWorksheet.getEndDate()));
		}
		if (woWorksheet.getBeginDate() == null){
			woWorksheet.setBeginDate(DateUtils.getDateStart(DateUtils.addMonths(woWorksheet.getEndDate(),-1)));
		}else{
			woWorksheet.setBeginDate(DateUtils.getDateStart(woWorksheet.getBeginDate()));
		}*/
		if (woWorksheet.getEndDate() != null){
			woWorksheet.setEndDate(DateUtils.getDateEnd(woWorksheet.getEndDate()));
		}
		if (woWorksheet.getBeginDate() != null){
			woWorksheet.setBeginDate(DateUtils.getDateStart(woWorksheet.getBeginDate()));
		}
		woWorksheet.setPage(page);
		page.setList(dao.findListForPO(woWorksheet));
		return page;
	}

	public List<WoWorksheet> findListByPO(String poId) {
		return dao.findListByPoId(poId);
	}

	public boolean checkFeeEditable(WoWorksheet woWorksheet) {
		PoRecord poRecord=poRecordDao.getByWoId(woWorksheet.getId());
		if(poRecord==null){
			return true;
		}else if("1".equals(poRecord.getStatus())){
			return true;
		}else{
			return false;
		}
	}

	public Long getWorkSheetCount(WoWorksheet woWorksheet) {
		return dao.count(woWorksheet);
	}

	@Transactional(readOnly = false)
	public void saveWorksheetDevices(String worksheetId, String deviceIds){
		if(deviceIds != null && !"".equals(deviceIds)){
			if(deviceIds.charAt(deviceIds.length() - 1) == ','){
				deviceIds = deviceIds.substring(0,deviceIds.length()-1);
			}
		}else{
			deviceIds = "";
		}
		WoWorksheet woWorksheet = new WoWorksheet();
		woWorksheet.setId(worksheetId);
		dao.deleteWorksheetDevice(woWorksheet);
		if(deviceIds.length()>0){
			String[] devArrays = deviceIds.split(",");
			if(devArrays.length > 0){
				List<WoDevice> devList = Lists.newArrayList();
				for (int i = 0; i < devArrays.length; i++) {
					WoDevice dev = new WoDevice();
					dev.setId(devArrays[i]);
					devList.add(dev);
				}
				woWorksheet.setDeviceList(devList);
				dao.insertWorksheetDevice(woWorksheet);
			}
		}
	}

	public List<String> findDeviceIdsByWorkSheetId(String worksheetId){
		return dao.findDeviceIdsByWorkSheetId(worksheetId);
	}
}