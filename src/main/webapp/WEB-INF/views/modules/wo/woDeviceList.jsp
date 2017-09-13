<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>设备管理</title>
    <%@ include file="/WEB-INF/views/include/head.jsp"%>
    <script type="text/javascript">
        function page(n,s){
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
        $(document).ready(function() {
            $("#btnImport").click(function(){
                top.layer.open({
                    content:$("#importBox").html(),
                    title:"导入数据",
                    btn:["关闭"]
                });
            });
        });
    </script>
</head>
<body >
<div class="wrapper wrapper-content animated fadeInRight">

    <div id="importBox" class="hide ">
        <form id="importForm" action="${ctx}/wo/woDevice/import" method="post" enctype="multipart/form-data"
              style="padding-left:10px;text-align:center;" class="form-search " onsubmit="loading('正在导入，请稍等...');"><br/>
            <input id="uploadFile" name="file" type="file" />
            <br/><br/>　　
            <input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>
            <a href="${ctx}/wo/woDevice/import/template">下载模板</a>
        </form>
    </div>

    <ul class="nav nav-tabs">
        <li class="active"><a href="${ctx}/wo/woDevice/">设备信息列表</a></li>
        <shiro:hasPermission name="wo:woDevice:edit"><li><a href="${ctx}/wo/woDevice/form">设备信息添加</a></li></shiro:hasPermission>
    </ul>
    <form:form id="searchForm" modelAttribute="woDevice" action="${ctx}/wo/woDevice/" method="post" class="form-inline well">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <label>设备类型2：</label>
        <sys:treeselect id="deviceType2" name="deviceType2.id" value="${woDevice.deviceType2.id}" labelName="deviceType2.name" labelValue="${woDevice.deviceType2.name}"
                        title="设备类型" url="/wo/devCategory/treeData?type=2" cssClass="required" allowClear="true" />
        <label>设备类型3：</label>
        <sys:treeselect id="deviceType3" name="deviceType3.id" value="${woDevice.deviceType3.id}" labelName="deviceType3.name" labelValue="${woDevice.deviceType3.name}"
                        title="设备类型" url="/wo/devCategory/treeData?type=2" cssClass="required" allowClear="true" />
        <label>所属品牌&nbsp;：</label><input name="deviceBrand" value="${woDevice.deviceBrand}" type="text"class="form-control"/>
        <label>所属型号&nbsp;：</label><input name="deviceModel" value="${woDevice.deviceModel}" type="text"class="form-control"/>
        </br></br>
        <label>所属客户&nbsp;：</label><sys:tableselect  id="woClient" name="woClient.id" value="${woClient.id}" labelName="woClient.name" labelValue="${woDevice.woClient.name}" url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
        <label>所属站点&nbsp;：</label><sys:tableselect  id="woStation" name="woStation.id" value="${woStation.id}" labelName="woStation.name" labelValue="${woDevice.woStation.name}" url="${ctx}/wo/woStation/tableSelect?id=" paramEle="Id" title="选择站点" cssClass="required"/>
        <label>固定资产编号：</label><input name="assetCode" value="${woDevice.assetCode}" type="text"class="form-control"/>
        <label>SN号：</label><input name="snCode" value="${woDevice.snCode}" type="text"class="form-control"/>
        <label>设备状态：</label>
        <form:select path="devStatus" htmlEscape="false" readonly="readonly" class="form-control" >
            <form:option value="0">请选择</form:option>
            <form:option value="1">启用</form:option>
            <form:option value="2">停用</form:option>
            <form:option value="3">维修</form:option>
            <form:option value="4">退出</form:option>
        </form:select>
        </br></br>
        <label>服务起始日期：</label><form:input path="beginServiceStartDate" readonly="readonly" class="form-control Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>-<form:input path="endServiceStartDate" readonly="readonly" class="form-control Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
        <label>服务截止日期：</label><form:input path="beginServiceEndDate" readonly="readonly" class="form-control Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>-<form:input path="endServiceEndDate" readonly="readonly" class="form-control Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
        <label>服务级别：</label>
        <form:select path="serviceLevel" htmlEscape="false" readonly="readonly" class="form-control" >
            <form:option value="0">请选择</form:option>
            <form:option value="1">5x8</form:option>
            <form:option value="2">7x8</form:option>
            <form:option value="3">7x24</form:option>
        </form:select>
        </br></br>
        <label>供应商：</label><input name="supplier" value="${woDevice.supplier}" type="text"class="form-control"/>
        <label>供应商联系人：</label><input name="supplierMan" value="${woDevice.supplierMan}" type="text"class="form-control"/>
        <label>供应商联系电话：</label><input name="supplierPhone" value="${woDevice.supplierPhone}" type="text"class="form-control"/>
        </br></br>
        <label>保修截止日期：</label><form:input path="beginRepairEndDate" readonly="readonly" class="form-control Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>-<form:input path="endRepairEndDate" readonly="readonly" class="form-control Wdate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
        <%--<label>固定资产编号：</label><input name="assetCode" value="${woDevice.assetCode}" type="text"class="form-control"/>
        <label>设备名称：</label><input name="name" value="${woDevice.name}" type="text"class="form-control"/>
        <label>SN号：</label><input name="snCode" value="${woDevice.snCode}" type="text"class="form-control"/></br></br>
        <label>供应商：</label><input name="supplier" value="${woDevice.supplier}" type="text"class="form-control"/>
        <label>关键参数：</label><input name="keyParams" value="${woDevice.keyParams}" type="text"class="form-control"/></br></br>
        <label>上线日期：</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
                                   value="<fmt:formatDate value="${woDevice.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
        <label>&nbsp;&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
                                                                    value="<fmt:formatDate value="${woDevice.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;&nbsp;
        --%>
        <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
        &nbsp;<input id="btnImport" class="btn btn-primary" type="button" value="导入"/>
    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable" class="table table-striped table-bordered table-condensed">
        <thead>
        <tr>
            <th>所属客户</th>
            <th>所属站点</th>
            <th>固定资产编号</th>
            <th>设备大类</th>
            <th>设备小类</th>
            <th>设备品牌</th>
            <th>设备型号</th>
            <!--<th>上线日期</th>-->
            <th>SN号</th>
            <%--<th>设备类型</th>--%>
            <%--<th>品牌</th>--%>
            <th>设备状态</th>
            <th>服务级别</th>
            <th>服务开始时间</th>
            <th>服务结束时间</th>
            <th>供应商</th>
            <th>保修截止日期</th>
            <th>供应商联系人</th>
            <th>供应商联系电话</th>
            <shiro:hasPermission name="wo:woDevice:edit"><th>操作</th></shiro:hasPermission>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${page.list}" var="woDevice">
            <tr>
                <td>${woDevice.woClient.name}</td>
                <td>${woDevice.woStation.name}</td>
                <td><a href="${ctx}/wo/woDevice/form?id=${woDevice.id}">${woDevice.assetCode}</a></td>
                <td>${woDevice.deviceType2.name}</td>
                <td>${woDevice.deviceType3.name}</td>
                <td>${woDevice.deviceBrand}</td>
                <td>${woDevice.deviceModel}</td>
                <%--<td><fmt:formatDate value="${woDevice.onLineDate}" pattern="yyyy-MM-dd"/></td>--%>
                <td>${woDevice.snCode}</td>
                <%--<td>${woDevice.deviceType.name}</td>--%>
                <%--<td>${woDevice.deviceBrand.name}</td>--%>
                <td><%--设备状态 (1、启用2、停用3、维修4、退出(默认启用))--%>
                    <c:if test="${woDevice.devStatus == 1}">启用</c:if>
                    <c:if test="${woDevice.devStatus == 2}">停用</c:if>
                    <c:if test="${woDevice.devStatus == 3}">维修</c:if>
                    <c:if test="${woDevice.devStatus == 4}">退出</c:if>
                </td>
                <td><%--服务级别 (1、5x8  2、7x8  3、7x24)--%>
                    <c:if test="${woDevice.serviceLevel == 1}">5x8</c:if>
                    <c:if test="${woDevice.serviceLevel == 2}">7x8</c:if>
                    <c:if test="${woDevice.serviceLevel == 3}">7x24</c:if>
                </td>
                <td><fmt:formatDate value="${woDevice.serviceStartDate}" pattern="yyyy-MM-dd"/></td>
                <td><fmt:formatDate value="${woDevice.serviceEndDate}" pattern="yyyy-MM-dd"/></td>
                <td>${woDevice.supplier}</td>
                <td><fmt:formatDate value="${woDevice.repairEndDate}" pattern="yyyy-MM-dd"/></td>
                <td>${woDevice.supplierMan}</td>
                <td>${woDevice.supplierPhone}</td>
                <%--<td><span title="${woDevice.remarks}">--%>
                        <%--${fns:abbr(woDevice.remarks,50)}--%>
                <%--</span></td>--%>
                <shiro:hasPermission name="wo:woDevice:edit"><td>
                    <a href="${ctx}/wo/woDevice/form?id=${woDevice.id}">修改</a>
                    <a href="${ctx}/wo/woDevice/delete?id=${woDevice.id}" onclick="return confirmx('确认要删除该设备信息吗？', this.href)">删除</a>
                </td></shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="pagination">${page}</div>

</div>
</body>
</html>