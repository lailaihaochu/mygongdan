package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoClient;

import java.util.List;

/**
 * 客户基本信息管理DAO接口
 * @author 许江辉
 * @version 2016-06-27
 */
@MyBatisDao
public interface WoClientDao extends CrudDao<WoClient> {

    List<WoClient> findClientByAreaId(WoClient woClient);
}