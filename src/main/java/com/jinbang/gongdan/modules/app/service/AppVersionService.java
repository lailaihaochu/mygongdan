package com.jinbang.gongdan.modules.app.service;

import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.app.dao.AppVersionDao;
import com.jinbang.gongdan.modules.app.entity.AppVersion;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/24 14:30
 */

@Service
@Transactional(readOnly = true)
public class AppVersionService extends CrudService<AppVersionDao,AppVersion> {
    public AppVersion getLastVersion(String appName){
        return dao.getLastVersion(new AppVersion(appName));
    }
}
