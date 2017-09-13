package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.common.persistence.BaseEntity;
import com.jinbang.gongdan.common.utils.IdGen;

import java.text.DecimalFormat;

/**
 * WO 工单号
 * author:Jianghui
 * date:2016/8/17 23:43
 */
public class WoEntity  extends BaseEntity<WoEntity>{
    private String clientCode;
    private String dateStr;
    private Integer curNum;

    public String getClientCode() {
        return clientCode;
    }

    public void setClientCode(String clientCode) {
        this.clientCode = clientCode;
    }

    public String getDateStr() {
        return dateStr;
    }

    public void setDateStr(String dateStr) {
        this.dateStr = dateStr;
    }

    public Integer getCurNum() {
        return curNum;
    }

    public void setCurNum(Integer curNum) {
        this.curNum = curNum;
    }

    @Override
    public void preInsert() {
        if (!this.isNewRecord){
            setId(IdGen.uuid());
        }
    }

    @Override
    public void preUpdate() {

    }

    public String getWOCode() {
        DecimalFormat df=new DecimalFormat("0000");
        return clientCode+dateStr+df.format(curNum);
    }
}
