package com.jinbang.gongdan.modules.wo.entity;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.persistence.DataEntity;
import com.jinbang.gongdan.modules.sys.entity.User;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;

/**
 * @author Jianghui
 * @version V1.0
 * @description 工程师工作状态
 * @date 2017-05-08 20:47
 */

public class WoEngineerStatus extends DataEntity<WoEngineerStatus> {
    /**
     * 状态标记（1：空闲；2：忙碌；）
     */
    public static final String STATUS_NORMAL = "1";
    public static final String STATUS_BUSY = "2";


    private User engineer;//工程师
    private String status;//工程师状态：1:空闲，2:忙碌
    private String woIds;//涉及工单ids

    private Double lat;//纬度
    private Double lon;//经度

    private Date reportDate;//上报时间

    private Date startDate;
    private Date endDate;

    private List<WoWorksheet> woWorksheets= Lists.newArrayList();//涉及工单

    public WoEngineerStatus(){
        super();
    }

    @Override
    public void preInsert() {
        super.preInsert();
        if(StringUtils.isEmpty(status))
            status=STATUS_NORMAL;
    }

    public WoEngineerStatus(String id){
        super(id);
    }

    public User getEngineer() {
        return engineer;
    }

    public void setEngineer(User engineer) {
        this.engineer = engineer;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getWoIds() {
        return woIds;
    }

    public void setWoIds(String woIds) {
        this.woIds = woIds;
    }

    public List<WoWorksheet> getWoWorksheets() {
        return woWorksheets;
    }

    public void setWoWorksheets(List<WoWorksheet> woWorksheets) {
        this.woWorksheets = woWorksheets;
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
