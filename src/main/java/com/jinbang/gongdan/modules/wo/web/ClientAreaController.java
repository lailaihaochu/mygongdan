package com.jinbang.gongdan.modules.wo.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.jinbang.gongdan.modules.wo.entity.ClientArea;
import com.jinbang.gongdan.modules.wo.service.ClientAreaService;

/**
 * 客户区域相关Controller
 * @author 许江辉
 * @version 2016-08-07
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/clientArea")
public class ClientAreaController extends BaseController {

	@Autowired
	private ClientAreaService clientAreaService;
	
	@ModelAttribute
	public ClientArea get(@RequestParam(required=false) String id) {
		ClientArea entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = clientAreaService.get(id);
		}
		if (entity == null){
			entity = new ClientArea();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:clientArea:view")
	@RequestMapping(value = {"list", ""})
	public String list(ClientArea clientArea, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<ClientArea> list = clientAreaService.findList(clientArea); 
		model.addAttribute("list", list);
		return "modules/wo/clientAreaList";
	}

	@RequiresPermissions("wo:clientArea:view")
	@RequestMapping(value = "form")
	public String form(ClientArea clientArea, Model model) {
		if (clientArea.getParent()!=null && StringUtils.isNotBlank(clientArea.getParent().getId())){
			clientArea.setParent(clientAreaService.get(clientArea.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(clientArea.getId())){
				ClientArea clientAreaChild = new ClientArea();
				clientAreaChild.setParent(new ClientArea(clientArea.getParent().getId()));
				List<ClientArea> list = clientAreaService.findList(clientArea); 
				if (list.size() > 0){
					clientArea.setSort(list.get(list.size()-1).getSort());
					if (clientArea.getSort() != null){
						clientArea.setSort(clientArea.getSort() + 30);
					}
				}
			}
		}
		if (clientArea.getSort() == null){
			clientArea.setSort(30);
		}
		model.addAttribute("clientArea", clientArea);
		return "modules/wo/clientAreaForm";
	}

	@RequiresPermissions("wo:clientArea:edit")
	@RequestMapping(value = "save")
	public String save(ClientArea clientArea, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, clientArea)){
			return form(clientArea, model);
		}
		clientAreaService.save(clientArea);
		addMessage(redirectAttributes, "保存客户区域成功");
		return "redirect:"+Global.getAdminPath()+"/wo/clientArea/?repage";
	}
	
	@RequiresPermissions("wo:clientArea:edit")
	@RequestMapping(value = "delete")
	public String delete(ClientArea clientArea, RedirectAttributes redirectAttributes) {
		clientAreaService.delete(clientArea);
		addMessage(redirectAttributes, "删除客户区域成功");
		return "redirect:"+Global.getAdminPath()+"/wo/clientArea/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(ClientArea clientArea,@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<ClientArea> list = clientAreaService.findList(clientArea);
		for (int i=0; i<list.size(); i++){
			ClientArea e = list.get(i);
			if (StringUtils.isBlank(extId) || (extId!=null && !extId.equals(e.getId()) && e.getParentIds().indexOf(","+extId+",")==-1)){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("name", e.getName());
				mapList.add(map);
			}
		}
		return mapList;
	}
	
}