package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.utils.FileUtils;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;

import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.entity.WoStatusLog;
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
 * date:2016/8/21 13:14
 */
@Controller
@RequestMapping("${adminPath}/app/wo/attachFile")
public class AppWorkAttchFileController extends BaseController {

    @Autowired
    private WoWorksheetService woWorksheetService;
    @ModelAttribute
    public WorksheetFiles get(@RequestParam(required=false) String id) {
        WorksheetFiles entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = woWorksheetService.getAttachFile(id);
        }
        if (entity == null){
            entity = new WorksheetFiles();
        }
        return entity;
    }

    /**
     * 获取附件列表
     * @param woId
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "list")
    public RetEntity list(String woId){
        RetEntity retEntity=new RetEntity();
        WoWorksheet worksheet=woWorksheetService.get(woId);
        try {
            List<WorksheetFiles> list = woWorksheetService.findAttachFiles(worksheet);
            retEntity.setSuccess(true);
            retEntity.setData(list);
        }catch (Exception e){
            retEntity.setSuccess(true);
            retEntity.setMsg("获取附件列表失败，错误消息："+e.getMessage());
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping(value = "upload")
    public RetEntity upload(String workId,String grp,MultipartFile file,String remarks,HttpServletRequest request){

        Date current=new Date();
        Calendar cal=Calendar.getInstance();
        cal.setTime(current);
        RetEntity retEntity =new RetEntity();
        User user= UserUtils.getUser();
        WoWorksheet worksheet=woWorksheetService.get(workId);
        try {
            String path = "/userfiles/" + user.getId() + "/file/worksheet/" + worksheet.getWoNo() + "/" + cal.get(Calendar.YEAR) + "/" + (cal.get(Calendar.MONTH) + 1) + "/";
            //String realPath = request.getSession().getServletContext().getRealPath(path)+"/";
            String suffix = file.getOriginalFilename().substring
                    (file.getOriginalFilename().lastIndexOf("."));
            File dest = new File(Global.getUserfilesBaseDir() + path);
            if (!dest.exists()) {
                FileUtils.createDirectory(Global.getUserfilesBaseDir() + path);
            }
            dest = new File(Global.getUserfilesBaseDir() + path + current.getTime() + suffix);
            file.transferTo(dest);
            WorksheetFiles worksheetFiles = new WorksheetFiles();
            worksheetFiles.setAtthFile(request.getContextPath() + path + current.getTime() + suffix);
            worksheetFiles.setName(worksheet.getWoNo() + current.getTime() + suffix);
            worksheetFiles.setUploadBy(UserUtils.getUser());
            worksheetFiles.setUploadDate(new Date());
            worksheetFiles.setGrp(grp);
            worksheetFiles.setWorksheet(worksheet);
            worksheetFiles.setRemarks(remarks);
            woWorksheetService.saveAttachFile(worksheetFiles);
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("上传了文件【"+worksheet.getWoNo() + current.getTime() + suffix+"】");
            woStatusLog.setOpStatus(worksheet.getWoStatus());
            woStatusLog.setWoWorksheet(worksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
            retEntity.setSuccess(true);
            retEntity.setData(request.getContextPath() + path + current.getTime() + suffix);

        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setData("【"+worksheet.getWoNo()+"】附件上传失败");
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping(value = "delete")
    public RetEntity delete(WorksheetFiles worksheetFiles){
        RetEntity retEntity=new RetEntity();
        try{
            woWorksheetService.deleteAttchFile(worksheetFiles);
            WoWorksheet worksheet=woWorksheetService.get(worksheetFiles.getWorksheet());
            WoStatusLog woStatusLog=new WoStatusLog();
            woStatusLog.setOperator(UserUtils.getUser());
            woStatusLog.setOpDate(new Date());
            woStatusLog.setOpLog("删除文件【"+worksheetFiles.getName()+"】");
            woStatusLog.setOpStatus(worksheet.getWoStatus());
            woStatusLog.setWoWorksheet(worksheet);
            woWorksheetService.saveStatusLog(woStatusLog);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("操作失败！消息："+e.getMessage());
        }

        return  retEntity;
    }
}
