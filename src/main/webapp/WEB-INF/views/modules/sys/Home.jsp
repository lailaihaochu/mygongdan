<%--
  Created by IntelliJ IDEA.
  User: Jianghui
  Date: 2016/9/14
  Time: 16:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>首页</title>
  <%@include file="/WEB-INF/views/include/head.jsp"%>
  <script>
    function addNote(){
      layer.open({
        type:1,
        title:"添加标签",
        content:$("#box").html(),
        area:["400px","300px"],
        btn:["保存","关闭"],
        yes:function(index,layero){
          $.ajax({
            url:"${ctx}/home/save",
            type:"POST",
            data:{remindDate:$("#remindDate",layero).val(),title:$("#title",layero).val(),
              content:$("#content",layero).val()},
            beforeSend:function(){
              loading();
            },
            success:function(data){
              if(data.success){
                showTip("添加成功！");
              }else{
                showTip("操作失败！");
              }
              layer.close(index);
              window.location.href="${ctx}/home";
            },
            complete:function(){
              top.layer.close(top.mask);
            }
          });
        }
      });
    }
    function modifyNote(ele){

      layer.open({
        type:1,
        title:"修改标签",
        content:$("#box").html(),
        area:["400px","300px"],
        btn:["保存","关闭"],
        yes:function(index,layero){
          $.ajax({
            url:"${ctx}/home/save",
            type:"POST",
            data:{remindDate:$("#remindDate",layero).val(),title:$("#title",layero).val(),
              content:$("#content",layero).val(),id:$(ele).parents("li").attr("id")},
            beforeSend:function(){
              loading();
            },
            success:function(data){
              if(data.success){
                showTip("修改成功！");
              }else{
                showTip("操作失败！");
              }
              layer.close(index);
              window.location.href="${ctx}/home";
            },
            complete:function(){
              top.layer.close(top.mask);
            }
          });
        },
        success:function(layero,index){
          $("#remindDate",layero).val($(ele).siblings("input[name='remindDate']").val());
          $("#title",layero).val($(ele).siblings("input[name='title']").val());
          $("#content",layero).val($(ele).siblings("input[name='content']").val());
        }
      });
    }
    function delNote(ele){
      confirmx("确定要删除该标签吗？",function(){
        $.ajax({
          url:"${ctx}/home/delete",
          type:"GET",
          data:{id:$(ele).parents("li").attr("id")},
          dataType:"json",
          beforeSend:function(){
            loading();
          },
          success:function(data){
            if(data.success){
              showTip("删除成功！","",2000,2000);
            }else{
              showTip("操作失败！","",2000,2000);
            }
            window.location.href="${ctx}/home";
          },
          complete:function(){
            top.layer.close(top.mask);
          }
        });
      });

    }
  </script>
</head>
<body>
<div id="box" class="hide">
    <div id="contentForm" style="text-align:center; width: 100%; padding-left: 30px;padding-top: 12px;"  >
      <label style="float:left;padding-left: 10px;" > 时间：</label><div class="col-xs-9 no-padding"><input id="remindDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate" value="" pattern="yyyy-MM-dd HH:mm:ss" onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/></div><br/><br/>
      <label style="float:left;padding-left: 10px;">标题：</label><div class="col-xs-9 no-padding"><input id="title" type="text" class="form-control"></div><br/><br/>
      <label style="float:left;padding-left: 10px;">内容：</label><div class="col-xs-9 no-padding"><textarea id="content"  class="form-control" rows="4"></textarea></div>
    </div>

</div>
<div class="row">
  <div class="col-sm-12">
    <div class="wrapper wrapper-content animated fadeInUp">
      <ul class="notes">
        <c:forEach items="${notes}" var="note">
        <li id="${note.id}">
          <div>
            <input type="hidden" name="remindDate" value="<fmt:formatDate value="${note.remindDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"/>
            <input type="hidden" name="title" value="${note.title}"/>
            <input type="hidden" name="content" value="${note.content}"/>
            <small><fmt:formatDate value="${note.remindDate}" pattern="yyyy年MM月dd日 a hh:mm"/> </small>
            <h4>${note.title}</h4>
            <p>
              ${note.content}
            </p>
            <a href="javascript:void(0);" onclick="modifyNote(this)" style="right:25px"><i class="fa fa-pencil"></i></a><a href="javascript:void(0);" onclick="delNote(this)"><i class="fa fa-trash-o "></i></a>
          </div>
        </li>
        </c:forEach>
      </ul>

    </div>
  </div>
</div>
<div  style="position:fixed;bottom:50px;right:26px;z-index:100">
  <a style=" font-size:16px; height:38px;width:38px;display:block;background:#1ab394;padding:9px 8px;text-align:center;color:#fff;border-radius:50%"
       href="javascript:void(0);" onclick="addNote()"   >
    <i style="margin-top: 2px;" class="fa fa-plus"></i>
  </a>
</div>
</body>
</html>
