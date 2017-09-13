package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.service.TreeService;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.dao.DevPositionDao;
import com.jinbang.gongdan.modules.wo.dao.DeviceCategoryDao;
import com.jinbang.gongdan.modules.wo.entity.DevPosition;
import com.jinbang.gongdan.modules.wo.entity.DeviceCategory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 设备类目相关Service
 * @author 许江辉
 * @version 2016-08-07
 */
@Service
@Transactional(readOnly = true)
public class DeviceCategoryService extends TreeService<DeviceCategoryDao, DeviceCategory> {

	public DeviceCategory get(String id) {
		return super.get(id);
	}
	
	public List<DeviceCategory> findList(DeviceCategory devCate) {
		if (StringUtils.isNotBlank(devCate.getParentIds())){
			devCate.setParentIds(","+devCate.getParentIds()+",");
		}
		return super.findList(devCate);
	}
	
	@Transactional(readOnly = false)
	public void save(DeviceCategory devCate) {
		super.save(devCate);
	}
	
	@Transactional(readOnly = false)
	public void delete(DeviceCategory devCate) {
		super.delete(devCate);
	}
	
}