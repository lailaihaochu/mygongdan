package com.jinbang.gongdan.modules.wo.service;


import com.jinbang.gongdan.common.service.CrudService;
import com.jinbang.gongdan.modules.sys.entity.Office;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.dao.WoEngineerStatusDao;
import com.jinbang.gongdan.modules.wo.entity.WoEngineerStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author Jianghui
 * @version V1.0
 * @description ${DESCRIPTION}
 * @date 2017-05-15 18:52
 */
@Service
@Transactional(readOnly = true)
public class WoEngineerStatusService extends CrudService<WoEngineerStatusDao,WoEngineerStatus> {

    public WoEngineerStatus getByEngineerId(String eId){
        WoEngineerStatus woEngineerStatus=new WoEngineerStatus();
        woEngineerStatus.setEngineer(new User(eId));
        return dao.getByEngineer(woEngineerStatus);
    }

    public List<WoEngineerStatus> findByOfficeId(String officeId) {
        User engineer=new User();
        engineer.setOffice(new Office(officeId));
        WoEngineerStatus woEngineerStatus=new WoEngineerStatus();
        woEngineerStatus.setEngineer(engineer);
        return dao.findList(woEngineerStatus);
    }
}
