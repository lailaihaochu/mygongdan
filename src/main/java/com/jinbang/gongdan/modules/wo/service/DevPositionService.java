package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.service.TreeService;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.dao.ClientAreaDao;
import com.jinbang.gongdan.modules.wo.dao.DevPositionDao;
import com.jinbang.gongdan.modules.wo.entity.ClientArea;
import com.jinbang.gongdan.modules.wo.entity.DevPosition;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 位置信息相关Service
 * @author 许江辉
 * @version 2016-08-07
 */
@Service
@Transactional(readOnly = true)
public class DevPositionService extends TreeService<DevPositionDao, DevPosition> {

	public DevPosition get(String id) {
		return super.get(id);
	}
	
	public List<DevPosition> findList(DevPosition devPos) {
		if (StringUtils.isNotBlank(devPos.getParentIds())){
			devPos.setParentIds(","+devPos.getParentIds()+",");
		}
		return super.findList(devPos);
	}
	
	@Transactional(readOnly = false)
	public void save(DevPosition devPos) {
		super.save(devPos);
	}
	
	@Transactional(readOnly = false)
	public void delete(DevPosition devPos) {
		super.delete(devPos);
	}
	
}