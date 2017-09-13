package org.androidpn.server.xmpp.handler;

import com.jinbang.gongdan.common.mapper.JsonMapper;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.common.utils.SpringContextHolder;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.entity.WoEngineerStatus;
import com.jinbang.gongdan.modules.wo.entity.WoPosLog;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import com.jinbang.gongdan.modules.wo.service.WoEngineerStatusService;
import com.jinbang.gongdan.modules.wo.service.WoPosLogService;
import org.androidpn.server.xmpp.UnauthenticatedException;
import org.androidpn.server.xmpp.UnauthorizedException;
import org.androidpn.server.xmpp.session.ClientSession;
import org.dom4j.Element;
import org.xmpp.packet.IQ;
import org.xmpp.packet.PacketError;

/**
 * @author Jianghui
 * @version V1.0
 * @description ${DESCRIPTION}
 * @date 2017-05-13 14:03
 */
public class IQRealLocHandler extends IQHandler {
    private static final String NAMESPACE = "androidpn:iq:realTimeLocation";
    private Element probeResponse;
    @Override
    public IQ handleIQ(IQ packet) throws UnauthorizedException {
        IQ reply = null;

        ClientSession session = sessionManager.getSession(packet.getFrom());
        if (session == null) {
            log.error("Session not found for key " + packet.getFrom());
            reply = IQ.createResultIQ(packet);
            reply.setChildElement(packet.getChildElement().createCopy());
            reply.setError(PacketError.Condition.internal_server_error);
            return reply;
        }
        try {
            log.info("realLoc:"+packet.toString());
            Element iq = packet.getElement();
            Element location = iq.element("realTimeLocation");
            WoEngineerStatusService statusService= SpringContextHolder.getBean("woEngineerStatusService");
            WoEngineerStatus woEngineerStatus=statusService.getByEngineerId(location.elementText("userId"));
            if(woEngineerStatus ==null){
                woEngineerStatus=new WoEngineerStatus();
                woEngineerStatus.setEngineer(new User(location.elementText("userId")));
            }

            woEngineerStatus.setLat(Double.valueOf(location.elementText("latitude")));
            woEngineerStatus.setLon(Double.valueOf(location.elementText("longitude")));
            woEngineerStatus.setReportDate(DateUtils.parseDate(location.elementText("sendTime"),"yyyy-MM-dd HH:mm:ss"));
            log.info("实时位置："+JsonMapper.getInstance().toJson(woEngineerStatus));
            statusService.save(woEngineerStatus);
        }catch (Exception ex){
            log.error(ex);
            reply = IQ.createResultIQ(packet);
            reply.setChildElement(packet.getChildElement().createCopy());
            if (ex instanceof IllegalArgumentException) {
                reply.setError(PacketError.Condition.not_acceptable);
            } else if (ex instanceof UnauthorizedException) {
                reply.setError(PacketError.Condition.not_authorized);
            } else if (ex instanceof UnauthenticatedException) {
                reply.setError(PacketError.Condition.not_authorized);
            } else {
                reply.setError(PacketError.Condition.internal_server_error);
            }
        }
        return null;
    }

    @Override
    public String getNamespace() {
        return NAMESPACE;
    }

    public static void main(String[] args) {
        IQRealLocHandler handler=new IQRealLocHandler();
        System.out.println(handler.getNamespace());
        System.out.println(handler.getNamespace().equalsIgnoreCase("androidpn:iq:realTimeLocation"));
    }
}
