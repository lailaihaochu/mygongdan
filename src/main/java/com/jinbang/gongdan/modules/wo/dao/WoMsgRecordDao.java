package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoMsgRecord;

import java.util.List;

/**
 * 工单团队消息Dao
 * author:Jianghui
 * date:2016/7/18 9:55
 */
@MyBatisDao
public interface WoMsgRecordDao {
    List<WoMsgRecord> findByWorksheet(String worksheetId);

    int insert(WoMsgRecord woMsgRecord);
}
