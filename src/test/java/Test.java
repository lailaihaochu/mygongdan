import com.jinbang.gongdan.common.test.SpringTransactionalContextTests;
import com.jinbang.gongdan.modules.wo.service.SnGenerator;
import com.jinbang.gongdan.modules.wo.service.WoWorksheetService;
import org.springframework.beans.factory.annotation.Autowired;


/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/7/23 11:18
 */

public class Test extends SpringTransactionalContextTests {
    @Autowired
    private SnGenerator snGenerator;
    @Autowired
    private WoWorksheetService woWorksheetService;
    @org.junit.Test
    public void test1(){
        /*String sn=snGenerator.getSn(woWorksheetService.get("002bfcd2857e4db58e2182e104db8941"));
        System.out.println(sn);*/
    }
}

