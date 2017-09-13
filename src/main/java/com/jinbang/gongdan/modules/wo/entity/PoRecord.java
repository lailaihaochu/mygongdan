package com.jinbang.gongdan.modules.wo.entity;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.persistence.DataEntity;
import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.User;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * PO订单对象
 * author:Jianghui
 * date:2016/9/13 14:04
 */
public class PoRecord extends DataEntity<PoRecord> {

    private String snNo;//评审号
    private String poNo;//po订单号
    private WoClient client;//所属客户
    private User  pm;//项目经理
    private String seller;//销售
    private String status;//1，未审核，2，已审核，
    private Office partA;//甲方
    private String contact;//联系人
    private String contPhone;//联系电话
    private Office partB;//乙方

    private String projectName;//项目名称

    private List<WoWorksheet> woWorksheets= Lists.newArrayList();//工单列表

    private BigDecimal cost;//上包合同金额
    private String billType;//发票类型

    private BigDecimal kaiPiao;//开票金额

    private String kpType;//开票发票类型

    private BigDecimal cntCost;//合同总金额

    private BigDecimal sellCost;//销售金额
    private BigDecimal pCost;//成本
    private BigDecimal pNCost;//采购成本
    private BigDecimal sellTax;//销项税额
    private BigDecimal incTax;//进项抵税额
    private BigDecimal otherTax;//应缴增值税

    private BigDecimal shiGongFee;//施工费

    private BigDecimal zhaoDaiFee;//招待费

    private BigDecimal maoli;//毛利
    private BigDecimal maolip;//毛利率
    private BigDecimal totCost;//综合运营成本
    private BigDecimal cmpTax;//企业所得税
    private BigDecimal pureEarn;//净利润
    private BigDecimal pureEarnp;//净利润率



    private Date beginDate;
    private Date endDate;

    public BigDecimal getpCost() {
        return pCost;
    }

    public void setpCost(BigDecimal pCost) {
        this.pCost = pCost;
    }

    public BigDecimal getpNCost() {
        return pNCost;
    }

    public void setpNCost(BigDecimal pNCost) {
        this.pNCost = pNCost;
    }

    public BigDecimal getSellTax() {
        return sellTax;
    }

    public void setSellTax(BigDecimal sellTax) {
        this.sellTax = sellTax;
    }

    public BigDecimal getIncTax() {
        return incTax;
    }

    public void setIncTax(BigDecimal incTax) {
        this.incTax = incTax;
    }

    public BigDecimal getOtherTax() {
        return otherTax;
    }

    public void setOtherTax(BigDecimal otherTax) {
        this.otherTax = otherTax;
    }

    public BigDecimal getMaoli() {
        return maoli;
    }

    public void setMaoli(BigDecimal maoli) {
        this.maoli = maoli;
    }

    public BigDecimal getMaolip() {
        return maolip;
    }

    public void setMaolip(BigDecimal maolip) {
        this.maolip = maolip;
    }

    public BigDecimal getTotCost() {
        return totCost;
    }

    public void setTotCost(BigDecimal totCost) {
        this.totCost = totCost;
    }

    public BigDecimal getCmpTax() {
        return cmpTax;
    }

    public void setCmpTax(BigDecimal cmpTax) {
        this.cmpTax = cmpTax;
    }

    public BigDecimal getPureEarn() {
        return pureEarn;
    }

    public void setPureEarn(BigDecimal pureEarn) {
        this.pureEarn = pureEarn;
    }

    public BigDecimal getPureEarnp() {
        return pureEarnp;
    }

    public void setPureEarnp(BigDecimal pureEarnp) {
        this.pureEarnp = pureEarnp;
    }

     public Date getBeginDate() {
        return beginDate;
    }

    public void setBeginDate(Date beginDate) {
        this.beginDate = beginDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getSnNo() {
        return snNo;
    }

    public void setSnNo(String snNo) {
        this.snNo = snNo;
    }

    public String getPoNo() {
        return poNo;
    }

    public void setPoNo(String poNo) {
        this.poNo = poNo;
    }

    public WoClient getClient() {
        return client;
    }

    public void setClient(WoClient client) {
        this.client = client;
    }

    public User getPm() {
        return pm;
    }

    public void setPm(User pm) {
        this.pm = pm;
    }

    public String getSeller() {
        return seller;
    }

    public void setSeller(String seller) {
        this.seller = seller;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Office getPartA() {
        return partA;
    }

    public void setPartA(Office partA) {
        this.partA = partA;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getContPhone() {
        return contPhone;
    }

    public void setContPhone(String contPhone) {
        this.contPhone = contPhone;
    }

    public Office getPartB() {
        return partB;
    }

    public void setPartB(Office partB) {
        this.partB = partB;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    public List<WoWorksheet> getWoWorksheets() {
        return woWorksheets;
    }

    public void setWoWorksheets(List<WoWorksheet> woWorksheets) {
        this.woWorksheets = woWorksheets;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public void setCost(BigDecimal cost) {
        this.cost = cost;
    }

    public String getBillType() {
        return billType;
    }

    public void setBillType(String billType) {
        this.billType = billType;
    }

    public BigDecimal getKaiPiao() {
        return kaiPiao;
    }

    public void setKaiPiao(BigDecimal kaiPiao) {
        this.kaiPiao = kaiPiao;
    }

    public String getKpType() {
        return kpType;
    }

    public void setKpType(String kpType) {
        this.kpType = kpType;
    }

    public BigDecimal getCntCost() {
        return cntCost;
    }

    public void setCntCost(BigDecimal cntCost) {
        this.cntCost = cntCost;
    }

    public BigDecimal getSellCost() {
        return sellCost;
    }

    public void setSellCost(BigDecimal sellCost) {
        this.sellCost = sellCost;
    }

    public BigDecimal getShiGongFee() {
        return shiGongFee;
    }

    public void setShiGongFee(BigDecimal shiGongFee) {
        this.shiGongFee = shiGongFee;
    }

    public BigDecimal getZhaoDaiFee() {
        return zhaoDaiFee;
    }

    public void setZhaoDaiFee(BigDecimal zhaoDaiFee) {
        this.zhaoDaiFee = zhaoDaiFee;
    }
}
