<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>任务指派</title>
  <%@include file="/WEB-INF/views/include/head.jsp"%>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
  <ul class="nav nav-tabs">
    <li><shiro:hasPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/${woWorksheet.self?"self":""}"></shiro:hasPermission><shiro:lacksPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/self"></shiro:lacksPermission>工单列表</a></li>
    <li class="active"><a href="${ctx}/wo/woWorksheet/assign?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}">人员指派</a></li>
  </ul>
  <div class="well">
    <div class="row">
      <div class="col-sm-5">
        <dl class="dl-horizontal no-margins">
          <dt>工单：</dt>
          <dd>${woWorksheet.woNo}</dd>
          <dt>WO号：</dt>
          <dd>${woWorksheet.snNo}</dd>
          <dt>项目经理：</dt>
          <dd>${woWorksheet.woStation.pm.name}</dd>
          <dt>客户：</dt>
          <dd>${woWorksheet.woClient.name}</dd>
          <dt>类型：</dt>
          <dd>${fns:getDictLabel(woWorksheet.woType,'worksheet_type','')}</dd>

        </dl>
      </div>
      <div class="col-sm-7" id="cluster_info">
        <dl class="dl-horizontal no-margins">
          <dt>状态：</dt>
          <dd>${fns:getDictLabel(woWorksheet.woStatus,'worksheet_status','')}</dd>
          <dt>紧急度：</dt>
          <dd>${fns:getDictLabel(woWorksheet.emGrade,'worksheet_emgrade','' )}</dd>
          <c:if test="${woWorksheet.woType ==1}">
          <dt>巡检模拟开始时间：</dt>
          <dd><fmt:formatDate value="${woWorksheet.advanceTime}" pattern="yyyy年MM月dd日 HH:mm:ss"/>
          </dd>
          </c:if>
          <dt>最后更新：</dt>
          <dd><fmt:formatDate value="${woWorksheet.updateDate}" pattern="yyyy年MM月dd日 HH:mm:ss"/> </dd>
          <dt>创建于：</dt>
          <dd><fmt:formatDate value="${woWorksheet.createDate}" pattern="yyyy年MM月dd日 HH:mm:ss"/></dd>
        </dl>
      </div>
    </div>
  </div>
  <sys:message content="${message}"/>
  <div class="breadcrumb">
    <form id="assignWorksheetForm" action="" method="post" class="hide"></form>
    <a id="assignButton" href="javascript:" class="btn btn-primary">分配人员</a>
    <a class="btn btn-default" href="${ctx}/wo/woWorksheet/detail?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}">返回</a>
    <script type="text/javascript">
      $("#assignButton").click(function(){
        top.layer.open({
          type:2,
          content:"${ctx}/wo/woWorksheet/usertoWorksheet?id=${woWorksheet.id}",
          title:"分配人员",
          area:[$(document).width()-20+"px",$(top.document).height()-240+"px"],
          btn: ["确定分配","关闭","清除已选"],
          bottomText:"通过选择部门，然后为列出的人员分配工单。",
          yes:function(index, layero){
            var pre_ids = layero.find("iframe")[0].contentWindow.pre_ids;
            var ids = layero.find("iframe")[0].contentWindow.ids;
            //nodes = selectedTree.getSelectedNodes();
            // 删除''的元素
            if(ids[0]==''){
              ids.shift();
              pre_ids.shift();
            }
            if(pre_ids.sort().toString() == ids.sort().toString()){
              showTip("未给工单【${woWorksheet.woNo}】分配新人员！", 'info');
              return;
            };
            // 执行保存
            loading('正在提交，请稍等...');
            var idsArr = "";
            for (var i = 0; i<ids.length; i++) {
              idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
            }
            $('#assignWorksheetForm').attr('action','${ctx}/wo/woWorksheet/assignWorksheet?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}&idsArr='+idsArr).submit();
            top.layer.close(index);
          },
          cancel:function(){

          },
          btn3:function(index, layero){
            layero.find("iframe")[0].contentWindow.clearAssign();
          },
          success:function(layero, index){

          }
        });
      });
    </script>
  </div>
  <table id="contentTable" class="table table-striped table-bordered table-condensed">
    <thead><tr><th>归属公司</th><th>归属部门</th><th>登录名</th><th>姓名</th><th>电话</th><th>手机</th><shiro:hasPermission name="wo:woWorksheet:edit"><th>操作</th></shiro:hasPermission></tr></thead>
    <tbody>
    <c:forEach items="${userList}" var="user">
      <tr>
        <td>${user.company.name}</td>
        <td>${user.office.name}</td>
        <td><a href="${ctx}/sys/user/form?id=${user.id}">${user.loginName}</a></td>
        <td>${user.name}</td>
        <td>${user.phone}</td>
        <td>${user.mobile}</td>
        <shiro:hasPermission name="wo:woWorksheet:assign"><td>
          <a href="${ctx}/wo/woWorksheet/outWorksheet?userId=${user.id}${woWorksheet.self?"&self=true":""}&worksheetId=${woWorksheet.id}"
             onclick="return confirmx('确认要将用户<b>[${user.name}]</b>从<b>[${woWorksheet.woNo}]</b>工单中移除吗？', this.href)">移除</a>
        </td></shiro:hasPermission>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>
</body>
</html>