package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;

import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * 合同信息相关Entity
 * @author 许江辉
 * @version 2016-07-01
 */
public class WoContract extends DataEntity<WoContract> {
	
	private static final long serialVersionUID = 1L;
	private String contractNo;		// 合同编号
	private String projectName;		// 项目名称
	private WoClient partA;		// 甲方
	private WoEmployee partAEmp;// 甲方联系人
	private String partAContact;		// 甲方联系人
	private String partAContactTel;		// 甲方联系电话
	private Office partB;		// 乙方
	private User partBEmp;//乙方联系人
	private String partBContact;		// 乙方联系人
	private String partBContactTel;		// 乙方联系电话
	private String contractContent;		// 合同内容
	private String contractFiles;		// 合同附件
	private String contractStatus;		// 合同状态
	
	public WoContract() {
		super();
	}

	public WoContract(String id){
		super(id);
	}

	@Length(min=0, max=200, message="合同编号长度必须介于 0 和 200 之间")
	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}
	
	@Length(min=0, max=255, message="项目名称长度必须介于 0 和 255 之间")
	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public WoClient getPartA() {
		return partA;
	}

	public void setPartA(WoClient partA) {
		this.partA = partA;
	}

	public WoEmployee getPartAEmp() {
		return partAEmp;
	}

	public void setPartAEmp(WoEmployee partAEmp) {
		this.partAEmp = partAEmp;
	}

	public Office getPartB() {
		return partB;
	}

	public void setPartB(Office partB) {
		this.partB = partB;
	}

	public User getPartBEmp() {
		return partBEmp;
	}

	public void setPartBEmp(User partBEmp) {
		this.partBEmp = partBEmp;
	}

	@Length(min=0, max=200, message="甲方联系人长度必须介于 0 和 200 之间")
	public String getPartAContact() {
		return partAContact;
	}

	public void setPartAContact(String partAContact) {
		this.partAContact = partAContact;
	}
	
	@Length(min=0, max=200, message="甲方联系电话长度必须介于 0 和 200 之间")
	public String getPartAContactTel() {
		return partAContactTel;
	}

	public void setPartAContactTel(String partAContactTel) {
		this.partAContactTel = partAContactTel;
	}
	

	@Length(min=0, max=200, message="乙方联系人长度必须介于 0 和 200 之间")
	public String getPartBContact() {
		return partBContact;
	}

	public void setPartBContact(String partBContact) {
		this.partBContact = partBContact;
	}
	
	@Length(min=0, max=200, message="乙方联系电话长度必须介于 0 和 200 之间")
	public String getPartBContactTel() {
		return partBContactTel;
	}

	public void setPartBContactTel(String partBContactTel) {
		this.partBContactTel = partBContactTel;
	}
	
	public String getContractContent() {
		return contractContent;
	}

	public void setContractContent(String contractContent) {
		this.contractContent = contractContent;
	}
	
	@Length(min=0, max=200, message="合同附件长度必须介于 0 和 200 之间")
	public String getContractFiles() {
		return contractFiles;
	}

	public void setContractFiles(String contractFiles) {
		this.contractFiles = contractFiles;
	}
	
	@Length(min=0, max=1, message="合同状态长度必须介于 0 和 1 之间")
	public String getContractStatus() {
		return contractStatus;
	}

	public void setContractStatus(String contractStatus) {
		this.contractStatus = contractStatus;
	}
	
}