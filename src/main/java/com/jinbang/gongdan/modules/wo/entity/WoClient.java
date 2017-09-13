package com.jinbang.gongdan.modules.wo.entity;

import org.hibernate.validator.constraints.Length;
import com.jinbang.gongdan.modules.sys.entity.Office;

import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * 客户基本信息管理Entity
 * @author 许江辉
 * @version 2016-06-27
 */
public class WoClient extends DataEntity<WoClient> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称(简称)
	private String fullName; //全称
	private String code;		// 代码
	private Office office;		// 归属机构
	
	public WoClient() {
		super();
	}

	public WoClient(String id){
		super(id);
	}

	@Length(min=0, max=200, message="简称长度必须介于 0 和 200 之间")
	public String getName() {
		return name;
	}
	@Length(min=0, max=200, message="全称长度必须介于 0 和 200 之间")
	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=100, message="代码长度必须介于 0 和 100 之间")
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}
	
	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	@Override
	public String toString() {
		return name;
	}
}