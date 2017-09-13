<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="输入框名称"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="输入框值"%>
<i id="${id}Icon" class="fa fa-${not empty value?value:' hide'}"></i>&nbsp;<label id="${id}IconLabel">${not empty value?value:'无'}</label>&nbsp;
<input id="${id}" name="${name}" type="hidden" value="${value}"/><a id="${id}Button" href="javascript:" class="btn btn-primary">选择</a>&nbsp;&nbsp;
<script type="text/javascript">
	$("#${id}Button").click(function(){
		top.layer.open({
			type:2,
			content:"${ctx}/tag/iconselect?value="+$("#${id}").val(),
			title:"选择图标",
			area:[ $(document).width()-20+'px', $(top.document).height()-180+'px'],
			btn:["确定","关闭","清除"],
			yes:function( index,layero){
				var icon = layero.find("iframe")[0].contentWindow.$("#icon").val();
				$("#${id}Icon").attr("class", "fa fa-"+icon);
				$("#${id}IconLabel").text(icon);
				$("#${id}").val(icon);
				top.layer.close(index);
            },
			btn3:function(layero, index){
				$("#${id}Icon").attr("class", "fa fa- hide");
				$("#${id}IconLabel").text("无");
				$("#${id}").val("");
				top.layer.close(index);
			},
			success:function(layero, index){
				layero.find("iframe")[0].contentWindow.dblfunc=this.yes;
            }
        });
	});
</script>