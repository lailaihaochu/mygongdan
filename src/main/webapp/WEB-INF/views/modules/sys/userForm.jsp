<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#loginName").focus();
			$("#inputForm").validate({
				rules: {
					loginName: {remote: "${ctx}/sys/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.loginName}')}
				},
				messages: {
					loginName: {remote: "用户登录名已存在"},
					confirmNewPassword: {equalTo: "输入与上面相同的密码"}
				}
			});
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/user/">用户列表</a></li>
		<li class="active"><a href="${ctx}/sys/user/form?id=${user.id}">用户<shiro:hasPermission name="sys:user:edit">${not empty user.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:user:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="row">
		<div class="ibox">
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">头像:</label>
			<div class="col-sm-3">
				<form:hidden id="nameImage" path="photo" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="nameImage" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="company">归属公司:</label>
			<div class="col-sm-3">
                <sys:treeselect id="company" name="company.id" value="${user.company.id}" labelName="company.name" labelValue="${user.company.name}"
					title="公司" url="/sys/office/treeData?type=1" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="office">归属部门:</label>
			<div class="col-sm-3">
                <sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}"
					title="部门" url="/sys/office/treeData?type=2" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="oldLoginName">登录名:</label>
			<div class="col-sm-3">
				<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
				<form:input path="loginName" htmlEscape="false" maxlength="50" class="required userName form-control"/>
			</div>
		</div>
		<%--<div class="form-group">
			<label class="col-sm-2 control-label" for="no">工号:</label>
			<div class="col-sm-3">
				<form:input path="no" htmlEscape="false" maxlength="50" class="required form-control"/>
			</div>
		</div>--%>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="name">姓名:</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="50" class="required form-control"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="newPassword">密码:</label>
			<div class="col-sm-3">
				<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" class="${empty user.id?'required':''} form-control"/>
				<c:if test="${not empty user.id}"><span class="help-inline"><i class="fa fa-info-circle"></i>若不修改密码，请留空。</span></c:if>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="confirmNewPassword">确认密码:</label>
			<div class="col-sm-3">
				<input id="confirmNewPassword" name="confirmNewPassword" type="password" class="form-control" value="" maxlength="50" minlength="3" equalTo="#newPassword"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="email">邮箱:</label>
			<div class="col-sm-3">
				<form:input path="email" htmlEscape="false" cssClass="email form-control" maxlength="100" class="email"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="phone">电话:</label>
			<div class="col-sm-3">
				<form:input path="phone" htmlEscape="false" cssClass="simplePhone form-control" maxlength="100"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="mobile">手机:</label>
			<div class="col-sm-3">
				<form:input path="mobile" cssClass="mobile form-control" htmlEscape="false" maxlength="100"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">是否允许登录:</label>
			<div class="col-sm-3">
				<form:select path="loginFlag" cssClass="chosen-select" cssStyle="width:80px;">
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<br/>
				<span class="help-inline"><i class="fa fa-info-circle"></i> “是”代表此账号允许登录，“否”则表示此账号不允许登录</span>
			</div>
		</div>
<%--
		<div class="form-group">
			<label class="col-sm-2 control-label" for="userType">用户类型:</label>
			<div class="col-sm-3">
				<form:select path="userType" cssClass="form-control chosen-select">
					<form:option value="" label="请选择"/>
					<form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>--%>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="roleIdList">用户角色:</label>
			<div style="padding: 6px 15px 0px 15px;">
				<form:checkboxes path="roleIdList" items="${allRoles}" itemLabel="name" itemValue="id" htmlEscape="false" class="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="remarks">备注:</label>
			<div class="col-sm-3">
				<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge form-control"/>
			</div>
		</div>
		<c:if test="${not empty user.id}">
			<div class="form-group">
				<label class="col-sm-2 control-label">创建时间:</label>
				<div style="padding: 6px 15px 0px 15px;">
					<label class="lbl"><fmt:formatDate value="${user.createDate}" type="both" dateStyle="full"/></label>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">最后登陆:</label>
				<div style="padding: 6px 15px 0px 15px;">
					<label class="lbl">IP: ${user.loginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.loginDate}" type="both" dateStyle="full"/></label>
				</div>
			</div>
		</c:if>

		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="sys:user:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
	</div>
</body>
</html>