<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>合同信息管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate();
		});
		function tableCallBack(contentWindow,ele){
			var prefix=$(ele).attr("id").replace("Id","");
			$("#"+prefix+"NameH").val(contentWindow.selectedLabel);
			$("#"+prefix+"Phone").val(contentWindow.selectedPhone);
		}
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/wo/woContract/">合同信息列表</a></li>
		<li class="active"><a href="${ctx}/wo/woContract/form?id=${woContract.id}">合同信息<shiro:hasPermission name="wo:woContract:edit">${not empty woContract.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woContract:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>

	<form:form id="inputForm" modelAttribute="woContract" action="${ctx}/wo/woContract/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<c:if test="${woContract.contractStatus ne '1'}">
		<div class="form-group">
			<label class="col-sm-2 control-label">合同编号：</label>
			<div class="col-sm-3">
				<form:input path="contractNo" htmlEscape="false" maxlength="200" class="form-control required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">项目名称：</label>
			<div class="col-sm-5">
				<form:input path="projectName" htmlEscape="false" maxlength="255" class="form-control required"/>
			</div>
		</div>
	<div class="col-sm-6 no-padding" style="padding-left: 5px !important;">
		<div class="form-group">
			<label class="col-sm-4 control-label">甲方：</label>
			<div class="col-sm-6">
				<sys:tableselect id="partA_" name="partA.id" value="${woContract.partA.id}" labelName="partA.name" labelValue="${woContract.partA.name}"
								 title="选择客户" url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" cssClass=" required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-4 control-label">联系人：</label>
			<div class="col-sm-6">
				<sys:tableselect id="partAEmp" name="partAEmp.id" value="${woContract.partAEmp.id}" labelName="partAEmp.name" labelValue="${woContract.partAEmp.name}"
								 title="选择联系人" url="${ctx}/wo/woEmployee/tableSelect?id=" paramEle="Id" callBack="tableCallBack" cssClass=" required"/>
				<input id="partAEmpNameH" type="hidden" name="partAContact" value="${woContract.partAContact}"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-4 control-label">联系电话：</label>
			<div class="col-sm-6">
				<input id="partAEmpPhone" readonly="true" value="${woContract.partAContactTel}" name="partAContactTel" htmlEscape="false" maxlength="200" class="form-control "/>
			</div>
		</div>
		</div>
		<div class="col-sm-6 no-padding" style="padding-right: 5px !important; ">
		<div class="form-group">
			<label class="col-sm-3 control-label">乙方：</label>
			<div class="col-sm-6">
				<sys:treeselect id="partB" name="partB.id" value="${woContract.partB.id}" labelValue="${woContract.partB.name}" labelName="partB.name"
								title="选择公司" url="/sys/office/treeData?type=1" cssClass=" required" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-3 control-label">联系人：</label>
			<div class="col-sm-6">
				<sys:tableselect id="partBEmp" name="partBEmp.id" value="${woContract.partBEmp.id}" labelName="partBEmp.name" labelValue="${woContract.partBEmp.name}"
								title="用户" url="${ctx}/sys/user/tableSelect?id=" cssClass=" required" paramEle="Id" callBack="tableCallBack" />
				<input id="partBEmpNameH" type="hidden" name="partBContact" value="${woContract.partBContact}"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-3 control-label">联系电话：</label>
			<div class="col-sm-6">
				<input id="partBEmpPhone" readonly="true" name="partBContactTel" value="${woContract.partBContactTel}" htmlEscape="false" maxlength="200" class="form-control "/>
			</div>
		</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">合同内容：</label>
			<div class="col-sm-8">
				<form:textarea id="content" path="contractContent" htmlEscape="false" rows="4" class="form-control "/>
				<sys:ckeditor replace="content" uploadPath="/wo/woContract" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">合同附件：</label>
			<div class="col-sm-3">
				<form:hidden id="contractFiles" path="contractFiles" htmlEscape="false" class="input-xlarge"/>
				<sys:ckfinder input="contractFiles" type="files" uploadPath="/wo/woContract" selectMultiple="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">合同状态：</label>
			<div class="col-sm-3">
				<form:radiobuttons path="contractStatus" items="${fns:getDictList('contract_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">备注：</label>
			<div class="col-sm-6">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="wo:woContract:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
		</c:if>
		<c:if test="${woContract.contractStatus eq '1'}">
			<div class="form-group">
				<label class="col-sm-2 control-label">合同编号：</label>
				<div class="col-sm-3">
					<form:input path="contractNo" readonly="true" htmlEscape="false" maxlength="200" class="form-control required"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">项目名称：</label>
				<div class="col-sm-5">
					<form:input path="projectName" readonly="true" htmlEscape="false" maxlength="255" class="form-control required"/>
				</div>
			</div>
			<div class="col-sm-6 no-padding" style="padding-left: 5px !important;">
				<div class="form-group">
					<label class="col-sm-4 control-label">甲方：</label>
					<div class="col-sm-6">
						<input id="partA" readonly="true" value="${woContract.partA.name}" class="form-control" />
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">联系人：</label>
					<div class="col-sm-6">
						<input id="partAEmpNameV" type="text" readonly="true" name="partAContact" value="${woContract.partAContact}" class="form-control"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-4 control-label">联系电话：</label>
					<div class="col-sm-6">
						<input id="partAEmpPhoneV" readonly="true" value="${woContract.partAContactTel}" name="partAContactTel" htmlEscape="false" maxlength="200" class="form-control "/>
					</div>
				</div>
			</div>
			<div class="col-sm-6 no-padding" style="padding-right: 5px !important; ">
				<div class="form-group">
					<label class="col-sm-3 control-label">乙方：</label>
					<div class="col-sm-6">
						<input value="${woContract.partB.name}" class="form-control" readonly="true">
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">联系人：</label>
					<div class="col-sm-6">
						<input id="partBEmpNameV" type="text" name="partBContact" value="${woContract.partBContact}" class="form-control" readonly="true"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-sm-3 control-label">联系电话：</label>
					<div class="col-sm-6">
						<input id="partBEmpPhoneV" readonly="true" name="partBContactTel" value="${woContract.partBContactTel}" htmlEscape="false" maxlength="200" class="form-control "/>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">合同内容：</label>
				<div class="col-sm-8">
					<form:textarea id="contentV" path="contractContent" readonly="true" htmlEscape="false" rows="4" class="form-control "/>
					<sys:ckeditor replace="contentV" uploadPath="/wo/woContract" />
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">合同附件：</label>
				<div class="col-sm-3">
					<form:hidden id="contractFiles" path="contractFiles" htmlEscape="false" class="input-xlarge"/>
					<sys:ckfinder input="contractFiles" type="files" uploadPath="/wo/woContract" selectMultiple="true" readonly="true"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">合同状态：</label>
				<div class="col-sm-3">
					${fns:getDictLabel(woContract.contractStatus,'contract_status' ,'')}
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">备注：</label>
				<div class="col-sm-6">
					<form:textarea path="remarks" htmlEscape="false" readonly="true" rows="4" maxlength="255" class="form-control "/>
				</div>
			</div>
			<div class="hr-line-dashed"></div>
			<div class="form-group">
				<div class="col-sm-4 col-sm-offset-2">
					<input id="btnBack" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
				</div>
			</div>
		</c:if>
	</form:form>
</div>
</body>
</html>