package com.jinbang.gongdan.modules.wo.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jinbang.gongdan.common.persistence.TreeEntity;

import java.util.List;

/**
 * @author Jianghui
 * @version V1.0
 * @description 设备类目
 * @date 2017-03-28 22:49
 */
public class DeviceCategory extends TreeEntity<DeviceCategory> {

    private String description;

    public DeviceCategory(){super();}
    public DeviceCategory(String id) {
        super(id);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public DeviceCategory getParent() {
        return this.parent;
    }

    @Override
    public void setParent(DeviceCategory parent) {
        this.parent=parent;
    }

    @JsonIgnore
    public static void sortList(List<DeviceCategory> list, List<DeviceCategory> sourcelist, String parentId, boolean cascade){
        for (int i=0; i<sourcelist.size(); i++){
            DeviceCategory e = sourcelist.get(i);
            if (e.getParent()!=null && e.getParent().getId()!=null
                    && e.getParent().getId().equals(parentId)){
                list.add(e);
                if (cascade){
                    // 判断是否还有子节点, 有则继续获取子节点
                    for (int j=0; j<sourcelist.size(); j++){
                        DeviceCategory child = sourcelist.get(j);
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
