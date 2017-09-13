<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>员工信息管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate();
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/wo/woEmployee/">员工信息列表</a></li>
		<li class="active"><a href="${ctx}/wo/woEmployee/form?id=${woEmployee.id}">员工信息<shiro:hasPermission name="wo:woEmployee:edit">${not empty woEmployee.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woEmployee:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="woEmployee" action="${ctx}/wo/woEmployee/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-sm-2 control-label">名称：</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">登陆名：</label>
			<div class="col-sm-3">
				<form:input path="loginName" htmlEscape="false" maxlength="200" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">密码：</label>
			<div class="col-sm-3">
				<form:input path="password" htmlEscape="false" maxlength="200" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属客户：</label>
			<div class="col-sm-3">
				<sys:tableselect  id="woClient" name="woClient.id" value="${woStation.woClient.id}" labelName="woClient.name" labelValue="${woStation.woClient.name}"
								  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属机构：</label>
			<div class="col-sm-3">
				<sys:treeselect id="company" name="company.id" value="${woEmployee.company.id}" labelName="company.name" labelValue="${woEmployee.company.name}"
								title="部门" url="/sys/office/treeData?type=1" cssClass="" allowClear="true" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属部门：</label>
			<div class="col-sm-3">
				<sys:treeselect id="office" name="office.id" value="${woEmployee.office.id}" labelName="office.name" labelValue="${woEmployee.office.name}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">邮箱：</label>
			<div class="col-sm-3">
				<form:input path="email" htmlEscape="false" maxlength="100" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">电话：</label>
			<div class="col-sm-3">
				<form:input path="phone" htmlEscape="false" maxlength="100" class="form-control "/>
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
				<shiro:hasPermission name="wo:woEmployee:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>

	</form:form>
</div>
</body>
</html>