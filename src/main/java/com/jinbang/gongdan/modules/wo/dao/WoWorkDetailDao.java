package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoWorkDetail;

/**
 * 工单任务相关DAO接口
 * @author 许江辉
 * @version 2016-07-05
 */
@MyBatisDao
public interface WoWorkDetailDao extends CrudDao<WoWorkDetail> {
	
}