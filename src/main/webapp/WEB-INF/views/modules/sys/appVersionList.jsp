<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>App版本管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp"%>

    <script type="text/javascript">
        $(document).ready(function() {

        });
        function page(n,s){
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").attr("action","${ctx}/sys/appVersion/").submit();
            return false;
        }
    </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
    <ul class="nav nav-tabs">
        <li class="active"><a href="${ctx}/sys/appVersion/">app版本列表</a></li>
        <shiro:hasPermission name="sys:appVersion:edit"><li><a href="${ctx}/sys/appVersion/form">app版本添加</a></li></shiro:hasPermission>
    </ul>

    <form:form id="searchForm" modelAttribute="appVersion" action="${ctx}/sys/appVersion/" method="post" class="form-inline well">
        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <input id="orderBy" name="orderBy" type="hidden" value="${page.orderBy}"/>
        <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
        &nbsp;<label>App名称：</label><form:input path="appName" htmlEscape="false" maxlength="50" class="form-control"/>
        &nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>


    </form:form>
    <sys:message content="${message}"/>
    <table id="contentTable" class="table table-striped table-bordered table-condensed">
        <thead><tr><th class="sort-column appName">app名称</th><th class="sort-column verCode">版本号</th><th>app版本</th><th>下载路径</th><th>更新日志路径</th><th>创建人</th><th>更新人</th><shiro:hasPermission name="sys:appVersion:edit"><th>操作</th></shiro:hasPermission></tr></thead>
        <tbody>
        <c:forEach items="${page.list}" var="appVersion" varStatus="index">
            <tr>
                <td>${appVersion.appName}</td>
                <td>${appVersion.verCode}</td>
                <td>${appVersion.verName}</td>
                <td><input type="hidden" id="file${index.index}"  value="${appVersion.filePath}" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="file${index.index}" type="files" uploadPath="" maxWidth="38" maxHeight="38" readonly="true" selectMultiple="false"/></td>
                <td><input type="hidden" id="file${index.index}"  value="${appVersion.docPath}" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="file${index.index}" type="files" uploadPath="" maxWidth="38" maxHeight="38" readonly="true" selectMultiple="false"/></td>
                <td>${appVersion.createBy.name}</td>
                <td>${appVersion.updateBy.name}</td>
                <shiro:hasPermission name="sys:appVersion:edit"><td>
                    <a href="${ctx}/sys/appVersion/form?id=${appVersion.id}">修改</a>
                    <a href="${ctx}/sys/appVersion/delete?id=${appVersion.id}" onclick="return confirmx('确认要删除该版本吗？', this.href)">删除</a>
                </td></shiro:hasPermission>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="pagination">${page}</div>
</div>
</body>
</html>