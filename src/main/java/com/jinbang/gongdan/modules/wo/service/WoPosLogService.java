package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.wo.dao.WoPosLogDao;
import com.jinbang.gongdan.modules.wo.entity.WoPosLog;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author Jianghui
 * @version V1.0
 * @description ${DESCRIPTION}
 * @date 2017-05-08 20:41
 */
@Service
@Transactional(readOnly = true)
public class WoPosLogService extends CrudService<WoPosLogDao,WoPosLog> {

}
