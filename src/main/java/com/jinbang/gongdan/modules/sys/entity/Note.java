package com.jinbang.gongdan.modules.sys.entity;

import com.jinbang.gongdan.common.persistence.DataEntity;

import java.util.Date;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/14 16:53
 */
public class Note extends DataEntity {
    private User owner;
    private String title;
    private String content;
    private Date remindDate;

    public Note (){
        super();
    }
    public Note(String id) {
        super(id);
    }

    public User getOwner() {
        return owner;
    }

    public void setOwner(User owner) {
        this.owner = owner;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getRemindDate() {
        return remindDate;
    }

    public void setRemindDate(Date remindDate) {
        this.remindDate = remindDate;
    }
}
