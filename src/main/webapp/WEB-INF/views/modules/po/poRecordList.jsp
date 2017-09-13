<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>PO订单管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
		    $("#btnSubmit").click(function () {
                $("#searchForm").attr("action","${ctx}/po/poRecord").submit();
            });
			$("#btnExport").click(function(){
				confirmx("确认要导出PO订单记录吗？",function(){
					$("#searchForm").attr("action","${ctx}/po/poRecord/export").submit();
				});
			});
		});
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }

	</script>
</head>
<body>

<div class="wrapper wrapper-content animated fadeInRight">

	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/po/poRecord/">PO订单列表</a></li>
		<shiro:hasPermission name="po:poRecord:edit"><li><a href="${ctx}/po/poRecord/preForm">PO订单添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="poRecord" action="${ctx}/po/poRecord/" method="post" class="form-inline well">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<label >归属客户：</label>
		<sys:tableselect  id="woClient" name="client.id" value="${poRecord.client.id}" labelName="client.name" labelValue="${poRecord.client.name}"
						  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
		<label>评&nbsp;&nbsp;审&nbsp;&nbsp;号&nbsp;：</label><input name="snNo" value="${poRecord.snNo}" type="text"class="form-control"/>
		<br/><br/><label>项目经理：</label>
		<sys:treeselect id="pm" name="pm.id" value="${poRecord.pm.id}" labelName="pmName" labelValue="${poRecord.pm.name}"
						title="用户" url="/sys/office/treeData?type=3" cssClass="input-xxlarge required" allowClear="true" notAllowSelectParent="true"/>


		<label>订单PO号：</label><input name="poNo" value="${poRecord.poNo}" type="text"class="form-control"/>
		<br/><br/>
		<label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
										 value="<fmt:formatDate value="${poRecord.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,maxDate:'%y-%M-%d'});"/>
		<label>&nbsp;&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
																	value="<fmt:formatDate value="${poRecord.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false,maxDate:'%y-%M-%d'});"/>&nbsp;&nbsp;
		<label>状态：</label>
		<form:select id="type" path="status" style="width:100px;" class="form-control chosen-select"><form:option value="" label="请选择"/><form:options items="${fns:getDictList('po_status')}" itemLabel="label" itemValue="value" htmlEscape="false"/></form:select>
		&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="button" value="查询"/>
		&nbsp;&nbsp;<input id="btnExport" class="btn btn-primary" type="button" value="导出"/>
	</form:form>
	<sys:message content="${message}"/>
	<div class="table-responsive">
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>评审号</th>
				<th>订单PO号</th>
				<th>所属客户</th>
				<th>项目经理</th>
				<th>状态</th>
				<shiro:hasPermission name="wo:woWorksheet:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="poRecord">
			<tr>
				<td>
					<a href="${ctx}/po/poRecord/form?id=${poRecord.id}" class="<c:if test="${poRecord.status eq 2}"> label label-primary</c:if> ">
					${poRecord.snNo}</a>
				</td>
				<td>
					${poRecord.poNo}
				</td>
				<td>
					${poRecord.client.name}
				</td>
				<td>
					${poRecord.pm.name}
				</td>
				<td>
					${fns:getDictLabel(poRecord.status,'po_status','')}
				</td>
				<td>
    				<a href="${ctx}/po/poRecord/form?id=${poRecord.id}">查看</a>
					<c:if test="${poRecord.status!='2'}">
					<shiro:hasPermission name="po:poRecord:edit">
						<a href="${ctx}/po/poRecord/form?id=${poRecord.id}">修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="po:poRecord:del">
						<a href="${ctx}/po/poRecord/delete?id=${poRecord.id}" onclick="return confirmx('确认要删除该订单吗？', this.href)">删除</a>
					</shiro:hasPermission>
					</c:if>
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