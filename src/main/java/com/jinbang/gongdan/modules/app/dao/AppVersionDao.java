package com.jinbang.gongdan.modules.app.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.app.entity.AppVersion;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/24 14:31
 */
@MyBatisDao
public interface AppVersionDao extends CrudDao<AppVersion> {
    AppVersion getLastVersion(AppVersion appVersion);

}
