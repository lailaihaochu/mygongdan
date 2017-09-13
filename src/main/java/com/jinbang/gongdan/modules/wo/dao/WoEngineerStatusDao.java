package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WoEngineerStatus;

/**
 * @author Jianghui
 * @version V1.0
 * @description ${DESCRIPTION}
 * @date 2017-05-15 18:49
 */
@MyBatisDao
public interface WoEngineerStatusDao extends CrudDao<WoEngineerStatus> {

    public WoEngineerStatus getByEngineer(WoEngineerStatus woEngineerStatus);


}
