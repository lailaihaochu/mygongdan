package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.AppVersion;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.app.entity.UserInfo;
import com.jinbang.gongdan.modules.app.service.AppVersionService;
import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.security.UsernamePasswordToken;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.AuthorizationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/13 21:05
 */
@Controller
@RequestMapping("${adminPath}/app")
public class AppLoginController extends BaseController {
    @Autowired
    private AppVersionService appVersionService;

    @ResponseBody
    @RequestMapping("login")
    public RetEntity login(String username,String password,String isHistory,HttpServletRequest request){
        RetEntity returnEntity=new RetEntity();
        if(StringUtils.isNotEmpty(isHistory)&&isHistory.equals("true")){
            User user = UserUtils.getUser();
            if(user.getId() != null){
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
                returnEntity.setSuccess(true);
                returnEntity.setData(userInfo);
                return returnEntity;
            }else{
                returnEntity.setSuccess(false);
                returnEntity.setError("2");
                returnEntity.setMsg("密码过期，请重新输入");
                return returnEntity;
            }
        }
        UsernamePasswordToken token=null;
        token =new UsernamePasswordToken(username,password.toCharArray(),true,request.getRemoteHost(),null);
        try {
            SecurityUtils.getSubject().login(token);
            returnEntity.setSuccess(true);
            User user= UserUtils.getUser();
            UserInfo userInfo=new UserInfo();
            userInfo.setId(user.getId());
            userInfo.setName(user.getName());
            userInfo.setNo(user.getNo());
            userInfo.setPhoto(user.getPhoto());
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
            returnEntity.setData(userInfo);
        }catch (AuthorizationException e){
            logger.error(e.getMessage());
            returnEntity.setSuccess(false);
            returnEntity.setError("1");
            returnEntity.setMsg("账号或密码不正确！");
        }
        return returnEntity;
    }
    @ResponseBody
    @RequestMapping("checkAppVersion")
    public RetEntity checkAppVersion(String appName){
        RetEntity appDataEntity=new RetEntity();
        try{
            AppVersion appVersion=appVersionService.getLastVersion(appName);
            if(appVersion!=null){
                appDataEntity.setSuccess(true);
                appDataEntity.setData(appVersion);
            }else{
                appDataEntity.setSuccess(false);
                appDataEntity.setMsg("获取服务端app版本信息失败！");
            }
        }catch (Exception e){
            logger.error(e.getMessage());
            appDataEntity.setSuccess(false);
            appDataEntity.setMsg("服务端异常，加载版本信息失败！");
        }
        return appDataEntity;
    }
    @ResponseBody
    @RequestMapping("logout")
    public RetEntity logout(){
        RetEntity retEntity=new RetEntity();
        try {
            SecurityUtils.getSubject().logout();
            retEntity.setSuccess(true);

        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
        }
        return retEntity;
    }
}
