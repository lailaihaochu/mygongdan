<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>模板管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/wo/woTemplate/">模板列表</a></li>
		<shiro:hasPermission name="wo:woTemplate:edit"><li><a href="${ctx}/wo/woTemplate/form">模板添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="woTemplate" action="${ctx}/wo/woTemplate/" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input type="hidden" name="type" value="0"/>
		<form:input path="name" htmlEscape="false" maxlength="200" class="form-control"/>
		&nbsp;&nbsp;
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
	</form:form>
	<sys:message content="${message}"/>
	<div class="table-responsive">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>模板名称</th>
				<th>创建人</th>
				<th>创建时间</th>
				<th>修改人</th>
				<th>修改时间</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:woTemplate:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="woTemplate">
			<tr>
				<td><a href="${ctx}/wo/woTemplate/form?id=${woTemplate.id}">${woTemplate.name}</a></td>
				<td>${woTemplate.createBy.name}</td>
				<td><fmt:formatDate value="${woTemplate.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<td>${woTemplate.updateBy.name}</td>
				<td><fmt:formatDate value="${woTemplate.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				<td>
					${woTemplate.remarks}
				</td>
				<shiro:hasPermission name="wo:woTemplate:edit"><td>
					<a href="${ctx}/wo/woTemplate/form?id=${woTemplate.id}">修改</a>
					<a href="${ctx}/wo/woTemplate/delete?id=${woTemplate.id}" onclick="return confirmx('确认要删除该模板吗？', this.href)">删除</a>

				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div>
	</div>
</body>
</html>