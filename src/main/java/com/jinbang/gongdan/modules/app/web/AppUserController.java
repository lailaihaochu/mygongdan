package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.FileUtils;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.MobilePage;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.app.entity.UserInfo;
import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.Role;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.service.SystemService;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.lang.annotation.Retention;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/27 9:41
 */
@Controller
@RequestMapping("${adminPath}/app/sys/user")
public class AppUserController extends BaseController {

    @Autowired
    private SystemService systemService;


    @ModelAttribute
    public User get(@RequestParam(required = false)String id){
        User entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = systemService.getUser(id);
        }
        if (entity == null){
            entity = new User();
        }
        return entity;
    }

    @ResponseBody
    @RequestMapping(value ={"list",""})
    public RetEntity list(User user,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try{
            Page<User> page=systemService.findUser(new Page<User>(request,response),user);
            MobilePage mobilePage=new MobilePage();
            mobilePage.setCount(page.getCount());
            mobilePage.setPageNo(page.getPageNo());
            mobilePage.setPageSize(page.getPageSize());
            mobilePage.setList(page.getList());
            retEntity.setSuccess(true);
            retEntity.setData(mobilePage);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping(value = "getStationEngineers")
    public RetEntity getStationEngineers(String stationId){
        RetEntity retEntity=new RetEntity();
        try {
            List<User> users=systemService.findUserByStationId(stationId);
            retEntity.setSuccess(true);
            retEntity.setData(users);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping(value = "getEngineersFromPool")
    public RetEntity getEngineersFromPool(){
        RetEntity retEntity=new RetEntity();
        try {
            Role role=systemService.getRoleByName("工程师");
            List<User> userList = systemService.findUser(new User(new Role(role.getId())));
            retEntity.setSuccess(true);
            retEntity.setData(userList);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping(value = "accountInfo")
    public RetEntity accountInfo(){
        RetEntity retEntity=new RetEntity();
        try {
            User user = UserUtils.getUser();
            UserInfo userInfo=new UserInfo();
            userInfo.setId(user.getId());
            userInfo.setName(user.getName());
            userInfo.setNo(user.getNo());
            userInfo.setPhoto(user.getPhoto());
            userInfo.setEmail(user.getEmail());
            userInfo.setPhone(user.getPhone());
            userInfo.setMobile(user.getMobile());
            userInfo.setLoginDate(user.getLoginDate());
            userInfo.setLoginIp(user.getLoginIp());
            userInfo.setRoleNames(user.getRoleNames());
            Office office=new Office();
            office.setId(user.getOffice().getId());
            office.setName(user.getOffice().getName());
            userInfo.setOffice(office);
            Office company=new Office();
            company.setId(user.getCompany().getId());
            company.setName(user.getCompany().getName());
            company.setAddress(user.getCompany().getAddress());
            userInfo.setCompany(company);
            retEntity.setSuccess(true);
            retEntity.setData(userInfo);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取失败！"+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping(value = "saveInfo")
    public RetEntity save(User user){
        RetEntity retEntity=new RetEntity();
        try {
            UserInfo userInfo=new UserInfo();
            userInfo.setId(user.getId());
            userInfo.setName(user.getName());
            userInfo.setNo(user.getNo());
            userInfo.setPhoto(user.getPhoto());
            userInfo.setEmail(user.getEmail());
            userInfo.setPhone(user.getPhone());
            userInfo.setMobile(user.getMobile());
            userInfo.setLoginDate(user.getLoginDate());
            userInfo.setLoginIp(user.getLoginIp());
            userInfo.setRoleNames(user.getRoleNames());
            Office office=new Office();
            office.setId(user.getOffice().getId());
            office.setName(user.getOffice().getName());
            userInfo.setOffice(office);
            Office company=new Office();
            company.setId(user.getCompany().getId());
            company.setName(user.getCompany().getName());
            company.setAddress(user.getCompany().getAddress());
            userInfo.setCompany(company);
            systemService.saveUser(user);
            retEntity.setSuccess(true);
            retEntity.setData(userInfo);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg("获取失败！"+e.getMessage());
        }
        return retEntity;
    }
    @ResponseBody
    @RequestMapping(value = "changeHeadPic")
    public RetEntity changeHeadpic(MultipartFile file,HttpServletRequest request){
        Date current=new Date();
        Calendar cal=Calendar.getInstance();
        cal.setTime(current);
        RetEntity appDataEntity =new RetEntity();
        User user=UserUtils.getUser();
        String path = "/userfiles/"+user.getId()+"/images/headpic/"+cal.get(Calendar.YEAR)+"/"+(cal.get(Calendar.MONTH)+1)+"/";
        //String realPath = request.getSession().getServletContext().getRealPath(path)+"/";
        String suffix = file.getOriginalFilename().substring
                (file.getOriginalFilename().lastIndexOf("."));
        File dest=new File(Global.getUserfilesBaseDir() +path);
        if(!dest.exists()){
            FileUtils.createDirectory(Global.getUserfilesBaseDir() + path);
        }
        dest=new File(Global.getUserfilesBaseDir() +path+current.getTime()+suffix);
        try {
            file.transferTo(dest);
            appDataEntity.setSuccess(true);
            user.setPhoto(request.getContextPath() + path + current.getTime() + suffix);
            systemService.saveUser(user);
            appDataEntity.setData(request.getContextPath() + path + current.getTime() + suffix);
        } catch (IOException e) {
            e.printStackTrace();
            appDataEntity.setSuccess(false);
        }
        return appDataEntity;
    }
}
