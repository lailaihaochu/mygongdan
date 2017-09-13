package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.BaseDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.SnEntity;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/16 21:51
 */
@MyBatisDao
public interface SnGenDao  extends BaseDao {
    public SnEntity getCurrentSn(SnEntity snEntity);

    public int insert(SnEntity snEntity);

    public int update(SnEntity snEntity);
}
