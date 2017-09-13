package com.jinbang.gongdan.modules.wo.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.entity.WoTemplate;
import com.jinbang.gongdan.modules.wo.service.WoTemplateService;

/**
 * 模板管理Controller
 * @author 许江辉
 * @version 2016-09-03
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woTemplate")
public class WoTemplateController extends BaseController {

	@Autowired
	private WoTemplateService woTemplateService;
	
	@ModelAttribute
	public WoTemplate get(@RequestParam(required=false) String id) {
		WoTemplate entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = woTemplateService.get(id);
		}
		if (entity == null){
			entity = new WoTemplate();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:woTemplate:view")
	@RequestMapping(value = {"list", ""})
	public String list(WoTemplate woTemplate, HttpServletRequest request, HttpServletResponse response, Model model) {
		woTemplate.setType("0");
		Page<WoTemplate> page = woTemplateService.findPage(new Page<WoTemplate>(request,response),woTemplate);
		model.addAttribute("page", page);
		return "modules/wo/woTemplateList";
	}
	@ResponseBody
	@RequestMapping(value = "checkName")
	public String checkUnique(String oldName,String name) {
		if (name !=null && name.equals(oldName)) {
			return "true";
		} else if (name !=null && woTemplateService.getByName(name) == null) {
			return "true";
		}
		return "false";
	}
	@RequiresPermissions("wo:woTemplate:view")
	@RequestMapping(value = "form")
	public String form(WoTemplate woTemplate, Model model) {
		if(!woTemplate.getIsNewRecord()){
			WoTemplate tmp=new WoTemplate();
			tmp.setParent(woTemplate);
			tmp.setType("1");
			List<WoTemplate> list=woTemplateService.findList(tmp);
			woTemplate.setWoTemplateList(list);
		}
		model.addAttribute("woTemplate", woTemplate);
		return "modules/wo/woTemplateForm";
	}

	@RequiresPermissions("wo:woTemplate:edit")
	@RequestMapping(value = "save")
	public String save(WoTemplate woTemplate, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, woTemplate)){
			return form(woTemplate, model);
		}
		woTemplateService.save(woTemplate);

		addMessage(redirectAttributes, "保存模板成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woTemplate/?repage";
	}
	
	@RequiresPermissions("wo:woTemplate:edit")
	@RequestMapping(value = "delete")
	public String delete(WoTemplate woTemplate, RedirectAttributes redirectAttributes) {
		woTemplateService.delete(woTemplate);
		addMessage(redirectAttributes, "删除模板成功");
		return "redirect:"+Global.getAdminPath()+"/wo/woTemplate/?repage";
	}

	@RequestMapping("createForm")
	public String createForm(WoTemplate woTemplate,Model model){
		model.addAttribute("woTemplate", woTemplate);
		return "modules/wo/woTemplateCreateForm";
	}
	@ResponseBody
	@RequestMapping("ajaxSave")
	public RetEntity ajaxSave(WoTemplate woTemplate){
		RetEntity retEntity=new RetEntity();
		WoTemplate woTpl=woTemplateService.getByName(woTemplate.getName());
		if(woTpl!=null){
			retEntity.setSuccess(false);
			retEntity.setMsg("模板名称已存在！");
			return retEntity;
		}
		woTemplateService.save(woTemplate);
		retEntity.setSuccess(true);
		return retEntity;
	}

	@RequiresPermissions("wo:woTemplate:view")
	@RequestMapping(value = "tableSelect")
	public String tableSelect(WoTemplate woTemplate, HttpServletRequest request, HttpServletResponse response, Model model) {
		model.addAttribute("woTemplate", woTemplate);
		Page<WoTemplate> page = woTemplateService.findPage(new Page<WoTemplate>(request, response), woTemplate);
		model.addAttribute("page", page);
		return "modules/wo/woTemplateTableSelect";
	}

	@RequiresPermissions("wo:woTemplate:view")
	@ResponseBody
	@RequestMapping("getDetail")
	public List<WoTemplate> getDetail(WoTemplate woTemplate){
		WoTemplate tmp=new WoTemplate();
		tmp.setParent(woTemplate);
		tmp.setType("1");
		List<WoTemplate> list=woTemplateService.findList(tmp);
		return list;
	}
}