<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工单管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate();
			$("input[name=woType]").click(function(){
				if($(this).val()==1){
					$("#preDate").removeClass("hide");
					$("#taskDetail").removeClass("hide");
				}else{
					$("#preDate").addClass("hide");
					$("#taskDetail").addClass("hide");
				}
			});
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
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
		function needReAssign(woId,snNo){
			layer.open({
				content:$("#needReAssignBox").html(),
				title:"请求转派",
				area:['300px', '300px'],
				btn:["发送","关闭"],
				yes:function(index,layero){
					loading();
					window.location.href="${ctx}/wo/woWorksheet/needReAssign?id="+woId+"${woWorksheet.self?"&self=true":""}"+"&msg="+$("#areason",layero).val();
				},
				success:function(layero,index){
					$("#asNo",layero).html(snNo)
				}
			});
		}
		function needAssistance(woId,snNo){
			layer.open({
				content:$("#needHelpBox").html(),
				title:"请求协助",
				area:['300px', '350px'],
				btn:["发送","关闭"],
				yes:function(index,layero){
					loading();
					window.location.href="${ctx}/wo/woWorksheet/needAssistance?id="+woId+"${woWorksheet.self?"&self=true":""}"+"&nhNum="+$("#nhNum",layero).val()+"&msg="+$("#reason",layero).val();
				},
				success:function(layero,index){
					$("#sNo",layero).html(snNo)
				}
			});
		}
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<div id="needReAssignBox" class="hide">
		<div id="reAssignForm" style="text-align:center;height:auto;"  >
			<div id="assignForm" style="text-align:center;height:auto;" class="row" >
				<label style="float:left;padding-left: 10px;" > 工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单：</label><span id="asNo" style="float:left;" ></span><br/><br/>

				<label style="float:left;padding-left: 10px;">原因描述：</label><div class="col-xs-7 no-padding"><textarea id="areason" name="msg" class="form-control" rows="4"></textarea></div>
			</div>

		</div>
	</div>
	<div id="needHelpBox" class="hide">
		<div id="reportForm" style="text-align:center;height:auto;"  >
			<div id="helpForm" style="text-align:center;height:auto;" class="row" >
				<label style="float:left;padding-left: 10px;" > 工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单：</label><span id="sNo" style="float:left;" ></span><br/><br/>
				<label style="float:left;padding-left: 10px;">协助人数：</label><div class="col-xs-7 no-padding"><input id="nhNum" type="number" class="form-control"></div><br/><br/>
				<label style="float:left;padding-left: 10px;">原因描述：</label><div class="col-xs-7 no-padding"><textarea id="reason" name="msg" class="form-control" rows="4"></textarea></div>
			</div>

		</div>
	</div>
	<ul class="nav nav-tabs">
		<li><shiro:hasPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/${woWorksheet.self?"self":""}"></shiro:hasPermission><shiro:lacksPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/self"></shiro:lacksPermission>工单列表</a></li>
		<li class="active"><a href="${ctx}/wo/woWorksheet/start?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}">工单<shiro:hasPermission name="wo:woWorksheet:edit">${not empty woWorksheet.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woWorksheet:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="woWorksheet" action="${ctx}/wo/woWorksheet/complete" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<c:if test="${woWorksheet.self}">
			<input type="hidden" name="self" value="true">
		</c:if>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属客户：</label>
			<div class="col-sm-3">
				${woWorksheet.woClient.name}
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属站点：</label>
			<div class="col-sm-3">
				${woWorksheet.woStation.name}
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">工单号：</label>
			<div class="col-sm-3">
				${woWorksheet.woNo}
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">WO号：</label>
			<div class="col-sm-3">
					${woWorksheet.snNo}
			</div>
		</div>
		<div class="form-group hide">
			<label class="col-sm-2 control-label">工单状态：</label>
			<div class="col-sm-6">
				<%--<form:radiobuttons path="woStatus" items="${fns:getDictList('worksheet_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />--%>
					${fns:getDictLabel(woWorksheet,'worksheet_status' , '')}
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">工单类型：</label>
			<div class="col-sm-3">
				${fns:getDictLabel(woWorksheet.woType,'worksheet_type' , '')}
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">紧急度：</label>
			<div class="col-sm-3">
				${fns:getDictLabel(woWorksheet.emGrade,'worksheet_emgrade' ,'' )}
			</div>
		</div>


		<div class="form-group">
			<label class="col-sm-2 control-label">是否将当前工单单独生成为PO订单：</label>
			<div class="col-sm-3">
				${fns:getDictLabel(woWorksheet.calculateType,'worksheet_cal_type','' )}
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">任务要求：</label>
			<div class="col-sm-6">
				<form:textarea path="remarks" rows="4" htmlEscape="false" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">描述：</label>
			<div class="col-sm-6">
				<form:textarea path="description" rows="4" htmlEscape="false" class="form-control "/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">备注：</label>
			<div class="col-sm-6">
				<form:textarea path="remarks" rows="4" htmlEscape="false" class="form-control "/>
			</div>
		</div>
		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="wo:woWorksheet:needReAssign">
					<c:if test="${ woWorksheet.woStatus eq '4' }">
						&nbsp; <a href="javascript:void(0)" onclick="needReAssign('${woWorksheet.id}','${woWorksheet.woNo}')" class="btn btn-primary " >请求转派</a>
					</c:if>
				</shiro:hasPermission>
				<shiro:hasPermission name="wo:woWorksheet:needAssistance">
					<c:if test="${ woWorksheet.woStatus eq '4'}">
						&nbsp;<a href="javascript:void(0)" onclick="needAssistance('${woWorksheet.id}','${woWorksheet.woNo}')" class="btn btn-primary" >请求协助</a>
					</c:if>
				</shiro:hasPermission>
				<shiro:hasPermission name="wo:woWorksheet:edit">&nbsp;<input id="btnSubmit"  ${fn:length(woWorksheet.unCheckedUsers)>0?'disabled':'tt'}  class="btn btn-primary" type="submit" value="确认完成"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>


			</div>
		</div>
	</form:form>
	</div>
</body>
</html>