<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>个人信息</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#inputForm").validate();
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
    <ul class="nav nav-tabs">
        <li class="active"><a href="${ctx}/sys/user/info">个人信息</a></li>
    </ul><br/>
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/info" method="post" class="form-horizontal"><%--
		<form:hidden path="email" htmlEscape="false" maxlength="255" class="input-xlarge"/>
		<sys:ckfinder input="email" type="files" uploadPath="/mytask" selectMultiple="false"/> --%>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">头像:</label>
			<div class="col-sm-3">
				<form:hidden id="nameImage" path="photo" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="nameImage" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属公司:</label>
			<div class="col-sm-3">
				<label class="lbl">${user.company.name}</label>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属部门:</label>
			<div class="col-sm-3">
				<label class="lbl">${user.office.name}</label>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">姓名:</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="50" class="required form-control" readonly="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">邮箱:</label>
			<div class="col-sm-3">
				<form:input path="email" htmlEscape="false" maxlength="50" class="email form-control"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">电话:</label>
			<div class="col-sm-3">
				<form:input path="phone" htmlEscape="false" maxlength="50" cssClass="form-control"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">手机:</label>
			<div class="col-sm-3">
				<form:input path="mobile" htmlEscape="false" maxlength="50" cssClass="form-control"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">备注:</label>
			<div class="col-sm-4">
				<form:textarea path="remarks" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge form-control"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">用户类型:</label>
			<div class="col-sm-3">
				<label class="lbl">${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</label>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">用户角色:</label>
			<div class="col-sm-6">
				<label class="lbl">${user.roleNames}</label>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">上次登录:</label>
			<div class="col-sm-6">
				<label class="lbl">IP: ${user.oldLoginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.oldLoginDate}" type="both" dateStyle="full"/></label>
			</div>
		</div>
        <div class="hr-line-dashed"></div>
        <div class="form-group">
            <div class="col-sm-4 col-sm-offset-2">
                <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
            </div>
        </div>
	</form:form>
</div>	
</body>
</html>