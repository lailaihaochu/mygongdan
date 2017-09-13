package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.wo.entity.WorksheetFiles;

/**
 * 工单附件DAO接口
 * @author 许江辉
 * @version 2016-07-12
 */
@MyBatisDao
public interface WorksheetFilesDao extends CrudDao<WorksheetFiles> {
	
}