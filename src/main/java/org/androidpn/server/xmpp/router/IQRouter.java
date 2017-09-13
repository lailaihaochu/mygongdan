package org.androidpn.server.xmpp.router;


import org.androidpn.server.xmpp.handler.*;
import org.androidpn.server.xmpp.session.ClientSession;
import org.androidpn.server.xmpp.session.Session;
import org.androidpn.server.xmpp.session.SessionManager;
import org.apache.commons.logging.LogFactory;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xmpp.packet.IQ;
import org.xmpp.packet.JID;
import org.xmpp.packet.PacketError;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/** 
 * This class is to route IQ packets to their corresponding handler.
 *
 * @author Sehwan Noh (devnoh@gmail.com)
 */
public class IQRouter {

    private final Logger log = LoggerFactory.getLogger(getClass());

    private SessionManager sessionManager;

    private List<IQHandler> iqHandlers = new ArrayList<IQHandler>();

    private Map<String, IQHandler> namespace2Handlers = new ConcurrentHashMap<String, IQHandler>();

    /**
     * Constucts a packet router registering new IQ handlers.
     */
    public IQRouter() {
        sessionManager = SessionManager.getInstance();
        iqHandlers.add(new IQAuthHandler());
        iqHandlers.add(new IQRegisterHandler());
        iqHandlers.add(new IQRosterHandler());
        iqHandlers.add(new IQLocationHandler());//定位location
        iqHandlers.add(new IQRealLocHandler());
        //iqHandlers.addAll(Application.getHandlers());
    }

    /**
     * Routes the IQ packet based on its namespace.
     * 
     * @param packet the packet to route
     */
    public void route(IQ packet) {
        if (packet == null) {
            throw new NullPointerException();
        }
        JID sender = packet.getFrom();
        ClientSession session = sessionManager.getSession(sender);

        if (session == null
                || session.getStatus() == Session.STATUS_AUTHENTICATED
                || ("jabber:iq:auth".equals(packet.getChildElement()
                        .getNamespaceURI())
                        || "jabber:iq:register".equals(packet.getChildElement()
                                .getNamespaceURI()) || "urn:ietf:params:xml:ns:xmpp-bind"
                        .equals(packet.getChildElement().getNamespaceURI()))) {
            handle(packet);
        } else {
            IQ reply = IQ.createResultIQ(packet);
            reply.setChildElement(packet.getChildElement().createCopy());
            reply.setError(PacketError.Condition.not_authorized);
            session.process(reply);
        }
    }

    private void handle(IQ packet) {
        try {
            Element childElement = packet.getChildElement();
            String namespace = null;
            if (childElement != null) {
                namespace = childElement.getNamespaceURI();
            }
            if (namespace == null) {
                if (packet.getType() != IQ.Type.result
                        && packet.getType() != IQ.Type.error) {
                    log.warn("Unknown packet " + packet);
                }
            } else {
                log.info("命名空间："+namespace);
                IQHandler handler = getHandler(namespace);
                if (handler == null) {
                    log.info("handler:null");
                    sendErrorPacket(packet,
                            PacketError.Condition.service_unavailable);
                } else {
                    log.info("handler:"+handler.getNamespace());
                    handler.process(packet);
                }
            }

        } catch (Exception e) {
            log.error("Could not route packet", e);
            Session session = sessionManager.getSession(packet.getFrom());
            if (session != null) {
                IQ reply = IQ.createResultIQ(packet);
                reply.setError(PacketError.Condition.internal_server_error);
                session.process(reply);
            }
        }
    }

    /**
     * Senda the error packet to the original sender
     */
    private void sendErrorPacket(IQ originalPacket,
            PacketError.Condition condition) {
        if (IQ.Type.error == originalPacket.getType()) {
            log.error("Cannot reply an IQ error to another IQ error: "
                    + originalPacket);
            return;
        }
        IQ reply = IQ.createResultIQ(originalPacket);
        reply.setChildElement(originalPacket.getChildElement().createCopy());
        reply.setError(condition);
        try {
            PacketDeliverer.deliver(reply);
        } catch (Exception e) {
            // Ignore
        }
    }

    /**
     * Adds a new IQHandler to the list of registered handler.
     * 
     * @param handler the IQHandler
     */
    public void addHandler(IQHandler handler) {
        if (iqHandlers.contains(handler)) {
            throw new IllegalArgumentException(
                    "IQHandler already provided by the server");
        }
        namespace2Handlers.put(handler.getNamespace(), handler);
    }

    /**
     * Removes an IQHandler from the list of registered handler.
     * 
     * @param handler the IQHandler
     */
    public void removeHandler(IQHandler handler) {
        if (iqHandlers.contains(handler)) {
            throw new IllegalArgumentException(
                    "Cannot remove an IQHandler provided by the server");
        }
        namespace2Handlers.remove(handler.getNamespace());
    }

    /**
     * Returns an IQHandler with the given namespace.
     */
    private IQHandler getHandler(String namespace) {
        IQHandler handler = namespace2Handlers.get(namespace);

        if (handler == null) {
            for (IQHandler handlerCandidate : iqHandlers) {
                log.info("handlerNms:"+handlerCandidate.getNamespace()+"|"+namespace+":"+namespace.equalsIgnoreCase(handlerCandidate.getNamespace()));
                if (namespace.equalsIgnoreCase(handlerCandidate.getNamespace())) {
                    handler = handlerCandidate;
                    //log.info("handlerNms:"+handlerCandidate.getNamespace()+"|"+namespace);
                    //log.info("handler:"+handler.getNamespace()+"|"+namespace);
                    namespace2Handlers.put(namespace, handler);
                    break;
                }
            }
        }
        return handler;
    }

}
