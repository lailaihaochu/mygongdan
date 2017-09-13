package com.jinbang.gongdan.modules.app.entity;

import com.jinbang.gongdan.modules.sys.entity.Office;

import java.util.Date;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/13 21:20
 */
public class UserInfo {
    private String id;
    private String name;
    private String no;
    private String photo;
    private String email;
    private String phone;
    private String mobile;
    private Date loginDate;
    private String loginIp;
    private Office office;
    private Office company;
    private String roleNames;
    public String getName() {
        return name;
    }

    public String getNo() {
        return no;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getPhoto() {
        return photo;
    }

    public void setLoginDate(Date loginDate) {
        this.loginDate = loginDate;
    }

    public Date getLoginDate() {
        return loginDate;
    }

    public void setLoginIp(String loginIp) {
        this.loginIp = loginIp;
    }

    public String getLoginIp() {
        return loginIp;
    }

    public void setOffice(Office office) {
        this.office = office;
    }

    public Office getOffice() {
        return office;
    }

    public void setCompany(Office company) {
        this.company = company;
    }

    public Office getCompany() {
        return company;
    }

    public String getRoleNames() {
        return roleNames;
    }

    public void setRoleNames(String roleNames) {
        this.roleNames = roleNames;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }
}
