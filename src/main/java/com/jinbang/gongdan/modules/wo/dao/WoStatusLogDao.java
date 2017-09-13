package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.BaseDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoStatusLog;

import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/30 15:56
 */
@MyBatisDao
public interface WoStatusLogDao extends BaseDao {
    List<WoStatusLog> findList(WoStatusLog woStatusLog);

    int insert(WoStatusLog woStatusLog);
}
