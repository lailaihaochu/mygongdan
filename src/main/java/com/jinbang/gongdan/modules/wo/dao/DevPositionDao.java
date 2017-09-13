package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.TreeDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.DevPosition;

/**
 * 客户区域相关DAO接口
 * @author 许江辉
 * @version 2016-08-07
 */
@MyBatisDao
public interface DevPositionDao extends TreeDao<DevPosition> {
	
}