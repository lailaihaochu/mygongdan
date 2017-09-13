package com.jinbang.gongdan.modules.wo.entity;

import org.hibernate.validator.constraints.Length;
import com.jinbang.gongdan.modules.sys.entity.User;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * 工单附件Entity
 * @author 许江辉
 * @version 2016-07-12
 */
public class WorksheetFiles extends DataEntity<WorksheetFiles> {
	
	private static final long serialVersionUID = 1L;
	private String name;		// 附件名
	private WoWorksheet worksheet;		// 工单
	private String grp;
	private String atthFile;		// 附件
	private User uploadBy;		// 上传人
	private Date uploadDate;		// 上传日期
	
	public WorksheetFiles() {
		super();
	}

	public WorksheetFiles(String id){
		super(id);
	}


	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}


	public WoWorksheet getWorksheet() {
		return worksheet;
	}

	public void setWorksheet(WoWorksheet worksheet) {
		this.worksheet = worksheet;
	}


	public String getAtthFile() {
		return atthFile;
	}

	public void setAtthFile(String atthFile) {
		this.atthFile = atthFile;
	}
	
	public User getUploadBy() {
		return uploadBy;
	}

	public void setUploadBy(User uploadBy) {
		this.uploadBy = uploadBy;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getUploadDate() {
		return uploadDate;
	}

	public void setUploadDate(Date uploadDate) {
		this.uploadDate = uploadDate;
	}

	public String getGrp() {
		return grp;
	}

	public void setGrp(String grp) {
		this.grp = grp;
	}
}