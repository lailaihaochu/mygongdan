package com.jinbang.gongdan.modules.app.web;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.MobilePage;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import com.jinbang.gongdan.modules.wo.entity.WoStation;
import com.jinbang.gongdan.modules.wo.service.WoStationService;
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
@RequestMapping("${adminPath}/app/wo/station")
public class AppStationController extends BaseController {

    @Autowired
    private WoStationService woStationService;

    @ModelAttribute
    public WoStation get(@RequestParam(required=false) String id) {
        WoStation entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = woStationService.get(id);
        }
        if (entity == null){
            entity = new WoStation();
        }
        return entity;
    }
    @ResponseBody
    @RequestMapping(value = {"list",""})
    public RetEntity findPage(WoStation woStation ,HttpServletRequest request,HttpServletResponse response){
        RetEntity retEntity=new RetEntity();
        try {
            Page<WoStation> page=woStationService.findPage(new Page<WoStation>(request,response),woStation);
            MobilePage mobilePage=new MobilePage();
            mobilePage.setPageNo(page.getPageNo());
            mobilePage.setCount(page.getCount());
            mobilePage.setList(page.getList());
            mobilePage.setPageSize(page.getPageSize());
            retEntity.setSuccess(true);
            retEntity.setData(mobilePage);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
        }
        return retEntity;
    }
}
