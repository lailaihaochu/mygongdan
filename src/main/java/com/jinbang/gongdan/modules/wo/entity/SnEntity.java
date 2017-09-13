package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.common.persistence.BaseEntity;
import com.jinbang.gongdan.common.utils.IdGen;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Date;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/16 20:56
 */
public class SnEntity extends BaseEntity {


    private String startStr="FJ3";//固定字符


    private String yearStr;//日期年字符串
    private String monStr;//日期月字符串
    private String clientCode;//客户代码

    private Integer currentNum;

    private Date currentDate;

    @Override
    public void preInsert() {
// 不限制ID为UUID，调用setIsNewRecord()使用自定义ID
        if (!this.isNewRecord){
            setId(IdGen.uuid());
        }
    }

    @Override
    public void preUpdate() {

    }

    public String getStartStr() {
        return startStr;
    }

    public void setStartStr(String startStr) {
        this.startStr = startStr;
    }

    public String getYearStr() {
        return yearStr;
    }

    public void setYearStr(String yearStr) {
        this.yearStr = yearStr;
    }

    public String getMonStr() {
        return monStr;
    }

    public void setMonStr(String monStr) {
        this.monStr = monStr;
    }

    public String getClientCode() {
        return clientCode;
    }

    public void setClientCode(String clientCode) {
        this.clientCode = clientCode;
    }

    public Integer getCurrentNum() {
        return currentNum;
    }

    public void setCurrentNum(Integer currentNum) {
        this.currentNum = currentNum;
    }

    public Date getCurrentDate() {
        return currentDate;
    }

    public void setCurrentDate(Date currentDate) {
        this.currentDate = currentDate;
    }

    public String getSN() {
        DecimalFormat df=new DecimalFormat("0000");
        return startStr+yearStr+clientCode+"-"+monStr+df.format(currentNum);
    }
}
