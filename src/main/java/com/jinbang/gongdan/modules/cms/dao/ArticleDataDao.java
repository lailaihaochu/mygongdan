
package com.jinbang.gongdan.modules.cms.dao;


import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.cms.entity.ArticleData;

/**
 * 文章DAO接口
 */
@MyBatisDao
public interface ArticleDataDao extends CrudDao<ArticleData> {
	
}
