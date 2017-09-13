package com.jinbang.gongdan.modules.wo.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.utils.excel.annotation.ExcelField;
import com.jinbang.gongdan.modules.sys.entity.User;
import org.hibernate.validator.constraints.Length;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * 工单相关Entity
 * @author 许江辉
 * @version 2016-07-05
 */
public class WoWorksheet extends DataEntity<WoWorksheet> {
	
	private static final long serialVersionUID = 1L;
	private String snNo;		//客户工单号
	private String woNo;		// 工单号
	private String woStatus;		// 工单状态
	private String woType;		// 工单类型
	private String serviceType;//服务请求类型
	private String emGrade;		// 紧急度
	private WoClient woClient;		// 归属客户
	private WoStation woStation;		// 归属站点
	private String calculateType;		// 核算类型
	private String description;		// 描述
	private Date advanceTime;		// 预约时间   --（计划开始时间）
	private Date realTime;		// 实际执行时间   --（暂未使用）
	private Date assignTime;//指派时间   --（第一次分配人员的时间）
	private Date acceptTime;//接单时间   --（最后一个分配人员确认接单的时间）
	private Date endTime;		// 结束时间   --（暂未使用）
	private Date completeTime;		// 完成时间   --（确认完成操作)
	private Date closeTime;		// 关闭时间   --（关闭）
	private boolean isSelf;		// 是否只查询自己的工单
	private String envStatus;//现场情况 0：独立完成，1，需协助，2，需转派
	private Date beginDate;
	private Date endDate;
	private int feeStatus;//0 草稿，1 发布
	private Integer needAssitNum;//请求协助人数
	private String reason;//原因；
	private BigDecimal trafficFee; // --（交通费）
	private BigDecimal trafficFeeOut; //--（）
	private String trafficDesc;
	private Date actStartTime;//始发时间
	private String acpType;//接受类型:1邮件，2电话，3其他
	private String other;//其他说明
	private String stringleng;//对外输出字符串

	private Long totCostTime;//总耗时
	private Long waitTime;//等待耗时
	private Long actCostTime;//实际耗时
	private Date beginTime;//开始执行时间
	private Date startWaitTime;//开始等待时间

	private List<WoDevice> deviceList = Lists.newArrayList(); // 按明细设置数据范围(关联设备)
	private String deviceIds;//创建工单时关联的设备deviceIds

	private List<WoFeeItem> cailiaoList=Lists.newArrayList();
	private List<WoFeeItem> fenbaoList=Lists.newArrayList();
	private List<WoFeeItem> rengongList=Lists.newArrayList();
	private List<WoFeeItem> qitaList=Lists.newArrayList();

	public BigDecimal getTrafficFeeOut() {
		return trafficFeeOut;
	}

	public void setTrafficFeeOut(BigDecimal trafficFeeOut) {
		this.trafficFeeOut = trafficFeeOut;
	}

	public String getTrafficDesc() {
		return trafficDesc;
	}

	public void setTrafficDesc(String trafficDesc) {
		this.trafficDesc = trafficDesc;
	}

	public BigDecimal getTrafficFee() {
		return trafficFee;
	}

	public void setTrafficFee(BigDecimal trafficFee) {
		this.trafficFee = trafficFee;
	}

	@ExcelField(title="协助人数", align=2, sort=90)
	public Integer getNeedAssitNum() {
		return needAssitNum;
	}

	public void setNeedAssitNum(Integer needAssitNum) {
		this.needAssitNum = needAssitNum;
	}
	@ExcelField(title="协助原因", align=2, sort=100)
	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	private List<User> checkedUsers=Lists.newArrayList();//确认用户列表

	private List<User> unCheckedUsers=Lists.newArrayList();//未确认用户列表

	private List<WoWorkDetail> detailList=Lists.newArrayList();//任务明细

	private List<WoMsgRecord> msgRecords=Lists.newArrayList();//团队消息

	private List<WoFeeItem> feeItemList=Lists.newArrayList();//费用列表


	public int getFeeStatus() {
		return feeStatus;
	}

	public void setFeeStatus(int feeStatus) {
		this.feeStatus = feeStatus;
	}

	public WoWorksheet() {
		super();
	}

	public WoWorksheet(String id){
		super(id);
	}

	@Length(min=0, max=200, message="客户工单号长度必须介于 0 和 200 之间")
	@ExcelField(title="客户工单号", align=2, sort=40)
	public String getSnNo() {
		return snNo;
	}

	public void setSnNo(String snNo) {
		this.snNo = snNo;
	}
	@ExcelField(title="现场情况", align=2, sort=80,dictType="wo_env_status")
	public String getEnvStatus() {
		return envStatus;
	}

	public void setEnvStatus(String envStatus) {
		this.envStatus = envStatus;
	}

	@Length(min=0, max=255, message="工单号长度必须介于 0 和 255 之间")
	@ExcelField(title="单号", align=2, sort=30)
	public String getWoNo() {
		return woNo;
	}

	public void setWoNo(String woNo) {
		this.woNo = woNo;
	}
	
	@Length(min=0, max=1, message="工单状态长度必须介于 0 和 1 之间")
	@ExcelField(title="工单状态", align=2, sort=50,dictType="worksheet_status")
	public String getWoStatus() {
		return woStatus;
	}

	public void setWoStatus(String woStatus) {
		this.woStatus = woStatus;
	}
	
	@Length(min=0, max=1, message="工单类型长度必须介于 0 和 1 之间")
	@ExcelField(title="工单类型", align=2, sort=60,dictType="worksheet_type")
	public String getWoType() {
		return woType;
	}

	public void setWoType(String woType) {
		this.woType = woType;
	}
	
	@Length(min=0, max=1, message="紧急度长度必须介于 0 和 1 之间")
	@ExcelField(title="紧急度", align=2, sort=70,dictType="worksheet_emgrade")
	public String getEmGrade() {
		return emGrade;
	}

	public void setEmGrade(String emGrade) {
		this.emGrade = emGrade;
	}
	@ExcelField(title="归属客户", align=2, sort=10)
	public WoClient getWoClient() {
		return woClient;
	}

	public void setWoClient(WoClient woClient) {
		this.woClient = woClient;
	}
	@ExcelField(title="归属站点", align=2, sort=20)
	public WoStation getWoStation() {
		return woStation;
	}

	public void setWoStation(WoStation woStation) {
		this.woStation = woStation;
	}

	@Length(min=0, max=1, message="核算类型长度必须介于 0 和 1 之间")
	@ExcelField(title="是否单独核算", align=2, sort=110,dictType = "worksheet_cal_type")
	public String getCalculateType() {
		return calculateType;
	}

	public void setCalculateType(String calculateType) {
		this.calculateType = calculateType;
	}
	@ExcelField(title="执行情况", align=2, sort=900)
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="巡检模拟开始时间", type=1, align=1, sort=115)
	public Date getAdvanceTime() {
		return advanceTime;
	}

	public void setAdvanceTime(Date advanceTime) {
		this.advanceTime = advanceTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")

	public Date getRealTime() {
		return realTime;
	}

	public void setRealTime(Date realTime) {
		this.realTime = realTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="完成时间", type=1, align=1, sort=130)
	public Date getCompleteTime() {
		return completeTime;
	}

	public void setCompleteTime(Date completeTime) {
		this.completeTime = completeTime;
	}
	
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@ExcelField(title="关闭时间", type=1, align=1, sort=140)
	public Date getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(Date closeTime) {
		this.closeTime = closeTime;
	}

	public List<WoWorkDetail> getDetailList() {
		return detailList;
	}

	public void setDetailList(List<WoWorkDetail> detailList) {
		this.detailList = detailList;
	}

	public List<User> getCheckedUsers() {
		return checkedUsers;
	}

	public void setCheckedUsers(List<User> checkedUsers) {
		this.checkedUsers = checkedUsers;
	}

	public List<User> getUnCheckedUsers() {
		return unCheckedUsers;
	}

	public String getServiceType() {
		return serviceType==null?"":serviceType;
	}

	public void setServiceType(String serviceType) {
		this.serviceType = serviceType;
	}

	public void setUnCheckedUsers(List<User> unCheckedUsers) {
		this.unCheckedUsers = unCheckedUsers;
	}
	@JsonIgnore
	public List<String> getEngineerIdList() {
		List<String> engineerIdList = Lists.newArrayList();
		for (User user : checkedUsers) {
			engineerIdList.add(user.getId());
		}
		for (User user:unCheckedUsers){
			engineerIdList.add(user.getId());
		}
		return engineerIdList;
	}

	public boolean isSelf() {
		return isSelf;
	}

	public void setSelf(boolean isSelf) {
		this.isSelf = isSelf;
	}

	public List<WoMsgRecord> getMsgRecords() {
		return msgRecords;
	}

	public void setMsgRecords(List<WoMsgRecord> msgRecords) {
		this.msgRecords = msgRecords;
	}

	public Date getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate;
	}
	@ExcelField(title="开始执行时间", type=1, align=1, sort=120)
	public Date getBeginTime() {
		return beginTime;
	}

	public void setBeginTime(Date beginTime) {
		this.beginTime = beginTime;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public List<WoDevice> getDeviceList() {
		return deviceList;
	}

	public void setDeviceList(List<WoDevice> deviceList) {
		this.deviceList = deviceList;
	}

	@JsonIgnore
	public String getDeviceIds() {
		return deviceIds;
	}

	public void setDeviceIds(String deviceIds) {
		this.deviceIds = deviceIds;
	}

	@JsonIgnore
	public List<WoFeeItem> getFeeItemList() {
		return feeItemList;
	}

	public void setFeeItemList(List<WoFeeItem> feeItemList) {
		this.feeItemList = feeItemList;
	}
	@JsonIgnore
	public List<WoFeeItem> getCailiaoList() {
		return cailiaoList;
	}

	public void setCailiaoList(List<WoFeeItem> cailiaoList) {
		this.cailiaoList = cailiaoList;
	}
	@JsonIgnore
	public List<WoFeeItem> getFenbaoList() {
		return fenbaoList;
	}

	public void setFenbaoList(List<WoFeeItem> fenbaoList) {
		this.fenbaoList = fenbaoList;
	}
	@JsonIgnore
	public List<WoFeeItem> getRengongList() {
		return rengongList;
	}

	public void setRengongList(List<WoFeeItem> rengongList) {
		this.rengongList = rengongList;
	}
	@JsonIgnore
	public List<WoFeeItem> getQitaList() {
		return qitaList;
	}

	public void setQitaList(List<WoFeeItem> qitaList) {
		this.qitaList = qitaList;
	}
	@ExcelField(title="任务要求", align=2, sort=800)
	public String getRemarks(){
		return super.getRemarks();
	}
	@ExcelField(title = "始发时间",align = 1,sort =128 )
	public Date getActStartTime() {
		return actStartTime;
	}

	public void setActStartTime(Date actStartTime) {
		this.actStartTime = actStartTime;
	}
	@ExcelField(title = "接受类型",align = 2,sort = 45,dictType = "worksheet_acp_type")
	public String getAcpType() {
		return acpType;
	}

	public void setAcpType(String acpType) {
		this.acpType = acpType;
	}
	@ExcelField(title = "总耗时",align = 3,sort = 132)
	public Long getTotCostTime() {
		return totCostTime;
	}

	public void setTotCostTime(Long totCostTime) {
		this.totCostTime = totCostTime;
	}
	@ExcelField(title = "等待耗时",align = 3,sort = 134)
	public Long getWaitTime() {
		return waitTime;
	}

	public void setWaitTime(Long waitTime) {
		this.waitTime = waitTime;
	}
	@ExcelField(title = "实际耗时",align = 3,sort=136)
	public Long getActCostTime() {
		return actCostTime;
	}

	public void setActCostTime(Long actCostTime) {
		this.actCostTime = actCostTime;
	}
	@ExcelField(title = "其他说明",align = 3,sort=47)
	public String getOther() {
		return other;
	}

	public void setOther(String other) {
		this.other = other;
	}
	@ExcelField(title = "指派时间",align = 1,sort =117 )
	public Date getAssignTime() {
		return assignTime;
	}

	public void setAssignTime(Date assignTime) {
		this.assignTime = assignTime;
	}
	@ExcelField(title = "接单时间",align = 1,sort =118 )
	public Date getAcceptTime() {
		return acceptTime;
	}

	public void setAcceptTime(Date acceptTime) {
		this.acceptTime = acceptTime;
	}
	@ExcelField(title = "创建时间",align = 1,sort =116 )
	@Override
	public Date getCreateDate() {
		return super.getCreateDate();
	}


	public Date getStartWaitTime() {
		return startWaitTime;
	}

	public void setStartWaitTime(Date startWaitTime) {
		this.startWaitTime = startWaitTime;
	}
	@ExcelField(title="执行人", align=2, sort=41)
	public String getStringleng() {
		return stringleng;
	}

	public void setStringleng(String stringleng) {
		this.stringleng = stringleng;
	}
}