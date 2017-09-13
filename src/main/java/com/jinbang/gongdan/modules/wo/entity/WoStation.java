package com.jinbang.gongdan.modules.wo.entity;

import javax.validation.constraints.NotNull;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.modules.sys.entity.Area;
import com.jinbang.gongdan.modules.sys.entity.User;
import org.apache.fop.area.inline.WordArea;
import org.hibernate.validator.constraints.Length;

import com.jinbang.gongdan.common.persistence.DataEntity;

import java.math.BigDecimal;
import java.util.List;

/**
 * 运作站点基本信息Entity
 *
 * @author 许江辉
 * @version 2016-06-27
 */
public class WoStation extends DataEntity<WoStation> {

    private static final long serialVersionUID = 1L;
    private WoClient woClient;        // 归属客户
    private ClientArea area;        // 归属区域
    private String name;        // 站点名称
    private String description;        // 站点描述
    private String addr;        // 地址
    private Double lat;//纬度
    private Double lon;//经度
    private String contact;        // 联系人
    private String contactTel;        // 联系电话
    private String email;        // 邮箱
    private User pm;//项目经理
    private BigDecimal trafficFee;//交通费
    private List<WoEmployee> contactList = Lists.newArrayList(); //联系人
    private List<User> engineerList = Lists.newArrayList();//工程师

    @NotNull(message = "项目经理不能为空")
    public User getPm() {
        return pm;
    }

    public void setPm(User pm) {
        this.pm = pm;
    }

    public WoStation() {
        super();
    }

    public WoStation(String id) {
        super(id);
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

    @NotNull(message = "归属客户不能为空")
    public WoClient getWoClient() {
        return woClient;
    }

    public void setWoClient(WoClient woClient) {
        this.woClient = woClient;
    }

    @NotNull(message = "归属区域不能为空")
    public ClientArea getArea() {
        return area;
    }

    public void setArea(ClientArea area) {
        this.area = area;
    }

    @Length(min = 1, max = 200, message = "站点名称长度必须介于 1 和 200 之间")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Length(min = 0, max = 255, message = "站点描述长度必须介于 0 和 255 之间")
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Length(min = 0, max = 255, message = "地址长度必须介于 0 和 255 之间")
    public String getAddr() {
        return addr;
    }

    public void setAddr(String addr) {
        this.addr = addr;
    }

    @Length(min = 0, max = 200, message = "联系人长度必须介于 0 和 200 之间")
    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    @Length(min = 0, max = 100, message = "联系电话长度必须介于 0 和 100 之间")
    public String getContactTel() {
        return contactTel;
    }

    public void setContactTel(String contactTel) {
        this.contactTel = contactTel;
    }

    @Length(min = 0, max = 100, message = "邮箱长度必须介于 0 和 100 之间")
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<WoEmployee> getContactList() {
        return contactList;
    }

    public void setContactList(List<WoEmployee> contactList) {
        this.contactList = contactList;
    }

    public List<User> getEngineerList() {
        return engineerList;
    }

    public void setEngineerList(List<User> engineerList) {
        this.engineerList = engineerList;
    }

    public BigDecimal getTrafficFee() {
        return trafficFee;
    }

    public void setTrafficFee(BigDecimal trafficFee) {
        this.trafficFee = trafficFee;
    }

    @Override
    public String toString() {
        //return name+"("+pm.getName()+")";
        return name;
    }
}