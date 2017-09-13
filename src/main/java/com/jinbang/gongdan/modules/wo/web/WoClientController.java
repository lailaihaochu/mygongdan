package com.jinbang.gongdan.modules.wo.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.entity.WoClient;
import com.jinbang.gongdan.modules.wo.service.WoClientService;

import java.util.List;
import java.util.Map;

/**
 * 客户基本信息管理Controller
 * @author 许江辉
 * @version 2016-06-27
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woClient")
public class WoClientController extends BaseController {

	@Autowired
	private WoClientService woClientService;
	
	@ModelAttribute
	public WoClient get(@RequestParam(required=false) String id) {
		WoClient entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = woClientService.get(id);
		}
		if (entity == null){
			entity = new WoClient();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:woClient:view")
	@RequestMapping(value = {"list", ""})
	public String list(WoClient woClient, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WoClient> page = woClientService.findPage(new Page<WoClient>(request, response), woClient); 
		model.addAttribute("page", page);
		return "modules/wo/woClientList";
	}

	@RequiresPermissions("wo:woClient:view")
	@RequestMapping(value = "form")
	public String form(WoClient woClient, Model model) {
		model.addAttribute("woClient", woClient);
		return "modules/wo/woClientForm";
	}

	@RequiresPermissions("wo:woClient:edit")
	@RequestMapping(value = "save")
	public String save(WoClient woClient, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, woClient)){
			return form(woClient, model);
		}
		woClientService.save(woClient);
		addMessage(redirectAttributes, "保存客户信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woClient/?repage";
	}
	
	@RequiresPermissions("wo:woClient:edit")
	@RequestMapping(value = "delete")
	public String delete(WoClient woClient, RedirectAttributes redirectAttributes) {
		woClientService.delete(woClient);
		addMessage(redirectAttributes, "删除客户信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woClient/?repage";
	}
	@RequiresPermissions("wo:woClient:view")
	@RequestMapping(value = "tableSelect")
	public String tableSelect(WoClient woClient, HttpServletRequest request, HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		if (!user.isAdmin()){
			woClient.setCreateBy(user);
		}
		model.addAttribute("woClient", woClient);
		Page<WoClient> page = woClientService.findPage(new Page<WoClient>(request, response), woClient);
		model.addAttribute("page", page);
		return "modules/wo/woClientTableSelect";
	}
}