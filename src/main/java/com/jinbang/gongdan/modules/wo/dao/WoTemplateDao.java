package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.TreeDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoTemplate;

/**
 * 模板管理DAO接口
 * @author 许江辉
 * @version 2016-09-03
 */
@MyBatisDao
public interface WoTemplateDao extends TreeDao<WoTemplate> {

    WoTemplate getByName(String name);
}