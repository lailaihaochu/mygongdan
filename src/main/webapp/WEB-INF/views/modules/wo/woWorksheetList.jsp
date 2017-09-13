<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>工单管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			<shiro:hasPermission name="wo:woWorksheet:export">
			$("#btnExport").click(function(){
				confirmx("确认要导出工单记录吗？",function(){
					$("#searchForm").attr("action","${ctx}/wo/woWorksheet/export?${woWorksheet.self?"self=true":""}").submit();
				});
			});
			</shiro:hasPermission>
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").attr("action","${ctx}/wo/woWorksheet/${woWorksheet.self?'self':''}").submit();
        	return false;
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
		function exportFile(){

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
		<li class="active"><a href="${ctx}/wo/woWorksheet/${woWorksheet.self?"self":""}">工单列表</a></li>
		<shiro:hasPermission name="wo:woWorksheet:edit"><li><a href="${ctx}/wo/woWorksheet/form?${woWorksheet.self?"self=true":""}">工单添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="woWorksheet" action="${ctx}/wo/woWorksheet/${woWorksheet.self?'self':''}" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label >归属客户：</label>
		<sys:tableselect  id="woClient" name="woClient.id" value="${woWorksheet.woClient.id}" labelName="woClient.name" labelValue="${woWorksheet.woClient.name}"
						  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
		<label>归属站点：</label>
		<sys:tableselect  id="woStation" name="woStation.id" value="${woWorksheet.woStation.id}" labelName="woStation.name" labelValue="${woWorksheet.woStation.name}"
						  url="${ctx}/wo/woStation/tableSelect?id=" paramEle="Id" title="选择站点" cssClass="required"/>
		&nbsp;<label>WO号：</label><input name="snNo" value="${woWorksheet.snNo}" type="text"class="form-control"/>
		<br/><br/><label>项目经理：</label>
		<sys:treeselect id="pm" name="woStation.pm.id" value="${woWorksheet.woStation.pm.id}" labelName="pmName" labelValue="${woWorksheet.woStation.pm.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-xxlarge required" allowClear="true" notAllowSelectParent="true"/>
		<label>创&nbsp;建&nbsp;人&nbsp;：</label>
		<sys:treeselect id="createBy" name="createBy.id" value="${woWorksheet.createBy.id}" labelName="pmName" labelValue="${woWorksheet.createBy.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-xxlarge required" allowClear="true" notAllowSelectParent="true"/>


		<label>工单号：</label><input name="woNo" value="${woWorksheet.woNo}" type="text"class="form-control"/>
		<label>任务要求：</label><input name="remarks" value="${woWorksheet.remarks}" type="text"class="form-control"/>
		<br/><br/><label>工单类型：</label>
		<form:select id="type" path="woType" class="form-control chosen-select"><form:option value="" label="请选择"/><form:options items="${fns:getDictList('worksheet_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/></form:select>
		&nbsp;&nbsp;&nbsp;<label>工单状态：</label>
		<form:select id="status" path="woStatus" class="form-control chosen-select"><form:option value="" label="请选择"/><form:options items="${fns:getDictList('worksheet_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/></form:select>
		&nbsp;&nbsp;&nbsp;<label>紧急度：</label>
		<form:select id="grade" path="emGrade" class="form-control chosen-select"><form:option value="" label="请选择"/><form:options items="${fns:getDictList('worksheet_emgrade')}" itemLabel="label" itemValue="value" htmlEscape="false"/></form:select>
		&nbsp;&nbsp;&nbsp;<label>现场情况：</label>
		<form:select id="envStatus" path="envStatus" class="form-control chosen-select"><form:option value="" label="请选择"/><form:options items="${fns:getDictList('wo_env_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/></form:select>
		<br/><br/><label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
										 value="<fmt:formatDate value="${woWorksheet.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
		<label>&nbsp;&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
																	value="<fmt:formatDate value="${woWorksheet.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;&nbsp;

		&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
		<shiro:hasPermission name="wo:woWorksheet:export">
		&nbsp;&nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出"/>
		</shiro:hasPermission>

	</form:form>
	<sys:message content="${message}"/>
	<div class="table-responsive">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>归属客户</th>
				<th>归属站点</th>
				<th>项目经理</th>
				<th>工单号</th>
				<th>WO号</th>
				<th>工单状态</th>
				<th>工单类型</th>
				<th>紧急度</th>
				<th>现场情况</th>
				<th>工程师</th>
				<th>创建人</th>
				<th>创建时间</th>
				<shiro:hasPermission name="wo:woWorksheet:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="worksheet">
			<tr>
				<td>
						${worksheet.woClient.name}
				</td>
				<td>
						${worksheet.woStation.name}
				</td>
				<td>
						${worksheet.woStation.pm.name}
				</td>
				<td><a href="${ctx}/wo/woWorksheet/detail?id=${worksheet.id}${woWorksheet.self?"&self=true":""}">
						${worksheet.woNo}
				</a></td>
				<td>
						${worksheet.snNo}
				</td>
				<td>
					${fns:getDictLabel(worksheet.woStatus,'worksheet_status','')}
				</td>
				<td>
					${fns:getDictLabel(worksheet.woType,'worksheet_type','')}
				</td>
				<td>
					${fns:getDictLabel(worksheet.emGrade,'worksheet_emgrade','')}
				</td>
				<td>
						${fns:getDictLabel(worksheet.envStatus,'wo_env_status','')}
				</td>
				<td>
					<c:forEach items="${worksheet.checkedUsers}" var="checkedUser">
						${checkedUser.name}（确认）&nbsp;&nbsp;
					</c:forEach>
					<c:forEach items="${worksheet.unCheckedUsers}" var="unCheckedUser">
						${unCheckedUser.name}（未确认）&nbsp;&nbsp;
					</c:forEach>
				</td>
				<td>
					${worksheet.createBy.name}
				</td>
				<td>
					<fmt:formatDate value="${worksheet.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
    				<a href="${ctx}/wo/woWorksheet/detail?id=${worksheet.id}${woWorksheet.self?"&self=true":""}">查看</a>
					<shiro:hasPermission name="wo:woWorksheet:edit">
					<c:if test="${worksheet.woStatus=='1'}">
						<a href="${ctx}/wo/woWorksheet/form?id=${worksheet.id}${woWorksheet.self?"&self=true":""}">修改</a>
					</c:if>
					</shiro:hasPermission>
					<%--<shiro:hasPermission name="wo:woWorksheet:assign">
					<c:if test="${ worksheet.woStatus == '1' or worksheet.envStatus ne '0' }">
						<a href="${ctx}/wo/woWorksheet/assign?id=${worksheet.id}${woWorksheet.self?"&self=true":""}">指派</a>
					</c:if>
					</shiro:hasPermission>--%>
				<%--	<shiro:hasPermission name="wo:woWorksheet:needReAssign">
						<c:if test="${worksheet.woStatus eq '2'or worksheet.woStatus eq '3' or  worksheet.woStatus eq '4' }">
						<a href="javascript:void(0)" onclick="needReAssign('${worksheet.id}','${worksheet.snNo}')">请求转派</a>
						</c:if>
					</shiro:hasPermission>
					<shiro:hasPermission name="wo:woWorksheet:needAssistance">
						<c:if test="${worksheet.woStatus eq '3' or  worksheet.woStatus eq '4'}">
						<a href="javascript:void(0)" onclick="needAssistance('${worksheet.id}','${worksheet.snNo}')">请求协助</a>
						</c:if>
					</shiro:hasPermission>--%>
					<shiro:hasPermission name="wo:woWorksheet:start">
					<c:if test="${worksheet.envStatus ne '2'}">
						<c:if test="${worksheet.woStatus eq '3'}"><a href="${ctx}/wo/woWorksheet/start?id=${worksheet.id}${woWorksheet.self?"&self=true":""}" onclick="return confirmx('是否要开始执行该工单？', this.href)">开始</a></c:if>
						<c:if test="${worksheet.woStatus eq '4'}">
							<a href="${ctx}/wo/woWorksheet/start?id=${worksheet.id}${woWorksheet.self?"&self=true":""}">编辑</a>
						</c:if>
					</c:if>
					</shiro:hasPermission>
					<shiro:hasPermission name="wo:woWorksheet:close">
					<c:if test="${worksheet.woStatus ne '5' and worksheet.woStatus ne '6' }">
						<a href="${ctx}/wo/woWorksheet/close?id=${worksheet.id}${woWorksheet.self?"&self=true":""}">关闭</a>
					</c:if>
					</shiro:hasPermission>
					<shiro:hasPermission name="wo:woWorksheet:edit">
					<c:if test="${worksheet.woStatus=='1'}">
					<a href="${ctx}/wo/woWorksheet/delete?id=${worksheet.id}${woWorksheet.self?"&self=true":""}" onclick="return confirmx('确认要删除该工单吗？', this.href)">删除</a>
					</c:if>
					</shiro:hasPermission>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
	</div>
	</div>
</body>
</html>