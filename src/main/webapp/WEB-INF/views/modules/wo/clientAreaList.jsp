<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>客户区域管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, ids = [], rootIds = [];
			for (var i=0; i<data.length; i++){
				ids.push(data[i].id);
			}
			ids = ',' + ids.join(',') + ',';
			for (var i=0; i<data.length; i++){
				if (ids.indexOf(','+data[i].parentId+',') == -1){
					if ((','+rootIds.join(',')+',').indexOf(','+data[i].parentId+',') == -1){
						rootIds.push(data[i].parentId);
					}
				}
			}
			for (var i=0; i<rootIds.length; i++){
				addRow("#treeTableList", tpl, data, rootIds[i], true);
			}
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/wo/clientArea/">客户区域列表</a></li>
		<shiro:hasPermission name="wo:clientArea:edit"><li><a href="${ctx}/wo/clientArea/form">客户区域添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="clientArea" action="${ctx}/wo/clientArea/" method="post" class="form-inline well">
		<label >归属客户：</label>
		<sys:tableselect  id="woClient" name="woClient.id" value="${clientArea.woClient.id}" labelName="woClient.name" labelValue="${clientArea.woClient.name}"
						  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
			&nbsp;&nbsp;
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
	</form:form>
	<sys:message content="${message}"/>
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>区域名称</th>
				<th>所属客户</th>
				<th>排序</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:clientArea:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="${ctx}/wo/clientArea/form?id={{row.id}}">
				{{row.name}}
			</a></td>
			<td>
				{{row.woClient.name}}
			</td>
			<td>
				{{row.sort}}
			</td>
			<td>
				{{row.remarks}}
			</td>
			<shiro:hasPermission name="wo:clientArea:edit"><td>
   				<a href="${ctx}/wo/clientArea/form?id={{row.id}}">修改</a>
				<a href="${ctx}/wo/clientArea/delete?id={{row.id}}" onclick="return confirmx('确认要删除该客户区域及所有子客户区域吗？', this.href)">删除</a>
				<a href="${ctx}/wo/clientArea/form?parent.id={{row.id}}&woClient.id={{row.woClient.id}}&woClient.name={{row.woClient.name}}">添加下级客户区域</a>
			</td></shiro:hasPermission>
		</tr>
	</script>
	</div>
</body>
</html>