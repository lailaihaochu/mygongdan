package com.jinbang.gongdan.modules.app.entity;

import java.util.List;

/**
 * Created by hlx on 15-5-11.
 */
public class MobilePage {
    private long count;
    private int pageNo;
    private int pageSize;
    private List<?> list;

    public long getCount() {
        return count;
    }

    public void setCount(long count) {
        this.count = count;
    }

    public int getPageNo() {
        return pageNo;
    }

    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }

    public List<?> getList() {
        return list;
    }

    public void setList(List<?> list) {
        this.list = list;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }
}
