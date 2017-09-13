<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;">
<head>
  <title>数据选择</title>
  <%@include file="/WEB-INF/views/include/head.jsp" %>
  <script type="text/javascript">
    var selectedId,selectedLabel,usable="true", dblFunc;
    $(document).ready(function(){
      $("#dataTable tbody tr").dblclick(function(){
        selectedId=$(this).attr("code");
        selectedLabel=$(this).attr("codeLabel");
        var index=parent.layer.getFrameIndex(window.name);
        dblFunc(index,$("#layui-layer"+index,window.parent.document));
      });
      $("#dataTable tbody tr").click(function(){
        selectedId=$(this).attr("code");
        selectedLabel=$(this).attr("codeLabel");
        $(this).find("input[type=radio]").attr("checked",true);
      });
    });
    function page(n,s){
      $("#pageNo").val(n);
      $("#pageSize").val(s);
      $("#queryForm").attr("action","${ctx}/wo/woStation/tableSelect").submit();
      return false;
    }
  </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
  <form:form id="queryForm" modelAttribute="woStation" action="${ctx}/wo/woStation/tableSelect" method="post" class="well form-inline">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}"/>
    <div class="col-xs-5">
      <label class="col-xs-3 no-padding" style="padding-top:10px !important; ">名称：</label>
      <div class="col-xs-9 no-padding">
        <form:input id="nameFilter" path="name" htmlEscape="false" maxlength="50" class="form-control"/>
      </div>
    </div>
    <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
    <input class="btn btn-primary" type="button" value="重置" onclick="$('#nameFilter').val('');">
  </form:form>

  <table id="dataTable" class="table table-striped table-bordered table-condensed table-hover">
    <thead><tr><th>选择</th><th>区域</th><th>归属客户</th><th>站点名称</th><th>项目经理</th></tr><thead>
    <tbody>
    <c:forEach items="${page.list}" var="woStation">
      <tr   code="${woStation.id}" codeLabel="${woStation.name}">
        <td><input type="radio" name="invNo" class="radio"/></td>
        <td>${woStation.area.name}</td>
        <td>${woStation.woClient.name}</td>
        <td>${woStation.name}</td>
        <td>${woStation.pm.name}</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <div class="pagination">${page}</div>
</div>
</body>