<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户区域管理</title>
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
		<li><a href="${ctx}/wo/clientArea/">客户区域列表</a></li>
		<li class="active"><a href="${ctx}/wo/clientArea/form?id=${clientArea.id}&parent.id=${clientArea.parent.id}">客户区域<shiro:hasPermission name="wo:clientArea:edit">${not empty clientArea.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:clientArea:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="clientArea" action="${ctx}/wo/clientArea/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属客户：</label>
			<div class="col-sm-3">
				<sys:tableselect  id="woClient" name="woClient.id" value="${clientArea.woClient.id}" labelName="woClient.name" labelValue="${clientArea.woClient.name}"
								  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">上级区域:</label>
			<div class="col-sm-3">
				<sys:treeselect id="parent" name="parent.id" value="${clientArea.parent.id}" labelName="parent.name" labelValue="${clientArea.parent.name}"
					title="上级区域" url="/wo/clientArea/treeData" extId="${clientArea.id}" cssClass="" allowClear="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">区域名称：</label>
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
				<shiro:hasPermission name="wo:clientArea:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
	</div>
</body>
</html>