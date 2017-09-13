package com.jinbang.gongdan.modules.wo.utils;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.utils.CacheUtils;
import com.jinbang.gongdan.common.utils.SpringContextHolder;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.sys.dao.AreaDao;
import com.jinbang.gongdan.modules.sys.entity.Dict;
import com.jinbang.gongdan.modules.wo.dao.*;
import com.jinbang.gongdan.modules.wo.entity.*;
import org.apache.poi.ss.formula.functions.T;

import java.util.List;
import java.util.Map;

/**
 * Created by admin on 2017/5/17.
 */
public class DevPositionUtils {

    private static WoClientDao woClientDao = SpringContextHolder.getBean(WoClientDao.class);
    private static ClientAreaDao clientAreaDao = SpringContextHolder.getBean(ClientAreaDao.class);
    private static WoStationDao woStationDao = SpringContextHolder.getBean(WoStationDao.class);
    private static DevPositionDao devPositionDao = SpringContextHolder.getBean(DevPositionDao.class);
    private static DeviceCategoryDao deviceCategoryDao = SpringContextHolder.getBean(DeviceCategoryDao.class);

    public static final String CACHE_CLIENT_MAP = "clientMap";
    public static final String CACHE_AREA_MAP = "areaMap";
    public static final String CACHE_CITY_MAP = "cityMap";
    public static final String CACHE_STATION_MAP = "stationMap";
    public static final String CACHE_BUILD_MAP = "buildMap";
    public static final String CACHE_FLOOR_MAP = "floorMap";
    public static final String CACHE_ROOM_MAP = "roomMap";
    public static final String CACHE_FIRST_TYPE_MAP = "deviceType1Map";
    public static final String CACHE_SEC_TYPE_MAP = "deviceType2Map";
    public static final String CACHE_THIRD_TYPE_MAP = "deviceType3Map";

    public static String getIdValues(String client,String area,String city,String station,String build,String floor,String room,String className){
        if("woClient".equals(className)){
            if(StringUtils.isNoneBlank(client)){
                Map<String,String> woClientMap = (Map<String, String>) CacheUtils.get(CACHE_CLIENT_MAP);
                if (woClientMap==null){
                    woClientMap = Maps.newHashMap();
                    WoClient c1 = new WoClient();
                    c1.setName(client);
                    for (WoClient c : woClientDao.findList(c1)){
                        if(c != null){
                            woClientMap.put(client,c.getId());
                        }
                    }
                    CacheUtils.put(CACHE_FIRST_TYPE_MAP, woClientMap);
                }
                String id = woClientMap.get(client);
                return id == null?"":id;
            }
        }else if("woArea".equals(className)){
            if(StringUtils.isNoneBlank(client) && StringUtils.isNoneBlank(area)){

            }
        }else if("woCity".equals(className)){

        }else if("woStation".equals(className)){

        }else if("woBuild".equals(className)){

        }else if("woFloor".equals(className)){

        }else if("woRoom".equals(className)){

        }
        return "";
    }

    /**
     * 根据设备类型名字匹配设备类型信息
     * @param deviceType1
     * @param deviceType2
     * @param deviceType3
     * @param className
     * @return
     */
    public static DeviceCategory getDeviceCategoryByName(String deviceType1,String deviceType2,String deviceType3,String className){
        DeviceCategory category = null;
        Map<String,DeviceCategory> deviceType1Map = (Map<String, DeviceCategory>) CacheUtils.get(CACHE_FIRST_TYPE_MAP);
        if (deviceType1Map==null || deviceType1Map.keySet().size() == 0){
            deviceType1Map = Maps.newHashMap();
            DeviceCategory c = new DeviceCategory();
            DeviceCategory p = new DeviceCategory();
            p.setId("0");
            c.setParent(p);
            List<DeviceCategory> type1s = deviceCategoryDao.findList(c);
            List<DeviceCategory> type11s = Lists.newArrayList();
            for (DeviceCategory t1 : type1s) {
                DeviceCategory t1p = new DeviceCategory();
                t1p.setParent(t1);
                for (DeviceCategory t2 :deviceCategoryDao.findList(t1p)) {
                    type11s.add(t2);
                }
            }
            for (DeviceCategory type1 : type11s){
                if(type1 != null){
                    deviceType1Map.put(type1.getName(),type1);
                }
            }
            CacheUtils.put(CACHE_FIRST_TYPE_MAP, deviceType1Map);
        }
        Map<String,Map<String,DeviceCategory>> deviceType2Map = (Map<String, Map<String,DeviceCategory>>) CacheUtils.get(CACHE_SEC_TYPE_MAP);
        if (deviceType2Map==null || deviceType2Map.keySet().size() == 0){
            deviceType2Map = Maps.newHashMap();
            Map type2Map = Maps.newHashMap();
            for (String deviceType1Name: deviceType1Map.keySet()) {
                DeviceCategory type1 = deviceType1Map.get(deviceType1Name);
                DeviceCategory type1p = new DeviceCategory();
                type1p.setParent(type1);
                List<DeviceCategory> deviceType2List = deviceCategoryDao.findList(type1p);
                type2Map = Maps.newHashMap();
                for (DeviceCategory type2: deviceType2List) {
                    type2Map.put(type2.getName(),type2);
                }
                deviceType2Map.put(deviceType1Name,type2Map);
            }
            CacheUtils.put(CACHE_SEC_TYPE_MAP, deviceType2Map);
        }
        Map<String,Map<String,Map<String,DeviceCategory>>> deviceType3Map = (Map<String, Map<String,Map<String,DeviceCategory>>>) CacheUtils.get(CACHE_THIRD_TYPE_MAP);
        if (deviceType3Map==null || deviceType3Map.keySet().size() == 0){
            deviceType3Map = Maps.newHashMap();
            Map type2Map = Maps.newHashMap();
            Map type3Map = Maps.newHashMap();
            for (String deviceType1Name: deviceType1Map.keySet()) {
                DeviceCategory type1 = deviceType1Map.get(deviceType1Name);
                DeviceCategory type1p = new DeviceCategory();
                type1p.setParent(type1);
                List<DeviceCategory> deviceType2List = deviceCategoryDao.findList(type1p);
                type2Map = Maps.newHashMap();
                for (DeviceCategory type2: deviceType2List) {
                    type3Map = Maps.newHashMap();
                    DeviceCategory type2p = new DeviceCategory();
                    type2p.setParent(type2);
                    List<DeviceCategory> deviceType3List = deviceCategoryDao.findList(type2p);
                    for (DeviceCategory type3: deviceType3List) {
                        type3Map.put(type3.getName(),type3);
                    }
                    type2Map.put(type2.getName(),type3Map);
                }
                deviceType3Map.put(deviceType1Name,type2Map);
            }
            CacheUtils.put(CACHE_THIRD_TYPE_MAP, deviceType3Map);
        }
        if("deviceType1".equals(className)){
            category  = deviceType1Map.get(deviceType1);
        }else if("deviceType2".equals(className)){
            category  = deviceType2Map.get(deviceType1).get(deviceType2);
        }else if("deviceType3".equals(className)){
            category  = deviceType3Map.get(deviceType1).get(deviceType2).get(deviceType3);
        }
        return category;
    }

    /**
     * 根据站点名字匹配站点信息
     * @param name
     * @return
     */
    public static WoStation getWoStationByName(String name){
        Map<String,WoStation> woStationMap = (Map<String, WoStation>) CacheUtils.get(CACHE_STATION_MAP);
        if (woStationMap==null || woStationMap.keySet().size() == 0){
            woStationMap = Maps.newHashMap();
            for (WoStation woStation : woStationDao.findAllList(new WoStation())){
                woStationMap.put(woStation.getName(),woStation);
            }
            CacheUtils.put(CACHE_STATION_MAP, woStationMap);
        }
        return woStationMap.get(name);
    }

    /**
     * 根据客户名字匹配客户信息
     * @param name
     * @return
     */
    public static WoClient getWoClientByName(String name){
        Map<String,WoClient> woClientMap = (Map<String, WoClient>) CacheUtils.get(CACHE_CLIENT_MAP);
        if (woClientMap==null || woClientMap.keySet().size() == 0){
            woClientMap = Maps.newHashMap();
            for (WoClient woClient : woClientDao.findAllList(new WoClient())){
                woClientMap.put(woClient.getName(),woClient);
            }
            CacheUtils.put(CACHE_CLIENT_MAP, woClientMap);
        }
        return woClientMap.get(name);
    }

    /**
     * 根据客户名字和区域名字匹配区域信息
     *
     * @param clientName
     * @param areaName
     * @return
     */
    public static ClientArea getClientAreaByAreaName(String clientName,String areaName){
        WoClient client = getWoClientByName(clientName);
        ClientArea ca = new ClientArea();
        ca.setWoClient(client);
        List<ClientArea> clientAreas = clientAreaDao.findList(ca);
        Map<String,ClientArea> areaMap = Maps.newHashMap();
        for (ClientArea  cc : clientAreas) {
            areaMap.put(cc.getName(),cc);
        }
        return areaMap.get(areaName);
    }

    /**
     * 根据客户名字和区域名字、城市名字匹配城市信息
     *
     * @param clientName
     * @param areaName
     * @return
     */
    public static ClientArea getClientAreaByCityName(String clientName,String areaName,String cityName){
        ClientArea ca = new ClientArea();
        ca.setParent(getClientAreaByAreaName(clientName,areaName));
        List<ClientArea> clientAreas = clientAreaDao.findList(ca);
        Map<String,ClientArea> areaMap = Maps.newHashMap();
        for (ClientArea  cc : clientAreas) {
            areaMap.put(cc.getName(),cc);
        }
        return areaMap.get(cityName);
    }

    /**
     * 根据客户名字、区域名字、城市名字、站点名字匹配站点信息
     * @param clientName
     * @param areaName
     * @param cityName
     * @param stationName
     * @return
     */
    public static WoStation getWoStationByName(String clientName,String areaName,String cityName,String stationName){
        ClientArea c = getClientAreaByCityName(clientName,areaName,cityName);
        WoStation w = new WoStation();
        w.setArea(c);
        List<WoStation> woStations = woStationDao.findList(w);
        Map<String,WoStation> woStationMap = Maps.newHashMap();
        for (WoStation ww:woStations) {
            woStationMap.put(ww.getName(),ww);
        }
        return woStationMap.get(stationName);
    }

    /**
     * 根据客户名字、区域名字、城市名字、站点名字、大楼名字匹配大楼信息
     * @param clientName
     * @param areaName
     * @param cityName
     * @param stationName
     * @param buildName
     * @return
     */
    public static DevPosition getDevPositionByBuildName(String clientName,String areaName,String cityName,String stationName,String buildName){
        WoStation w = getWoStationByName(clientName, areaName,cityName, stationName);
        DevPosition d = new DevPosition();
        d.setWoStation(w);
        List<DevPosition> devPositions = devPositionDao.findList(d);
        Map<String,DevPosition> devPositionMap = Maps.newHashMap();
        for (DevPosition dd: devPositions) {
            devPositionMap.put(dd.getName(),dd);
        }
        return devPositionMap.get(buildName);
    }

    /**
     * 根据客户名字、区域名字、城市名字、站点名字、大楼名字、楼层名字匹配楼层信息
     * @param clientName
     * @param areaName
     * @param cityName
     * @param stationName
     * @param buildName
     * @param floorName
     * @return
     */
    public static DevPosition getDevPositionByFloorName(String clientName,String areaName,String cityName,String stationName,String buildName,String floorName){
        DevPosition d = getDevPositionByBuildName(clientName,areaName, cityName,stationName, buildName);
        DevPosition dd = new DevPosition();
        dd.setParent(d);
        List<DevPosition> devPositions = devPositionDao.findList(dd);
        Map<String,DevPosition> devPositionMap = Maps.newHashMap();
        for (DevPosition ddd :devPositions ) {
            devPositionMap.put(ddd.getName(),ddd);
        }
        return devPositionMap.get(floorName);
    }

    /**
     * 根据客户名字、区域名字、城市名字、站点名字、大楼名字、楼层名字、房间名字匹配房间信息
     * @param clientName
     * @param areaName
     * @param cityName
     * @param stationName
     * @param buildName
     * @param floorName
     * @param roomName
     * @return
     */
    public static DevPosition getDevPositionByRoomName(String clientName,String areaName,String cityName,String stationName,String buildName,String floorName,String roomName){
        DevPosition d = getDevPositionByFloorName(clientName, areaName, cityName, stationName, buildName, floorName);
        DevPosition dd = new DevPosition();
        dd.setParent(d);
        List<DevPosition> devPositions = devPositionDao.findList(dd);
        Map<String,DevPosition> devPositionMap = Maps.newHashMap();
        for (DevPosition ddd :devPositions ) {
            devPositionMap.put(ddd.getName(),ddd);
        }


        return devPositionMap.get(roomName);
    }

    /**
     * 根据设备位置节点名字匹配设备位置节点信息
     * @param clientName
     * @param areaName
     * @param stationName
     * @param cityName
     * @param buildName
     * @param floorName
     * @param roomName
     * @param type  节点类型(客户？区域？城市？站点？大楼？楼层？房间？)
     * @return
     */
    public static DevPosition getDevPositionByName(String clientName,String areaName,String stationName,String cityName,String buildName,String floorName,String roomName,String type){
        DevPosition devPosition = null;
        Map<String,DevPosition> clientMap = (Map<String, DevPosition>) CacheUtils.get(CACHE_CLIENT_MAP);
        if (clientMap==null || clientMap.keySet().size() == 0){
            clientMap = Maps.newHashMap();
            DevPosition c = new DevPosition();
            DevPosition p = new DevPosition();
            p.setId("0");
            c.setParent(p);
            List<DevPosition> clients = devPositionDao.findList(c);
            for (DevPosition t1 : clients) {
                clientMap.put(t1.getName(),t1);
            }
            CacheUtils.put(CACHE_CLIENT_MAP, clientMap);
        }
        Map<String,Map<String,DevPosition>> areaMap = (Map<String, Map<String,DevPosition>>) CacheUtils.get(CACHE_AREA_MAP);
        if (areaMap==null || areaMap.keySet().size() == 0){
            for (String t1 : clientMap.keySet()) {
                DevPosition t1p = new DevPosition();
                t1p.setParent(clientMap.get(t1));
                Map<String,DevPosition> area2Map = Maps.newHashMap();
                for (DevPosition t2 : devPositionDao.findList(t1p)) {
                    area2Map.put(t2.getName(),t2);
                }
                areaMap.put(t1,area2Map);
            }
            CacheUtils.put(CACHE_AREA_MAP, areaMap);
        }
        Map<String,Map<String,Map<String,DevPosition>>> cityMap = (Map<String, Map<String,Map<String,DevPosition>>>) CacheUtils.get(CACHE_CITY_MAP);
        if (cityMap==null || cityMap.keySet().size() == 0){
            for (String t1 : clientMap.keySet()) {
                DevPosition t1p = new DevPosition();
                t1p.setParent(clientMap.get(t1));
                Map<String,Map<String,DevPosition>> area2Map = Maps.newHashMap();
                for (DevPosition t2 : devPositionDao.findList(t1p)) {
                    DevPosition t2p = new DevPosition();
                    t2p.setParent(t2);
                    Map<String,DevPosition> area3Map = Maps.newHashMap();
                    for (DevPosition t3 : devPositionDao.findList(t2p)) {
                        area3Map.put(t3.getName(),t3);
                    }
                    area2Map.put(t2.getName(),area3Map);
                }
                cityMap.put(t1,area2Map);
            }
            CacheUtils.put(CACHE_CITY_MAP, cityMap);
        }
        Map<String,Map<String,Map<String,Map<String,DevPosition>>>> stationMap = (Map<String, Map<String,Map<String,Map<String,DevPosition>>>>) CacheUtils.get(CACHE_STATION_MAP);
        if (stationMap==null || stationMap.keySet().size() == 0){
            for (String t1 : clientMap.keySet()) {
                DevPosition t1p = new DevPosition();
                t1p.setParent(clientMap.get(t1));
                Map<String,Map<String,Map<String,DevPosition>>> area2Map = Maps.newHashMap();
                for (DevPosition t2 : devPositionDao.findList(t1p)) {
                    DevPosition t2p = new DevPosition();
                    t2p.setParent(t2);
                    Map<String,Map<String,DevPosition>> area3Map = Maps.newHashMap();
                    for (DevPosition t3 : devPositionDao.findList(t2p)) {
                        DevPosition t3p = new DevPosition();
                        t3p.setParent(t3);
                        Map<String,DevPosition> area4Map = Maps.newHashMap();
                        for (DevPosition t4 : devPositionDao.findList(t3p)) {
                            area4Map.put(t4.getName(),t4);
                        }
                        area3Map.put(t3.getName(),area4Map);
                    }
                    area2Map.put(t2.getName(),area3Map);
                }
                stationMap.put(t1,area2Map);
            }
            CacheUtils.put(CACHE_STATION_MAP, stationMap);
        }
        Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>> buildMap = (Map<String, Map<String,Map<String,Map<String,Map<String,DevPosition>>>>>) CacheUtils.get(CACHE_BUILD_MAP);
        if (buildMap==null || buildMap.keySet().size() == 0){
            for (String t1 : clientMap.keySet()) {
                DevPosition t1p = new DevPosition();
                t1p.setParent(clientMap.get(t1));
                Map<String,Map<String,Map<String,Map<String,DevPosition>>>> area2Map = Maps.newHashMap();
                for (DevPosition t2 : devPositionDao.findList(t1p)) {
                    DevPosition t2p = new DevPosition();
                    t2p.setParent(t2);
                    Map<String,Map<String,Map<String,DevPosition>>> area3Map = Maps.newHashMap();
                    for (DevPosition t3 : devPositionDao.findList(t2p)) {
                        DevPosition t3p = new DevPosition();
                        t3p.setParent(t3);
                        Map<String,Map<String,DevPosition>> area4Map = Maps.newHashMap();
                        for (DevPosition t4 : devPositionDao.findList(t3p)) {
                            DevPosition t4p = new DevPosition();
                            t4p.setParent(t4);
                            Map<String,DevPosition> area5Map = Maps.newHashMap();
                            for (DevPosition t5 : devPositionDao.findList(t4p)) {
                                area5Map.put(t5.getName(),t5);
                            }
                            area4Map.put(t4.getName(),area5Map);
                        }
                        area3Map.put(t3.getName(),area4Map);
                    }
                    area2Map.put(t2.getName(),area3Map);
                }
                buildMap.put(t1,area2Map);
            }
            CacheUtils.put(CACHE_BUILD_MAP, buildMap);
        }
        Map<String,Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>>> floorMap = (Map<String, Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>>>) CacheUtils.get(CACHE_BUILD_MAP);
        if (floorMap==null || floorMap.keySet().size() == 0){
            for (String t1 : clientMap.keySet()) {
                DevPosition t1p = new DevPosition();
                t1p.setParent(clientMap.get(t1));
                Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>> area2Map = Maps.newHashMap();
                for (DevPosition t2 : devPositionDao.findList(t1p)) {
                    DevPosition t2p = new DevPosition();
                    t2p.setParent(t2);
                    Map<String,Map<String,Map<String,Map<String,DevPosition>>>> area3Map = Maps.newHashMap();
                    for (DevPosition t3 : devPositionDao.findList(t2p)) {
                        DevPosition t3p = new DevPosition();
                        t3p.setParent(t3);
                        Map<String,Map<String,Map<String,DevPosition>>> area4Map = Maps.newHashMap();
                        for (DevPosition t4 : devPositionDao.findList(t3p)) {
                            DevPosition t4p = new DevPosition();
                            t4p.setParent(t4);
                            Map<String,Map<String,DevPosition>> area5Map = Maps.newHashMap();
                            for (DevPosition t5 : devPositionDao.findList(t4p)) {
                                DevPosition t5p = new DevPosition();
                                t5p.setParent(t5);
                                Map<String,DevPosition> area6Map = Maps.newHashMap();
                                for (DevPosition t6 : devPositionDao.findList(t5p)) {
                                    area6Map.put(t6.getName(),t6);
                                }
                                area5Map.put(t5.getName(),area6Map);
                            }
                            area4Map.put(t4.getName(),area5Map);
                        }
                        area3Map.put(t3.getName(),area4Map);
                    }
                    area2Map.put(t2.getName(),area3Map);
                }
                floorMap.put(t1,area2Map);
            }
            CacheUtils.put(CACHE_BUILD_MAP, floorMap);
        }
        Map<String,Map<String,Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>>>> roomMap = (Map<String, Map<String,Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>>>>) CacheUtils.get(CACHE_BUILD_MAP);
        if (roomMap==null || roomMap.keySet().size() == 0){
            for (String t1 : clientMap.keySet()) {
                DevPosition t1p = new DevPosition();
                t1p.setParent(clientMap.get(t1));
                Map<String,Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>>> area2Map = Maps.newHashMap();
                for (DevPosition t2 : devPositionDao.findList(t1p)) {
                    DevPosition t2p = new DevPosition();
                    t2p.setParent(t2);
                    Map<String,Map<String,Map<String,Map<String,Map<String,DevPosition>>>>> area3Map = Maps.newHashMap();
                    for (DevPosition t3 : devPositionDao.findList(t2p)) {
                        DevPosition t3p = new DevPosition();
                        t3p.setParent(t3);
                        Map<String,Map<String,Map<String,Map<String,DevPosition>>>> area4Map = Maps.newHashMap();
                        for (DevPosition t4 : devPositionDao.findList(t3p)) {
                            DevPosition t4p = new DevPosition();
                            t4p.setParent(t4);
                            Map<String,Map<String,Map<String,DevPosition>>> area5Map = Maps.newHashMap();
                            for (DevPosition t5 : devPositionDao.findList(t4p)) {
                                DevPosition t5p = new DevPosition();
                                t5p.setParent(t5);
                                Map<String,Map<String,DevPosition>> area6Map = Maps.newHashMap();
                                for (DevPosition t6 : devPositionDao.findList(t5p)) {
                                    DevPosition t6p = new DevPosition();
                                    t6p.setParent(t6);
                                    Map<String,DevPosition> area7Map = Maps.newHashMap();
                                    for (DevPosition t7 : devPositionDao.findList(t6p)) {
                                        area7Map.put(t7.getName(),t7);
                                    }
                                    area6Map.put(t6.getName(),area7Map);
                                }
                                area5Map.put(t5.getName(),area6Map);
                            }
                            area4Map.put(t4.getName(),area5Map);
                        }
                        area3Map.put(t3.getName(),area4Map);
                    }
                    area2Map.put(t2.getName(),area3Map);
                }
                roomMap.put(t1,area2Map);
            }
            CacheUtils.put(CACHE_BUILD_MAP, roomMap);
        }
        if("client".equals(type)){
            return clientMap.get(clientName);
        }else if("area".equals(type)){
            return areaMap.get(clientName).get(areaName);
        }else if("city".equals(type)){
            return cityMap.get(clientName).get(areaName).get(cityName);
        }else if("station".equals(type)){
            return stationMap.get(clientName).get(areaName).get(cityName).get(stationName);
        }else if("build".equals(type)){
            return buildMap.get(clientName).get(areaName).get(cityName).get(stationName).get(buildName);
        }else if("floor".equals(type)){
            return floorMap.get(clientName).get(areaName).get(cityName).get(stationName).get(buildName).get(floorName);
        }else if("room".equals(type)){
            return roomMap.get(clientName).get(areaName).get(cityName).get(stationName).get(buildName).get(floorName).get(roomName);
        }
        return null;
    }



}
