package com.jinbang.gongdan.modules.sys.dao;

import com.jinbang.gongdan.common.persistence.BaseDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.sys.entity.Note;

import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/14 16:54
 */
@MyBatisDao
public interface NoteDao extends BaseDao {

    List<Note> findByUser(Note note);
    int insert(Note note);
    int update(Note note);
    int delete(Note note);
    Note get(Note note);
}
