
package com.jinbang.gongdan.modules.cms.service;

import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.cms.dao.ArticleDataDao;
import com.jinbang.gongdan.modules.cms.entity.ArticleData;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 站点Service
 */
@Service
@Transactional(readOnly = true)
public class ArticleDataService extends CrudService<ArticleDataDao, ArticleData> {

}
