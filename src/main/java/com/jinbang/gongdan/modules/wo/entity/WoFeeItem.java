package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.common.persistence.DataEntity;

import java.math.BigDecimal;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/6 23:54
 */
public class WoFeeItem extends DataEntity<WoFeeItem> {
    private WoWorksheet woWorksheet;
    private String name;
    private String feeType;
    private Integer sort;
    private BigDecimal price;
    private Integer num;
    private BigDecimal cost;
    private String billType;
    private BigDecimal outPer;
    private BigDecimal outPrice;
    private BigDecimal npb;
    private BigDecimal zpb;

    public BigDecimal getOutPrice() {
        return outPrice;
    }

    public void setOutPrice(BigDecimal outPrice) {
        this.outPrice = outPrice;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public WoWorksheet getWoWorksheet() {
        return woWorksheet;
    }

    public void setWoWorksheet(WoWorksheet woWorksheet) {
        this.woWorksheet = woWorksheet;
    }

    public String getFeeType() {
        return feeType;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
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

    public BigDecimal getNpb() {
        return npb;
    }

    public void setNpb(BigDecimal npb) {
        this.npb = npb;
    }

    public BigDecimal getZpb() {
        return zpb;
    }

    public BigDecimal getOutPer() {
        return outPer;
    }

    public void setOutPer(BigDecimal outPer) {
        this.outPer = outPer;
    }

    public void setZpb(BigDecimal zpb) {
        this.zpb = zpb;
    }
}
