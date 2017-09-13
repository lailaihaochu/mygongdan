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
		<li class="active"><a href="${ctx}/wo/devPosition/">设备位置列表</a></li>
		<shiro:hasPermission name="wo:devPosition:edit"><li><a href="${ctx}/wo/devPosition/form">设备位置添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="devPosition" action="${ctx}/wo/devPosition/" method="post" class="form-inline well">
		<label >归属站点：</label>
		<sys:tableselect  id="woStation" name="woStation.id" value="${devPosition.woStation.id}" labelName="woStation.name" labelValue="${devPosition.woStation.name}"
						  url="${ctx}/wo/woStation/tableSelect?id=" paramEle="Id" title="选择站点" cssClass="required"/>
			&nbsp;&nbsp;
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
	</form:form>
	<sys:message content="${message}"/>
	<table id="treeTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>位置名称</th>
				<th>所属战点</th>
				<th>排序</th>
				<th>备注</th>
				<shiro:hasPermission name="wo:devPosition:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a href="${ctx}/wo/devPosition/form?id={{row.id}}">
				{{row.name}}
			</a></td>
			<td>
				{{row.woStation.name}}
			</td>
			<td>
				{{row.sort}}
			</td>
			<td>
				{{row.remarks}}
			</td>
			<shiro:hasPermission name="wo:devPosition:edit"><td>
   				<a href="${ctx}/wo/devPosition/form?id={{row.id}}">修改</a>
				<a href="${ctx}/wo/devPosition/delete?id={{row.id}}" onclick="return confirmx('确认要删除该位置信息及所有子位置信息吗？', this.href)">删除</a>
				<a href="${ctx}/wo/devPosition/form?parent.id={{row.id}}&woStation.id={{row.woStation.id}}&woStation.name={{row.woStation.name}}">添加下级位置信息</a>
			</td></shiro:hasPermission>
		</tr>
	</script>
	</div>
</body>
</html>