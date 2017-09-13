package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoContract;

/**
 * 合同信息相关DAO接口
 * @author 许江辉
 * @version 2016-07-01
 */
@MyBatisDao
public interface WoContractDao extends CrudDao<WoContract> {
	
}