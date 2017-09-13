<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同信息管理</title>
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
		<li class="active"><a href="${ctx}/wo/woContract/">合同信息列表</a></li>
		<shiro:hasPermission name="wo:woContract:edit"><li><a href="${ctx}/wo/woContract/form">合同信息添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="woContract" action="${ctx}/wo/woContract/" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<input name="projectName" value="${woContract.projectName}" class="form-control"/>
		&nbsp;&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>合同编号</th>
				<th>项目名称</th>
				<th>甲方</th>
				<th>乙方</th>
				<th>状态</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:woContract:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="woContract">
			<tr>
				<td><a href="${ctx}/wo/woContract/form?id=${woContract.id}">
					${woContract.contractNo}
				</a></td>
				<td>
					${woContract.projectName}
				</td>
				<td>${woContract.partA.name}</td>
				<td>${woContract.partB.name}</td>
				<td>${fns:getDictLabel(woContract.contractStatus,'contract_status','')}</td>
				<td>
					${woContract.remarks}
				</td>
				<shiro:hasPermission name="wo:woContract:edit"><td>
    				<a href="${ctx}/wo/woContract/form?id=${woContract.id}"><c:if test="${woContract.contractStatus eq '1'}">查看</c:if><c:if test="${woContract.contractStatus ne '1'}">修改</c:if></a>
					<a href="${ctx}/wo/woContract/delete?id=${woContract.id}" onclick="return confirmx('确认要删除该合同信息吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div>
</body>
</html>