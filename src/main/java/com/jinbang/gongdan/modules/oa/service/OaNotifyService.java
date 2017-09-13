
package com.jinbang.gongdan.modules.oa.service;

import com.jinbang.gongdan.common.mapper.JsonMapper;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.oa.dao.OaNotifyDao;
import com.jinbang.gongdan.modules.oa.dao.OaNotifyRecordDao;
import com.jinbang.gongdan.modules.oa.entity.OaNotify;
import com.jinbang.gongdan.modules.oa.entity.OaNotifyRecord;
import com.jinbang.gongdan.modules.oa.push.NotificationManager;
import com.jinbang.gongdan.modules.sys.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

/**
 * 通知通告Service
 */
@Service
@Transactional(readOnly = true)
public class OaNotifyService extends CrudService<OaNotifyDao, OaNotify> {

	@Autowired
	private OaNotifyRecordDao oaNotifyRecordDao;

	@Autowired
	private UserDao userDao;
	@Autowired
	private NotificationManager notificationManager;

	public OaNotify get(String id) {
		OaNotify entity = dao.get(id);
		return entity;
	}

	/**
	 * 获取通知发送记录
	 * @param oaNotify
	 * @return
	 */
	public OaNotify getRecordList(OaNotify oaNotify) {
		oaNotify.setOaNotifyRecordList(oaNotifyRecordDao.findList(new OaNotifyRecord(oaNotify)));
		return oaNotify;
	}

	public Page<OaNotify> find(Page<OaNotify> page, OaNotify oaNotify) {
		oaNotify.setPage(page);
		page.setList(dao.findList(oaNotify));
		return page;
	}

	/**
	 * 获取通知数目
	 * @param oaNotify
	 * @return
	 */
	public Long findCount(OaNotify oaNotify) {
		return dao.findCount(oaNotify);
	}

	@Transactional(readOnly = false)
	public void save(OaNotify oaNotify) {
		super.save(oaNotify);

		// 更新发送接受人记录
		oaNotifyRecordDao.deleteByOaNotifyId(oaNotify.getId());
		if (oaNotify.getOaNotifyRecordList().size() > 0){
			oaNotifyRecordDao.insertAll(oaNotify.getOaNotifyRecordList());
			for(OaNotifyRecord oaNotifyRecord :oaNotify.getOaNotifyRecordList()){
				logger.info("发送消息："+ JsonMapper.toJsonString(oaNotifyRecord));
				System.out.println("发送消息："+ JsonMapper.toJsonString(oaNotifyRecord));
				notificationManager.sendNotifcationToUser("1234567890",userDao.get(oaNotifyRecord.getUser()).getLoginName(),oaNotify.getTitle(),JsonMapper.toJsonString(oaNotify),"url");
				//notificationManager.sendBroadcast("1234567890",oaNotify.getTitle()+"",oaNotify.getContent()+"","url");
			}
		}
	}

	/**
	 * 更新阅读状态
	 */
	@Transactional(readOnly = false)
	public void updateReadFlag(OaNotify oaNotify) {
		OaNotifyRecord oaNotifyRecord = new OaNotifyRecord(oaNotify);
		oaNotifyRecord.setUser(oaNotifyRecord.getCurrentUser());
		oaNotifyRecord.setReadDate(new Date());
		oaNotifyRecord.setReadFlag("1");
		oaNotifyRecordDao.update(oaNotifyRecord);
	}
}