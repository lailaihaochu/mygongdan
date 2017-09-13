<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;">
<head>
  <title>数据选择</title>
  <%@include file="/WEB-INF/views/include/head.jsp" %>
  <script type="text/javascript">
    var selectedId,selectedLabel,selectedPhone,selectedEmail,usable="true", dblFunc;
    $(document).ready(function(){
      $("#dataTable tbody tr").dblclick(function(){
        selectedId=$(this).attr("code");
        selectedLabel=$(this).attr("codeLabel");
        selectedPhone=$(this).attr("phone");
        selectedEmail=$(this).attr("email");
        var index=parent.layer.getFrameIndex(window.name);
        dblFunc(index,$("#layui-layer"+index,window.parent.document));
      });
      $("#dataTable tbody tr").click(function(){
        selectedId=$(this).attr("code");
        selectedLabel=$(this).attr("codeLabel");
        selectedPhone=$(this).attr("phone");
        selectedEmail=$(this).attr("email");
        $(this).find("input[type=radio]").attr("checked",true);
      });
    });
    function page(n,s){
      $("#pageNo").val(n);
      $("#pageSize").val(s);
      $("#queryForm").attr("action","${ctx}/sys/user/tableSelect").submit();
      return false;
    }
  </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
  <form:form id="queryForm" modelAttribute="user" action="${ctx}/sys/user/tableSelect" method="post" class="well form-inline">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}"/>
    <div class="col-xs-5">
      <label class="col-xs-3 no-padding" style="padding-top:10px !important; ">名称：</label>
      <div class="col-xs-9 no-padding">
        <form:input path="name" htmlEscape="false" maxlength="50" class="form-control"/>
      </div>
    </div>
    <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
  </form:form>

  <table id="dataTable" class="table table-striped table-bordered table-condensed table-hover">
    <thead><tr><th>选择</th><th>公司</th><th>部门</th><th>员工名称</th><th>联系电话</th><th>邮箱</th></tr><thead>
    <tbody>
    <c:forEach items="${page.list}" var="user">
      <tr   code="${user.id}" codeLabel="${user.name}" phone="${user.phone}" email="${user.email}">
        <td><input type="radio" name="userId" class="radio"/></td>
        <td>${user.company.name}</td>
        <td>${user.office.name}</td>
        <td>${user.name}</td>
        <td>${user.phone}</td>
        <td>${user.email}</td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
  <div class="pagination">${page}</div>
</div>
</body>