package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.PoRecord;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/14 10:08
 */
@MyBatisDao
public interface PoRecordDao extends CrudDao<PoRecord> {
    PoRecord getByPo(String poNo);

    PoRecord getByWoId(String woId);

    int deleteWorksheets(PoRecord poRecord);

    int insertWorksheets(PoRecord poRecord);

}
