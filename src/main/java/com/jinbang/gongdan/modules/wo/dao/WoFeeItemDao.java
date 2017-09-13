package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.BaseDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoFeeItem;

import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/7 0:12
 */
@MyBatisDao
public interface WoFeeItemDao extends BaseDao {
    int insert(WoFeeItem item);
    int update(WoFeeItem item);
    WoFeeItem get(WoFeeItem item);
    List<WoFeeItem> findByWorksheet(WoFeeItem item);

    int delete(WoFeeItem item);
}
