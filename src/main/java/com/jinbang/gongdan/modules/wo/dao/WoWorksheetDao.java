package com.jinbang.gongdan.modules.wo.dao;

import com.jinbang.gongdan.common.persistence.CrudDao;
import com.jinbang.gongdan.common.persistence.annotation.MyBatisDao;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;

import java.util.List;

/**
 * 工单相关DAO接口
 * @author 许江辉
 * @version 2016-07-05
 */
@MyBatisDao
public interface WoWorksheetDao extends CrudDao<WoWorksheet> {

    int deleteEngineerInWorkSheet(WoWorksheet woWorksheet, User user);

    int insertEngineerInWorkSheet(WoWorksheet woWorksheet, User user);

    List<WoWorksheet> findListByAssignedEngineer(String userId);

    int saveEngineerCheck(WoWorksheet woWorksheet, User user);

    List<WoWorksheet> findListByPoId(String poId);

    WoWorksheet getBySn(String snNo);

    List<WoWorksheet> findListForPO(WoWorksheet woWorksheet);

    long count(WoWorksheet woWorksheet);

    int deleteWorksheetDevice(WoWorksheet woWorksheet);

    int insertWorksheetDevice(WoWorksheet woWorksheet);

    List<String> findDeviceIdsByWorkSheetId(String worksheetId);
}