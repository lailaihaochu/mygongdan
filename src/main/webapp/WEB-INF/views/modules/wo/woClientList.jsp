<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户信息管理</title>
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
<body >
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/wo/woClient/">客户信息列表</a></li>
		<shiro:hasPermission name="wo:woClient:edit"><li><a href="${ctx}/wo/woClient/form">客户信息添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="woClient" action="${ctx}/wo/woClient/" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>所属机构：</label>
		<sys:treeselect id="office" name="office.id" value="${woClient.office.id}" labelName="office.name" labelValue="${woClient.office.name}"
						title="部门" url="/sys/office/treeData?type=2" cssClass="required" allowClear="true" />
		<label>客户简称：</label>
		<form:input path="name" htmlEscape="false" maxlength="200" class="form-control"/>
		<br/><br/>
		<label>客户全称：</label>
		<form:input path="fullName" htmlEscape="false" maxlength="200" class="form-control"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<label>客户代码：</label>
		<form:input path="code" htmlEscape="false" maxlength="100" class="form-control "/>
		&nbsp;&nbsp;
		<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>归属机构</th>
				<th>客户简称</th>
				<th>客户全称</th>
				<th>客户代码</th>
				<th>修改时间</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:woClient:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="woClient">
			<tr>
				<td>${woClient.office.name}</td>
				<td><a href="${ctx}/wo/woClient/form?id=${woClient.id}">
					${woClient.name}
				</a></td>
				<td><span title="${woClient.fullName}">
					${fns:abbr(woClient.fullName,50)}
				</span></td>
				<td>${woClient.code}</td>
				<td>
					<fmt:formatDate value="${woClient.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${woClient.remarks}
				</td>
				<shiro:hasPermission name="wo:woClient:edit"><td>
    				<a href="${ctx}/wo/woClient/form?id=${woClient.id}">修改</a>
					<a href="${ctx}/wo/woClient/delete?id=${woClient.id}" onclick="return confirmx('确认要删除该客户信息吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>

	</div>
</body>
</html>