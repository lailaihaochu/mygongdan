package com.jinbang.gongdan.modules.sys.web;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.AppVersion;
import com.jinbang.gongdan.modules.app.service.AppVersionService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriUtils;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/22 11:27
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/appVersion")
public class AppVersionController extends BaseController {

    @Autowired
    private AppVersionService appVersionService;

    @ModelAttribute
    public AppVersion get(@RequestParam(required = false)String id){
        if (StringUtils.isNotBlank(id)){
            return appVersionService.get(id);
        }else{
            return new AppVersion();
        }
    }
    @RequiresPermissions("sys:appVersion:view")
    @RequestMapping(value = {"list",""})
    public String list(AppVersion appVersion,HttpServletRequest request,HttpServletResponse response,Model model){

        Page page =appVersionService.findPage(new Page<AppVersion>(request,response),appVersion);
        model.addAttribute("page",page);

        return "modules/sys/appVersionList";
    }
    @RequiresPermissions("sys:appVersion:view")
    @RequestMapping(value = "form")
    public String form(AppVersion appVersion,Model model){
        model.addAttribute("appVersion",appVersion);
        return "modules/sys/appVersionForm";
    }
    @RequiresPermissions("sys:appVersion:edit")
    @RequestMapping(value = "save")
    public String save(AppVersion appVersion,RedirectAttributes redirectAttributes){
        appVersionService.save(appVersion);
        addMessage(redirectAttributes,"保存app版本成功！");
        return "redirect:"+ Global.getAdminPath()+"/sys/appVersion?repage";
    }
    @RequiresPermissions("sys:appVersion:edit")
    @RequestMapping(value="delete")
    public String delete(AppVersion appVersion ,RedirectAttributes redirectAttributes ){
        appVersionService.delete(appVersion);
        addMessage(redirectAttributes,"删除app版本成功！");
        return "redirect:"+ Global.getAdminPath()+"/sys/appVersion?repage";
    }
    @RequestMapping(value = "workTask.apk")
    public void download(HttpServletRequest req,HttpServletResponse resp) throws IOException, ServletException {
        AppVersion appVersion=appVersionService.getLastVersion("金曜工单系统");
        String filepath = appVersion.getFilePath();
        int index = filepath.indexOf(Global.USERFILES_BASE_URL);
        if(index >= 0) {
            filepath = filepath.substring(index + Global.USERFILES_BASE_URL.length());
        }
        try {
            filepath = UriUtils.decode(filepath, "UTF-8");
        } catch (UnsupportedEncodingException e1) {
            logger.error(String.format("解释文件路径失败，URL地址为%s", filepath), e1);
        }
        File file = new File(Global.getUserfilesBaseDir() + Global.USERFILES_BASE_URL + filepath);
        try {
            FileCopyUtils.copy(new FileInputStream(file), resp.getOutputStream());
            resp.setHeader("Content-Type", "application/octet-stream");
            return;
        } catch (FileNotFoundException e) {
            req.setAttribute("exception", new FileNotFoundException("请求的文件不存在"));
            logger.info("文件未找到" );
            req.getRequestDispatcher("/WEB-INF/views/error/404.jsp").forward(req, resp);
        }
    }
}
