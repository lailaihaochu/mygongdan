<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工单管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").focus();
			$("#inputForm").validate({
				rules:{
					snNo: {remote: "${ctx}/wo/woWorksheet/checkSn?oldSn=" + encodeURIComponent('${woWorksheet.snNo}')}
				},
				messages:{
					snNo: {remote: "客户工单号已存在"}
				}
			});
			$("input[name=acpType]").click(function () {
				if($(this).val()==3){
                    $("#otherDiv").removeClass("hide");
				}else{
				    $("#otherDiv").addClass("hide");
				}
            });
			$("input[name=woType]").click(function(){
				if($(this).val()==1){
					$("#sType").addClass("hide");
					//$("#preDate").removeClass("hide");
					$("#taskDetail").removeClass("hide");
					$("#calculateTypeDiv").addClass("hide");
					$("#snNoDiv").addClass("hide");
					$("#emGradeDiv").addClass("hide");
					$("input[name=serviceType]").removeClass("required");
				}else{
					$("#sType").removeClass("hide");
					//$("#preDate").addClass("hide");
					$("#taskDetail").addClass("hide");
					$("#calculateTypeDiv").removeClass("hide");
					$("#snNoDiv").removeClass("hide");
					$("#emGradeDiv").removeClass("hide");
					$("input[name=serviceType]").addClass("required");
				}
			});
			$("input[name=serviceType]").click(function(){
				if($(this).val()==9){
					$("#remarks").addClass("required");
				}else{
					$("#remarks").removeClass("required");
				}
			});
			$("#stationButton").click(function(){
				var clientId=$("#woClientId").val();
				top.layer.open({
					type:2,
					content:"${ctx}/wo/woStation/tableSelect?id=${woWorksheet.woStation.id}&woClient.id="+clientId,
					title:"选择站点",
					area:['600px', '520px'],
					btn:["确定","关闭"],
					yes:function(index,layero){
						if(layero.find("iframe")[0].contentWindow.usable=="true"){
							$("#woStation").val(layero.find("iframe")[0].contentWindow.selectedId);
							$("#stationName").val(layero.find("iframe")[0].contentWindow.selectedLabel);
						}else{
							showTip("无效的选择！");
						}
						top.layer.close(index);
					},
					success:function(layero,index){
						layero.find("iframe")[0].contentWindow.dblFunc=this.yes;
					}
				});
			});
		});
		<shiro:hasAnyPermissions name="wo:woTemplate:view">
		function importTpl(){
			layer.open({
				type:2,
				content:"${ctx}/wo/woTemplate/tableSelect?type=0",
				title:"选择模板",
				area:['600px', '520px'],
				btn:["确定","关闭"],
				yes:function(index,layero){
					if(layero.find("iframe")[0].contentWindow.usable=="true"){
						$.ajax({
							url:"${ctx}/wo/woTemplate/getDetail?id="+layero.find("iframe")[0].contentWindow.selectedId,
							type:"GET",
							dataType:"json",
							beforeSend:function(){
								loading("导入中...")
							},
							success:function(data){

								for (var i=0; i<data.length; i++){
									addTplRow('#detailList', contentRowIdx, tplContentTpl, data[i]);
									contentRowIdx = contentRowIdx + 1;
								}

							},
							complete:function(){
								top.layer.close(top.mask);
							},
							error:function(){
								showTip("导入失败！")
							}
						});
					}else{
						showTip("无效的选择！");
					}
					layer.close(index);
				},
				success:function(layero,index){
					layero.find("iframe")[0].contentWindow.dblFunc=this.yes;
				}
			});
		}
		function addTplRow(list,idx,tpl,row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list).find(".trIndex").each(function(i){
				$(this).html(i+1);
			});
			$(list).find(".sortIndex").each(function (i) {
				$(this).val(i+1);
            });
		}
		</shiro:hasAnyPermissions>
		<shiro:hasAnyPermissions name="wo:woTemplate:edit">
		function createTpl(){
			layer.open({
				type:2,
				content:"${ctx}/wo/woTemplate/createForm",
				title:"生成模板",
				area:['950px', '520px'],
				btn:["确定","关闭"],
				yes:function(index,layero){
					var form=layero.find("iframe")[0].contentWindow.tplForm;
					$.ajax({
						url:$(form).attr("action"),
						type:"POST",
						data:$(form).serialize(),
						dataType:"json",
						beforeSend:function(){
							loading()
						},
						success:function(data){
							if(data.success){
								showTip("保存成功！");
								layer.close(index);
							}else{
								showTip(data.msg);
							}
						},
						complete:function(){
							top.layer.close(top.mask);
						}
					});
				},
				success:function(layero,index){
					var obj=$.formHelper.getObject($('#inputForm').serialize());
					for (var i=0; i<obj.detailList.length; i++) {
						layero.find("iframe")[0].contentWindow.addTpl(obj.detailList[i]);
					}
				}
			});
		}
		</shiro:hasAnyPermissions>

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
			$(list).find(".trIndex").each(function(i){
				$(this).html(i+1);
			});
            $(list).find(".sortIndex").each(function (i) {
                $(this).val(i+1);
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
			$(list).find(".trIndex").each(function(i){
				$(this).html(i+1);
			});
		}
		function checkForm(){
			console.info("${fns:getUser().roleNames}");

			<c:if test="${empty woWorksheet.id and fns:getUser().roleNames.contains('项目经理') and fns:getUser().roleNames.contains('工程师')}">
				top.layer.confirm("是否将当前工单分配给自己",{icon: 3, title:'系统提示',btn:['是','否']},function(index){
					$("#assSelf").val("1");
					$("#inputForm").submit();
					top.layer.close(index);
				},function(index){
					$("#assSelf").val("0");
					$("#inputForm").submit();
					top.layer.close(index);
				});
			</c:if>
			<c:if test="${! empty woWorksheet.id or !fns:getUser().roleNames.contains('工程师')}">
				$("#inputForm").submit();
			</c:if>
			<c:if test="${ empty woWorksheet.id and fns:getUser().roleNames.contains('工程师') and !fns:getUser().roleNames.contains('项目经理')}">
				$("#assSelf").val("1");
				$("#inputForm").submit();
			</c:if>
		}
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><shiro:hasPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/${woWorksheet.self?"self":""}"></shiro:hasPermission><shiro:lacksPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/self"></shiro:lacksPermission>工单列表</a></li>
		<li class="active"><a href="${ctx}/wo/woWorksheet/form?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}">工单<shiro:hasPermission name="wo:woWorksheet:edit">${not empty woWorksheet.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woWorksheet:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="woWorksheet" action="${ctx}/wo/woWorksheet/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="assSelf" name="assSelf" value="0"/>
		<form:hidden path="envStatus"/>
		<c:if test="${woWorksheet.self}">
			<input type="hidden" name="self" value="true">
		</c:if>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属客户：</label>
			<div class="col-sm-3">
				<sys:tableselect  id="woClient" name="woClient.id" value="${woWorksheet.woClient.id}" labelName="woClient.name" labelValue="${woWorksheet.woClient.name}"
								  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属站点：</label>
			<div class="col-sm-3">
				<div class="input-group">
					<input id="woStation" name="woStation.id" type="hidden" value="${woWorksheet.woStation.id}" class="required"/>
					<input id="stationName" name="woStation.name" readonly="readonly" type="text" value="${woWorksheet.woStation.name}"
						   class="form-control required"/><span class="input-group-btn"><button id="stationButton" type="button" class="btn btn-primary "><i class="fa fa-search" ></i>&nbsp;</button></span>
				</div>

			</div>
		</div>
		<c:if test="${woWorksheet ne null and woWorksheet.id ne null}">
			<div class="form-group">
				<label class="col-sm-2 control-label">工单号：</label>
				<div class="col-sm-3">
					<form:input path="woNo" htmlEscape="false" readonly="true" maxlength="255" class="form-control "/>
				</div>
			</div>
		</c:if>
		<div id="snNoDiv" class="form-group">
			<label class="col-sm-2 control-label">WO号：</label>
			<div class="col-sm-3">
				<form:input path="snNo"  htmlEscape="false"  maxlength="255" class="form-control "/>
			</div>
		</div>
		<div  class="form-group">
				<label class="col-sm-2 control-label">始发时间：</label>
			<div class="col-sm-3">
				<input name="actStartTime" type="text" readonly="readonly" maxlength="20" class="form-control Wdate "
					   value="<fmt:formatDate value="${woWorksheet.actStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div  class="form-group">
			<label class="col-sm-2 control-label">接受类型：</label>
			<div class="col-sm-3">
				<form:radiobuttons path="acpType"  items="${fns:getDictList('worksheet_acp_type')}" itemLabel="label" itemValue="value" htmlEscape="false" />
			</div>
		</div>
		<div id="otherDiv" class="form-group  ${woWorksheet.acpType eq '3'?'':'hide'}">
			<label class="col-sm-2 control-label">其他说明：</label>
			<div class="col-sm-3">
				<form:input path="other"  htmlEscape="false"  maxlength="255" class="form-control "/>
			</div>
		</div>
		<div class="form-group hide">
			<label class="col-sm-2 control-label">工单状态：</label>
			<div class="col-sm-6">
				<%--<form:radiobuttons path="woStatus" items="${fns:getDictList('worksheet_status')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />--%>
					<input type="hidden" name="woStatus" value="1"/>

			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">工单类型：</label>
			<div class="col-sm-3">
				<form:radiobuttons path="woType"  items="${fns:getDictList('worksheet_type')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />
			</div>
		</div>
		<div id="sType"  class="form-group ${woWorksheet.woType eq '2'?'':'hide'}">
			<label class="col-sm-2 control-label">服务类型：</label>
			<div class="col-sm-6">
				<form:radiobuttons path="serviceType" items="${fns:getDictList('worksheet_service_type')}" itemLabel="label" itemValue="value"  htmlEscape="false" />
			</div>
		</div>
		<div id="emGradeDiv" class="form-group">
			<label class="col-sm-2 control-label">紧急度：</label>
			<div class="col-sm-3">
				<form:radiobuttons path="emGrade" items="${fns:getDictList('worksheet_emgrade')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />
			</div>
		</div>

		<div id="calculateTypeDiv" class="form-group">
			<label class="col-sm-2 control-label">单独报价：</label>
			<div class="col-sm-3">
				<form:radiobuttons path="calculateType" items="${fns:getDictList('worksheet_cal_type')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">任务要求：</label>
			<div class="col-sm-6">
				<form:textarea path="remarks" rows="4" htmlEscape="false" class="form-control "/>
			</div>
		</div>
		<div id="preDate" class="form-group ">
		<%--<div id="preDate" class="form-group ${woWorksheet.woType=='1'?"":"hide"}">--%>
			<label class="col-sm-2 control-label">计划开始时间：</label>
			<div class="col-sm-3">
				<input name="advanceTime" type="text" readonly="readonly" maxlength="20" class="form-control Wdate "
					value="<fmt:formatDate value="${woWorksheet.advanceTime}" pattern="yyyy-MM-dd HH:mm:ss"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
			</div>
		</div>
		<div id="taskDetail" class="form-group ${woWorksheet.woType=='1'?"":"hide"}">
			<label class="col-sm-2 control-label">巡检项：</label>
			<div class="col-sm-8">
				<table id="contentTable" class="table table-striped table-bordered table-condensed">
					<thead>
					<tr>
						<th width="10%">序号</th>
						<th width="30%">名称</th>
						<th width="30%">标准</th>
						<th width="20%">备注</th>
						<th width="10%">操作</th>
					</tr>
					</thead>
					<tbody id="detailList">

					</tbody>
					<tfoot>
					<tr><td colspan="5">
						<a href="javascript:" onclick="addRow('#detailList', contentRowIdx, contentTpl);contentRowIdx = contentRowIdx + 1;" class="btn btn-primary">新增</a>
						<shiro:hasAnyPermissions name="wo:woTemplate:view">
						&nbsp;<a href="javascript:" onclick="importTpl()" class="btn btn-primary">导入模板</a>
						</shiro:hasAnyPermissions>
						<shiro:hasAnyPermissions name="wo:woTemplate:edit">
						&nbsp;<a href="javascript:" onclick="createTpl()" class="btn btn-primary">生成模板</a>
						</shiro:hasAnyPermissions>
					</td></tr>
					</tfoot>
				</table>
				<script type="text/template" id="contentTpl">//<!--
						<tr id="detailList{{idx}}">
							<td><span class='trIndex'></span></td>
							<td>
							<input id="detailList{{idx}}_sort" class='sortIndex' name="detailList[{{idx}}].sort" type="hidden" value="{{row.sort}}"/>
							<input id="detailList{{idx}}_id" name="detailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
							<input id="detailList{{idx}}_delFlag" name="detailList[{{idx}}].delFlag" type="hidden" value="0"/>
							<textarea id="detailList{{idx}}_name" name ="detailList[{{idx}}].name" rows=4 value="{{row.name}}" class="form-control" >{{row.name}}</textarea>
							</td>
							<td ><textarea id="detailList{{idx}}_content" name="detailList[{{idx}}].content" rows=4 value="{{row.content}}" class="form-control">{{row.content}}</textarea></td>
							<td ><textarea id="detailList{{idx}}_remarks" name="detailList[{{idx}}].remarks" rows=4 value="{{row.remarks}}" class="form-control">{{row.remarks}}</textarea></td>
							<td class="text-center" width="10%">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#detailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
						</tr>//-->
				</script>
				<shiro:hasAnyPermissions name="wo:woTemplate:view">
				<script type="text/template" id="tplContentTpl">//<!--
						<tr id="detailList{{idx}}">
							<td><span class='trIndex'></span></td>
							<td >
							<input id="detailList{{idx}}_sort" class='sortIndex' name="detailList[{{idx}}].sort" type="hidden" value=""/>
							<input id="detailList{{idx}}_id" name="detailList[{{idx}}].id" type="hidden" value=""/>
							<input id="detailList{{idx}}_delFlag" name="detailList[{{idx}}].delFlag" type="hidden" value="0"/>
							<textarea id="detailList{{idx}}_detailName" name ="detailList[{{idx}}].name" rows=4 value="{{row.detailName}}" class="form-control" >{{row.detailName}}</textarea>
							</td>
							<td ><textarea id="detailList{{idx}}_detailContent" name="detailList[{{idx}}].content" rows=4 value="{{row.detailContent}}" class="form-control">{{row.detailContent}}</textarea></td>
							<td ><textarea id="detailList{{idx}}_remarks" name="detailList[{{idx}}].remarks" rows=4 value="" class="form-control"></textarea></td>
							<td class="text-center" width="10%">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#detailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td>
						</tr>//-->
				</script>
				</shiro:hasAnyPermissions>
				<script type="text/javascript">
					var contentRowIdx = 0, contentTpl = $("#contentTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
					tplContentTpl = $("#tplContentTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
					$(document).ready(function() {
						var data = ${fns:toJson(woWorksheet.detailList)};
						for (var i=0; i<data.length; i++){
							addRow('#detailList', contentRowIdx, contentTpl, data[i]);
							contentRowIdx = contentRowIdx + 1;
						}
					});
				</script>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">执行情况：</label>
			<div class="col-sm-6">
				<form:textarea path="description" rows="4" disabled="true" readonly="true" htmlEscape="false" class="form-control "/>
			</div>
		</div>
		<div class="hr-line-dashed"></div>
		<div class="form-group">
			<div class="col-sm-4 col-sm-offset-2">
				<shiro:hasPermission name="wo:woWorksheet:edit"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="checkForm();" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>
	</form:form>
	</div>
</body>
</html>