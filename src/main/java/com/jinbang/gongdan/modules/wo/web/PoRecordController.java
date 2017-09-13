package com.jinbang.gongdan.modules.wo.web;

import com.google.common.collect.Lists;
import com.jinbang.gongdan.common.config.Global;
import com.jinbang.gongdan.common.persistence.Page;
import com.jinbang.gongdan.common.utils.DateUtils;
import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.utils.excel.ExportExcel;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.oa.entity.OaNotify;
import com.jinbang.gongdan.modules.oa.service.OaNotifyService;
import com.jinbang.gongdan.modules.sys.entity.User;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import com.jinbang.gongdan.modules.wo.entity.PoRecord;
import com.jinbang.gongdan.modules.wo.entity.WoFeeItem;
import com.jinbang.gongdan.modules.wo.entity.WoWorksheet;
import com.jinbang.gongdan.modules.wo.service.PoRecordService;
import com.jinbang.gongdan.modules.wo.service.SnGenerator;
import com.jinbang.gongdan.modules.wo.service.WoClientService;
import com.jinbang.gongdan.modules.wo.service.WoWorksheetService;
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
import java.util.Date;
import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/14 13:15
 */
@Controller
@RequestMapping(value = "${adminPath}/po/poRecord")
public class PoRecordController extends BaseController {

    @Autowired
    private PoRecordService poRecordService;

    @Autowired
    private OaNotifyService oaNotifyService;
    @Autowired
    private SnGenerator snGenerator;
    @Autowired
    private WoWorksheetService woWorksheetService;



    @Autowired
    private WoClientService woClientService;

    @ModelAttribute
    public PoRecord get(@RequestParam(required = false) String id){
        PoRecord entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = poRecordService.get(id);
        }
        if (entity == null){
            entity = new PoRecord();
        }
        return entity;
    }

    @RequiresPermissions("po:poRecord:view")
    @RequestMapping(value = {"list", ""})
    public String list(PoRecord poRecord, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<PoRecord> page = poRecordService.findPage(new Page<PoRecord>(request, response), poRecord);
        model.addAttribute("page", page);
        return "modules/po/poRecordList";
    }

    @RequestMapping(value = "form")
    public String form(PoRecord poRecord,Model model){
        poRecord.setWoWorksheets(woWorksheetService.findListByPO(poRecord.getId()));
        for(WoWorksheet worksheet:poRecord.getWoWorksheets()){
            List<WoFeeItem> feeItems=woWorksheetService.findByWorksheet(worksheet);
            List<WoFeeItem> cailiaoItems=Lists.newArrayList();
            List<WoFeeItem> fenbaoItems=Lists.newArrayList();
            List<WoFeeItem> rengongItems=Lists.newArrayList();
            List<WoFeeItem> qitaItems=Lists.newArrayList();
            for(WoFeeItem item:feeItems){
                if("1".equals(item.getFeeType()))
                    cailiaoItems.add(item);
                else if("2".equals(item.getFeeType()))
                    fenbaoItems.add(item);
                else if("3".equals(item.getFeeType()))
                    rengongItems.add(item);
                else if("4".equals(item.getFeeType()))
                    qitaItems.add(item);
            }
            worksheet.setCailiaoList(cailiaoItems);
            worksheet.setFenbaoList(fenbaoItems);
            worksheet.setRengongList(rengongItems);
            worksheet.setQitaList(qitaItems);
        }

        model.addAttribute("poRecord",poRecord);
        return "modules/po/poRecordDetail";
    }
    @ResponseBody
    @RequestMapping(value = "ajaxSave")
    public RetEntity ajaxSave(PoRecord poRecord){
        RetEntity retEntity=new RetEntity();
        try {
            poRecordService.saveData(poRecord);
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("po:poRecord:audit")
    @ResponseBody
    @RequestMapping(value = "passAudit")
    public RetEntity passAudit(PoRecord poRecord){
        RetEntity retEntity=new RetEntity();
        try {
            poRecord.setStatus("2");
            poRecordService.saveData(poRecord);
            poRecord=poRecordService.getDetail(poRecord.getId());
            for(WoWorksheet worksheet:poRecord.getWoWorksheets()){
                OaNotify oaNotify=new OaNotify();
                oaNotify.setType("4");
                oaNotify.setTitle("工单费用审核通过");
                oaNotify.setContent("工单【"+ worksheet.getWoNo() + "】费用已审核通过！");
                oaNotify.setCreateBy(UserUtils.getUser());
                oaNotify.setCreateDate(new Date());
                oaNotify.setUpdateBy(UserUtils.getUser());
                oaNotify.setUpdateDate(new Date());
                oaNotify.setStatus("1");//发布
                oaNotify.setOaNotifyRecordIds(worksheet.getWoStation().getPm().getId());//消息接收人
                oaNotifyService.save(oaNotify);
            }
            retEntity.setSuccess(true);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("po:poRecord:audit")
    @ResponseBody
    @RequestMapping(value = "rejectAudit")
    public RetEntity rejectAudit(PoRecord poRecord,String[] worksheets,String remarks){
        RetEntity retEntity=new RetEntity();
        try{
            for(String workId:worksheets){
                WoWorksheet woWorksheet=woWorksheetService.get(workId);
                woWorksheet.setFeeStatus(0);
                woWorksheetService.save(woWorksheet);
                OaNotify oaNotify=new OaNotify();
                oaNotify.setType("4");
                oaNotify.setTitle("工单费用审核未通过");
                oaNotify.setContent("PO订单【"+poRecord.getSnNo()+"】中工单【"+ woWorksheet.getWoNo() + "】费用审核未通过，驳回原因："+remarks);
                oaNotify.setCreateBy(UserUtils.getUser());
                oaNotify.setCreateDate(new Date());
                oaNotify.setUpdateBy(UserUtils.getUser());
                oaNotify.setUpdateDate(new Date());
                oaNotify.setStatus("1");//发布
                oaNotify.setOaNotifyRecordIds(woWorksheet.getWoStation().getPm().getId());//消息接收人
                oaNotifyService.save(oaNotify);
                retEntity.setSuccess(true);
            }
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
    @RequiresPermissions("po:poRecord:edit")
    @ResponseBody
    @RequestMapping(value = "create")
    public RetEntity create(String poNo,String[] worksheets){
        RetEntity retEntity=new RetEntity();
        try{
            PoRecord hasRecord=poRecordService.getByPoNo(poNo);
            if(hasRecord!=null){
                retEntity.setSuccess(false);
                retEntity.setMsg("订单PO号【"+poNo+"】，已存在！");
                return retEntity;
            }
            List<WoWorksheet> woWorksheets= Lists.newArrayList();
            String pjName="";
            for(String woId:worksheets){
                WoWorksheet woWorksheet=woWorksheetService.get(woId);
                pjName+=woWorksheet.getSnNo()+"-";
                woWorksheets.add(woWorksheet);
                OaNotify oaNotify=new OaNotify();
                oaNotify.setType("4");
                oaNotify.setTitle("工单费用待审核");
                oaNotify.setContent("工单【"+ woWorksheet.getWoNo() + "】费用已生成PO待审核！");
                oaNotify.setCreateBy(UserUtils.getUser());
                oaNotify.setCreateDate(new Date());
                oaNotify.setUpdateBy(UserUtils.getUser());
                oaNotify.setUpdateDate(new Date());
                oaNotify.setStatus("1");//发布
                oaNotify.setOaNotifyRecordIds(woWorksheet.getWoStation().getPm().getId());//消息接收人
                oaNotifyService.save(oaNotify);
            }
            pjName=pjName.substring(0,pjName.length()-1);
            woWorksheets.get(0).setWoClient(woClientService.get(woWorksheets.get(0).getWoClient()));
            PoRecord poRecord=new PoRecord();
            poRecord.setPm(woWorksheets.get(0).getWoStation().getPm());
            poRecord.setClient(woWorksheets.get(0).getWoClient());
            poRecord.setPartA(woWorksheets.get(0).getWoClient().getOffice());
            //poRecord.setPartB(user.getCompany());
            User user= UserUtils.get(poRecord.getPm().getId());
            poRecord.setPartB(user.getOffice());
            poRecord.setProjectName(woWorksheets.get(0).getWoClient().getCode()+"-"+pjName);
            poRecord.setSnNo(snGenerator.getSn(woWorksheets.get(0)));
            poRecord.setStatus("1");
            poRecord.setPoNo(poNo);
            poRecord.setWoWorksheets(woWorksheets);
            poRecordService.save(poRecord);
            retEntity.setSuccess(true);
            retEntity.setData(poRecord);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }

    @RequestMapping(value = "preForm")
    public String preForm(WoWorksheet woWorksheet,HttpServletRequest request,HttpServletResponse response,Model model){
        if(StringUtils.isBlank(woWorksheet.getCalculateType()))
            woWorksheet.setCalculateType("1");
        if(woWorksheet.getWoStation()==null||woWorksheet.getWoStation().getPm()==null){
            model.addAttribute("page",new Page(request,response));
            return "modules/po/poRecordPreForm";
        }
        woWorksheet.setWoStatus("5");
        woWorksheet.setWoType("2");
        Page<WoWorksheet> page=woWorksheetService.findPageForPO(new Page<WoWorksheet>(request,response),woWorksheet);
        model.addAttribute("page",page);
        return "modules/po/poRecordPreForm";
    }
    @RequiresPermissions("po:poRecord:del")
    @RequestMapping(value = "delete")
    public String delete(PoRecord poRecord,HttpServletRequest request,HttpServletResponse response,RedirectAttributes redirectAttributes){
        poRecordService.delete(poRecord);
        addMessage(redirectAttributes, "删除PO订单成功");
        return "redirect:"+Global.getAdminPath()+"/po/poRecord/?repage";
    }

    @RequestMapping(value = "export")
    public String export(PoRecord poRecord, HttpServletResponse response,RedirectAttributes redirectAttributes){
        Page<PoRecord> page = poRecordService.findPage(new Page<PoRecord>(), poRecord);
        String fileName = "金曜运维财务明细表"+ DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
        try {

            new ExportExcel("金曜运维财务明细表",new String[]{
                    "甲方","归属公司","评审号","订单PO号","销售金额（未税）","采购成本（未税）",
                    "销项税额","进项抵税额","应缴税额","税后毛利","税后毛利率","综合总成本","企业所得税",
                    "净利润","净利润率","发票类型"
            }).statPoRecord(poRecord.getBeginDate(),poRecord.getEndDate(),page.getList()).write(response,fileName).dispose();
            return null;
        }catch (Exception e){
            addMessage(redirectAttributes, "导出PO订单记录失败！失败信息：" + e.getMessage());
        }
        return "redirect:"+ Global.getAdminPath()+"/po/poRecord?repage";
    }

    @RequestMapping(value = "briefExport")
    public String briefExport(PoRecord poRecord,Integer sts,HttpServletResponse response,Model model){
        poRecord.setWoWorksheets(woWorksheetService.findListByPO(poRecord.getId()));
        for(WoWorksheet worksheet:poRecord.getWoWorksheets()){
            List<WoFeeItem> feeItems=woWorksheetService.findByWorksheet(worksheet);
            List<WoFeeItem> cailiaoItems=Lists.newArrayList();
            List<WoFeeItem> rengongItems=Lists.newArrayList();
            List<WoFeeItem> qitaItems=Lists.newArrayList();
            for(WoFeeItem item:feeItems){
                if("1".equals(item.getFeeType()))
                    cailiaoItems.add(item);
                else if("3".equals(item.getFeeType()))
                    rengongItems.add(item);
                else if("4".equals(item.getFeeType()))
                    qitaItems.add(item);
            }
            worksheet.setCailiaoList(cailiaoItems);
            worksheet.setRengongList(rengongItems);
            worksheet.setQitaList(qitaItems);
        }

        String fileName ="PO订单简报"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
        try {
            new ExportExcel(null,new String[]{}).statBriefPoRecord(poRecord,sts==1).write(response,fileName).dispose();
            return null;

        }catch (Exception e){
            e.printStackTrace();
            addMessage(model,"导出PO订单失败！失败信息："+e.getMessage());
        }
        return form(poRecord,model);
    }
}
