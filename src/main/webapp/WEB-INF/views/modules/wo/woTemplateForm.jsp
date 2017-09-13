<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>模板管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules:{
					name: {remote: "${ctx}/wo/woTemplate/checkName?oldName=" + encodeURIComponent('${woTemplate.name}')}
				},
				messages:{
					name: {remote: "模板名称已存在"}
				}
			});
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row,idxIndex:idx+1
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}

	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/wo/woTemplate/">模板列表</a></li>
		<li class="active"><a href="${ctx}/wo/woTemplate/form?id=${woTemplate.id}">模板查看</a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="woTemplate" action="${ctx}/wo/woTemplate/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" name="type" value="0"/>
		<input type="hidden" name="parent.id" value="0"/>
		<sys:message content="${message}"/>
		<div class="form-group">

		<div class="form-group">
			<label class="col-sm-2 control-label">模板名称：</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control required"/>
			</div>
		</div>
			<div id="taskDetail" class="form-group ">
				<label class="col-sm-2 control-label">巡检项：</label>
				<div class="col-sm-8">
					<table id="contentTable" class="table table-striped table-bordered table-condensed">
						<thead>
						<tr>
							<th width="10%">序号</th>
							<th width="30%">名称</th>
							<th width="40%">标准</th>
							<th width="10%">操作</th>
						</tr>
						</thead>
						<tbody id="woTemplateList">

						</tbody>
						<tfoot>
						<tr><td colspan="5"><a href="javascript:" onclick="addRow('#woTemplateList', contentRowIdx, contentTpl);contentRowIdx = contentRowIdx + 1;" class="btn btn-primary">新增</a></td></tr>
						</tfoot>
					</table>
					<script type="text/template" id="contentTpl">//<!--
						<tr id="woTemplateList{{idx}}">
							<td>{{idxIndex}}</td>
							<td width="30%">
							<input id="woTemplateList{{idx}}_id" name="woTemplateList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
							<input id="woTemplateList{{idx}}_delFlag" name="woTemplateList[{{idx}}].delFlag" type="hidden" value="0"/>
							<input id="woTemplateList{{idx}}_type" name="woTemplateList[{{idx}}].type" type="hidden" value="1"/>
							<textarea id="woTemplateList{{idx}}_detailName" name ="woTemplateList[{{idx}}].detailName" rows="4"  value="{{row.detailName}}" class="form-control" >{{row.detailName}}</textarea>
							</td>
							<td width="40%"><textarea id="woTemplateList{{idx}}_detailContent" rows="4" name="woTemplateList[{{idx}}].detailContent" type="text" value="{{row.detailContent}}" maxlength="100" class="form-control">{{row.detailContent}}</textarea></td>
							<td class="text-center" width="10%">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#woTemplateList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
						</tr>//-->
					</script>
					<script type="text/javascript">
						var contentRowIdx = 0, contentTpl = $("#contentTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
						$(document).ready(function() {
							var data = ${fns:toJson(woTemplate.woTemplateList)};
							for (var i=0; i<data.length; i++){
								addRow('#woTemplateList', contentRowIdx, contentTpl, data[i]);
								contentRowIdx = contentRowIdx + 1;
							}
						});
					</script>
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
				<shiro:hasPermission name="wo:woStation:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>

	</form:form>
</div>
</body>
</html>