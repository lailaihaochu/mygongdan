<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="labelName" type="java.lang.String" required="true" description="输入框名称（Name）"%>
<%@ attribute name="labelValue" type="java.lang.String" required="true" description="输入框值（Name）"%>
<%@ attribute name="title" type="java.lang.String" required="true" description="选择框标题"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="表格数据地址"%>
<%@ attribute name="paramEle" type="java.lang.String" required="true" description="参数获取元素后缀" %>
<%@ attribute name="allowClear" type="java.lang.Boolean" required="false" description="是否允许清除"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="disabled" type="java.lang.String" required="false" description="是否限制选择，如果限制，设置为disabled"%>
<%@ attribute name="callBack" type="java.lang.String" required="false" description="回调函数"%>
<div class="input-group">
  <input type="hidden" name="${name}" id="${id}Id" value="${value}" ${disabled eq 'true' ? ' disabled=\'disabled\'' : ''} class="${cssClass}"/>
  <input name="${labelName}" id="${id}Name" type="text" readonly="readonly" value="${labelValue}" maxlength="50"${disabled eq "true"? " disabled=\"disabled\"":""}"
  class="form-control  ${cssClass}" style="${cssStyle} "/><span class="input-group-btn"><button id="${id}Button" type="button" class="btn btn-primary ${disabled eq 'true' ? ' disabled' : ''}"><i class="fa fa-search"></i>&nbsp;</button></span>
</div>
<script type="text/javascript">
  $("#${id}Button").click(function(){
    // 正常打开
    top.layer.open({
      type:2,
      content:"${url}"+ $("#${id}${paramEle}").val(),
      title:"${title}",
      area:['600px', '520px'],
      btn:["确定","关闭"${allowClear ? ",\"清除\"":""}],
      yes:function(index,layero){
        if(layero.find("iframe")[0].contentWindow.usable=="true"){
          $("#${id}Id").val(layero.find("iframe")[0].contentWindow.selectedId);
          $("#${id}Name").val(layero.find("iframe")[0].contentWindow.selectedLabel);
          <c:if test="${not empty callBack}">
            ${callBack}(layero.find("iframe")[0].contentWindow,$("#${id}Id"));
          </c:if>
        }else{
          showTip("无效的选择！");
        }
        top.layer.close(index);
      },
      //<c:if test="${allowClear}">
      btn3: function(index, layero){
        $("#${id}Id").val("");
        $("#${id}Name").val("");
        top.layer.close(index);
      }, //</c:if>
      success:function(layero,index){
        layero.find("iframe")[0].contentWindow.dblFunc=this.yes;
      }
    });
  });
</script>