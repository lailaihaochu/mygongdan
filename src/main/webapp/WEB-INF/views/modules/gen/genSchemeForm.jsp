<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>生成方案管理</title>
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
		<li><a href="${ctx}/gen/genScheme/">生成方案列表</a></li>
		<li class="active"><a href="${ctx}/gen/genScheme/form?id=${genScheme.id}">生成方案<shiro:hasPermission name="gen:genScheme:edit">${not empty genScheme.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="gen:genScheme:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="genScheme" action="${ctx}/gen/genScheme/save" method="post" class="form-horizontal">
		<form:hidden path="id"/><form:hidden path="flag"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">方案名称:</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">模板分类:</label>
			<div class="col-sm-4">
				<form:select path="category" class="required chosen-select">
					<form:options items="${config.categoryList}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<br/>
				<span class="help-inline">
					生成结构：{包名}/{模块名}/{分层(dao,entity,service,web)}/{子模块名}/{java类}
				</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成包路径:</label>
			<div class="col-sm-3">
				<form:input path="packageName" htmlEscape="false" maxlength="500" class="required form-control"/>
				<span class="help-inline">建议模块包：com.jingbang.gongdan.modules</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成模块名:</label>
			<div class="col-sm-2">
				<form:input path="moduleName" htmlEscape="false" maxlength="500" class="required form-control"/>
				<br/>
				<span class="help-inline">可理解为子系统名，例如 sys</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成子模块名:</label>
			<div class="col-sm-3">
				<form:input path="subModuleName" htmlEscape="false" maxlength="500" class="form-control"/>
				<br/>
				<span class="help-inline">可选，分层下的文件夹，例如 </span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成功能描述:</label>
			<div class="col-sm-3">
				<form:input path="functionName" htmlEscape="false" maxlength="500" class="required form-control"/>
				<br/>
				<span class="help-inline">将设置到类描述</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成功能名:</label>
			<div class="col-sm-3">
				<form:input path="functionNameSimple" htmlEscape="false" maxlength="500" class="required form-control"/>
				<br/>
				<span class="help-inline">用作功能提示，如：保存“某某”成功</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成功能作者:</label>
			<div class="col-sm-3">
				<form:input path="functionAuthor" htmlEscape="false" maxlength="500" class="required form-control"/>
				<br/>
				<span class="help-inline">功能开发者</span>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">业务表名:</label>
			<div class="col-sm-3">
				<form:select path="genTable.id" class="required chosen-select">
					<form:options items="${tableList}" itemLabel="nameAndComments" itemValue="id" htmlEscape="false"/>
				</form:select>
				<br/>
				<span class="help-inline">生成的数据表，一对多情况下请选择主表。</span>
			</div>
		</div>
		<div class="form-group hide">
			<label class="col-sm-2 control-label">备注:</label>
			<div class="col-sm-3">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="form-control"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">生成选项:</label>
			<div class="col-sm-3">
				<form:checkbox path="replaceFile" label="是否替换现有文件"/>
			</div>
		</div>
	<div class="hr-line-dashed"></div>
	<div class="form-group">
		<div class="col-sm-4 col-sm-offset-2">
			<shiro:hasPermission name="gen:genScheme:edit">
				<input id="btnSubmit" class="btn btn-primary" type="submit" value="保存方案" onclick="$('#flag').val('0');"/>&nbsp;
				<input id="btnSubmit" class="btn btn-danger" type="submit" value="保存并生成代码" onclick="$('#flag').val('1');"/>&nbsp;
			</shiro:hasPermission>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
		</div>
	</form:form>
	</div>
</body>
</html>
