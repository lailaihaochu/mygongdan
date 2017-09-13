<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;">
<head>
  <title>数据选择</title>
  <%@include file="/WEB-INF/views/include/head.jsp" %>
  <script type="text/javascript">
    var selectedId,usable="true", dblFunc;
    $(document).ready(function(){
      $("#contentTable tbody tr").dblclick(function(){
        selectedId=$(this).attr("code");
        var index=parent.layer.getFrameIndex(window.name);

        dblFunc(index,$("#layui-layer"+index,window.parent.document));
      });
      $("#contentTable tbody tr").click(function(){
        selectedId=$(this).attr("code");
        $(this).find("input[type=radio]").attr("checked",true);
      });
    });
    function page(n,s){
      $("#pageNo").val(n);
      $("#pageSize").val(s);
      $("#queryForm").attr("action","${ctx}/wo/woTemplate/tableSelect").submit();
      return false;
    }
  </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
  <form:form id="searchForm" modelAttribute="woTemplate" action="${ctx}/wo/woTemplate/" method="post" class="form-inline well">
    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
    <input type="hidden" name="type" value="0"/>
    <div class="col-xs-5">
      <form:input path="name" htmlEscape="false" maxlength="200" class="form-control"/>

    </div>

    &nbsp;&nbsp;
    <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
  </form:form>
  <sys:message content="${message}"/>

    <table id="contentTable" class="table table-striped table-bordered table-condensed">
      <thead>
      <tr>
        <th>选择</th>
        <th>模板名称</th>
        <th>创建人</th>
        <th>创建时间</th>
        <th>备注</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${page.list}" var="woTemplate">
        <tr   code="${woTemplate.id}">
          <td><input type="radio" name="invNo" class="radio"/></td>
          <td>${woTemplate.name}</td>
          <td>${woTemplate.createBy.name}</td>
          <td><fmt:formatDate value="${woTemplate.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>

          <td>
              ${woTemplate.remarks}
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
    <div class="pagination">${page}</div>
</div>
</body>