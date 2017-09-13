package com.jinbang.gongdan.modules.wo.web;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.wo.entity.WoPosLog;
import com.jinbang.gongdan.modules.wo.service.WoPosLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import java.util.List;

/**
 * @author Jianghui
 * @version V1.0
 * @description ${DESCRIPTION}
 * @date 2017-05-08 20:44
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woEngineerPos")
public class WoEngineerPositionController extends BaseController {

    @Autowired
    private WoPosLogService woPosLogService;

    @ResponseBody
    @RequestMapping("queryHistory")
    public List<WoPosLog> getEngineerPos(WoPosLog woPosLog){
        List<WoPosLog> list=woPosLogService.findList(woPosLog);
        return list;
    }
}
