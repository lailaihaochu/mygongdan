package com.jinbang.gongdan.modules.wo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jinbang.gongdan.common.service.TreeService;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.entity.WoTemplate;
import com.jinbang.gongdan.modules.wo.dao.WoTemplateDao;

/**
 * 模板管理Service
 * @author 许江辉
 * @version 2016-09-03
 */
@Service
@Transactional(readOnly = true)
public class WoTemplateService extends TreeService<WoTemplateDao, WoTemplate> {

	public WoTemplate get(String id) {
		return super.get(id);
	}
	
	public List<WoTemplate> findList(WoTemplate woTemplate) {
		if (StringUtils.isNotBlank(woTemplate.getParentIds())){
			woTemplate.setParentIds(","+woTemplate.getParentIds()+",");
		}
		return super.findList(woTemplate);
	}
	
	@Transactional(readOnly = false)
	public void save(WoTemplate woTemplate) {
		super.save(woTemplate);
		for (WoTemplate detail : woTemplate.getWoTemplateList()){
			if (detail.getId() == null){
				continue;
			}
			if (detail.DEL_FLAG_NORMAL.equals(detail.getDelFlag())){
				detail.setParent(woTemplate);
				if (StringUtils.isBlank(detail.getId())){
					detail.preInsert();
					dao.insert(detail);
				}else{
					detail.preUpdate();
					dao.update(detail);
				}
			}else{
				dao.delete(detail);
			}
		}
	}
	
	@Transactional(readOnly = false)
	public void delete(WoTemplate woTemplate) {
		super.delete(woTemplate);
	}

	public WoTemplate getByName(String name) {
		return dao.getByName(name);
	}
}