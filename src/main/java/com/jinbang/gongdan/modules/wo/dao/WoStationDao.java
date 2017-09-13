package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import com.jinbang.gongdan.modules.wo.entity.WoStation;

import java.util.List;
import java.util.Map;

/**
 * 运作站点基本信息DAO接口
 * @author 许江辉
 * @version 2016-06-27
 */
@MyBatisDao
public interface WoStationDao extends CrudDao<WoStation> {

    int deleteContactByStationId(String stationId);

    int insertContact(WoStation woStation);

    int deleteEngineerByStationId(String stationId);

    int insertEngineer(WoStation woStation);
    List<Map<String,Object>> findTreeData();

}