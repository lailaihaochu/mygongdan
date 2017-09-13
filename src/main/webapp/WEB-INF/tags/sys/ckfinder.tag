<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="input" type="java.lang.String" required="true" description="输入框"%>
<%@ attribute name="type" type="java.lang.String" required="true" description="files、images、flash、thumb"%>
<%@ attribute name="uploadPath" type="java.lang.String" required="true" description="打开文件管理的上传路径"%>
<%@ attribute name="selectMultiple" type="java.lang.Boolean" required="false" description="是否允许多选"%>
<%@ attribute name="readonly" type="java.lang.Boolean" required="false" description="是否查看模式"%>
<%@ attribute name="maxWidth" type="java.lang.String" required="false" description="最大宽度"%>
<%@ attribute name="maxHeight" type="java.lang.String" required="false" description="最大高度"%>

<ol id="${input}Preview"></ol><c:if test="${!readonly}"><a href="javascript:" onclick="${input}FinderOpen();" class="btn btn-xs btn-primary">${selectMultiple?'添加':'选择'}</a>&nbsp;<a href="javascript:" onclick="${input}DelAll();" class="btn btn-xs btn-info ">清除</a></c:if>
<script type="text/javascript">
	function ${input}FinderOpen(){//<c:if test="${type eq 'thumb'}"><c:set var="ctype" value="images"/></c:if><c:if test="${type ne 'thumb'}"><c:set var="ctype" value="${type}"/></c:if>
		var date = new Date(), year = date.getFullYear(), month = (date.getMonth()+1)>9?date.getMonth()+1:"0"+(date.getMonth()+1);
		var url = "${ctxStatic}/plugins/ckfinder/ckfinder.html?type=${ctype}&start=${ctype}:${uploadPath}/"+year+"/"+month+
			"/&action=js&func=${input}SelectAction&thumbFunc=${input}ThumbSelectAction&cb=${input}Callback&dts=${type eq 'thumb'?'1':'0'}&sm=${selectMultiple?1:0}";
		windowOpen(url,"文件管理",1000,700);

	}
	function ${input}SelectAction(fileUrl, data, allFiles){
		var url="", files=ckfinderAPI.getSelectedFiles();
		for(var i=0; i<files.length; i++){//<c:if test="${type eq 'thumb'}">
			url += files[i].getThumbnailUrl();//</c:if><c:if test="${type ne 'thumb'}">
			url += files[i].getUrl();//</c:if>
			if (i<files.length-1) url+="|";
		}//<c:if test="${selectMultiple}">
		$("#${input}").val($("#${input}").val()+($("#${input}").val(url)==""?url:"|"+url));//</c:if><c:if test="${!selectMultiple}">
		$("#${input}").val(url);//</c:if>
		${input}Preview();
	}
	function ${input}ThumbSelectAction(fileUrl, data, allFiles){
		var url="", files=ckfinderAPI.getSelectedFiles();
		for(var i=0; i<files.length; i++){
			url += files[i].getThumbnailUrl();
			if (i<files.length-1) url+="|";
		}//<c:if test="${selectMultiple}">
		$("#${input}").val($("#${input}").val()+($("#${input}").val(url)==""?url:"|"+url));//</c:if><c:if test="${!selectMultiple}">
		$("#${input}").val(url);//</c:if>
		${input}Preview();
		//top.$.jBox.close();
	}
	function ${input}Callback(api){
		ckfinderAPI = api;
	}
	function ${input}Del(obj){
		var url = $(obj).prev().attr("url");
		$("#${input}").val($("#${input}").val().replace("|"+url,"","").replace(url+"|","","").replace(url,"",""));
		${input}Preview();
	}
	function ${input}DelAll(){
		$("#${input}").val("");
		${input}Preview();
	}
	var ${input}imgs=[],${input}dat={};
	function ${input}Preview(){
		//删除重复
		var url ="";
		var li, urls = $("#${input}").val().split("|");
		for (var i=0; i<urls.length; i++){
			if(url.indexOf(urls[i] + "|")<0) {
				url=url+urls[i]+"|";
			}
		}
		if(url.length>0) {
			url = url.substring(0,url.length-1);
		}
		$("#${input}").val(url);
		urls=url.split("|");
		$("#${input}Preview").children().remove();

		for (var i=0; i<urls.length; i++){
			if (urls[i]!=""){//<c:if test="${type eq 'thumb' || type eq 'images'}">
                ${input}imgs[i]={"alt":"","pid":i,"src":urls[i]};
				li = "<li><a href=\"javascript:void(0)\" onclick=\"${input}ShowImg(this)\" url=\""+urls[i]+"\" class=\"img-preview\" rel=\"gallery\"><img src=\""+urls[i]+"\"  layer-src=\""+urls[i]+"\" url=\""+urls[i]+"\" style=\"max-width:${empty maxWidth ? 200 : maxWidth}px;max-height:${empty maxHeight ? 200 : maxHeight}px;_height:${empty maxHeight ? 200 : maxHeight}px;border:0;padding:3px;\"></a>";//</c:if><c:if test="${type ne 'thumb' && type ne 'images'}">
				li = "<li><a href=\""+urls[i]+"\" url=\""+urls[i]+"\" target=\"_blank\">"+decodeURIComponent(urls[i].substring(urls[i].lastIndexOf("/")+1))+"</a>";//</c:if>
				li += "&nbsp;&nbsp;<c:if test="${!readonly}"><a href=\"javascript:\" onclick=\"${input}Del(this);\">×</a></c:if></li>";
				$("#${input}Preview").append(li);
			}
		}
        ${input}dat={
            "title": "", //相册标题
            "id": 123, //相册id
            "start": 0, //初始显示的图片序号，默认0
            "data": ${input}imgs
        }
		if ($("#${input}Preview").text() == ""){
			$("#${input}Preview").html("<li style='list-style:none;padding-top:5px;'>无</li>");
		}
	}
	${input}Preview();

	function ${input}ShowImg(ele) {
        //.log("click");
        // 获取元素

        var theimg = $(ele).children('img');
        var url = theimg.attr("src");

        var imgcontent = '<img src="'+url+'" class="img-responsive" >';

        var setting = {
            type: 1,
            title: false,
            skin: 'layui-layer-nobg', //没有背景色
            shadeClose: true,
            shade: 0.6, //遮罩透明度
            content: imgcontent
        }

        layer.open(setting);
    }
</script>