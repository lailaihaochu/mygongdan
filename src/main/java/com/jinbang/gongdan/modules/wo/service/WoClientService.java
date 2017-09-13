package com.jinbang.gongdan.modules.wo.service;

import java.util.List;

import com.jinbang.gongdan.modules.sys.entity.Area;
import com.jinbang.gongdan.modules.sys.entity.Office;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.wo.entity.WoClient;
import com.jinbang.gongdan.modules.wo.dao.WoClientDao;

/**
 * 客户基本信息管理Service
 * @author 许江辉
 * @version 2016-06-27
 */
@Service
@Transactional(readOnly = true)
public class WoClientService extends CrudService<WoClientDao, WoClient> {

	public WoClient get(String id) {
		return super.get(id);
	}
	
	public List<WoClient> findList(WoClient woClient) {
		return super.findList(woClient);
	}
	
	public Page<WoClient> findPage(Page<WoClient> page, WoClient woClient) {
		return super.findPage(page, woClient);
	}
	
	@Transactional(readOnly = false)
	public void save(WoClient woClient) {
		super.save(woClient);
	}
	
	@Transactional(readOnly = false)
	public void delete(WoClient woClient) {
		super.delete(woClient);
	}

	public List<WoClient> findClientByAreaId(String areaId) {
		WoClient woClient=new WoClient();
		Office office=new Office();
		office.setArea(new Area(areaId));
		woClient.setOffice(office);
		return dao.findClientByAreaId(woClient);
	}
}