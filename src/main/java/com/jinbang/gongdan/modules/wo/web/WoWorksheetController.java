package com.jinbang.gongdan.modules.wo.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.Collections3;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.common.utils.FileUtils;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.utils.excel.ExportExcel;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.oa.entity.OaNotify;
import com.jinbang.gongdan.modules.oa.service.OaNotifyService;
import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.service.SystemService;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.entity.*;
import com.jinbang.gongdan.modules.wo.service.WoClientService;
import com.jinbang.gongdan.modules.wo.service.WoEngineerStatusService;
import com.jinbang.gongdan.modules.wo.service.WoGenerator;
import com.jinbang.gongdan.modules.wo.service.WoWorksheetService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.*;

/**
 * 工单相关Controller
 *TODO 1 工程师角色创建的工单，默认指派给自己(ok)
 * 2 请求转派，请求协助要开始任务才出现，(ok)
 * 3 详情页缺少站点信息（ok）
 * 4 增加现场情况字段，列表中放到紧急度后面
 * 5 关闭，在完成后，不存在关闭操作(ok)
 * 6 评审号在po订单中，(ok)
 * 7 工单号自定义生成规则(ok)
 * 二期
 * 1模板管理
 * 2费用列表
 * 3po订单
 *
 * @author 许江辉
 * @version 2016-07-05
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woWorksheet")
public class WoWorksheetController extends BaseController {

	@Autowired
	private WoWorksheetService woWorksheetService;
	@Autowired
	private OaNotifyService oaNotifyService;

	@Autowired
	private WoGenerator woGenerator;
	@Autowired
	private WoClientService woClientService;
	@Autowired
	private SystemService systemService;

	@Autowired
	private WoEngineerStatusService woEngineerStatusService;
	@ModelAttribute
	public WoWorksheet get(@RequestParam(required=false) String id) {
		WoWorksheet entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = woWorksheetService.get(id);
		}
		if (entity == null){
			entity = new WoWorksheet();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:woWorksheet:view")
	@RequestMapping(value = {"list", ""})
	public String list(WoWorksheet woWorksheet, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WoWorksheet> page = woWorksheetService.findPage(new Page<WoWorksheet>(request, response), woWorksheet);
		for(WoWorksheet wo: page.getList()){
			wo=woWorksheetService.getEngineers(wo);//获取运维人员
		}
		model.addAttribute("page", page);
		return "modules/wo/woWorksheetList";
	}

	@RequiresPermissions("wo:woWorksheet:view")
	@RequestMapping(value = "form")
	public String form(WoWorksheet woWorksheet, Model model ,RedirectAttributes redirectAttributes) {
		String sStr="";
		if(woWorksheet.getIsNewRecord()){
			woWorksheet.setWoType("2");
			woWorksheet.setEmGrade("1");
			woWorksheet.setCalculateType("2");
		}
		if(woWorksheet.isSelf())
			sStr="self";
		if(!woWorksheet.getIsNewRecord()&&!"1".equals(woWorksheet.getWoStatus())){
			addMessage(redirectAttributes, "操作失败,已指派工单的内容不可以编辑！");
			return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
		}
		model.addAttribute("woWorksheet", woWorksheet);
		return "modules/wo/woWorksheetForm";
	}
	@ResponseBody
	@RequestMapping(value = "checkSn")
	public String checkUnique(String oldSn,String snNo) {
		if (snNo !=null && snNo.equals(oldSn)) {
			return "true";
		} else if (snNo !=null && woWorksheetService.getBySn(snNo) == null) {
			return "true";
		}
		return "false";
	}
	@RequiresPermissions("wo:woWorksheet:edit")
	@RequestMapping(value = "save")
	public String save(WoWorksheet woWorksheet,String assSelf, Model model, RedirectAttributes redirectAttributes) {
		String sStr="";
		if(woWorksheet.isSelf())
			sStr="self";
		if (!beanValidator(model, woWorksheet)){
			return form(woWorksheet, model,redirectAttributes);
		}
		if(woWorksheet.getIsNewRecord()){
			//TODO 增加确认是否分配给自己

			if("1".equals(woWorksheet.getWoType())){
				woWorksheet.setSnNo(null);
				woWorksheet.setEmGrade(null);
				woWorksheet.setCalculateType(null);
			}
			User user=UserUtils.getUser();
			woWorksheet.setWoClient(woClientService.get(woWorksheet.getWoClient().getId()));
			woWorksheet.setWoNo(woGenerator.getWO(woWorksheet));
			woWorksheet.setEnvStatus("0");
			woWorksheetService.save(woWorksheet);
			// 创建状态日志
			long currentTime=System.currentTimeMillis()-1000;
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date(currentTime));
			woStatusLog.setOpLog("新的工单创建了");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			if(user.getRoleNames().contains("工程师")&&"1".equals(assSelf)){//工程师角色创建的工单，默认指派给自己
				user =woWorksheetService.assignUserToWorkSheet(woWorksheet,user);
			}
		}else{
			// 信息修改
			woWorksheetService.save(woWorksheet);
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单信息修改");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
		}
		addMessage(redirectAttributes, "保存工单成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
	}
	@RequiresPermissions("wo:woWorksheet:view")
	@RequestMapping(value = "detail")
	public String detail(WoWorksheet woWorksheet ,Model model){
		woWorksheet=woWorksheetService.getEngineers(woWorksheet);//获取运维人员
		woWorksheet=woWorksheetService.getMsgRecords(woWorksheet);//获取团队消息
		List<WoStatusLog> list=woWorksheetService.getStatusLogs(woWorksheet);//获取状态流转
		List<WorksheetFiles> worksheetFiles=woWorksheetService.findAttachFiles(woWorksheet);
		List<WoFeeItem> feeItems =woWorksheetService.findByWorksheet(woWorksheet);//获取费用列表
		List<WoFeeItem> cailiaoItems=Lists.newArrayList();
		List<WoFeeItem> fenbaoItems=Lists.newArrayList();
		List<WoFeeItem> rengongItems=Lists.newArrayList();
		List<WoFeeItem> jiaotongItems=Lists.newArrayList();
		for(WoFeeItem item:feeItems){
			if("1".equals(item.getFeeType()))
				cailiaoItems.add(item);
			else if("2".equals(item.getFeeType()))
				fenbaoItems.add(item);
			else if("3".equals(item.getFeeType()))
				rengongItems.add(item);
			else if("4".equals(item.getFeeType()))
				jiaotongItems.add(item);
		}
		//model.addAttribute("feeEditable",woWorksheetService.checkFeeEditable(woWorksheet));
		model.addAttribute("cailiaoItems",cailiaoItems);
		model.addAttribute("fenbaoItems",fenbaoItems);
		model.addAttribute("rengongItems",rengongItems);
		model.addAttribute("jiaotongItems",jiaotongItems);
		model.addAttribute("statusLogs",list);
		model.addAttribute("woWorksheet", woWorksheet);
		model.addAttribute("attachFiles", worksheetFiles);

		return "modules/wo/woWorksheetDetail";
	}
	@ResponseBody
	@RequestMapping(value = "updateWoNo")
	public  RetEntity updateWoNo(WoWorksheet woWorksheet){
		RetEntity retEntity=new RetEntity();
		try{
			String no=woWorksheetService.get(woWorksheet).getSnNo();
			woWorksheetService.save(woWorksheet);
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单号【"+no+"】修改为【"+woWorksheet.getSnNo()+"】");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			String title="工单修改通知";
			String msg="工单号【"+no+"】修改为【"+woWorksheet.getSnNo()+"】";
			notifyOtherEngineers(woWorksheet,msg,title);
			retEntity.setSuccess(true);
			retEntity.setData(woWorksheet);

		}catch (Exception e){
			retEntity.setSuccess(false);
			retEntity.setMsg(e.getMessage());
			e.printStackTrace();
		}
		return  retEntity;
	}
	@ResponseBody
	@RequestMapping(value = "updateDes")
	public  RetEntity updateDes(WoWorksheet woWorksheet){
		RetEntity retEntity=new RetEntity();
		try{
			woWorksheetService.save(woWorksheet);
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单【"+woWorksheet.getSnNo()+"】执行情况修改了");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			retEntity.setSuccess(true);
			retEntity.setData(woWorksheet);
			String title="工单修改通知";
			String msg="工单【"+woWorksheet.getSnNo()+"】执行情况修改了";
			notifyOtherEngineers(woWorksheet,msg,title);
		}catch (Exception e){
			retEntity.setSuccess(false);
			retEntity.setMsg(e.getMessage());
			e.printStackTrace();
		}
		return  retEntity;
	}
	@ResponseBody
	@RequestMapping(value = "updateAdvanceTime")
	public  RetEntity updateAdDate(WoWorksheet woWorksheet){
		RetEntity retEntity=new RetEntity();
		try{
			woWorksheetService.save(woWorksheet);
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单【"+woWorksheet.getWoNo()+"】巡检模拟开始时间修改了");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			retEntity.setSuccess(true);
			retEntity.setData(woWorksheet);
			String title="工单修改通知";
			String msg="工单【"+woWorksheet.getWoNo()+"】巡检模拟开始时间修改了";
			notifyOtherEngineers(woWorksheet,msg,title);
		}catch (Exception e){
			retEntity.setSuccess(false);
			retEntity.setMsg(e.getMessage());
			e.printStackTrace();
		}
		return  retEntity;
	}
	@ResponseBody
	@RequestMapping("feeAjaxSave")
	public RetEntity feeAjaxSave(WoWorksheet woWorksheet){
		RetEntity retEntity=new RetEntity();
		try{
			woWorksheetService.saveFeeItem(woWorksheet);
			retEntity.setSuccess(true);
			// 信息修改
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单费用信息修改");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
		}catch (Exception e){
			retEntity.setSuccess(false);
			retEntity.setMsg(e.getMessage());
			e.printStackTrace();
		}
		return retEntity;
	}

	@RequiresPermissions("wo:woWorksheet:edit")
	@RequestMapping(value = "delete")
	public String delete(WoWorksheet woWorksheet, RedirectAttributes redirectAttributes) {
		String sStr="";
		if(woWorksheet.isSelf())
			sStr="self";
		woWorksheetService.delete(woWorksheet);
		addMessage(redirectAttributes, "删除工单成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
	}
	/**
	 * 工程师分配 -- 根据部门编号获取用户列表
	 * @param officeId
	 * @param response
	 * @return
	 */
	@RequiresPermissions("wo:woWorksheet:assign")
	@ResponseBody
	@RequestMapping(value = "users")
	public List<Map<String, Object>> users(String officeId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		User user = new User();
		user.setOffice(new Office(officeId));
		Page<User> page = systemService.findUser(new Page<User>(1, -1), user);
		for (User e : page.getList()) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", 0);
			map.put("name", e.getName());
			mapList.add(map);
		}
		return mapList;
	}
	@RequiresPermissions("wo:woWorksheet:assign")
	@ResponseBody
	@RequestMapping(value = "stationEngineers")
	public List<Map<String,Object>> stationEngineers(String stationId){
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<User> list = systemService.findUserByStationId(stationId);
		for (User e : list) {
			Map<String, Object> map = Maps.newHashMap();
			map.put("id", e.getId());
			map.put("pId", 0);
			map.put("name", e.getName());
			mapList.add(map);
		}
		return mapList;
	}

	@RequiresPermissions("wo:woWorksheet:assign")
	@RequestMapping(value = "assign")
	public String assign(WoWorksheet woWorksheet,Model model ){
		List<User> userList= Lists.newArrayList();
		woWorksheet=woWorksheetService.getEngineers(woWorksheet);
		userList.addAll(woWorksheet.getCheckedUsers());
		userList.addAll(woWorksheet.getUnCheckedUsers());
		model.addAttribute("userList",userList);
		return "modules/wo/woWorksheetEngineerAssign";
	}
	@RequiresPermissions("wo:woWorksheet:assign")
	@RequestMapping(value = "usertoWorksheet")
	public String selectUserToWorksheet(WoWorksheet woWorksheet, Model model) {
		User user=UserUtils.getUser();
		List<User> userList = Lists.newArrayList();
		woWorksheet=woWorksheetService.getEngineers(woWorksheet);
		List<User> list = systemService.findUserByStationId(woWorksheet.getWoStation().getId());
		userList.addAll(woWorksheet.getCheckedUsers());
		userList.addAll(woWorksheet.getUnCheckedUsers());
		List<User> resourceList=systemService.findUserByCmIdAndRoleNameLike(user.getCompany().getId(), "工程师");

		model.addAttribute("woWorksheet", woWorksheet);
		model.addAttribute("userList", userList);
		model.addAttribute("stationList", list);
		model.addAttribute("selectIds", Collections3.extractToString(userList, "name", ","));
		model.addAttribute("resourceList",resourceList);
		return "modules/wo/selectUserToWorksheet";
	}
	@RequiresPermissions("wo:woWorksheet:assign")
	@RequestMapping(value = "outWorksheet")
	public String outWorksheet(String userId, String worksheetId,Boolean self, RedirectAttributes redirectAttributes) {
		String sStr="";
		if(self!=null && self){
			sStr="&self=true";
		}
		WoWorksheet woWorksheet = woWorksheetService.get(worksheetId);
		User user = systemService.getUser(userId);
		if (UserUtils.getUser().getId().equals(userId)) {
			addMessage(redirectAttributes, "移除失败，无法从工单【" + woWorksheet.getWoNo() + "】中移除工程师【" + user.getName() + "】自己！");
		}else {

			Boolean flag = woWorksheetService.outUserInWorkSheet(woWorksheet, user);
			if (!flag) {
				addMessage(redirectAttributes, "工程师【" + user.getName() + "】从工单【" + woWorksheet.getWoNo() + "】中移除失败！");
			}else {
				//TODO 是否添加操作日志
				WoStatusLog woStatusLog=new WoStatusLog();
				woStatusLog.setOperator(UserUtils.getUser());
				woStatusLog.setOpDate(new Date());
				woStatusLog.setOpLog("工程师【"+user.getName()+"】被移除工单");
				woStatusLog.setOpStatus(woWorksheet.getWoStatus());
				woStatusLog.setWoWorksheet(woWorksheet);
				woWorksheetService.saveStatusLog(woStatusLog);
				//移除工单通知
				OaNotify oaNotify=new OaNotify();
				oaNotify.setType("4");
				oaNotify.setTitle("工单移除通知");
				oaNotify.setContent("已将您从工单【"+ woWorksheet.getWoNo() + "】指派工程师名单中移除");
				oaNotify.setWorkId(woWorksheet.getId());
				oaNotify.setCreateBy(UserUtils.getUser());
				oaNotify.setCreateDate(new Date());
				oaNotify.setUpdateBy(UserUtils.getUser());
				oaNotify.setUpdateDate(new Date());
				oaNotify.setStatus("1");//发布
				oaNotify.setOaNotifyRecordIds(user.getId());//消息接收人
				oaNotifyService.save(oaNotify);
				String title="工单移除通知";
				String msg="已将工程师【"+user.getName()+"】从工单【"+ woWorksheet.getWoNo() +"】指派工程师名单中移除";
				notifyOtherEngineers(woWorksheet,msg,title);
				addMessage(redirectAttributes, "工程师【" + user.getName() + "】从工单【" + woWorksheet.getWoNo() + "】中移除成功！");
			}
		}
		return "redirect:" + adminPath + "/wo/woWorksheet/assign?id="+woWorksheet.getId()+sStr;
	}

	@RequiresPermissions("wo:woWorksheet:assign")
	@RequestMapping(value = "assignWorksheet")
	public String assignWorksheet(WoWorksheet woWorksheet, String[] idsArr,Boolean self, RedirectAttributes redirectAttributes) {
		String sStr="";
		if(self!=null && self){
			sStr="&self=true";
		}
		StringBuilder msg = new StringBuilder();
		int newNum = 0;
		for (int i = 0; i < idsArr.length; i++) {
			User user =woWorksheetService.assignUserToWorkSheet(woWorksheet,systemService.getUser(idsArr[i]));
			if (null != user) {
				//分配工单通知
				//TODO 指派人员日志
				OaNotify oaNotify=new OaNotify();
				oaNotify.setType("4");
				oaNotify.setTitle("工单分配通知");
				oaNotify.setContent("您有新的任务，工单【"+ woWorksheet.getWoNo() + "】");
				oaNotify.setWorkId(woWorksheet.getId());
				oaNotify.setCreateBy(UserUtils.getUser());
				oaNotify.setCreateDate(new Date());
				oaNotify.setUpdateBy(UserUtils.getUser());
				oaNotify.setUpdateDate(new Date());
				oaNotify.setStatus("1");//发布
				oaNotify.setOaNotifyRecordIds(user.getId());//消息接收人
				oaNotifyService.save(oaNotify);
				String title="工单分配通知";
				String otherMsg="工单【"+ woWorksheet.getWoNo() +"】新指派工程师【"+user.getName()+"】";
				notifyOtherEngineers(woWorksheet,otherMsg,title);
				msg.append("<br/>新增工程师【" + user.getName() + "】到工单【" + woWorksheet.getWoNo() + "】！");
				newNum++;
			}
		}
		addMessage(redirectAttributes, "已成功分配 "+newNum+" 个工程师"+msg);
		return "redirect:" + adminPath + "/wo/woWorksheet/assign?id="+woWorksheet.getId()+sStr;
	}


	@RequiresPermissions("wo:woWorksheet:view")
	@RequestMapping("self")
	public String getMyWorksheet(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response,Model model){
		woWorksheet=woWorksheetService.getEngineers(woWorksheet);//获取运维人员
		woWorksheet.setSelf(true);
		Page<WoWorksheet> page = woWorksheetService.findPage(new Page<WoWorksheet>(request, response), woWorksheet);
		model.addAttribute("page", page);
		return "modules/wo/woWorksheetList";
	}
	@RequiresPermissions("wo:woWorksheet:accept")
	@RequestMapping("accept")
	public String accept(WoWorksheet woWorksheet,Model model){
		User currentUser=UserUtils.getUser();
		if(woWorksheet.getAcceptTime()==null)
			woWorksheet.setAcceptTime(new Date());
		woWorksheetService.acceptWorksheet(woWorksheet,currentUser);
		long currentTime=System.currentTimeMillis();
		//TODO 用户接受日志
		WoStatusLog woStatusLog=new WoStatusLog();
		woStatusLog.setOperator(UserUtils.getUser());
		woStatusLog.setOpDate(new Date(currentTime));
		woStatusLog.setOpLog("工程师【"+currentUser.getName()+"】接单");
		woStatusLog.setOpStatus(woWorksheet.getWoStatus());
		woStatusLog.setWoWorksheet(woWorksheet);
		woWorksheetService.saveStatusLog(woStatusLog);
		String title="工单修改通知";
		String msg="工单【"+woWorksheet.getSnNo()+"】,工程师【"+currentUser.getName()+"】接单";
		notifyOtherEngineers(woWorksheet,msg,title);
		woWorksheet =woWorksheetService.getEngineers(woWorksheet);
		if(woWorksheet.getUnCheckedUsers()==null||woWorksheet.getUnCheckedUsers().size()<=0){
			woWorksheet.setWoStatus("3");
			woWorksheetService.save(woWorksheet);
			//TODO 状态流转
			woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date(currentTime+1000));
			woStatusLog.setOpLog("工单状态改变");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
		}
		return detail(woWorksheet,model);
	}
	@RequiresPermissions("wo:woWorksheet:start")
	@RequestMapping("start")
	public String start(WoWorksheet woWorksheet,RedirectAttributes redirectAttributes){
		String sStr="";
		try {
			if(woWorksheet.isSelf()){
				sStr="self";
			}
			if(!"4".equals(woWorksheet.getWoStatus())){

				woWorksheet.setBeginTime(new Date());
				woWorksheet.setWoStatus("4");
				woWorksheetService.save(woWorksheet);
				//TODO 工单开始日志
				WoStatusLog woStatusLog=new WoStatusLog();
				woStatusLog.setOperator(UserUtils.getUser());
				woStatusLog.setOpDate(new Date());
				woStatusLog.setOpLog("工程师【"+UserUtils.getUser().getName()+"】开始执行工单");
				woStatusLog.setOpStatus(woWorksheet.getWoStatus());
				woStatusLog.setWoWorksheet(woWorksheet);
				woWorksheetService.saveStatusLog(woStatusLog);
				OaNotify oaNotify=new OaNotify();
				oaNotify.setType("4");
				oaNotify.setTitle("工单开始执行通知");
				oaNotify.setContent("工单【"+woWorksheet.getWoNo()+"】开始执行。");
				oaNotify.setWorkId(woWorksheet.getId());
				oaNotify.setCreateBy(UserUtils.getUser());
				oaNotify.setCreateDate(new Date());
				oaNotify.setUpdateBy(UserUtils.getUser());
				oaNotify.setUpdateDate(new Date());
				oaNotify.setStatus("1");//发布
				oaNotify.setOaNotifyRecordIds(woWorksheet.getWoStation().getPm().getId());//消息接收人
				oaNotifyService.save(oaNotify);
				//状态更新
				WoEngineerStatus woEngineerStatus=woEngineerStatusService.getByEngineerId(UserUtils.getUser().getId());
				if(woEngineerStatus ==null){
					woEngineerStatus=new WoEngineerStatus();
					woEngineerStatus.setEngineer(UserUtils.getUser());
				}
				woEngineerStatus.setStatus(WoEngineerStatus.STATUS_BUSY);
				woEngineerStatusService.save(woEngineerStatus);
				String title="工单开始执行通知";
				notifyOtherEngineers(woWorksheet,oaNotify.getContent(),title);
			}
		}catch (Exception e){
			addMessage(redirectAttributes,"开始失败！错误信息：" + e.getMessage());
			return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
		}
		return "modules/wo/woWorksheetStartForm";
	}

	@RequiresPermissions("wo:woWorksheet:edit")
	@RequestMapping("complete")
	public String complete(WoWorksheet woWorksheet,RedirectAttributes redirectAttributes){
		String sStr="";
		if(woWorksheet.isSelf()){
			sStr="self";
		}
		try {
			woWorksheet.setCompleteTime(new Date());
			woWorksheet.setWoStatus("5");
			woWorksheetService.save(woWorksheet);
			addMessage(redirectAttributes,"操作成功！");
			//TODO 工单完成日志
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("完成工单");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			OaNotify oaNotify=new OaNotify();
			oaNotify.setType("4");
			oaNotify.setTitle("工单已完成通知");
			oaNotify.setContent("工单【"+woWorksheet.getWoNo()+"】工作已完成。");
			oaNotify.setWorkId(woWorksheet.getId());
			oaNotify.setCreateBy(UserUtils.getUser());
			oaNotify.setCreateDate(new Date());
			oaNotify.setUpdateBy(UserUtils.getUser());
			oaNotify.setUpdateDate(new Date());
			oaNotify.setStatus("1");//发布
			oaNotify.setOaNotifyRecordIds(woWorksheet.getWoStation().getPm().getId());//消息接收人
			oaNotifyService.save(oaNotify);
			WoWorksheet worksheet=new WoWorksheet();
			worksheet.setSelf(true);
			worksheet.setWoStatus("4");
			Long count=woWorksheetService.getWorkSheetCount(worksheet);
			if(count!=null &&count<=0){
				WoEngineerStatus woEngineerStatus=woEngineerStatusService.getByEngineerId(UserUtils.getUser().getId());
				if(woEngineerStatus ==null){
					woEngineerStatus=new WoEngineerStatus();
					woEngineerStatus.setEngineer(UserUtils.getUser());
				}
				woEngineerStatus.setStatus(WoEngineerStatus.STATUS_NORMAL);
				woEngineerStatusService.save(woEngineerStatus);
			}
			String title="工单完成通知";
			notifyOtherEngineers(woWorksheet,oaNotify.getContent(),title);
		}catch (Exception e){
			addMessage(redirectAttributes,"更新失败！错误信息：" + e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
	}
	@RequiresPermissions("wo:woWorksheet:close")
	@RequestMapping("close")
	public String close(WoWorksheet woWorksheet,RedirectAttributes redirectAttributes){
		String sStr="";
		if(woWorksheet.isSelf()){
			sStr="self";
		}
		woWorksheet.setWoStatus("6");
		woWorksheet.setCloseTime(new Date());
		woWorksheetService.save(woWorksheet);
		//TODO 记录关闭操作日志
		WoStatusLog woStatusLog=new WoStatusLog();
		woStatusLog.setOperator(UserUtils.getUser());
		woStatusLog.setOpDate(new Date());
		woStatusLog.setOpLog("工单关闭");
		woStatusLog.setOpStatus(woWorksheet.getWoStatus());
		woStatusLog.setWoWorksheet(woWorksheet);
		woWorksheetService.saveStatusLog(woStatusLog);
		String title="工单关闭通知";
		notifyOtherEngineers(woWorksheet,"工单【"+woWorksheet.getWoNo()+"】关闭",title);
		addMessage(redirectAttributes,"关闭成功！");
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
	}
	@RequiresPermissions("wo:woWorksheet:needAssistance")
	@RequestMapping("needAssistance")
	public String needAssistance(WoWorksheet woWorksheet,Integer nhNum,String msg,RedirectAttributes redirectAttributes){
		String sStr="";
		if(woWorksheet.isSelf()){
			sStr="self";
		}
		try {
			//TODO 请求协助日志记录
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工程师【"+UserUtils.getUser().getName()+"】请求协助，消息：[工单【"+woWorksheet.getWoNo()+"】请求协助，协助人数："+nhNum+"，原因描述："+msg+"]");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			OaNotify oaNotify=new OaNotify();
			oaNotify.setType("4");
			oaNotify.setTitle("工单请求协助");
			oaNotify.setContent("工单【"+woWorksheet.getWoNo()+"】请求协助，协助人数："+nhNum+"，原因描述："+msg);
			oaNotify.setWorkId(woWorksheet.getId());
			oaNotify.setCreateBy(UserUtils.getUser());
			oaNotify.setCreateDate(new Date());
			oaNotify.setUpdateBy(UserUtils.getUser());
			oaNotify.setUpdateDate(new Date());
			oaNotify.setStatus("1");//发布
			oaNotify.setOaNotifyRecordIds(woWorksheet.getWoStation().getPm().getId());//消息接收人
			oaNotifyService.save(oaNotify);

			woWorksheet.setEnvStatus("1");
			woWorksheet.setNeedAssitNum(nhNum);
			woWorksheet.setReason(msg);
			woWorksheetService.save(woWorksheet);
			addMessage(redirectAttributes,"请求发送成功！");
		}catch (Exception e){
			addMessage(redirectAttributes, "请求失败！错误信息：" + e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
	}
	@RequiresPermissions("wo:woWorksheet:needReAssign")
	@RequestMapping("needReAssign")
	public String needReAssign(WoWorksheet woWorksheet,String msg,RedirectAttributes redirectAttributes){
		String sStr="";
		if(woWorksheet.isSelf()){
			sStr="self";
		}
		try {
			// 请求转派日志记录
			WoStatusLog woStatusLog=new WoStatusLog();
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工程师【"+UserUtils.getUser().getName()+"】请求转派，消息：[工单【"+woWorksheet.getWoNo()+"】请求转派，原因描述："+msg+"]");
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setWoWorksheet(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);

			OaNotify oaNotify=new OaNotify();
			oaNotify.setType("4");
			oaNotify.setTitle("工单请求转派");
			oaNotify.setContent("工单【" + woWorksheet.getWoNo() + "】请求转派，原因描述：" + msg);
			oaNotify.setWorkId(woWorksheet.getId());
			oaNotify.setCreateBy(UserUtils.getUser());
			oaNotify.setCreateDate(new Date());
			oaNotify.setUpdateBy(UserUtils.getUser());
			oaNotify.setUpdateDate(new Date());
			oaNotify.setStatus("1");//发布
			oaNotify.setOaNotifyRecordIds(woWorksheet.getWoStation().getPm().getId());//消息接收人
			oaNotifyService.save(oaNotify);
			woWorksheet.setEnvStatus("2");
			woWorksheet.setWoStatus("2");
			woWorksheetService.save(woWorksheet);
			addMessage(redirectAttributes,"请求发送成功！");

		}catch (Exception e){
			addMessage(redirectAttributes, "请求失败！错误信息：" + e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/"+sStr+"?repage";
	}

	@RequestMapping(value = "upload")
	public String upload(WoWorksheet worksheet,String grp,@RequestParam("files") MultipartFile[] files,String remarks,HttpServletRequest request,Model model){

		Date current=new Date();
		Calendar cal=Calendar.getInstance();
		cal.setTime(current);
		User user= UserUtils.getUser();
		System.out.println("==========workId=|"+worksheet.getId()+"|==========");
		grp = UUID.randomUUID()+"";
		try {
			String path = "/userfiles/" + user.getId() + "/file/worksheet/" + worksheet.getWoNo() + "/" + cal.get(Calendar.YEAR) + "/" + (cal.get(Calendar.MONTH) + 1) + "/";
			for (int i=0;i<files.length;i++) {
				MultipartFile file = files[i];
				//String realPath = request.getSession().getServletContext().getRealPath(path)+"/";
				String suffix = file.getOriginalFilename().substring
						(file.getOriginalFilename().lastIndexOf("."));
				File dest = new File(Global.getUserfilesBaseDir() + path);
				if (!dest.exists()) {
					FileUtils.createDirectory(Global.getUserfilesBaseDir() + path);
				}
				String filename = UUID.randomUUID()+suffix;
				dest = new File(Global.getUserfilesBaseDir() + path + filename);
				file.transferTo(dest);
				WorksheetFiles worksheetFiles = new WorksheetFiles();
				worksheetFiles.setAtthFile(request.getContextPath() + path + filename);
				worksheetFiles.setName(worksheet.getWoNo() + filename);
				worksheetFiles.setUploadBy(UserUtils.getUser());
				worksheetFiles.setUploadDate(new Date());
				worksheetFiles.setGrp(grp);
				worksheetFiles.setWorksheet(worksheet);
				worksheetFiles.setRemarks(remarks);
				woWorksheetService.saveAttachFile(worksheetFiles);
				WoStatusLog woStatusLog = new WoStatusLog();
				woStatusLog.setOperator(UserUtils.getUser());
				woStatusLog.setOpDate(new Date());
				woStatusLog.setOpLog("上传了文件【" + worksheet.getWoNo() + current.getTime() + suffix + "】");
				woStatusLog.setOpStatus(worksheet.getWoStatus());
				woStatusLog.setWoWorksheet(worksheet);
				woWorksheetService.saveStatusLog(woStatusLog);
				addMessage(model, "附件上传成功！");
			}
		}catch(Exception e){
			addMessage(model, "附件上传失败！");
		}

		return detail(worksheet,model);
	}


	private void notifyOtherEngineers(WoWorksheet woWorksheet,String msg,String title){
		String ids="";
		woWorksheet=woWorksheetService.getEngineers(woWorksheet);
		User currentUser=UserUtils.getUser();
		for(User u:woWorksheet.getCheckedUsers()){
			if(u.getId().equals(currentUser.getId()))
				continue;
			ids+=u.getId()+",";
		}
		for(User user1:woWorksheet.getUnCheckedUsers()){
			if(user1.getId().equals(currentUser.getId()))
				continue;
			ids+=user1.getId()+",";
		}
		if(ids.length()>0){
			ids.substring(0,ids.length()-1);
			OaNotify oaNotify=new OaNotify();
			oaNotify.setType("4");
			oaNotify.setTitle(title);
			oaNotify.setContent(msg);
			oaNotify.setWorkId(woWorksheet.getId());
			oaNotify.setCreateBy(UserUtils.getUser());
			oaNotify.setCreateDate(new Date());
			oaNotify.setUpdateBy(UserUtils.getUser());
			oaNotify.setUpdateDate(new Date());
			oaNotify.setStatus("1");//发布
			oaNotify.setOaNotifyRecordIds(ids);//消息接收人
			oaNotifyService.save(oaNotify);
		}
	}
	@RequestMapping(value = "export")
	public String export(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response,RedirectAttributes redirectAttributes){
		//woWorksheet.setSelf(true);
		String fileName = "工单记录"+ DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
		Page<WoWorksheet> page=woWorksheetService.findPage(new Page<WoWorksheet>(),woWorksheet);
		page.getList();
		for(WoWorksheet wo:page.getList()){
			wo=woWorksheetService.getEngineers(wo);//获取运维人员
			String s ="";
			for(User u1 :wo.getCheckedUsers()){
				s+= u1.getName()+" ";
			}
			for(User u2 :wo.getUnCheckedUsers()){
				s+=u2.getName()+" ";
			}
			wo.setStringleng(s);
		}
		try {
			new ExportExcel("工单记录",WoWorksheet.class).setDataList(page.getList()).write(response,fileName).dispose();
			return null;
		} catch (IOException e) {
			addMessage(redirectAttributes, "导出工单记录！失败信息：" + e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/wo/woWorksheet/self?repage";
	}

	@RequestMapping(value = "saveWorksheetDevices", method = RequestMethod.POST)
	public void saveWorksheetDevices(String worksheetId, String deviceIds,HttpServletResponse response) {
		try {
			System.out.println("worksheetId="+worksheetId+",deviceIds="+deviceIds);
			woWorksheetService.saveWorksheetDevices(worksheetId,deviceIds);
			response.getWriter().write("true");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("设备关联操作失败：" + new Date() + ":", e);
			try {
				response.getWriter().write("false");
			} catch (IOException e1) {
				e1.printStackTrace();
				logger.error("设备关联操作写回true失败：" + new Date() + ":", e1);
			}
		}
	}

	@ResponseBody
	@RequestMapping("startWait")
	public RetEntity startWait(WoWorksheet woWorksheet,String reason){
		RetEntity retEntity=new RetEntity();
		try{
			Long lastWaitTime=woWorksheet.getWaitTime();
			if(lastWaitTime==null){
				woWorksheet.setWaitTime(0l);
			}
			woWorksheet.setWoStatus("7");//等待中
			woWorksheet.setStartWaitTime(new Date());
			WoStatusLog woStatusLog = new WoStatusLog();
			woStatusLog.setWoWorksheet(woWorksheet);
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单开始等待");
			woStatusLog.setRemarks(reason);
			woWorksheetService.save(woWorksheet);
			woWorksheetService.saveStatusLog(woStatusLog);
			retEntity.setSuccess(true);
		}catch (Exception e){
			retEntity.setSuccess(false);
			e.printStackTrace();
			logger.error("开始等待操作失败："+e.getMessage());
			retEntity.setMsg("操作失败！"+e.getMessage());
		}
		return retEntity;
	}
	@ResponseBody
	@RequestMapping("endWait")
	public RetEntity endWait(WoWorksheet woWorksheet){
		RetEntity retEntity=new RetEntity();
		try {
			Long lastWaitTime=woWorksheet.getWaitTime();
			long currentTime=System.currentTimeMillis();
			long thisGap=currentTime-woWorksheet.getStartWaitTime().getTime();
			lastWaitTime+=thisGap;
			woWorksheet.setWaitTime(lastWaitTime);
			woWorksheet.setWoStatus("4");//进行中
			woWorksheetService.save(woWorksheet);
			WoStatusLog woStatusLog = new WoStatusLog();
			woStatusLog.setWoWorksheet(woWorksheet);
			woStatusLog.setOpStatus(woWorksheet.getWoStatus());
			woStatusLog.setOperator(UserUtils.getUser());
			woStatusLog.setOpDate(new Date());
			woStatusLog.setOpLog("工单结束等待，共耗时："+(thisGap/1000)+"秒");
			woWorksheetService.saveStatusLog(woStatusLog);
			retEntity.setSuccess(true);
		}catch (Exception e){
			retEntity.setSuccess(false);
			e.printStackTrace();
			logger.error("停止等待操作失败："+e.getMessage());
			retEntity.setMsg("操作失败！"+e.getMessage());
		}
		return retEntity;
	}
}