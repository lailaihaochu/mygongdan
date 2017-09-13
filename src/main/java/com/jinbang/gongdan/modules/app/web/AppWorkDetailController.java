package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.utils.FileUtils;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.entity.WoStatusLog;
import com.jinbang.gongdan.modules.wo.entity.WoWorkDetail;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import com.jinbang.gongdan.modules.wo.entity.WorksheetFiles;
import com.jinbang.gongdan.modules.wo.service.WoWorksheetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/2 22:27
 */
@Controller
@RequestMapping("${adminPath}/app/wo/workdetail")
public class AppWorkDetailController extends BaseController {

    @Autowired
    private WoWorksheetService woWorksheetService;



    @ModelAttribute
    public WoWorkDetail get(@RequestParam(required=false) String id) {
        WoWorkDetail entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = woWorksheetService.getDetail(id);
        }
        if (entity == null){
            entity = new WoWorkDetail();
        }
        return entity;
    }
    @ResponseBody
    @RequestMapping(value = "list")
    public RetEntity list(String woId){
        RetEntity  retEntity=new RetEntity();
        WoWorksheet worksheet=woWorksheetService.get(woId);
        try{
            List<WoWorkDetail> list=woWorksheetService.findDetailList(worksheet);
            retEntity.setSuccess(true);
            retEntity.setData(list);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取【"+worksheet.getWoNo()+"】巡检项失败，消息："+e.getMessage());
        }
        return retEntity;
    }


    @ResponseBody
    @RequestMapping(value = "start")
    public RetEntity start(WoWorkDetail woWorkDetail){
        RetEntity retEntity=new RetEntity();
        try {
            woWorkDetail.setStatus("2");
            woWorksheetService.saveDetail(woWorkDetail);

            //TODO 记录开始日志
            WoWorksheet worksheet=woWorksheetService.get(woWorkDetail.getWoWorksheet());
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("工程师【"+UserUtils.getUser().getName()+"】开始执行巡检项【"+woWorkDetail.getName()+"】");
            woStatusLog.setOpStatus(worksheet.getWoStatus());
            woStatusLog.setWoWorksheet(worksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("任务开始失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping("uploadPic")
    public RetEntity uploadFile(WoWorkDetail woWorkDetail,MultipartFile file,HttpServletRequest request){
        Date current=new Date();
        Calendar cal=Calendar.getInstance();
        cal.setTime(current);
        RetEntity retEntity =new RetEntity();
        User user= UserUtils.getUser();
        try {
            String path = "/userfiles/"+user.getId()+"/images/worksheet/"+woWorkDetail.getWoWorksheet().getWoNo()+"/"+cal.get(Calendar.YEAR)+"/"+(cal.get(Calendar.MONTH)+1)+"/";
            //String realPath = request.getSession().getServletContext().getRealPath(path)+"/";
            String suffix = file.getOriginalFilename().substring
                    (file.getOriginalFilename().lastIndexOf("."));
            File dest=new File(Global.getUserfilesBaseDir() +path);
            if(!dest.exists()){
                FileUtils.createDirectory(Global.getUserfilesBaseDir() + path);
            }
            dest=new File(Global.getUserfilesBaseDir() +path+current.getTime()+suffix);
            file.transferTo(dest);
            String filePaths=woWorkDetail.getAttachFiles();
            if (filePaths==null)
                filePaths="";
            else
                filePaths=filePaths+"|";
            woWorkDetail.setAttachFiles(filePaths+request.getContextPath() + path + current.getTime() + suffix);
            woWorksheetService.saveDetail(woWorkDetail);
            //TODO 上传图片 and 附件列表
            WoWorksheet worksheet=woWorksheetService.get(woWorkDetail.getWoWorksheet());
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("上传了图片【"+woWorkDetail.getName()+current.getTime()+suffix+"】");
            woStatusLog.setOpStatus(worksheet.getWoStatus());
            woStatusLog.setWoWorksheet(worksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            WorksheetFiles worksheetFiles=new WorksheetFiles();
            worksheetFiles.setAtthFile(request.getContextPath() + path + current.getTime() + suffix);
            worksheetFiles.setName(woWorkDetail.getName()+current.getTime()+suffix);
            worksheetFiles.setUploadBy(UserUtils.getUser());
            worksheetFiles.setUploadDate(new Date());
            worksheetFiles.setWorksheet(woWorkDetail.getWoWorksheet());
            woWorksheetService.saveAttachFile(worksheetFiles);
            retEntity.setSuccess(true);
            retEntity.setData(request.getContextPath() + path + current.getTime() + suffix);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("图片上传失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("updateRemarks")
    public RetEntity updateRemarks(WoWorkDetail woWorkDetail){
        RetEntity retEntity=new RetEntity();
        try {
            woWorksheetService.saveDetail(woWorkDetail);
            //TODO 记录完成日志
            WoWorksheet worksheet=woWorksheetService.get(woWorkDetail.getWoWorksheet());
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("巡检项【"+woWorkDetail.getName()+"】信息修改了");
            woStatusLog.setOpStatus(worksheet.getWoStatus());
            woStatusLog.setWoWorksheet(worksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("任务保存失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping("complete")
    public RetEntity complete(WoWorkDetail woWorkDetail){
        RetEntity retEntity=new RetEntity();
        try {
            woWorkDetail.setStatus("3");
            woWorksheetService.saveDetail(woWorkDetail);
            //TODO 记录完成日志
            WoWorksheet worksheet=woWorksheetService.get(woWorkDetail.getWoWorksheet());
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("巡检项【"+woWorkDetail.getName()+"】完成");
            woStatusLog.setOpStatus(worksheet.getWoStatus());
            woStatusLog.setWoWorksheet(worksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("任务保存失败！错误信息："+e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

}
