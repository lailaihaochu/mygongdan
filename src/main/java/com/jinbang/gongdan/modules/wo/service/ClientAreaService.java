package com.jinbang.gongdan.modules.wo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.service.TreeService;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.entity.ClientArea;
import com.jinbang.gongdan.modules.wo.dao.ClientAreaDao;

/**
 * 客户区域相关Service
 * @author 许江辉
 * @version 2016-08-07
 */
@Service
@Transactional(readOnly = true)
public class ClientAreaService extends TreeService<ClientAreaDao, ClientArea> {

	public ClientArea get(String id) {
		return super.get(id);
	}
	
	public List<ClientArea> findList(ClientArea clientArea) {
		if (StringUtils.isNotBlank(clientArea.getParentIds())){
			clientArea.setParentIds(","+clientArea.getParentIds()+",");
		}
		return super.findList(clientArea);
	}
	
	@Transactional(readOnly = false)
	public void save(ClientArea clientArea) {
		super.save(clientArea);
	}
	
	@Transactional(readOnly = false)
	public void delete(ClientArea clientArea) {
		super.delete(clientArea);
	}
	
}