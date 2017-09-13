package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.utils.excel.annotation.ExcelField;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.MobilePage;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.oa.entity.OaNotify;
import com.jinbang.gongdan.modules.oa.service.OaNotifyService;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.service.SystemService;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.entity.WoEngineerStatus;
import com.jinbang.gongdan.modules.wo.entity.WoStation;
import com.jinbang.gongdan.modules.wo.entity.WoStatusLog;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import com.jinbang.gongdan.modules.wo.service.WoClientService;
import com.jinbang.gongdan.modules.wo.service.WoEngineerStatusService;
import com.jinbang.gongdan.modules.wo.service.WoGenerator;
import com.jinbang.gongdan.modules.wo.service.WoWorksheetService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/13 21:48
 */
@Controller
@RequestMapping("${adminPath}/app/wo/worksheet")
public class AppWorkSheetController extends BaseController {

    @Autowired
    private WoWorksheetService woWorksheetService;

    @Autowired
    private SystemService systemService;

    @Autowired
    private OaNotifyService oaNotifyService;
    @Autowired
    private WoClientService woClientService;

    @Autowired
    private WoGenerator woGenerator;
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

    @ResponseBody
    @RequestMapping("getEmgCount")
    public RetEntity getEmgCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            woWorksheet.setEmGrade("3");//紧急
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取紧急任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getMyDispCount")
    public RetEntity getMyDispCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            WoStation woStation=new WoStation();
            woStation.setPm(UserUtils.getUser());
            woWorksheet.setWoStation(woStation);
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取我分配的任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getMyInvCount")
    public RetEntity getMyInvCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取我参与的任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getUnCheckedCount")
    public RetEntity getUnCheckedCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            woWorksheet.setWoStatus("2");//未确认
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取未确认的任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getProcessCount")
    public RetEntity getProcessCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            woWorksheet.setWoStatus("4");//进行中
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取进行中的任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getAcceptedCount")
    public RetEntity getAcceptedCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            woWorksheet.setWoStatus("3");
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取已接单任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getUnsignedCount")
    public RetEntity getUnsignedCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            woWorksheet.setWoStatus("1");
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取未指派任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("getCompletedCount")
    public RetEntity getCompletedCount(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            woWorksheet.setWoStatus("5");
            Long count=woWorksheetService.getWorkSheetCount(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(count);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取已完成任务数量失败："+e.getMessage());
        }
        return retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:view")
    @ResponseBody
    @RequestMapping("self")
    public RetEntity getAssignedWorksheets(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {

            woWorksheet.setSelf(true);
            Page<WoWorksheet> page=woWorksheetService.findPage(new Page<WoWorksheet>(request,response),woWorksheet);
            for(WoWorksheet worksheet:page.getList()){
                worksheet=woWorksheetService.getEngineers(worksheet);
                worksheet=woWorksheetService.getDevices(worksheet);
            }
            MobilePage mobilePage=new MobilePage();
            mobilePage.setCount(page.getCount());
            mobilePage.setList(page.getList());
            mobilePage.setPageNo(page.getPageNo());
            mobilePage.setPageSize(page.getPageSize());
            retEntity.setSuccess(true);
            retEntity.setData(mobilePage);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取指派工单失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:edit")
    @ResponseBody
    @RequestMapping("create")
    public RetEntity create(WoWorksheet woWorksheet,String[] assignedUsers,Model model){
        RetEntity retEntity=new RetEntity();
        try{
            if (!beanValidator(model, woWorksheet)){
                retEntity.setSuccess(false);
                retEntity.setMsg((String) model.asMap().get("message"));
            }
            woWorksheet.setWoStatus("1");
            woWorksheet.setWoClient(woClientService.get(woWorksheet.getWoClient().getId()));
            woWorksheet.setWoNo(woGenerator.getWO(woWorksheet));
            woWorksheet.setEnvStatus("0");
            woWorksheetService.save(woWorksheet);
            //TODO 工单创建日志记录
            long currentTime=System.currentTimeMillis()-1000;
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date(currentTime));
            woStatusLog.setOpLog("新的工单创建了");
            woStatusLog.setOpStatus(woWorksheet.getWoStatus());
            woStatusLog.setWoWorksheet(woWorksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            if(assignedUsers!=null){
            for(String assignedUser :assignedUsers){
                if(assignedUser!=null){
                    User user=systemService.getUser(assignedUser);
                    if(user!=null){
                        user= woWorksheetService.assignUserToWorkSheet(woWorksheet,user);
                        if(user!=null){
                            if(UserUtils.getUser().getId().equals(user.getId())){
                                woWorksheet.setWoStatus("3");
                                woWorksheet.setAssignTime(new Date());
                                woWorksheet.setAcceptTime(new Date());
                                woWorksheetService.save(woWorksheet);
                            }
                            //TODO 指派用户
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
                        }
                    }
                }
            }}
            woWorksheet=woWorksheetService.get(woWorksheet.getId());
            retEntity.setSuccess(true);
            retEntity.setData(woWorksheet);

        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("创建工单失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:edit")
    @ResponseBody
    @RequestMapping("update")
    public RetEntity update(WoWorksheet woWorksheet,Model model) {
        RetEntity retEntity = new RetEntity();
        try{
            if (!beanValidator(model, woWorksheet)){
                retEntity.setSuccess(false);
                retEntity.setMsg((String) model.asMap().get("message"));
            }
           if(woWorksheet.getIsNewRecord()){
                retEntity.setSuccess(false);
                retEntity.setMsg("操作失败,参数丢失！");
                return retEntity;
            }
            woWorksheetService.save(woWorksheet);
            //TODO 工单修改日志
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("工单信息修改");
            woStatusLog.setOpStatus(woWorksheet.getWoStatus());
            woStatusLog.setWoWorksheet(woWorksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            retEntity.setSuccess(true);
            retEntity.setData(woWorksheet);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("修改工单失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:accept")
    @ResponseBody
    @RequestMapping("accept")
    public RetEntity accept(WoWorksheet woWorksheet) {
        RetEntity retEntity=new RetEntity();
        try {
            User currentUser=UserUtils.getUser();
            woWorksheetService.acceptWorksheet(woWorksheet,currentUser);
            //TODO 接受工单
            long currentTime=System.currentTimeMillis();
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
                woWorksheet.setAcceptTime(new Date());
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
            retEntity.setSuccess(true);
            retEntity.setData(woWorksheet);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("操作失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:assign")
    @ResponseBody
    @RequestMapping("assign")
    public RetEntity assign(WoWorksheet woWorksheet,String[] idsArr){
        RetEntity retEntity=new RetEntity();
        try{
            StringBuilder msg = new StringBuilder();
            int newNum = 0;
            for (int i = 0; i < idsArr.length; i++) {
                User user =woWorksheetService.assignUserToWorkSheet(woWorksheet,systemService.getUser(idsArr[i]));
                if (null != user) {
                    //分配工单通知
                    //TODO 指派用户
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
                    String title="工单分配通知";
                    String otherMsg="工单【"+ woWorksheet.getWoNo() +"】新指派工程师【"+user.getName()+"】";
                    notifyOtherEngineers(woWorksheet, otherMsg, title);
                    msg.append("<br/>新增工程师【" + user.getName() + "】到工单【" + woWorksheet.getWoNo() + "】！");
                    newNum++;
                }
            }
            if("2".equals(woWorksheet.getEnvStatus())){
                woWorksheet.setEnvStatus("0");
                woWorksheetService.save(woWorksheet);
            }
            retEntity.setSuccess(true);
            retEntity.setMsg( "已成功分配 "+newNum+" 个工程师"+msg);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("操作工单失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return  retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:assign")
    @ResponseBody
    @RequestMapping("outWorksheet")
    public RetEntity outWorksheet(WoWorksheet woWorksheet,String userId){
        RetEntity retEntity=new RetEntity();
        try{
            User user = systemService.getUser(userId);
            if (UserUtils.getUser().getId().equals(userId)) {
                retEntity.setSuccess(false);
                retEntity.setMsg("移除失败，无法从工单【" + woWorksheet.getWoNo() + "】中移除工程师【" + user.getName() + "】自己！");
            }else {
                Boolean flag = woWorksheetService.outUserInWorkSheet(woWorksheet, user);
                if (!flag) {
                    retEntity.setSuccess(false);
                    retEntity.setMsg("工程师【" + user.getName() + "】从工单【" + woWorksheet.getWoNo() + "】中移除失败！");
                }else {
                    //移除工单通知
                    WoStatusLog woStatusLog=new WoStatusLog();
                    woStatusLog.setOperator(UserUtils.getUser());
                    woStatusLog.setOpDate(new Date());
                    woStatusLog.setOpLog("工程师【"+user.getName()+"】被移除工单");
                    woStatusLog.setOpStatus(woWorksheet.getWoStatus());
                    woStatusLog.setWoWorksheet(woWorksheet);
                    woWorksheetService.saveStatusLog(woStatusLog);
                    //TODO 移除用户
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
                    retEntity.setSuccess(true);
                    retEntity.setMsg("工程师【" + user.getName() + "】从工单【" + woWorksheet.getWoNo() + "】中移除成功！");
                }
            }

        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("操作工单失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("wo:woWorksheet:close")
    @ResponseBody
    @RequestMapping("closeWorksheet")
    public RetEntity close(WoWorksheet woWorksheet){
        RetEntity retEntity=new RetEntity();
        try{
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
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("关闭工单失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping("needAssistance")
    public RetEntity needAssistance(WoWorksheet woWorksheet,Integer nhNum, String msg){
        RetEntity retEntity=new RetEntity();
        try {
            //TODO 请求协助
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
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("请求失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping("needReAssign")
    public RetEntity needReAssign(WoWorksheet woWorksheet, String msg){
        RetEntity retEntity=new RetEntity();
        try {
            //
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
            oaNotify.setContent("工单【"+woWorksheet.getWoNo()+"】请求转派，原因描述："+msg);
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
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("请求失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("complete")
    public RetEntity complete(WoWorksheet woWorksheet){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setCompleteTime(new Date());
            woWorksheet.setWoStatus("5");
            woWorksheetService.save(woWorksheet);
            //TODO 工单完成标志
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
            retEntity.setSuccess(false);
            retEntity.setMsg("操作失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("start")
    public RetEntity start(WoWorksheet woWorksheet){
        RetEntity retEntity=new RetEntity();
        try {
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
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("开始失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping("statusLog")
    public RetEntity getStatusLog(WoWorksheet woWorksheet){
        RetEntity retEntity=new RetEntity();
        try {
            List<WoStatusLog> list=woWorksheetService.getStatusLogs(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(list);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取失败,消息："+e.getMessage());
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping("get")
    public RetEntity getById(WoWorksheet woWorksheet){
        RetEntity retEntity=new RetEntity();
        woWorksheet =woWorksheetService.getEngineers(woWorksheet);
        retEntity.setSuccess(true);
        retEntity.setData(woWorksheet);
        return retEntity;
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
    @ResponseBody
    @RequestMapping("startWait")
    public RetEntity startWait(WoWorksheet woWorksheet,String remarks){
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
            woStatusLog.setRemarks(remarks);
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

    @ResponseBody
    @RequestMapping("getCalendarPlan")
    public RetEntity getCalendarPlan(WoWorksheet woWorksheet){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheet.setSelf(true);
            List<WoWorksheet> list=woWorksheetService.findList(woWorksheet);
            retEntity.setSuccess(true);
            retEntity.setData(list);
        }catch (Exception e){
            retEntity.setSuccess(false);
            e.printStackTrace();
            logger.error("获取计划失败："+e.getMessage());
            retEntity.setMsg("获取计划失败！"+e.getMessage());
        }
        return retEntity;
    }

}
