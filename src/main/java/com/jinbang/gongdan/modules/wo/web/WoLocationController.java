package com.jinbang.gongdan.modules.wo.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.entity.WoEngineerStatus;
import com.jinbang.gongdan.modules.wo.service.WoEngineerStatusService;
import com.jinbang.gongdan.modules.wo.service.WoStationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * @author Jianghui
 * @version V1.0
 * @description 人员定位相关controller
 * @date 2017-05-15 18:02
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woLocation")
public class WoLocationController extends BaseController{

    @Autowired
    private WoEngineerStatusService woEngineerStatusService;
    @Autowired
    private WoStationService woStationService;

    @RequestMapping(value = {"locView",""})
    public String locView(){
        return "modules/wo/woLocation";
    }

    @ResponseBody
    @RequestMapping("getEngineerStatus")
    public List<Map<String,Object>> getEngineerStatus(@RequestParam(required = false) String officeId, HttpServletResponse response){
        List<WoEngineerStatus> list= woEngineerStatusService.findByOfficeId(officeId);
        List<Map<String, Object>> mapList = Lists.newArrayList();
        for (int i=0; i<list.size(); i++){
            WoEngineerStatus e = list.get(i);
            Map<String, Object> map = Maps.newHashMap();
            map.put("id", "u_"+e.getId());
            map.put("pId", officeId);
            String nameStr=StringUtils.replace(e.getEngineer().getName(), " ", "");
            if(WoEngineerStatus.STATUS_NORMAL.equals(e.getStatus())){
                nameStr +="【空闲】";
            }else{
                nameStr +="【忙碌】";
            }
            map.put("name", nameStr);
            map.put("lat",e.getLat());
            map.put("lon",e.getLon());
            map.put("status",e.getStatus());
            map.put("mobile",e.getEngineer().getMobile());
            String reportDateStr="";
            if(e.getReportDate()!=null){
                reportDateStr= DateUtils.formatDate(e.getReportDate(),"yyyy-MM-dd HH:mm:ss");
            }
            map.put("reportDate",reportDateStr );
            mapList.add(map);
        }
        return mapList;
    }

    @ResponseBody
    @RequestMapping("getStations")
    public List<Map<String,Object>> getStations(){
        List<Map<String,Object>> data=woStationService.getStationTreeData();
        List<Map<String,Object>> sortedData=Lists.newArrayList();
        sortStationList(data,"0",sortedData,true);
        return sortedData;
    }
    private void sortStationList(List<Map<String,Object>> srcData,String pId,List<Map<String,Object>> dstData,boolean cascade){
        for (int i=0; i<srcData.size(); i++){
            Map e = srcData.get(i);
            if ( e.get("pId")!=null
                    && e.get("pId").equals(pId)){
                dstData.add(e);
                if (cascade){
                    // 判断是否还有子节点, 有则继续获取子节点
                    for (int j=0; j<srcData.size(); j++){
                        Map child = srcData.get(j);
                        if (child.get("pId")!=null
                                && child.get("pId").equals(e.get("id"))){
                            sortStationList(srcData, (String) e.get("id"),dstData, true);
                            break;
                        }
                    }
                }
            }
        }
    }
}
