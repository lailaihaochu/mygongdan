package com.jinbang.gongdan.modules.wo.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.entity.WoStation;
import com.jinbang.gongdan.modules.wo.service.WoStationService;

/**
 * 运作站点基本信息Controller
 * @author 许江辉
 * @version 2016-06-27
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woStation")
public class WoStationController extends BaseController {

	@Autowired
	private WoStationService woStationService;
	
	@ModelAttribute
	public WoStation get(@RequestParam(required=false) String id) {
		WoStation entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = woStationService.get(id);
		}
		if (entity == null){
			entity = new WoStation();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:woStation:view")
	@RequestMapping(value = {"list", ""})
	public String list(WoStation woStation, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WoStation> page = woStationService.findPage(new Page<WoStation>(request, response), woStation); 
		model.addAttribute("page", page);
		return "modules/wo/woStationList";
	}

	@RequiresPermissions("wo:woStation:view")
	@RequestMapping(value = "form")
	public String form(WoStation woStation, Model model) {
		if(StringUtils.isNotBlank(woStation.getId())){
			woStation=woStationService.getContactList(woStation);
			woStation=woStationService.getEngineerList(woStation);
		}
		model.addAttribute("woStation", woStation);
		return "modules/wo/woStationForm";
	}

	@RequiresPermissions("wo:woStation:edit")
	@RequestMapping(value = "save")
	public String save(WoStation woStation, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, woStation)){
			return form(woStation, model);
		}
		woStationService.save(woStation);
		addMessage(redirectAttributes, "保存站点成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woStation/?repage";
	}
	
	@RequiresPermissions("wo:woStation:edit")
	@RequestMapping(value = "delete")
	public String delete(WoStation woStation, RedirectAttributes redirectAttributes) {
		woStationService.delete(woStation);
		addMessage(redirectAttributes, "删除站点成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woStation/?repage";
	}
	@RequiresPermissions("wo:woEmployee:view")
	@RequestMapping(value = "tableSelect")
	public String tableSelect(WoStation woStation, HttpServletRequest request, HttpServletResponse response, Model model) {
		model.addAttribute("woStation", woStation);
		Page<WoStation> page = woStationService.findPage(new Page<WoStation>(request, response), woStation);
		model.addAttribute("page", page);
		return "modules/wo/woStationTableSelect";
	}
}