<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>App版本管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp"%>

    <script type="text/javascript">
        $(document).ready(function() {
            $("#name").focus();
            $("#inputForm").validate();
        });

    </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/sys/appVersion/">app版本列表</a></li>
        <li class="active"><a href="${ctx}/sys/appVersion/form?id=${appVersion.id}">app版本<shiro:hasPermission name="sys:appVersion:edit">${not empty appVersion.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:appVersion:edit">查看</shiro:lacksPermission></a></li>
    </ul><br/>
    <div class="row">
        <div class="ibox">
            <form:form id="inputForm" modelAttribute="appVersion" action="${ctx}/sys/appVersion/save" method="post" class="form-horizontal">
                <form:hidden path="id"/>
                <sys:message content="${message}"/>

                <div class="form-group">
                    <label class="col-sm-2 control-label" for="appName">app名称:</label>
                    <div class="col-sm-3">
                        <form:input path="appName" htmlEscape="false" maxlength="50" class="form-control required"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label" for="verCode">app版本号:</label>
                    <div class="col-sm-3">
                        <form:input path="verCode" type="number" cssClass="form-control required" htmlEscape="false" maxlength="50"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label" for="verName">app版本:</label>
                    <div class="col-sm-3">
                        <form:input path="verName" cssClass="form-control required" htmlEscape="false" maxlength="50"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label" for="filePath">app应用文件:</label>
                    <div class="col-sm-3">
                        <form:hidden id="filePath" path="filePath" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                        <sys:ckfinder input="filePath" type="files" uploadPath="/app" selectMultiple="false" maxWidth="100" maxHeight="100" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label" for="docPath">版本说明文件:</label>
                    <div class="col-sm-3">
                        <form:hidden id="docPath" path="docPath" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                        <sys:ckfinder input="docPath" type="files" uploadPath="/doc" selectMultiple="false" maxWidth="100" maxHeight="100" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label" for="remarks">备注:</label>
                    <div class="col-sm-3">
                        <form:textarea path="remarks" cssClass="form-control" htmlEscape="false" rows="3" maxlength="200" class="input-xlarge"/>
                    </div>
                </div>
                <div class="hr-line-dashed"></div>
                <div class="form-group">
                    <div class="col-sm-4 col-sm-offset-2">
                        <shiro:hasPermission name="sys:appVersion:edit">
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
                        </shiro:hasPermission>
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>
                </div>

            </form:form>
        </div>
    </div>
</div>
</body>
</html>