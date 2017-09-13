package com.jinbang.gongdan.modules.wo.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.hibernate.validator.constraints.Length;

import com.jinbang.gongdan.common.persistence.TreeEntity;

import java.util.List;

/**
 * 客户区域相关Entity
 * @author 许江辉
 * @version 2016-08-07
 */
public class ClientArea extends TreeEntity<ClientArea> {
	
	private static final long serialVersionUID = 1L;

	private WoClient woClient;//归属客户

	public ClientArea() {
		super();
	}

	public ClientArea(String id){
		super(id);
	}

	public WoClient getWoClient() {
		return woClient;
	}

	public void setWoClient(WoClient woClient) {
		this.woClient = woClient;
	}

	@Override
	public ClientArea getParent() {
		return this.parent;
	}

	@Override
	public void setParent(ClientArea parent) {
		this.parent=parent;
	}
	@JsonIgnore
	public static void sortList(List<ClientArea> list, List<ClientArea> sourcelist, String parentId, boolean cascade){
		for (int i=0; i<sourcelist.size(); i++){
			ClientArea e = sourcelist.get(i);
			if (e.getParent()!=null && e.getParent().getId()!=null
					&& e.getParent().getId().equals(parentId)){
				list.add(e);
				if (cascade){
					// 判断是否还有子节点, 有则继续获取子节点
					for (int j=0; j<sourcelist.size(); j++){
						ClientArea child = sourcelist.get(j);
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