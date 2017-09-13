<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>员工信息管理</title>
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
		<li class="active"><a href="${ctx}/wo/woEmployee/">员工信息列表</a></li>
		<shiro:hasPermission name="wo:woEmployee:edit"><li><a href="${ctx}/wo/woEmployee/form">员工信息添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="woEmployee" action="${ctx}/wo/woEmployee/" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label>归属客户：</label>
		<sys:tableselect  id="woClient" name="woClient.id" value="${woStation.woClient.id}" labelName="woClient.name" labelValue="${woStation.woClient.name}"
						  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
		<label>归属部门：</label>
		<sys:treeselect id="office" name="office.id" value="${woEmployee.office.id}" labelName="office.name" labelValue="${woEmployee.office.name}"
						title="部门" url="/sys/office/treeData?type=2" cssClass="" allowClear="true" notAllowSelectParent="true"/>
		<br/><br/><label>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：</label>
		<form:input path="name" htmlEscape="false" maxlength="200" class="form-control"/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label>手&nbsp;机&nbsp;号：</label>
		<form:input path="phone" htmlEscape="false" maxlength="200" class="form-control"/>
			&nbsp;&nbsp;
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>

	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>归属机构</th>
				<th>归属部门</th>
				<th>名称</th>
				<th>登陆名</th>
				<th>归属客户</th>
				<th>邮箱</th>
				<th>电话</th>
				<th>修改时间</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:woEmployee:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="woEmployee">
			<tr>
				<td>
						${woEmployee.company.name}
				</td>
				<td>
						${woEmployee.office.name}
				</td>
				<td><a href="${ctx}/wo/woEmployee/form?id=${woEmployee.id}">
					${woEmployee.name}
				</a></td>
				<td>
					${woEmployee.loginName}
				</td>
				<td>
					${woEmployee.woClient.name}
				</td>

				<td>
					${woEmployee.email}
				</td>
				<td>
					${woEmployee.phone}
				</td>
				<td>
					<fmt:formatDate value="${woEmployee.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					${woEmployee.remarks}
				</td>
				<shiro:hasPermission name="wo:woEmployee:edit"><td>
    				<a href="${ctx}/wo/woEmployee/form?id=${woEmployee.id}">修改</a>
					<a href="${ctx}/wo/woEmployee/delete?id=${woEmployee.id}" onclick="return confirmx('确认要删除该员工信息吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>

	</div>
</body>
</html>