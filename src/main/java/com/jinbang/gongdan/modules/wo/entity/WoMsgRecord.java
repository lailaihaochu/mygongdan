package com.jinbang.gongdan.modules.wo.entity;

import com.jinbang.gongdan.common.persistence.DataEntity;
import com.jinbang.gongdan.modules.oa.entity.OaNotify;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/18 9:44
 */
public class WoMsgRecord extends DataEntity<WoMsgRecord> {
    private OaNotify oaNotify;

    private WoWorksheet worksheet;

    public OaNotify getOaNotify() {
        return oaNotify;
    }

    public void setOaNotify(OaNotify oaNotify) {
        this.oaNotify = oaNotify;
    }

    public WoWorksheet getWorksheet() {
        return worksheet;
    }

    public void setWorksheet(WoWorksheet worksheet) {
        this.worksheet = worksheet;
    }
}
