package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.service.BaseService;
import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.modules.wo.dao.PoRecordDao;
import com.jinbang.gongdan.modules.wo.dao.WoFeeItemDao;
import com.jinbang.gongdan.modules.wo.dao.WoWorksheetDao;
import com.jinbang.gongdan.modules.wo.entity.PoRecord;
import com.jinbang.gongdan.modules.wo.entity.WoFeeItem;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/14 13:05
 */
@Service
@Transactional(readOnly = true)
public class PoRecordService extends CrudService<PoRecordDao,PoRecord> {
    @Autowired
    private WoWorksheetDao woWorksheetDao;
    @Autowired
    private WoFeeItemDao woFeeItemDao;

    public PoRecord getDetail(String id){
        PoRecord poRecord=super.get(id);
        List<WoWorksheet> woWorksheetList=woWorksheetDao.findListByPoId(id);
        for(WoWorksheet wo:woWorksheetList){
            WoFeeItem item=new WoFeeItem();
            item.setWoWorksheet(wo);
            wo.setFeeItemList(woFeeItemDao.findByWorksheet(item));
        }
        poRecord.setWoWorksheets(woWorksheetList);
        return poRecord;
    }
    public Page<PoRecord> findPage(Page<PoRecord> page,PoRecord poRecord){
        // 设置默认时间范围，
        if (poRecord.getEndDate() != null){
            poRecord.setEndDate(DateUtils.getDateEnd(poRecord.getEndDate()));
        }
        if (poRecord.getBeginDate() != null){
            poRecord.setBeginDate(DateUtils.getDateStart(poRecord.getBeginDate()));
        }
        return super.findPage(page, poRecord);
    }

    public PoRecord getByPoNo(String poNo) {
        return dao.getByPo(poNo);
    }
    @Transactional(readOnly = false)
    public void save(PoRecord poRecord){
        super.save(poRecord);
        dao.deleteWorksheets(poRecord);
        dao.insertWorksheets(poRecord);
    }
    @Transactional(readOnly = false)
    public void delete(PoRecord poRecord){
        super.delete(poRecord);
        dao.deleteWorksheets(poRecord);
    }
    @Transactional(readOnly = false)
    public void saveData(PoRecord poRecord) {
        super.save(poRecord);
    }
}
