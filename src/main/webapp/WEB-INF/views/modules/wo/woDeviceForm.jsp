<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>设备信息管理</title>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <script type="text/javascript">
        $(document).ready(function() {
            //$("#name").focus();
            $("#inputForm").validate();

            //选择设备类型
            /*
            $("#deviceTypeButton").click(function(){
                var url="/wo/devCategory/treeData?deviceCategory.id="+$("#deviceTypeId").val();
                // 正常打开
                top.layer.open({
                    type:2,
                    content:"${ctx}/tag/treeselect?url=" + encodeURIComponent(url) + "&checked=&selectIds=" + $("#deviceTypeId").val(),
                    title:"选择类型",
                    area:['300px', '420px'],
                    btn:['确定','关闭'],
                    yes:function(index, layero){ //或者使用btn1
                        var ids = [],
                            names = [],
                            nodes = [],
                            tree = layero.find("iframe")[0].contentWindow.tree; //h.find("iframe").contents();
                        nodes = tree.getSelectedNodes();
                        for(var i=0; i<nodes.length; i++) {
                            ids.push(nodes[i].id);
                            names.push(nodes[i].name);
                            break; // 如果为非复选框选择，则返回第一个选择
                        }
                        $("#deviceTypeId").val(ids.join(",").replace(/u_/ig,""));
                        $("#deviceTypeName").val(names.join(","));
                        top.layer.close(index);
                    },
                    cancel: function(index){ //或者使用btn2
                        //按钮【按钮二】的回调
                    },
                    success:function(layero, index){
                        layero.find("iframe")[0].contentWindow.dblfunc=this.yes;
                    }
                });
            });
            //选择品牌
            $("#deviceBrandButton").click(function(){
                var url="/wo/devCategory/treeData?deviceCategory.id="+$("#deviceBrandId").val();
                // 正常打开
                top.layer.open({
                    type:2,
                    content:"${ctx}/tag/treeselect?url=" + encodeURIComponent(url) + "&checked=&selectIds=" + $("#deviceBrandId").val(),
                    title:"选择品牌",
                    area:['300px', '420px'],
                    btn:['确定','关闭'],
                    yes:function(index, layero){ //或者使用btn1
                        var ids = [],
                            names = [],
                            nodes = [],
                            tree = layero.find("iframe")[0].contentWindow.tree; //h.find("iframe").contents();
                        nodes = tree.getSelectedNodes();
                        for(var i=0; i<nodes.length; i++) {
                            ids.push(nodes[i].id);
                            names.push(nodes[i].name);
                            break; // 如果为非复选框选择，则返回第一个选择
                        }
                        $("#deviceBrandId").val(ids.join(",").replace(/u_/ig,""));
                        $("#deviceBrandName").val(names.join(","));
                        top.layer.close(index);
                    },
                    cancel: function(index){ //或者使用btn2
                        //按钮【按钮二】的回调
                    },
                    success:function(layero, index){
                        layero.find("iframe")[0].contentWindow.dblfunc=this.yes;
                    }
                });
            });
            //选择型号
            $("#deviceModelButton").click(function(){
                var url="/wo/devCategory/treeData?deviceCategory.id="+$("#deviceModelId").val();
                // 正常打开
                top.layer.open({
                    type:2,
                    content:"${ctx}/tag/treeselect?url=" + encodeURIComponent(url) + "&checked=&selectIds=" + $("#deviceModelId").val(),
                    title:"选择型号",
                    area:['300px', '420px'],
                    btn:['确定','关闭'],
                    yes:function(index, layero){ //或者使用btn1
                        var ids = [],
                            names = [],
                            nodes = [],
                            tree = layero.find("iframe")[0].contentWindow.tree; //h.find("iframe").contents();
                        nodes = tree.getSelectedNodes();
                        for(var i=0; i<nodes.length; i++) {
                            ids.push(nodes[i].id);
                            names.push(nodes[i].name);
                            break; // 如果为非复选框选择，则返回第一个选择
                        }
                        $("#deviceModelId").val(ids.join(",").replace(/u_/ig,""));
                        $("#deviceModelName").val(names.join(","));
                        top.layer.close(index);
                    },
                    cancel: function(index){ //或者使用btn2
                        //按钮【按钮二】的回调
                    },
                    success:function(layero, index){
                        layero.find("iframe")[0].contentWindow.dblfunc=this.yes;
                    }
                });
            });
            */
            $("#deviceModel").change(function(){
                var deviceModelId = $("#deviceModel").val();
                //alert("deviceModelId="+deviceModelId);
            });
        });

        function checkAssetCode(obj){
           // var b = false;
            $.ajax({
                //url: "${ctx}/wo/woWorksheet/saveWorksheetDevices?worksheetId=${woWorksheet.id}&deviceIds="+deviceIdArrays,
                url: "${ctx}/wo/woDevice/checkAssetCodeDevice?assetCode="+encodeURI(encodeURI($("#assetCode").val()))+"&deviceId="+encodeURI(encodeURI($("#deviceId").val())),
                type: "POST",
                dataType: "json",
//                beforeSend: function () {
//                    loading("设备关联中...")
//                },
                success: function (data) {
                    //debugger
                    if(!data){
                        showTip("资产编号已存在！")
                       // return false;
                    }else{
                        //b = true;
                        if(obj == 0){
                            $("#inputForm").submit();
                        }
                    }
                },
                error: function () {
                    showTip("资产编号检验异常！")
                    //return false;
                }
            });
        }

        //选择三级类别,自动填充一、二级类别
        function writeDeviceCategory(obj){
            //alert(obj);
          //  debugger
            $.ajax({
                url: "${ctx}/wo/woDevice/writeDeviceCategory?deviceTypeId="+obj,
                type: "POST",
                dataType: "json",
                success: function (data) {
                    $("#deviceType1Name").val(data.deviceType1Name);
                    $("#deviceType1Id").val(data.deviceType1Id);
                    $("#deviceType2Name").val(data.deviceType2Name);
                    $("#deviceType2Id").val(data.deviceType2Id);
                },
                error: function () {
                    showTip("设备类型自动填充异常！")
                }
            });
        }
    </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
    <ul class="nav nav-tabs">
        <li><a href="${ctx}/wo/woDevice/">设备信息列表</a></li>
        <li class="active"><a href="${ctx}/wo/woDevice/form?id=${woDevice.id}">设备信息<shiro:hasPermission name="wo:woDevice:edit">${not empty woDevice.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woDevice:edit">查看</shiro:lacksPermission></a></li>
    </ul><br/>
    <form:form id="inputForm" modelAttribute="woDevice" action="${ctx}/wo/woDevice/save" method="post" class="form-horizontal">
        <form:hidden id="deviceId" path="id"/>
        <sys:message content="${message}"/>
        <div class="form-group">
            <label class="col-sm-2 control-label">所属客户：</label>
            <div class="col-sm-3">
                <sys:tableselect  id="woClient" name="woClient.id" value="${woDevice.woClient.id}" labelName="woClient.name" labelValue="${woDevice.woClient.name}"
                                  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">所属站点：</label>
            <div class="col-sm-3">
                <sys:tableselect  id="woStation" name="woStation.id" value="${woDevice.woStation.id}" labelName="woStation.name" labelValue="${woDevice.woStation.name}"
                                  url="${ctx}/wo/woStation/tableSelect?id=" paramEle="Id" title="选择站点" cssClass="required"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备类型1：</label>
            <div class="col-sm-3">
                <input id="deviceType1Name" readonly="readonly" value="${woDevice.deviceType1.name}" class="form-control"/>
                <input id="deviceType1Id" type="hidden" name="deviceType1.id" value="${woDevice.deviceType1.id}"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备类型2：</label>
            <div class="col-sm-3">
                <input id="deviceType2Name" readonly="readonly" value="${woDevice.deviceType2.name}" class="form-control"/>
                <input id="deviceType2Id" type="hidden" name="deviceType2.id" value="${woDevice.deviceType2.id}"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备类型3：</label>
            <div class="col-sm-3">
                <sys:treeselect id="deviceType3" name="deviceType3.id" value="${woDevice.deviceType3.id}" labelName="deviceType3.name" labelValue="${woDevice.deviceType3.name}"
                                title="设备类型" url="/wo/devCategory/treeData?type=2" cssClass="required" allowClear="true"  notAllowSelectParent="true" callBack="writeDeviceCategory"/>
           </div>
           </div>
           <div class="form-group">
               <label class="col-sm-2 control-label">设备品牌：</label>
               <div class="col-sm-3">
                   <form:input path="deviceBrand" htmlEscape="false" maxlength="200" class="form-control "/>
                       <%--<sys:treeselect id="deviceBrand" name="deviceBrand.id" value="${woDevice.deviceBrand.id}" labelName="deviceBrand.name" labelValue="${woDevice.deviceBrand.name}"--%>
                                    <%--title="设备品牌" url="/wo/devCategory/treeData?deviceCategory.id=${woDevice.deviceType.id}" cssClass="required" allowClear="true"/>--%>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备型号：</label>
            <div class="col-sm-3">
                <form:input path="deviceModel" htmlEscape="false" maxlength="200" class="form-control "/>
                    <%--<sys:treeselect id="deviceModel" name="deviceModel.id" value="${woDevice.deviceModel.id}" labelName="deviceModel.name" labelValue="${woDevice.deviceModel.name}"--%>
                                    <%--title="设备型号" url="/wo/devCategory/treeData?deviceCategory.id=${woDevice.deviceBrand.id}" cssClass="required" allowClear="true"/>--%>
            </div>
        </div>
        <%--<div class="form-group">--%>
            <%--<label class="col-sm-2 control-label">设备编号：</label>--%>
            <%--<div class="col-sm-3">--%>
                <%--<form:input path="devCode" htmlEscape="false" maxlength="200" class="form-control "/>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备名称：</label>
            <div class="col-sm-3">
                <form:input path="name" htmlEscape="false" maxlength="200" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备描述：</label>
            <div class="col-sm-3">
                <form:textarea path="memo" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">固定资产编号：</label>
            <div class="col-sm-3">
                <form:input id="assetCode" path="assetCode" htmlEscape="false" maxlength="200" class="form-control " onblur="checkAssetCode(1)"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">SN号：</label>
            <div class="col-sm-3">
                <form:input path="snCode" htmlEscape="false" maxlength="200" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">设备状态：</label>
            <div class="col-sm-2">
                <form:select path="devStatus" htmlEscape="false" readonly="readonly" class="form-control" >
                    <form:option value="1">启用</form:option>
                    <form:option value="2">停用</form:option>
                    <form:option value="3">维修</form:option>
                    <form:option value="4">退出</form:option>
                </form:select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">供应商：</label>
            <div class="col-sm-3">
                <form:input path="supplier" htmlEscape="false" maxlength="200" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">供应商联系人：</label>
            <div class="col-sm-3">
                <form:input path="supplierMan" htmlEscape="false" maxlength="200" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">供应商联系电话：</label>
            <div class="col-sm-3">
                <form:input path="supplierPhone" htmlEscape="false" maxlength="200" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">关键参数：</label>
            <div class="col-sm-3">
                <form:input path="keyParams" htmlEscape="false" maxlength="200" class="form-control "/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">上线日期：</label>
            <div class="col-sm-2">
                <form:input path="onLineDate" readonly="readonly" class="form-control Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">出厂日期：</label>
            <div class="col-sm-2">
                <form:input path="manufactureDate" readonly="readonly" class="form-control Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">保修开始日期：</label>
            <div class="col-sm-2">
                <form:input path="repairStartDate" readonly="readonly" class="form-control Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">保修截止日期：</label>
            <div class="col-sm-2">
                <form:input path="repairEndDate" readonly="readonly" class="form-control Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">服务级别：</label>
            <div class="col-sm-2">
                <form:select path="serviceLevel" htmlEscape="false" readonly="readonly" class="form-control" >
                    <form:option value="1">5x8</form:option>
                    <form:option value="2">7x8</form:option>
                    <form:option value="3">7x24</form:option>
                </form:select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">服务开始日期：</label>
            <div class="col-sm-2">
                <form:input path="serviceStartDate" readonly="readonly" class="form-control Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">服务截止日期：</label>
            <div class="col-sm-2">
                <form:input path="serviceEndDate" readonly="readonly" class="form-control Wdate"
                            onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">备注：</label>
            <div class="col-sm-3">
                <form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
            </div>
        </div>
        <div class="hr-line-dashed"></div>
        <div class="form-group">
            <div class="col-sm-4 col-sm-offset-2">
                <shiro:hasPermission name="wo:woDevice:edit"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="checkAssetCode(0)" value="保 存"/>&nbsp;</shiro:hasPermission>
                <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
            </div>
        </div>

    </form:form>
</div>
</body>
</html>