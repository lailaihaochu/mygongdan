package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.modules.sys.dao.OfficeDao;
import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.dao.SnGenDao;
import com.jinbang.gongdan.modules.wo.dao.WoClientDao;
import com.jinbang.gongdan.modules.wo.entity.SnEntity;
import com.jinbang.gongdan.modules.wo.entity.WoClient;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/8/8 13:08
 */
@Service
@Transactional(readOnly = false)
public class SnGenerator  {

    @Autowired
    private SnGenDao snGenDao;
    @Autowired
    private OfficeDao officeDao;

    @Autowired
    private WoClientDao woClientDao;

    public String getSn(WoWorksheet woWorksheet){
        SnEntity snEntity=new SnEntity();
        snEntity.setYearStr(DateUtils.getYear().substring(2, 4));
        snEntity.setMonStr(DateUtils.getMonth());
        WoClient woClient=woClientDao.get(woWorksheet.getWoClient().getId());
        snEntity.setClientCode(woClient.getCode());
        SnEntity curSnEntity=snGenDao.getCurrentSn(snEntity);
        if (curSnEntity==null){
            curSnEntity=snEntity;
            curSnEntity.setYearStr(DateUtils.getYear().substring(2, 4));
            curSnEntity.setMonStr(DateUtils.getMonth());
            curSnEntity.setCurrentNum(1);
            curSnEntity.setCurrentDate(new Date());
            curSnEntity.preInsert();
            snGenDao.insert(curSnEntity);
        }else {
            if ((snEntity.getYearStr()+snEntity.getMonStr()).equals((curSnEntity.getYearStr() + curSnEntity.getMonStr()))){
                curSnEntity.setCurrentNum(curSnEntity.getCurrentNum()+1);
            }else {
                curSnEntity.setYearStr(DateUtils.getYear().substring(2, 4));
                curSnEntity.setMonStr(DateUtils.getMonth());
                curSnEntity.setCurrentNum(1);
                curSnEntity.setCurrentDate(new Date());
            }
            curSnEntity.preUpdate();
            snGenDao.update(curSnEntity);
        }

        return curSnEntity.getSN();
    }
}
