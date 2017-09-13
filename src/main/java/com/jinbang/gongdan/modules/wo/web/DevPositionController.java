package com.jinbang.gongdan.modules.wo.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.wo.entity.ClientArea;
import com.jinbang.gongdan.modules.wo.entity.DevPosition;
import com.jinbang.gongdan.modules.wo.service.ClientAreaService;
import com.jinbang.gongdan.modules.wo.service.DevPositionService;
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
 * 位置信息相关Controller
 * @author 许江辉
 * @version 2016-08-07
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/devPosition")
public class DevPositionController extends BaseController {

	@Autowired
	private DevPositionService devPositionService;
	
	@ModelAttribute
	public DevPosition get(@RequestParam(required=false) String id) {
		DevPosition entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = devPositionService.get(id);
		}
		if (entity == null){
			entity = new DevPosition();
		}
		return entity;
	}
	
	@RequiresPermissions("wo:devPosition:view")
	@RequestMapping(value = {"list", ""})
	public String list(DevPosition devPosition, HttpServletRequest request, HttpServletResponse response, Model model) {
		List<DevPosition> list = devPositionService.findList(devPosition);
		model.addAttribute("list", list);
		return "modules/wo/devPositionList";
	}

	@RequiresPermissions("wo:devPosition:view")
	@RequestMapping(value = "form")
	public String form(DevPosition devPos, Model model) {
		if (devPos.getParent()!=null && StringUtils.isNotBlank(devPos.getParent().getId())){
			devPos.setParent(devPositionService.get(devPos.getParent().getId()));
			// 获取排序号，最末节点排序号+30
			if (StringUtils.isBlank(devPos.getId())){
				DevPosition devPosChild = new DevPosition();
				devPosChild.setParent(new DevPosition(devPos.getParent().getId()));
				List<DevPosition> list = devPositionService.findList(devPos);
				if (list.size() > 0){
					devPos.setSort(list.get(list.size()-1).getSort());
					if (devPos.getSort() != null){
						devPos.setSort(devPos.getSort() + 30);
					}
				}
			}
		}
		if (devPos.getSort() == null){
			devPos.setSort(30);
		}
		model.addAttribute("devPosition", devPos);
		return "modules/wo/devPositionForm";
	}

	@RequiresPermissions("wo:devPosition:edit")
	@RequestMapping(value = "save")
	public String save(DevPosition devPosition, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, devPosition)){
			return form(devPosition, model);
		}
		devPositionService.save(devPosition);
		addMessage(redirectAttributes, "保存位置信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/devPosition/?repage";
	}
	
	@RequiresPermissions("wo:devPosition:edit")
	@RequestMapping(value = "delete")
	public String delete(DevPosition devPosition, RedirectAttributes redirectAttributes) {
		devPositionService.delete(devPosition);
		addMessage(redirectAttributes, "删除位置信息成功");
		return "redirect:"+Global.getAdminPath()+"/wo/devPosition/?repage";
	}

	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(DevPosition devPosition,@RequestParam(required=false) String extId, HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<DevPosition> list = devPositionService.findList(devPosition);
		for (int i=0; i<list.size(); i++){
			DevPosition e = list.get(i);
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