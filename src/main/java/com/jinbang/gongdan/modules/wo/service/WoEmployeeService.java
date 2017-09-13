package com.jinbang.gongdan.modules.wo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import com.jinbang.gongdan.modules.wo.dao.WoEmployeeDao;

/**
 * 员工信息相关Service
 * @author 许江辉
 * @version 2016-06-28
 */
@Service
@Transactional(readOnly = true)
public class WoEmployeeService extends CrudService<WoEmployeeDao, WoEmployee> {

	public WoEmployee get(String id) {
		return super.get(id);
	}
	
	public List<WoEmployee> findList(WoEmployee woEmployee) {
		return super.findList(woEmployee);
	}
	
	public Page<WoEmployee> findPage(Page<WoEmployee> page, WoEmployee woEmployee) {
		return super.findPage(page, woEmployee);
	}
	
	@Transactional(readOnly = false)
	public void save(WoEmployee woEmployee) {
		super.save(woEmployee);
	}
	
	@Transactional(readOnly = false)
	public void delete(WoEmployee woEmployee) {
		super.delete(woEmployee);
	}
	
}