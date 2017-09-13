package com.jinbang.gongdan.modules.wo.entity;

import org.hibernate.validator.constraints.Length;

import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * 工单任务相关Entity
 * @author 许江辉
 * @version 2016-07-05
 */
public class WoWorkDetail extends DataEntity<WoWorkDetail> {
	
	private static final long serialVersionUID = 1L;
	private WoWorksheet woWorksheet;		// 工单
	private String name;		// 名称
	private String content;		// 内容
	private String status;		// 状态 1:初始化状态，2:开始状态，
	private String tag;// 巡检状态：1：无此装置，2：正常，3：完成，4：需跟进
	private String result;		//结果
	private String attachFiles;		// 附件
	private int sort;
	
	public WoWorkDetail() {
		super();
	}

	public WoWorkDetail(String id){
		super(id);
	}

	public WoWorkDetail(WoWorksheet woWorksheet) {
		this.woWorksheet=woWorksheet;
	}


	public WoWorksheet getWoWorksheet() {
		return woWorksheet;
	}

	public void setWoWorksheet(WoWorksheet woWorksheet) {
		this.woWorksheet = woWorksheet;
	}
	
	@Length(min=0, max=200, message="名称长度必须介于 0 和 200 之间")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Length(min=0, max=255, message="内容长度必须介于 0 和 255 之间")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAttachFiles() {
		return attachFiles;
	}

	public void setAttachFiles(String attachFiles) {
		this.attachFiles = attachFiles;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public int getSort() {
		return sort;
	}

	public void setSort(int sort) {
		this.sort = sort;
	}

	@Override
	public void preInsert() {
		super.preInsert();
		this.setStatus("1");
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}
}