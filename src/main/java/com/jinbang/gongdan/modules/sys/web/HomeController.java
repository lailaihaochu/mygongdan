package com.jinbang.gongdan.modules.sys.web;

import com.jinbang.gongdan.common.utils.StringUtils;
import com.jinbang.gongdan.common.web.BaseController;
import com.jinbang.gongdan.modules.app.entity.RetEntity;
import com.jinbang.gongdan.modules.sys.entity.Note;
import com.jinbang.gongdan.modules.sys.service.SystemService;
import com.jinbang.gongdan.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Simple to Introduction
 * author:Jianghui
 * date:2016/9/14 16:37
 */
@Controller
@RequestMapping(value = "${adminPath}/home")
public class HomeController extends BaseController {

    @Autowired
    private SystemService systemService;

    @ModelAttribute
    public Note get(@RequestParam(required = false)String id){
        if (StringUtils.isNotBlank(id)){
            return systemService.getNote(id);
        }else{
            return new Note();
        }
    }

    @RequestMapping(value = "")
    public String home(Model model){
        List<Note> notes=systemService.findNoteList();
        model.addAttribute("notes",notes);
        return "modules/sys/Home";
    }

    @ResponseBody
    @RequestMapping(value = "save")
    public RetEntity save(Note note){
        RetEntity retEntity=new RetEntity();
        try {
            note.setOwner(UserUtils.getUser());
            systemService.saveNote(note);
            retEntity.setSuccess(true);
            retEntity.setData(note);
        }catch (Exception e){
            e.printStackTrace();
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
        }
        return retEntity;
    }

    @ResponseBody
    @RequestMapping(value = "delete")
    public RetEntity delete(Note note){
        RetEntity retEntity=new RetEntity();
        try {
            systemService.delNote(note);
            retEntity.setSuccess(true);
            retEntity.setData(note);
        }catch (Exception e){
            retEntity.setSuccess(false);
            retEntity.setMsg(e.getMessage());
            e.printStackTrace();
        }
        return retEntity;
    }
}
