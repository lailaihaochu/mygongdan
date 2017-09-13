package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.MobilePage;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import com.jinbang.gongdan.modules.wo.service.WoEmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/27 14:33
 */
@Controller
@RequestMapping("${adminPath}/app/wo/employee")
public class AppWoEmployeeController extends BaseController {

    @Autowired
    private WoEmployeeService woEmployeeService;

    @ModelAttribute
    public WoEmployee get(@RequestParam(required = false)String id){
        WoEmployee entity=null;
        if(StringUtils.isNotBlank(id)){
            entity=woEmployeeService.get(id);
        }
        if(entity==null){
            entity=new WoEmployee();
        }
        return entity;
    }

    @ResponseBody
    @RequestMapping(value = {"list",""})
    public RetEntity list(WoEmployee woEmployee ,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            Page<WoEmployee> page=woEmployeeService.findPage(new Page<WoEmployee>(request,response),woEmployee);
            MobilePage mobilePage=new MobilePage();
            mobilePage.setCount(page.getCount());
            mobilePage.setList(page.getList());
            mobilePage.setPageNo(page.getPageNo());
            mobilePage.setPageSize(page.getPageSize());
            retEntity.setSuccess(true);
            retEntity.setData(mobilePage);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }


}
