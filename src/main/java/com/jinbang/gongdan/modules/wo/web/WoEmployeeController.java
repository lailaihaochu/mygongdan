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
import com.jinbang.gongdan.modules.wo.entity.WoEmployee;
import com.jinbang.gongdan.modules.wo.service.WoEmployeeService;

/**
 * 员工信息相关Controller
 * @author 许江辉
 * @version 2016-06-28
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woEmployee")
public class WoEmployeeController extends BaseController {

	@Autowired
	private WoEmployeeService woEmployeeService;
	
	@ModelAttribute
	public WoEmployee get(@RequestParam(required=false) String id) {
		WoEmployee entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = woEmployeeService.get(id);
		}
		if (entity == null){
			entity = new WoEmployee();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:woEmployee:view")
	@RequestMapping(value = {"list", ""})
	public String list(WoEmployee woEmployee, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WoEmployee> page = woEmployeeService.findPage(new Page<WoEmployee>(request, response), woEmployee); 
		model.addAttribute("page", page);
		return "modules/wo/woEmployeeList";
	}

	@RequiresPermissions("wo:woEmployee:view")
	@RequestMapping(value = "form")
	public String form(WoEmployee woEmployee, Model model) {
		model.addAttribute("woEmployee", woEmployee);
		return "modules/wo/woEmployeeForm";
	}

	@RequiresPermissions("wo:woEmployee:edit")
	@RequestMapping(value = "save")
	public String save(WoEmployee woEmployee, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, woEmployee)){
			return form(woEmployee, model);
		}
		woEmployeeService.save(woEmployee);
		addMessage(redirectAttributes, "保存员工信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woEmployee/?repage";
	}
	
	@RequiresPermissions("wo:woEmployee:edit")
	@RequestMapping(value = "delete")
	public String delete(WoEmployee woEmployee, RedirectAttributes redirectAttributes) {
		woEmployeeService.delete(woEmployee);
		addMessage(redirectAttributes, "删除员工信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woEmployee/?repage";
	}
	@RequiresPermissions("wo:woEmployee:view")
	@RequestMapping(value = "tableSelect")
	public String tableSelect(WoEmployee woEmployee, HttpServletRequest request, HttpServletResponse response, Model model) {
		User user = UserUtils.getUser();
		if (!user.isAdmin()){
			woEmployee.setCreateBy(user);
		}
		model.addAttribute("woEmployee", woEmployee);
		Page<WoEmployee> page = woEmployeeService.findPage(new Page<WoEmployee>(request, response), woEmployee);
		model.addAttribute("page", page);
		return "modules/wo/woEmployeeTableSelect";
	}
}