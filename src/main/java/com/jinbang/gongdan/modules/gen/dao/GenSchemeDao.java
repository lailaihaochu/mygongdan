
package com.jinbang.gongdan.modules.gen.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.gen.entity.GenScheme;

/**
 * 生成方案DAO接口
 */
@MyBatisDao
public interface GenSchemeDao extends CrudDao<GenScheme> {
	
}
