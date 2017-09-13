<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>分配工单</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<script type="text/javascript">
	
		var officeTree,userTree;
		var selectedTree;//zTree已选择对象
		
		// 初始化
		$(document).ready(function(){
			officeTree = $.fn.zTree.init($("#officeTree"), setting, officeNodes);
			userTree=$.fn.zTree.init($("#userTree"), setting, pre_selectedNodes);
			selectedTree = $.fn.zTree.init($("#selectedTree"), setting, selectedNodes);
		});

		var setting = {view: {selectedMulti:false,nameIsHTML:true,showTitle:false},
				data: {simpleData: {enable: true}},
				callback: {onClick: treeOnClick}};
		
		var officeNodes=[
	            <c:forEach items="${resourceList}" var="user">
				<c:if test="${!fns:contains(user, userList)&&!fns:contains(user, stationList)}">
	            {id:"${user.id}",
	             pId:"0",
	             name:"${user.name}"},
				</c:if>
	            </c:forEach>];
		var pre_selectedNodes =[
   		        <c:forEach items="${stationList}" var="user">
				<c:if test="${!fns:contains(user, userList)}">
   		        {id:"${user.id}",
   		         pId:"0",
   		         name:"${user.name}"},
				</c:if>
   		        </c:forEach>];
		
		var selectedNodes =[
		        <c:forEach items="${userList}" var="user">
		        {id:"${user.id}",
		         pId:"0",
		         name:"<font color='red' style='font-weight:bold;'>${user.name}</font>"},
		        </c:forEach>];
		
		var pre_ids = "${selectIds}".split(",");
		var ids = "${selectIds}".split(",");
		
		//点击选择项回调
		function treeOnClick(event, treeId, treeNode, clickFlag){
			if("officeTree"==treeId){
				if($.inArray(String(treeNode.id), ids)<0){
					selectedTree.addNodes(null, treeNode);
					ids.push(String(treeNode.id));
				}
			}
			if("userTree"==treeId){
				//alert(treeNode.id + " | " + ids);
				//alert(typeof ids[0] + " | " +  typeof treeNode.id);
				if($.inArray(String(treeNode.id), ids)<0){
					selectedTree.addNodes(null, treeNode);
					ids.push(String(treeNode.id));
				}
			}
            if("selectedTree"==treeId){
                if($.inArray(String(treeNode.id), pre_ids)<0){
                    selectedTree.removeNode(treeNode);
                    ids.splice($.inArray(String(treeNode.id), ids), 1);
                }else{
                    showTip("只能删除新添加人员！", 'info');
                }
            }
		}
				
		function clearAssign(){
			top.layer.confirm("确定清除工单【${woWorksheet.woNo}】下的已选人员？",{icon: 3, title:'清除确认'},function(index){
				var tips="";
				if(pre_ids.sort().toString() == ids.sort().toString()){
					tips = "未给工单【${woWorksheet.woNo}】分配新人员！";
				}else{
					tips = "已选人员清除成功！";
				}
				ids=pre_ids.slice(0);
				selectedNodes=pre_selectedNodes;
				$.fn.zTree.init($("#selectedTree"), setting, selectedNodes);
				showTip(tips, 'info');
				top.layer.close(index);
			},function(index){
				// 取消
				showTip("取消清除操作！", 'info');
				top.layer.close(index);
			});
		}
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<div id="assignRole" class="row">
		<div class="col-sm-4" style="border-right: 1px solid #A8A8A8;">
			<p>资源池：</p>
			<div id="officeTree" class="ztree"></div>
		</div>
		<div class="col-sm-4">
			<p>站内工程师：</p>
			<div id="userTree" class="ztree"></div>
		</div>
		<div class="col-sm-4" style="padding-left:16px;border-left: 1px solid #A8A8A8;">
			<p>已选人员：</p>
			<div id="selectedTree" class="ztree"></div>
		</div>
	</div>
	</div>
</body>
</html>
