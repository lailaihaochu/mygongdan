package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.common.persistence.DataEntity;
import com.jinbang.gongdan.modules.sys.entity.User;

import java.util.Date;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/30 15:49
 */
public class WoStatusLog extends DataEntity<WoStatusLog> {

    private WoWorksheet woWorksheet;
    private String opStatus;
    private User operator;
    private Date opDate;
    private String opLog;

    public WoWorksheet getWoWorksheet() {
        return woWorksheet;
    }

    public void setWoWorksheet(WoWorksheet woWorksheet) {
        this.woWorksheet = woWorksheet;
    }

    public User getOperator() {
        return operator;
    }

    public void setOperator(User operator) {
        this.operator = operator;
    }

    public Date getOpDate() {
        return opDate;
    }

    public void setOpDate(Date opDate) {
        this.opDate = opDate;
    }

    public String getOpLog() {
        return opLog;
    }

    public void setOpLog(String opLog) {
        this.opLog = opLog;
    }

    public String getOpStatus() {
        return opStatus;
    }

    public void setOpStatus(String opStatus) {
        this.opStatus = opStatus;
    }
}
