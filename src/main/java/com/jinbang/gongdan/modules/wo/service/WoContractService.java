package com.jinbang.gongdan.modules.wo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.wo.entity.WoContract;
import com.jinbang.gongdan.modules.wo.dao.WoContractDao;

/**
 * 合同信息相关Service
 * @author 许江辉
 * @version 2016-07-01
 */
@Service
@Transactional(readOnly = true)
public class WoContractService extends CrudService<WoContractDao, WoContract> {

	public WoContract get(String id) {
		return super.get(id);
	}
	
	public List<WoContract> findList(WoContract woContract) {
		return super.findList(woContract);
	}
	
	public Page<WoContract> findPage(Page<WoContract> page, WoContract woContract) {
		return super.findPage(page, woContract);
	}
	
	@Transactional(readOnly = false)
	public void save(WoContract woContract) {
		super.save(woContract);
	}
	
	@Transactional(readOnly = false)
	public void delete(WoContract woContract) {
		super.delete(woContract);
	}
	
}