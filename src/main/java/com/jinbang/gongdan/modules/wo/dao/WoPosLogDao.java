package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoPosLog;

/**
 * @author Jianghui
 * @version V1.0
 * @description ${DESCRIPTION}
 * @date 2017-05-08 20:20
 */
@MyBatisDao
public interface WoPosLogDao extends CrudDao<WoPosLog> {
}
