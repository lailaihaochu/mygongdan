<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>站点管理</title>
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
		<li class="active"><a href="${ctx}/wo/woStation/">站点列表</a></li>
		<shiro:hasPermission name="wo:woStation:edit"><li><a href="${ctx}/wo/woStation/form">站点添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="woStation" action="${ctx}/wo/woStation/" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<label>项目经理：</label>
			<sys:treeselect id="pm" name="pm.id" value="${woStation.pm.id}" labelName="pmName" labelValue="${woStation.pm.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-xxlarge required" allowClear="true" notAllowSelectParent="true"/>
			<label>站点名称：</label>
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control"/>
			&nbsp;&nbsp;
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>

	</form:form>
	<sys:message content="${message}"/>
	<div class="table-responsive">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>归属客户</th>
				<th>项目经理</th>
				<th>站点名称</th>
				<th>站点描述</th>
				<th>联系人</th>
				<th>联系电话</th>
				<th>邮箱</th>
				<th>地址</th>
				<th>交通费</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:woStation:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="woStation">
			<tr>
				<td>${woStation.woClient.name}</td>
				<td>${woStation.pm.name}</td>
				<td><a href="${ctx}/wo/woStation/form?id=${woStation.id}">
					${woStation.name}
				</a></td>
				<td><span title="${woStation.description}">${fns:abbr(woStation.description,10)}</span></td>
				<td>${woStation.contact}</td>
				<td>${woStation.contactTel}</td>
				<td>${woStation.email}</td>
				<td><span title="${woStation.addr}">${fns:abbr(woStation.addr,10)}</span></td>
				<td>${woStation.trafficFee}</td>
				<td>
					<span title="${woStation.remarks}">${fns:abbr(woStation.remarks,10)}</span>
				</td>
				<shiro:hasPermission name="wo:woStation:edit"><td>
    				<a href="${ctx}/wo/woStation/form?id=${woStation.id}">修改</a>
					<a href="${ctx}/wo/woStation/delete?id=${woStation.id}" onclick="return confirmx('确认要删除该站点吗？', this.href)">删除</a>
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