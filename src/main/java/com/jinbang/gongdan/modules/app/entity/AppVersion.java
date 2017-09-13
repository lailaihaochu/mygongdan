package com.jinbang.gongdan.modules.app.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jinbang.gongdan.common.persistence.DataEntity;

/**
 * Created by hlx on 15-4-22.
 */

public class AppVersion extends DataEntity<AppVersion> {

    private Integer verCode;
    private String verName;
    private String appName;
    private String filePath;
    private String docPath;

    public AppVersion(String appName) {
        this.appName=appName;
    }

    public AppVersion() {
    }

    public Integer getVerCode() {
        return verCode;
    }

    public void setVerCode(Integer verCode) {
        this.verCode = verCode;
    }

    public String getVerName() {
        return verName;
    }

    public void setVerName(String verName) {
        this.verName = verName;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    @JsonIgnore
    public String getDocPath() {
        return docPath;
    }

    public void setDocPath(String docPath) {
        this.docPath = docPath;
    }
}
