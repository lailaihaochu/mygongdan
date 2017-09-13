package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.MobilePage;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.wo.entity.WoClient;
import com.jinbang.gongdan.modules.wo.service.WoClientService;
import org.restlet.engine.adapter.HttpRequest;
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
 * date:2016/7/27 9:41
 */
@Controller
@RequestMapping("${adminPath}/app/wo/client")
public class AppClientController extends BaseController {

    @Autowired
    private WoClientService woClientService;

    @ModelAttribute
    public WoClient get(@RequestParam(required = false) String id){
        WoClient entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = woClientService.get(id);
        }
        if (entity == null){
            entity = new WoClient();
        }
        return entity;
    }
    @ResponseBody
    @RequestMapping(value = {"list",""})
    public RetEntity getClientPage(WoClient woClient,HttpServletRequest request,HttpServletResponse  response){
        RetEntity retEntity=new RetEntity();
        try {
            Page<WoClient> page=woClientService.findPage(new Page<WoClient>(request,response),woClient);
            MobilePage mobilePage=new MobilePage();
            mobilePage.setCount(page.getCount());
            mobilePage.setList(page.getList());
            mobilePage.setPageNo(page.getPageNo());
            mobilePage.setPageSize(page.getPageSize());
            retEntity.setSuccess(true);
            retEntity.setData(mobilePage);
        }catch (Exception e){
            e.printStackTrace();
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
        }
        return retEntity;
    }
}
