<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>站点下节点管理</title>
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
		<li><a href="${ctx}/wo/devPosition/">设备位置列表</a></li>
		<li class="active"><a href="${ctx}/wo/devPosition/form?id=${devPosition.id}&parent.id=${devPosition.parent.id}">设备位置<shiro:hasPermission name="wo:devPosition:edit">${not empty devPosition.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:devPosition:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="devPosition" action="${ctx}/wo/devPosition/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属站点：</label>
			<div class="col-sm-3">
				<sys:tableselect  id="woStation" name="woStation.id" value="${devPosition.woStation.id}" labelName="woStation.name" labelValue="${devPosition.woStation.name}"
								  url="${ctx}/wo/woStation/tableSelect?id=" paramEle="Id" title="选择站点" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">上级位置:</label>
			<div class="col-sm-3">
				<sys:treeselect id="parent" name="parent.id" value="${devPosition.parent.id}" labelName="parent.name" labelValue="${devPosition.parent.name}"
					title="上级区域" url="/wo/devPosition/treeData" extId="${devPosition.id}" cssClass="" allowClear="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">位置名称：</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control "/>
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
				<shiro:hasPermission name="wo:devPosition:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
	</div>
</body>
</html>