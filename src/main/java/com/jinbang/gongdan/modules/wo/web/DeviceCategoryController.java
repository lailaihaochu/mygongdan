package com.jinbang.gongdan.modules.wo.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.wo.entity.DevPosition;
import com.jinbang.gongdan.modules.wo.entity.DeviceCategory;
import com.jinbang.gongdan.modules.wo.service.DevPositionService;
import com.jinbang.gongdan.modules.wo.service.DeviceCategoryService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 设备类目相关Controller
 * @author 许江辉
 * @version 2016-08-07
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/devCategory")
public class DeviceCategoryController extends BaseController {

	@Autowired
	private DeviceCategoryService deviceCategoryService;
	
	@ModelAttribute
	public DeviceCategory get(@RequestParam(required=false) String id) {
		DeviceCategory entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = deviceCategoryService.get(id);
		}
		if (entity == null){
			entity = new DeviceCategory();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:devCate:view")
	@RequestMapping(value = {"list", ""})
	public String list(DeviceCategory deviceCategory, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<DeviceCategory> list = deviceCategoryService.findList(deviceCategory);
		model.addAttribute("list", list);
		return "modules/wo/devCateList";
	}

	@RequiresPermissions("wo:devCate:view")
	@RequestMapping(value = "form")
	public String form(DeviceCategory deviceCategory, Model model) {
		if (deviceCategory.getParent()!=null && StringUtils.isNotBlank(deviceCategory.getParent().getId())){
			deviceCategory.setParent(deviceCategoryService.get(deviceCategory.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(deviceCategory.getId())){
				DeviceCategory devCateChild = new DeviceCategory();
				devCateChild.setParent(new DeviceCategory(deviceCategory.getParent().getId()));
				List<DeviceCategory> list = deviceCategoryService.findList(deviceCategory);
				if (list.size() > 0){
					deviceCategory.setSort(list.get(list.size()-1).getSort());
					if (deviceCategory.getSort() != null){
						deviceCategory.setSort(deviceCategory.getSort() + 30);
					}
				}
			}
		}
		if (deviceCategory.getSort() == null){
			deviceCategory.setSort(30);
		}
		model.addAttribute("deviceCategory", deviceCategory);
		return "modules/wo/devCateForm";
	}

	@RequiresPermissions("wo:devCate:edit")
	@RequestMapping(value = "save")
	public String save(DeviceCategory deviceCategory, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, deviceCategory)){
			return form(deviceCategory, model);
		}
		deviceCategoryService.save(deviceCategory);
		addMessage(redirectAttributes, "保存设备类型成功");
		return "redirect:"+Global.getAdminPath()+"/wo/devCategory/?repage";
	}
	
	@RequiresPermissions("wo:devCate:edit")
	@RequestMapping(value = "delete")
	public String delete(DeviceCategory deviceCategory, RedirectAttributes redirectAttributes) {
		deviceCategoryService.delete(deviceCategory);
		addMessage(redirectAttributes, "删除设备类型成功");
		return "redirect:"+Global.getAdminPath()+"/wo/devCategory/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(DeviceCategory deviceCategory,@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<DeviceCategory> list = deviceCategoryService.findList(deviceCategory);
		for (int i=0; i<list.size(); i++){
			DeviceCategory e = list.get(i);
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