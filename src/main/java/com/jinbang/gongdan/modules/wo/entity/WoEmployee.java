package com.jinbang.gongdan.modules.wo.entity;

import org.hibernate.validator.constraints.Length;
import com.jinbang.gongdan.modules.sys.entity.Office;

import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * 员工信息相关Entity
 * @author 许江辉
 * @version 2016-06-28
 */
public class WoEmployee extends DataEntity<WoEmployee> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 名称
	private String loginName;		// 登陆名
	private String password;		// 密码
	private WoClient woClient;		// 归属客户
	private Office office;		// 归属部门
	private Office company;		// 归属企业
	private String email;		// 邮箱
	private String phone;		// 电话
	
	public WoEmployee() {
		super();
	}

	public WoEmployee(String id){
		super(id);
	}

	@Length(min=1, max=200, message="名称长度必须介于 1 和 200 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=200, message="登陆名长度必须介于 0 和 200 之间")
	public String getLoginName() {
		return loginName;
	}

	public void setLoginName(String loginName) {
		this.loginName = loginName;
	}
	
	@Length(min=0, max=200, message="密码长度必须介于 0 和 200 之间")
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}


	public WoClient getWoClient() {
		return woClient;
	}

	public void setWoClient(WoClient woClient) {
		this.woClient = woClient;
	}

	public Office getOffice() {
		return office;
	}

	public void setOffice(Office office) {
		this.office = office;
	}
	
	public Office getCompany() {
		return company;
	}

	public void setCompany(Office company) {
		this.company = company;
	}
	
	@Length(min=0, max=100, message="邮箱长度必须介于 0 和 100 之间")
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	@Length(min=0, max=100, message="电话长度必须介于 0 和 100 之间")
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}
	
}