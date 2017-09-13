package com.jinbang.gongdan.modules.wo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.jinbang.gongdan.common.persistence.DataEntity;
import com.jinbang.gongdan.modules.sys.entity.User;

import java.util.Date;

/**
 * @author Jianghui
 * @version V1.0
 * @description 工程师出发路线记录
 * @date 2017-05-08 20:15
 */
public class WoPosLog extends DataEntity<WoPosLog> {

    private WoWorksheet worksheet; //工单
    private User engineer;//工程师
    private Double lat;//纬度
    private Double lon;//经度
    private Date reportDate;//上报时间

    private Date startDate;
    private Date endDate;

    public WoWorksheet getWorksheet() {
        return worksheet;
    }

    public void setWorksheet(WoWorksheet worksheet) {
        this.worksheet = worksheet;
    }

    public User getEngineer() {
        return engineer;
    }

    public void setEngineer(User engineer) {
        this.engineer = engineer;
    }

    public Double getLat() {
        return lat;
    }

    public void setLat(Double lat) {
        this.lat = lat;
    }

    public Double getLon() {
        return lon;
    }

    public void setLon(Double lon) {
        this.lon = lon;
    }

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    public Date getReportDate() {
        return reportDate;
    }

    public void setReportDate(Date reportDate) {
        this.reportDate = reportDate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
