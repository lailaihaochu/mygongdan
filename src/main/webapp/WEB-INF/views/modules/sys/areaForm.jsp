<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>区域管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>

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
		<li><a href="${ctx}/sys/area/">区域列表</a></li>
		<li class="active"><a href="${ctx}/sys/area/form?id=${area.id}&parent.id=${area.parent.id}">区域<shiro:hasPermission name="sys:area:edit">${not empty area.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:area:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="row">
	<div class="ibox">
	<form:form id="inputForm" modelAttribute="area" action="${ctx}/sys/area/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">上级区域:</label>
			<div class="col-sm-3">
                <sys:treeselect id="office" name="parent.id" value="${area.parent.id}" labelName="parent.name" labelValue="${area.parent.name}"
					title="区域" url="/sys/area/treeData" extId="${area.id}" cssClass="required"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="name">区域名称:</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="code">区域编码:</label>
			<div class="col-sm-3">
				<form:input path="code" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="type">区域类型:</label>
			<div class="col-sm-3">
				<form:select path="type" class="form-control chosen-select" tabindex="2">
					<form:options items="${fns:getDictList('sys_area_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="remarks">备注:</label>
			<div class="col-sm-3">
				<form:textarea path="remarks" cssClass="form-control" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
			</div>
		</div>
		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="sys:area:edit">
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
				</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>

	</form:form>
		</div>
	</div>
</div>
</body>
</html>