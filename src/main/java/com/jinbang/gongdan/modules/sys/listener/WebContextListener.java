package com.jinbang.gongdan.modules.sys.listener;

import org.androidpn.server.util.ConfigManager;
import org.androidpn.server.xmpp.XmppServer;
import org.springframework.web.context.WebApplicationContext;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;

public class WebContextListener extends org.springframework.web.context.ContextLoaderListener {
	
	@Override
	public WebApplicationContext initWebApplicationContext(ServletContext servletContext) {

		System.out.println("=======initWebApplicationContext= XmppServer=====");
		WebApplicationContext context=super.initWebApplicationContext(servletContext);
		XmppServer.getInstance();
		ConfigManager.getInstance().getConfig().setProperty("server.home.dir", WebContextListener.class.getResource("/").getPath());
		return context;

	}

}
