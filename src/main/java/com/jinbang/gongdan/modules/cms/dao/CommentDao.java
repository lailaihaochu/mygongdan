
package com.jinbang.gongdan.modules.cms.dao;


import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.cms.entity.Comment;

/**
 * 评论DAO接口
 */
@MyBatisDao
public interface CommentDao extends CrudDao<Comment> {

}
