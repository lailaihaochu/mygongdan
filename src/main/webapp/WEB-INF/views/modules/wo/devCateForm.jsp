<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>设备类型管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate();
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/wo/devCategory/">设备类型列表</a></li>
		<li class="active"><a href="${ctx}/wo/devCategory/form?id=${deviceCategory.id}&parent.id=${deviceCategory.parent.id}">设备类型<shiro:hasPermission name="wo:devCate:edit">${not empty deviceCategory.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:devCate:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="deviceCategory" action="${ctx}/wo/devCategory/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">上级类目:</label>
			<div class="col-sm-3">
				<sys:treeselect id="parent" name="parent.id" value="${deviceCategory.parent.id}" labelName="parent.name" labelValue="${deviceCategory.parent.name}"
					title="上级区域" url="/wo/devCategory/treeData" extId="${deviceCategory.id}" cssClass="" allowClear="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">名称：</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">描述：</label>
			<div class="col-sm-3">
				<form:textarea path="description" htmlEscape="false" rows="4" maxlength="1000" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">排序：</label>
			<div class="col-sm-3">
				<form:input path="sort" htmlEscape="false" maxlength="11" class="form-control "/>
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
				<shiro:hasPermission name="wo:devCate:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
	</div>
</body>
</html>