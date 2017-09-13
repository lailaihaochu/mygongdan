package com.jinbang.gongdan.modules.wo.web;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.jinbang.gongdan.common.beanvalidator.BeanValidators;
import com.jinbang.gongdan.common.mapper.JsonMapper;
import com.jinbang.gongdan.common.utils.excel.ExportExcel;
import com.jinbang.gongdan.common.utils.excel.ImportExcel;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.service.SystemService;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.entity.DeviceCategory;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import com.jinbang.gongdan.modules.wo.service.DeviceCategoryService;
import com.jinbang.gongdan.modules.wo.service.WoWorksheetService;
import com.jinbang.gongdan.modules.wo.utils.VariateUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.modules.wo.entity.WoDevice;
import com.jinbang.gongdan.modules.wo.service.WoDeviceService;

import java.io.IOException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import static org.apache.shiro.web.filter.mgt.DefaultFilter.user;

/**
 * 设备信息相关Controller
 * @author 于鹏杰
 * @version 2017-4-12
 */
@Controller
@RequestMapping(value = "${adminPath}/wo/woDevice")
public class WoDeviceController extends BaseController {

    @Autowired
    private WoDeviceService woDeviceService;
    @Autowired
    private WoWorksheetService woWorksheetService;
    @Autowired
    private DeviceCategoryService deviceCategoryService;

    @ModelAttribute
    public WoDevice get(@RequestParam(required=false) String id) {
        WoDevice entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = woDeviceService.get(id);
        }
        if (entity == null){
            entity = new WoDevice();
        }
        return entity;
    }

    @RequiresPermissions("wo:woDevice:view")
    @RequestMapping(value = {"list", ""})
    public String list(WoDevice woDevice, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<WoDevice> page = woDeviceService.findPage(new Page<WoDevice>(request, response), woDevice);
        model.addAttribute("page", page);
        return "modules/wo/woDeviceList";
    }

    @RequiresPermissions("wo:woDevice:view")
    @RequestMapping(value = "form")
    public String form(WoDevice woDevice, Model model) {
        model.addAttribute("woDevice", woDevice);
        return "modules/wo/woDeviceForm";
    }

    @RequiresPermissions("wo:woDevice:edit")
    @RequestMapping(value = "save")
    public String save(WoDevice woDevice, Model model, RedirectAttributes redirectAttributes) {
        if (!beanValidator(model, woDevice)){
            return form(woDevice, model);
        }
        if (woDevice.getIsNewRecord()){
            woDevice.setDevStatus(VariateUtils.QIYONG);
        }
        woDeviceService.save(woDevice);
        addMessage(redirectAttributes, "保存设备信息成功");
        return "redirect:"+Global.getAdminPath()+"/wo/woDevice/?repage";
    }

    @RequiresPermissions("wo:woDevice:edit")
    @RequestMapping(value = "delete")
    public String delete(WoDevice woDevice, RedirectAttributes redirectAttributes) {
        woDeviceService.delete(woDevice);
        addMessage(redirectAttributes, "删除设备信息成功");
        return "redirect:"+Global.getAdminPath()+"/wo/woDevice/?repage";
    }
    @RequiresPermissions("wo:woDevice:view")
    @RequestMapping(value = "tableSelect")
    public String tableSelect(WoDevice woDevice, String woWorksheetId, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user = UserUtils.getUser();
        if (!user.isAdmin()){
            woDevice.setCreateBy(user);
        }
        model.addAttribute("woDevice", woDevice);
        List<WoDevice> deviceList = Lists.newArrayList();
        List<String> deviceIdList =woWorksheetService.findDeviceIdsByWorkSheetId(woWorksheetId);
        if (deviceIdList .size() > 0) {
            for (int i = 0; i < deviceIdList.size(); i++) {
                WoDevice dev = new WoDevice();
                dev.setId(deviceIdList.get(i));
                deviceList.add(dev);
            }
        }
        model.addAttribute("woWorksheetId", woWorksheetId);
        model.addAttribute("deviceList", deviceList);
        Page<WoDevice> page = woDeviceService.findPage(new Page<WoDevice>(request, response), woDevice);
        model.addAttribute("page", page);
        return "modules/wo/woDeviceTableSelect";
    }
    @RequiresPermissions("wo:woDevice:view")
    @RequestMapping(value = "checkAssetCodeDevice")
    public void checkAssetCodeDevice(String assetCode,String deviceId, HttpServletResponse response) {
        boolean b = true;
        try {
            assetCode = URLDecoder.decode(assetCode,"UTF-8");
            if(StringUtils.isNoneBlank(assetCode)){
                List<WoDevice> deviceList =woDeviceService.findDeviceByAssetCode(assetCode);
                if(StringUtils.isNoneBlank(deviceId)){
                    if (deviceList.size() > 1){
                        b = false;
                    }
                }else{
                    if (deviceList.size() > 0){
                        b = false;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            b = false;
        } finally {
            try {
                response.getWriter().write(String.valueOf(b));
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    /**
     * 选三级类别,通过ajax 异步填充一二级类别
     * @param deviceTypeId  三级类别
     * @param response
     */
    @RequestMapping(value = "writeDeviceCategory")
    public void writeDeviceCategory(String deviceTypeId, HttpServletResponse response) {
        Map<String, Object> map = Maps.newHashMap();
        try {
            if(StringUtils.isNoneBlank(deviceTypeId)){
                DeviceCategory deviceType3 = deviceCategoryService.get(deviceTypeId);
                if(deviceType3 != null){
                    DeviceCategory deviceType2 = deviceCategoryService.get(deviceType3.getParentId());
                    map.put("deviceType2Id",deviceType2.getId());
                    map.put("deviceType2Name",deviceType2.getName());
                    if(deviceType2 != null){
                        DeviceCategory deviceType1 = deviceCategoryService.get(deviceType2.getParentId());
                        map.put("deviceType1Id",deviceType1.getId());
                        map.put("deviceType1Name",deviceType1.getName());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                response.getWriter().write(JsonMapper.toJsonString(map));
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    /**
     * 导入设备数据
     * @param file
     * @param redirectAttributes
     * @return
     */
    /*@RequiresPermissions("sys:user:edit")*/
    @RequestMapping(value = "import", method= RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
        if(Global.isDemoMode()){
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return "redirect:" + adminPath + "/wo/woDevice/list?repage";
        }
        try {
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<WoDevice> list = ei.getDataList(WoDevice.class);
            for (WoDevice woDevice : list){
                try{
                    if ("true".equals(checkAssetCode("", woDevice.getAssetCode()))){
                        BeanValidators.validateWithException(validator, woDevice);
                        woDeviceService.save(woDevice);
                        successNum++;
                    }else{
                        failureMsg.append("<br/>固定资产编号 "+woDevice.getAssetCode()+" 已存在; ");
                        failureNum++;
                    }
                }catch(ConstraintViolationException ex){
                    failureMsg.append("<br/>固定资产编号 "+woDevice.getAssetCode()+" 导入失败：");
                    List<String> messageList = BeanValidators.extractPropertyAndMessageAsList(ex, ": ");
                    for (String message : messageList){
                        failureMsg.append(message+"; ");
                        failureNum++;
                    }
                }catch (Exception ex) {
                    failureMsg.append("<br/>固定资产编号 "+woDevice.getAssetCode()+" 导入失败："+ex.getMessage());
                }
            }
            if (failureNum>0){
                failureMsg.insert(0, "，失败 "+failureNum+" 条设备信息，导入信息如下：");
            }
            addMessage(redirectAttributes, "已成功导入 "+successNum+" 条设备信息"+failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入设备失败！失败信息："+e.getMessage());
        }
        return "redirect:" + adminPath + "/wo/woDevice/list?repage";
    }

    /**
     * 下载导入用户数据模板
     * @param response
     * @param redirectAttributes
     * @return
     */
    /*@RequiresPermissions("sys:user:view")*/
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
        try {
            String fileName = "设备信息数据导入模板.xlsx";
            List<WoDevice> list = woDeviceService.findLastWoDevice();
            new ExportExcel("设备数据", WoDevice.class, 2).setDataList(list).write(response, fileName).dispose();
            return null;
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
        }
        return "redirect:" + adminPath + "/wo/woDevice/list?repage";
    }

    /**
     * 验证资产编号是否有效
     * @param oldAssetCode
     * @param assetCode
     * @return
     */
    @ResponseBody
    /*@RequiresPermissions("sys:user:edit")*/
    @RequestMapping(value = "checkAssetCode")
    public String checkAssetCode(String oldAssetCode, String assetCode) {
        if(assetCode != null && !oldAssetCode.equals(assetCode) && woDeviceService.findDeviceByAssetCode(assetCode).size() == 0){
            return "true";
        }
        return "false";
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }

}