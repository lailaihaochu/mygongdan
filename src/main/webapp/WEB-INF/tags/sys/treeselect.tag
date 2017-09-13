<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="labelName" type="java.lang.String" required="true" description="输入框名称（Name）"%>
<%@ attribute name="labelValue" type="java.lang.String" required="true" description="输入框值（Name）"%>
<%@ attribute name="title" type="java.lang.String" required="true" description="选择框标题"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="树结构数据地址"%>
<%@ attribute name="checked" type="java.lang.Boolean" required="false" description="是否显示复选框"%>
<%@ attribute name="extId" type="java.lang.String" required="false" description="排除掉的编号（不能选择的编号）"%>
<%@ attribute name="notAllowSelectRoot" type="java.lang.Boolean" required="false" description="不允许选择根节点"%>
<%@ attribute name="notAllowSelectParent" type="java.lang.Boolean" required="false" description="不允许选择父节点"%>
<%@ attribute name="module" type="java.lang.String" required="false" description="过滤栏目模型（只显示指定模型，仅针对CMS的Category树）"%>
<%@ attribute name="selectScopeModule" type="java.lang.Boolean" required="false" description="选择范围内的模型（控制不能选择公共模型，不能选择本栏目外的模型）（仅针对CMS的Category树）"%>
<%@ attribute name="allowClear" type="java.lang.Boolean" required="false" description="是否允许清除"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="disabled" type="java.lang.String" required="false" description="是否限制选择，如果限制，设置为disabled"%>
<%@ attribute name="nodesLevel" type="java.lang.String" required="false" description="菜单展开层数"%>
<%@ attribute name="nameLevel" type="java.lang.String" required="false" description="返回名称关联级别"%>
<%@ attribute name="callBack" type="java.lang.String" required="false" description="回调函数"%>
<div class="input-group">
	<input id="${id}Id" name="${name}" class="${cssClass}" type="hidden" value="${value}"${disabled eq 'true' ? ' disabled=\'disabled\'' : ''}/>
	<input id="${id}Name" name="${labelName}" readonly="readonly" type="text" value="${labelValue}"${disabled eq "true"? " disabled=\"disabled\"":""}"
		class="form-control ${cssClass}" style="${cssStyle} "/><span class="input-group-btn"><button id="${id}Button" type="button" class="btn btn-primary ${disabled eq 'true' ? ' disabled' : ''}"><i class="fa fa-search" ></i>&nbsp;</button></span>
</div>
<script type="text/javascript">

	$("#${id}Button").click(function(){
		// 是否限制选择，如果限制，设置为disabled
		if ($("#${id}Id").attr("disabled")){
			return true;
		}
        var nameLevel = ${nameLevel eq null ? "1" : nameLevel};
		// 正常打开	
		top.layer.open({
					type:2,
					content:"${lh}${ctx}/tag/treeselect?url=" + encodeURIComponent("${url}") + "&module=${module}&checked=${checked}&extId=${extId}&nodesLevel=${nodesLevel}&selectIds=" + $("#${id}Id").val(),
					title:"选择${title}",
					area:['300px', '420px'],
					btn:['确定','关闭'${allowClear ? ",\"清除\"":""}],
					yes:function(index, layero){ //或者使用btn1
						var ids = [],
								names = [],
								nodes = [],
								tree = layero.find("iframe")[0].contentWindow.tree; //h.find("iframe").contents();

						if ("${checked}"){
							nodes = tree.getCheckedNodes(true); //省略checked参数，等同于 true
						}else{
							nodes = tree.getSelectedNodes();
						}

						for(var i=0; i<nodes.length; i++) {//<c:if test="${checked && notAllowSelectParent}">
							if (nodes[i].isParent){
								continue; // 如果为复选框选择，则过滤掉父节点
							}//</c:if><c:if test="${notAllowSelectRoot}">
							if (nodes[i].level == 0){
								top.layer.msg("不能选择根节点（"+nodes[i].name+"）请重新选择。");
								return false;
							}//</c:if><c:if test="${notAllowSelectParent}">
							if (nodes[i].isParent){
								top.layer.msg("不能选择父节点（"+nodes[i].name+"）请重新选择。");
								return false;
							}//</c:if><c:if test="${not empty module && selectScopeModule}">
							if (nodes[i].module == ""){
								top.layer.msg("不能选择公共模型（"+nodes[i].name+"）请重新选择。");
								return false;
							}else if (nodes[i].module != "${module}"){
								top.layer.msg("不能选择当前栏目以外的栏目模型，请重新选择。");
								return false;
							}//</c:if>

							ids.push(nodes[i].id);

							names.push(nodes[i].name);//<c:if test="${!checked}">
							break; // 如果为非复选框选择，则返回第一个选择  </c:if>
						}

						$("#${id}Id").val(ids.join(",").replace(/u_/ig,""));
						$("#${id}Name").val(names.join(","));
                        <c:if test="${not empty callBack}">
                        //${callBack}(layero.find("iframe")[0].contentWindow,$("#${id}Id"));
                        ${callBack}($("#${id}Id").val());
                        </c:if>
						top.layer.close(index);
					},
					cancel: function(index){ //或者使用btn2
						//按钮【按钮二】的回调

					},
					//<c:if test="${allowClear}">
						btn3: function(index, layero){
							$("#${id}Id").val("");
							$("#${id}Name").val("");
							top.layer.close(index);
						}, //</c:if>

					success:function(layero, index){
						layero.find("iframe")[0].contentWindow.dblfunc=this.yes;
					}
		});
	});

</script>
