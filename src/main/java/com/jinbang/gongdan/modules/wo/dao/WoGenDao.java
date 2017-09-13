package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.BaseDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoEntity;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/17 23:45
 */
@MyBatisDao
public interface WoGenDao  extends BaseDao{
    WoEntity getCurrentWo(WoEntity woEntity);

    int insert(WoEntity curEntity);

    int update(WoEntity curEntity);
}
