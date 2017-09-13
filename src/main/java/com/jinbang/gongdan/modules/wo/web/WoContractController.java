package com.jinbang.gongdan.modules.wo.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.jinbang.gongdan.modules.wo.entity.WoContract;
import com.jinbang.gongdan.modules.wo.service.WoContractService;

/**
 * 合同信息相关Controller
 * @author 许江辉
 * @version 2016-07-01
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woContract")
public class WoContractController extends BaseController {

	@Autowired
	private WoContractService woContractService;
	
	@ModelAttribute
	public WoContract get(@RequestParam(required=false) String id) {
		WoContract entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = woContractService.get(id);
		}
		if (entity == null){
			entity = new WoContract();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:woContract:view")
	@RequestMapping(value = {"list", ""})
	public String list(WoContract woContract, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<WoContract> page = woContractService.findPage(new Page<WoContract>(request, response), woContract); 
		model.addAttribute("page", page);
		return "modules/wo/woContractList";
	}

	@RequiresPermissions("wo:woContract:view")
	@RequestMapping(value = "form")
	public String form(WoContract woContract, Model model) {
		model.addAttribute("woContract", woContract);
		return "modules/wo/woContractForm";
	}

	@RequiresPermissions("wo:woContract:edit")
	@RequestMapping(value = "save")
	public String save(WoContract woContract, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, woContract)){
			return form(woContract, model);
		}
		woContractService.save(woContract);
		addMessage(redirectAttributes, "保存合同信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woContract/?repage";
	}
	
	@RequiresPermissions("wo:woContract:edit")
	@RequestMapping(value = "delete")
	public String delete(WoContract woContract, RedirectAttributes redirectAttributes) {
		woContractService.delete(woContract);
		addMessage(redirectAttributes, "删除合同信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woContract/?repage";
	}

}