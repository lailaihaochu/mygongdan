package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.mapper.JsonMapper;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.modules.wo.dao.WoGenDao;
import com.jinbang.gongdan.modules.wo.entity.WoEntity;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/17 23:45
 */
@Service
@Transactional(readOnly = false)
public class WoGenerator {

    @Autowired
    private WoGenDao woGenDao;

    public String getWO(WoWorksheet woWorksheet){

        WoEntity woEntity=new WoEntity();
        woEntity.setDateStr(DateUtils.getSNDate());
        woEntity.setClientCode(woWorksheet.getWoClient().getCode());
        WoEntity curEntity=woGenDao.getCurrentWo(woEntity);
        if (curEntity==null){
            curEntity=woEntity;
            curEntity.setCurNum(1);
            curEntity.preInsert();
            woGenDao.insert(curEntity);
            System.out.println("工单号："+ JsonMapper.toJsonString(curEntity));
        }else {
            System.out.println("o工单号："+ JsonMapper.toJsonString(curEntity));
            if (woEntity.getDateStr().equals(curEntity.getDateStr())){

                curEntity.setCurNum(curEntity.getCurNum() + 1);
                System.out.println("o工单号："+ JsonMapper.toJsonString(curEntity));
            }else {
                curEntity.setCurNum(1);
                curEntity.setDateStr(DateUtils.getSNDate());
            }
            System.out.println("是否相同:"+woEntity.getDateStr().equals(curEntity.getDateStr()));

            curEntity.preUpdate();
            woGenDao.update(curEntity);
        }
        return curEntity.getWOCode();
    }
}
