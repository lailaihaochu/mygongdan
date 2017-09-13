package org.androidpn.server.xmpp.handler;

import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.common.utils.SpringContextHolder;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.wo.entity.WoPosLog;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
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
public class IQLocationHandler extends IQHandler {
    private static final String NAMESPACE = "androidpn:iq:location";

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
            Element iq = packet.getElement();
            Element location = iq.element("location");
            WoPosLogService posLogService= SpringContextHolder.getBean("woPosLogService");
            WoPosLog woPosLog=new WoPosLog();
            woPosLog.setWorksheet(new WoWorksheet(location.elementText("workOrderId")));
            woPosLog.setEngineer(new User(location.elementText("userId")));
            woPosLog.setLat(Double.valueOf(location.elementText("latitude")));
            woPosLog.setLon(Double.valueOf(location.elementText("longitude")));
            woPosLog.setReportDate(DateUtils.parseDate(location.elementText("sendTime"),"yyyy-MM-dd HH:mm:ss"));
            posLogService.save(woPosLog);
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
}
