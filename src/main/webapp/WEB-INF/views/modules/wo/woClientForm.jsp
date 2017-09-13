<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户信息管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#fullName").focus();
			$("#inputForm").validate();
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/wo/woClient/">客户信息列表</a></li>
		<li class="active"><a href="${ctx}/wo/woClient/form?id=${woClient.id}">客户信息<shiro:hasPermission name="wo:woClient:edit">${not empty woClient.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woClient:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="woClient" action="${ctx}/wo/woClient/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">全称：</label>
			<div class="col-sm-3">
				<form:input path="fullName" htmlEscape="false" maxlength="200" class="form-control required "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">简称：</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control required "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">代码：</label>
			<div class="col-sm-3">
				<form:input path="code" htmlEscape="false" maxlength="100" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属机构：</label>
			<div class="col-sm-3">
				<sys:treeselect id="office" name="office.id" value="${woClient.office.id}" labelName="office.name" labelValue="${woClient.office.name}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="required" allowClear="true" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">备注：</label>
			<div class="col-sm-3">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="wo:woClient:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>

	</form:form>
</div>
</body>
</html>