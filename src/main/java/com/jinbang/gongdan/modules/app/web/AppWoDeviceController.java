package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.MobilePage;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.wo.entity.WoDevice;
import com.jinbang.gongdan.modules.wo.service.WoDeviceService;
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
 * author:ypj
 * date:2017/5/5 10:28
 */
@Controller
@RequestMapping("${adminPath}/app/wo/device")
public class AppWoDeviceController extends BaseController {

    @Autowired
    private WoDeviceService woDeviceService;

    @ModelAttribute
    public WoDevice get(@RequestParam(required = false)String id){
        WoDevice entity=null;
        if(StringUtils.isNotBlank(id)){
            entity=woDeviceService.get(id);
        }
        if(entity==null){
            entity=new WoDevice();
        }
        return entity;
    }

    @ResponseBody
    @RequestMapping(value = {"list",""})
    public RetEntity list(WoDevice woDevice ,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            Page<WoDevice> page=woDeviceService.findPage(new Page<WoDevice>(request,response),woDevice);
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
