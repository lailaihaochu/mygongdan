package com.jinbang.gongdan.modules.wo.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jinbang.gongdan.common.persistence.TreeEntity;

import java.util.List;

/**
 * @author Jianghui
 * @version V1.0
 * @description 设备节点位置信息
 * @date 2017-03-28 23:11
 */
public class DevPosition extends TreeEntity<DevPosition> {

    private WoStation woStation;

    public DevPosition() {
        super();
    }

    public DevPosition(String id){
        super(id);
    }
    public WoStation getWoStation() {
        return woStation;
    }

    public void setWoStation(WoStation woStation) {
        this.woStation = woStation;
    }

    @Override
    public DevPosition getParent() {
        return this.parent;
    }

    @Override
    public void setParent(DevPosition parent) {
        this.parent=parent;
    }

    @JsonIgnore
    public static void sortList(List<DevPosition> list, List<DevPosition> sourcelist, String parentId, boolean cascade){
        for (int i=0; i<sourcelist.size(); i++){
            DevPosition e = sourcelist.get(i);
            if (e.getParent()!=null && e.getParent().getId()!=null
                    && e.getParent().getId().equals(parentId)){
                list.add(e);
                if (cascade){
                    // 判断是否还有子节点, 有则继续获取子节点
                    for (int j=0; j<sourcelist.size(); j++){
                        DevPosition child = sourcelist.get(j);
                        if (child.getParent()!=null && child.getParent().getId()!=null
                                && child.getParent().getId().equals(e.getId())){
                            sortList(list, sourcelist, e.getId(), true);
                            break;
                        }
                    }
                }
            }
        }
    }

    @Override
    public String toString() {
        return name;
    }
}
