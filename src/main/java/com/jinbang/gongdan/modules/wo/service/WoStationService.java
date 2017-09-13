package com.jinbang.gongdan.modules.wo.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.sys.dao.UserDao;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.dao.WoEmployeeDao;
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.wo.entity.WoStation;
import com.jinbang.gongdan.modules.wo.dao.WoStationDao;

/**
 * 运作站点基本信息Service
 * @author 许江辉
 * @version 2016-06-27
 */
@Service
@Transactional(readOnly = true)
public class WoStationService extends CrudService<WoStationDao, WoStation> {
	@Autowired
	private UserDao userDao;

	@Autowired
	private WoEmployeeDao woEmployeeDao;

	public WoStation get(String id) {
		return super.get(id);
	}
	
	public List<WoStation> findList(WoStation woStation) {
		return super.findList(woStation);
	}
	
	public Page<WoStation> findPage(Page<WoStation> page, WoStation woStation) {
		return super.findPage(page, woStation);
	}
	
	@Transactional(readOnly = false)
	public void save(WoStation woStation) {
		dao.deleteContactByStationId(woStation.getId());
		if(woStation.getContactList().size()>0){
			List<WoEmployee> employees=new ArrayList<WoEmployee>();
			for(WoEmployee woEmployee:woStation.getContactList()){
				if(StringUtils.isNotBlank(woEmployee.getId())){
					employees.add(woEmployee);
				}
			}
			woStation.setContactList(employees);
			if (employees.size()>0){
				WoEmployee contact=woStation.getContactList().get(0);
				contact=woEmployeeDao.get(contact.getId());
				woStation.setContact(contact.getName());
				woStation.setContactTel(contact.getPhone());
				woStation.setEmail(contact.getEmail());
			}
			dao.insertContact(woStation);
		}else{
			woStation.setContact("");
			woStation.setContactTel("");
			woStation.setEmail("");
		}
		dao.deleteEngineerByStationId(woStation.getId());
		if(woStation.getEngineerList().size()>0){
			List<User> engineers=new ArrayList<User>();
			for(User engineer:woStation.getEngineerList()){
				if(StringUtils.isNotBlank(engineer.getId())){
					engineers.add(engineer);
				}
			}
			woStation.setEngineerList(engineers);
			dao.insertEngineer(woStation);
		}
		super.save(woStation);
	}
	
	@Transactional(readOnly = false)
	public void delete(WoStation woStation) {
		super.delete(woStation);
		dao.deleteContactByStationId(woStation.getId());
		dao.deleteEngineerByStationId(woStation.getId());
	}

	public WoStation getContactList(WoStation woStation) {
		woStation.setContactList(woEmployeeDao.findEmploeeByStationId(woStation.getId()));
		return woStation;
	}

	public WoStation getEngineerList(WoStation woStation) {
		woStation.setEngineerList(userDao.findUserByStationId(woStation.getId()));
		return woStation;
	}

	public List<Map<String, Object>> getStationTreeData() {
		return dao.findTreeData();
	}
}