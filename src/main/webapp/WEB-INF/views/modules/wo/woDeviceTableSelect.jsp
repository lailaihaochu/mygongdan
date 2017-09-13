<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;">
<head>
    <title>数据选择</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <script type="text/javascript">
        var selectedId,selectedLabel,usable="true", dblFunc,invNoStr="";
        $(document).ready(function(){
            /*$("#dataTable tbody tr").dblclick(function(){
                //debugger
                //selectedId=$(this).attr("code");
                //selectedLabel=$(this).attr("codeLabel");
                var index=parent.layer.getFrameIndex(window.name);
                dblFunc(index,$("#layui-layer"+index,window.parent.document));
            });*/
            $("#dataTable tbody tr").click(function(){
//                debugger
                //selectedId=$(this).attr("code");
                //selectedLabel=$(this).attr("codeLabel");
                $(this).find("input[type=checkbox]").attr("checked",true);
                invNoStr = "";
                $("input[name='invNo'][type=checkbox]:checked").each(function(){
                    invNoStr  += this.id +  "," ;
                });
            });
        });
        function page(n,s){
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#queryForm").attr("action","${ctx}/wo/woDevice/tableSelect").submit();
            return false;
        }
    </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
    <form:form id="queryForm" modelAttribute="woDevice" action="${ctx}/wo/woDevice/tableSelect" method="post" class="well form-inline">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}"/>
        <input name="woWorksheetId" type="hidden" value="${woWorksheetId}"/>
        <div class="col-xs-5">
            <label class="col-xs-3 no-padding" style="padding-top:10px !important; ">名称：</label>
            <div class="col-xs-9 no-padding">
                <form:input id="nameFilter" path="name" htmlEscape="false" maxlength="50" class="form-control"/>
            </div>
        </div>
        <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
        <input class="btn btn-primary" type="button" value="重置" onclick="$('#nameFilter').val('');">
    </form:form>

    <table id="dataTable" class="table table-striped table-bordered table-condensed table-hover">
        <thead><tr><th>选择</th><th>品牌</th><th>型号</th><th>设备名称</th></tr><thead>
        <tbody>
        <c:forEach items="${page.list}" var="woDevice">
            <tr   code="${woDevice.id}" codeLabel="${woDevice.name}">
                <td><input id="${woDevice.id}" type="checkbox" name="invNo" class="checkbox"
                    <c:forEach items="${deviceList}" var="device">
                        <c:if test="${device.id == woDevice.id}">checked="checked"</c:if>
                    </c:forEach>
                    />
                </td>
                <td>${woDevice.deviceBrand}</td>
                <td>${woDevice.deviceModel}</td>
                <td>${woDevice.name}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="pagination">${page}</div>
</div>
</body>