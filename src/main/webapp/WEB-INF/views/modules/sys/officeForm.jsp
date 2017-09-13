<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>机构管理</title>
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
		<li><a href="${ctx}/sys/office/">机构列表</a></li>
		<li class="active"><a href="${ctx}/sys/office/form?id=${office.id}&parent.id=${office.parent.id}">机构<shiro:hasPermission name="sys:office:edit">${not empty office.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:office:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<div class="row">
	<div class="ibox">
	<form:form id="inputForm" modelAttribute="office" action="${ctx}/sys/office/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">上级机构:</label>
			<div class="col-sm-3">
                <sys:treeselect id="office" name="parent.id" value="${office.parent.id}" labelName="parent.name" labelValue="${office.parent.name}"
					title="机构" url="/sys/office/treeData" extId="${office.id}" cssClass=""/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属区域:</label>
			<div class="col-sm-3">
                <sys:treeselect id="area" name="area.id" value="${office.area.id}" labelName="area.name" labelValue="${office.area.name}"
					title="区域" url="/sys/area/treeData" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="name">机构名称:</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="code">机构编码:</label>
			<div class="col-sm-3">
				<form:input path="code" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="sort">排序:</label>
			<div class="col-sm-3">
				<form:input path="sort" type="number" cssClass="form-control required" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="type">机构类型:</label>
			<div class="col-sm-3">
				<form:select path="type" class="form-control chosen-select" tabindex="2">
					<form:options items="${fns:getDictList('sys_office_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="grade">机构级别:</label>
			<div class="col-sm-3">
				<form:select path="grade" class="form-control chosen-select">
					<form:options items="${fns:getDictList('sys_office_grade')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">是否可用:</label>
			<div class="col-sm-6">
				<form:select path="useable" cssClass="chosen-select" cssStyle="width: 80px">
					<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">主负责人:</label>
			<div class="col-sm-3">
				<sys:treeselect id="primaryPerson" name="primaryPerson.id" value="${office.primaryPerson.id}" labelName="office.primaryPerson.name" labelValue="${office.primaryPerson.name}"
								title="用户" url="/sys/office/treeData?type=3" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">副负责人:</label>
			<div class="col-sm-3">
				<sys:treeselect id="deputyPerson" name="deputyPerson.id" value="${office.deputyPerson.id}" labelName="office.deputyPerson.name" labelValue="${office.deputyPerson.name}"
								title="用户" url="/sys/office/treeData?type=3" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="address">联系地址:</label>
			<div class="col-sm-3">
				<form:input path="address" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="zipCode">邮政编码:</label>
			<div class="col-sm-3">
				<form:input path="zipCode" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="master">负责人:</label>
			<div class="col-sm-3">
				<form:input path="master" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="phone">电话:</label>
			<div class="col-sm-3">
				<form:input path="phone" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label" for="fax">传真:</label>
			<div class="col-sm-3">
				<form:input path="fax"  cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="email">邮箱:</label>
			<div class="col-sm-3">
				<form:input path="email" cssClass="form-control" htmlEscape="false" maxlength="50"/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label" for="remarks">备注:</label>
			<div class="col-sm-5">
				<form:textarea path="remarks" cssClass="form-control" htmlEscape="false" rows="4" maxlength="200" class="input-xlarge"/>
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