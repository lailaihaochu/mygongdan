package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import com.jinbang.gongdan.modules.wo.entity.WoStation;

import java.util.List;

/**
 * 员工信息相关DAO接口
 * @author 许江辉
 * @version 2016-06-28
 */
@MyBatisDao
public interface WoEmployeeDao extends CrudDao<WoEmployee> {

    List<WoEmployee> findEmploeeByStationId(String  stationId);
}