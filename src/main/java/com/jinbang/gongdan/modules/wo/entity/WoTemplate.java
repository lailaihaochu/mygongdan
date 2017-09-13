package com.jinbang.gongdan.modules.wo.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import org.hibernate.validator.constraints.Length;

import com.jinbang.gongdan.common.persistence.TreeEntity;

import java.util.List;

/**
 * 模板管理Entity
 * @author 许江辉
 * @version 2016-09-03
 */
public class WoTemplate extends TreeEntity<WoTemplate> {
	
	private static final long serialVersionUID = 1L;
	private WoTemplate parent;		// 父节点
	private String parentIds;		// parent_ids
	private String name;		// 模板名称
	private String type;//类型：0模板，1模板项
	private String detailName;		// 巡检项名称
	private String detailContent;		// 巡检内容
	private List<WoTemplate> woTemplateList;//模板内容：

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public List<WoTemplate> getWoTemplateList() {
		return woTemplateList;
	}

	public void setWoTemplateList(List<WoTemplate> woTemplateList) {
		this.woTemplateList = woTemplateList;
	}

	public WoTemplate() {
		super();
	}

	public WoTemplate(String id){
		super(id);
	}

	@JsonBackReference
	public WoTemplate getParent() {
		return parent;
	}

	public void setParent(WoTemplate parent) {
		this.parent = parent;
	}
	
	@Length(min=0, max=2000, message="parent_ids长度必须介于 0 和 2000 之间")
	public String getParentIds() {
		return parentIds;
	}

	public void setParentIds(String parentIds) {
		this.parentIds = parentIds;
	}
	
	@Length(min=0, max=255, message="模板名称长度必须介于 0 和 255 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=255, message="巡检项名称长度必须介于 0 和 255 之间")
	public String getDetailName() {
		return detailName;
	}

	public void setDetailName(String detailName) {
		this.detailName = detailName;
	}
	
	@Length(min=0, max=255, message="巡检内容长度必须介于 0 和 255 之间")
	public String getDetailContent() {
		return detailContent;
	}

	public void setDetailContent(String detailContent) {
		this.detailContent = detailContent;
	}
	
	public String getParentId() {
		return parent != null && parent.getId() != null ? parent.getId() : "0";
	}



}