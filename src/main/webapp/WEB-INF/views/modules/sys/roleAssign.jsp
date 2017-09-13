<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>分配角色</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/sys/role/">角色列表</a></li>
		<li class="active"><a href="${ctx}/sys/role/assign?id=${role.id}"><shiro:hasPermission name="sys:role:edit">角色分配</shiro:hasPermission><shiro:lacksPermission name="sys:role:edit">人员列表</shiro:lacksPermission></a></li>
	</ul>
	<div class="well">
		<div class="row">
			<span class="col-sm-4">角色名称: <b>${role.name}</b></span>
			<span class="col-sm-4">归属机构: ${role.office.name}</span>
			<c:set var="dictvalue" value="${role.dataScope}" scope="page" />
			<span class="col-sm-4">数据范围: ${fns:getDictLabel(dictvalue, 'sys_data_scope', '')}</span>
		</div>
	</div>
	<sys:message content="${message}"/>
	<div class="breadcrumb">
		<form id="assignRoleForm" action="" method="post" class="hide"></form>
		<a id="assignButton" href="javascript:" class="btn btn-primary">分配角色</a>
		<script type="text/javascript">
			$("#assignButton").click(function(){
				top.layer.open({
					type:2,
					content:"${ctx}/sys/role/usertorole?id=${role.id}",
					title:"分配角色",
					area:[$(document).width()-20+"px",$(top.document).height()-240+"px"],
					btn: ["确定分配","关闭","清除已选"],
					bottomText:"通过选择部门，然后为列出的人员分配角色。",
					yes:function(index, layero){
						var pre_ids = layero.find("iframe")[0].contentWindow.pre_ids;
						var ids = layero.find("iframe")[0].contentWindow.ids;
						//nodes = selectedTree.getSelectedNodes();
							// 删除''的元素
							if(ids[0]==''){
								ids.shift();
								pre_ids.shift();
							}
							if(pre_ids.sort().toString() == ids.sort().toString()){
								showTip("未给角色【${role.name}】分配新成员！", 'info');
								return;
							};
					    	// 执行保存
					    	loading('正在提交，请稍等...');
					    	var idsArr = "";
					    	for (var i = 0; i<ids.length; i++) {
					    		idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
					    	}
					    	$('#assignRoleForm').attr('action','${ctx}/sys/role/assignrole?id=${role.id}&idsArr='+idsArr).submit();
							top.layer.close(index);
						},
						cancel:function(){

						},
						btn3:function(index, layero){
							layero.find("iframe")[0].contentWindow.clearAssign();
						},
						success:function(layero, index){

						}
				});
			});
		</script>
	</div>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>归属公司</th><th>归属部门</th><th>登录名</th><th>姓名</th><th>电话</th><th>手机</th><shiro:hasPermission name="sys:role:edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody>
		<c:forEach items="${userList}" var="user">
			<tr>
				<td>${user.company.name}</td>
				<td>${user.office.name}</td>
				<td><a href="${ctx}/sys/user/form?id=${user.id}">${user.loginName}</a></td>
				<td>${user.name}</td>
				<td>${user.phone}</td>
				<td>${user.mobile}</td>
				<shiro:hasPermission name="sys:role:edit"><td>
					<a href="${ctx}/sys/role/outrole?userId=${user.id}&roleId=${role.id}" 
						onclick="return confirmx('确认要将用户<b>[${user.name}]</b>从<b>[${role.name}]</b>角色中移除吗？', this.href)">移除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	</div>
</body>
</html>
