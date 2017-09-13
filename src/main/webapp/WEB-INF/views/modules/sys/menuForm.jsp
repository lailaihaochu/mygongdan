<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>菜单管理</title>
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
		<li><a href="${ctx}/sys/menu/">菜单列表</a></li>
		<li class="active"><a href="${ctx}/sys/menu/form?id=${menu.id}&parent.id=${menu.parent.id}">菜单<shiro:hasPermission name="sys:menu:edit">${not empty menu.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:menu:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="row">
	<div class="ibox">
	<form:form id="inputForm" modelAttribute="menu" action="${ctx}/sys/menu/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">上级菜单:</label>
			<div class="col-sm-3">
                <sys:treeselect id="menu" name="parent.id" value="${menu.parent.id}" labelName="parent.name" labelValue="${menu.parent.name}"
					title="菜单" url="/sys/menu/treeData" extId="${office.id}" cssClass="required"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="name">名称:</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="href">连接:</label>
			<div class="col-sm-3">
				<form:input path="href" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="target">目标:</label>
			<div class="col-sm-3">
				<form:input path="target" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="icon">图标:</label>
			<div class="col-sm-3">
				<sys:iconselect id="icon" name="icon" value="${menu.icon}"></sys:iconselect>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="sort">排序:</label>
			<div class="col-sm-3">
				<form:input path="sort" type="number" cssClass="form-control required" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="isShow">可见:</label>
			<div class="col-sm-3" style="padding: 6px 15px 0px 15px;">
				<form:radiobuttons path="isShow" items="${fns:getDictList('show_hide')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="permission">权限标识:</label>
			<div class="col-sm-3">
				<form:input path="permission" cssClass="form-control" htmlEscape="false" maxlength="100"/>
			</div>
		</div>
		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="sys:office:edit">
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