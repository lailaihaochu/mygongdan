package com.jinbang.gongdan.modules.wo.service;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.modules.wo.dao.WoDeviceDao;
import com.jinbang.gongdan.modules.wo.entity.WoDevice;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.jinbang.gongdan.common.service.CrudService;

import java.util.List;

/**
 * 设备信息相关Service
 * @author 于鹏杰
 * @version 2017-04-12
 */
@Service
@Transactional(readOnly = true)
public class WoDeviceService extends CrudService<WoDeviceDao,WoDevice>{

    public Page<WoDevice> findPage(Page<WoDevice> page, WoDevice woDevice) {
        return super.findPage(page, woDevice);
    }

    public List<WoDevice> findDeviceByAssetCode(String assetCode) {return dao.findDeviceByAssetCode(assetCode);}

    public List<WoDevice> findLastWoDevice(){return dao.findLastWoDevice();}

}
