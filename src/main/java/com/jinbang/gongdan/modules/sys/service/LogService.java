
package com.jinbang.gongdan.modules.sys.service;


import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.modules.sys.dao.LogDao;
import com.jinbang.gongdan.modules.sys.entity.Log;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 日志Service
 */
@Service
@Transactional(readOnly = true)
public class LogService extends CrudService<LogDao, Log> {

	public Page<Log> findPage(Page<Log> page, Log log) {
		
		// 设置默认时间范围，默认当前月
		if (log.getBeginDate() == null){
			log.setBeginDate(DateUtils.setDays(DateUtils.parseDate(DateUtils.getDate()), 1));
		}
		if (log.getEndDate() == null){
			log.setEndDate(DateUtils.getDateEnd(DateUtils.addMonths(log.getBeginDate(), 1)));
		}
		
		return super.findPage(page, log);
		
	}
	
}
