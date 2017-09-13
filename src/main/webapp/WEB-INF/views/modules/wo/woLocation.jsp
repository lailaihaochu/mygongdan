<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
    <title>站点管理</title>
    <%@ include file="/WEB-INF/views/include/head.jsp"%>
    <%@ include file="/WEB-INF/views/include/treeview.jsp"%>
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=R0ixKO15Bk0xVcEmVKvNVZxb7bbTFq5S"></script>
    <style>
        .jstree-open>.jstree-anchor>.fa-folder:before{content:"\f07c"}.jstree-default .jstree-icon.none{width:0}
    </style>
    <script  type="text/javascript">
        var obj1={},obj2={};
        obj1.markerMap=[];obj2.markerMap=[];
        var tree1,tree2, setting1 = {view:{selectedMulti:false,dblClickExpand:false},check:{enable:"true",nocheckInherit:true},
            async:{enable:"true",url:"${ctx}/wo/woLocation/getEngineerStatus",autoParam:["id=officeId"],dataType:"json",dataFilter:function (treeId, parentNode, responseData) {
                /*if (responseData) {
                    obj1.dataMap=[];
                    for(var i =0; i < responseData.length; i++) {
                        obj1.dataMap[''+responseData[i].id] =responseData[i];
                    }
                }*/
                return responseData;
            }},
            data:{simpleData:{enable:true}},callback:{
                onClick:function(event, treeId, treeNode){
                    tree1.expandNode(treeNode);
                },onCheck: function(e, treeId, treeNode){
                    for(var key in obj1.markerMap){
                        map.removeOverlay(obj1.markerMap[key]);
                    }
                    var nodes = tree1.getCheckedNodes(true);
                    for (var i=0, l=nodes.length; i<l; i++) {
                        tree1.expandNode(nodes[i], true, false, false);
                        if(nodes[i].id.indexOf('u_')!=-1) {

                            var lat = parseFloat(nodes[i].lat) || 31.219781;
                            var lon = parseFloat(nodes[i].lon) || 121.403083;
                            var icon;
                            if(nodes[i].status=='1')
                                icon=normIcon;
                            else
                                icon=busyIcon;


                            var pt=new BMap.Point(lon, lat);
                            var marker = new BMap.Marker(pt,{icon:icon});
                            marker.setRotation(90);
                            var content={};
                            content.str = "<b>" + nodes[i].name + "</b>" +
                                "<br/>联系电话："+nodes[i].mobile+
                                "<br/>位置：$loc<br/>上报时间：" + nodes[i].reportDate;
                            geoc.getLocation(pt, function(rs){
                                if(rs==null){
                                    content.str=content.str.replace('$loc',"");
                                    return;
                                }
                                var addComp = rs.addressComponents;
                                content.str=content.str.replace('$loc',addComp.street+""+addComp.streetNumber);
                            });
                            map.addOverlay(marker);
                            addClickHandler(content, marker,opts);
                            obj1.markerMap[nodes[i].id] = marker;

                        }
                        //console.info(nodes[i].id);
                    }
                    return false;
                },onAsyncSuccess: function(event, treeId, treeNode, msg){
                    var nodes = tree1.getNodesByParam("pId", treeNode.id, null);
                    for (var i=0, l=nodes.length; i<l; i++) {
                        try{tree1.checkNode(nodes[i], treeNode.checked, true);}catch(e){}
                        //tree.selectNode(nodes[i], false);
                    }

                },onDblClick: function(){

                }
            }
        };
        setting2 = {view:{selectedMulti:false,dblClickExpand:false},check:{enable:"true",nocheckInherit:true},

            data:{simpleData:{enable:true}},callback:{
                onClick:function(event, treeId, treeNode){
                    tree2.expandNode(treeNode);
                },onCheck: function(e, treeId, treeNode){
                    for(var key in obj2.markerMap){
                        map.removeOverlay(obj2.markerMap[key]);
                    }
                    var nodes = tree2.getCheckedNodes(true);
                    for (var i=0, l=nodes.length; i<l; i++) {
                        tree2.expandNode(nodes[i], true, false, false);
                        if(nodes[i].id.indexOf('s_')!=-1){
                            var lat = parseFloat(nodes[i].lat) || 31.219781;
                            var lon = parseFloat(nodes[i].lon) || 121.403083;
                            var pt=new BMap.Point(lon, lat);
                            var marker = new BMap.Marker(pt,{icon:stationIcon});
                            var content={};
                            content.str = "<b>" + nodes[i].name + "</b>" +
                                "<br/>项目经理：" + nodes[i].pm +
                                "<br/>位置：$loc" +
                                "<br/>地址：" +nodes[i].addr ;
                            geoc.getLocation(pt, function(rs){
                                if(rs==null){
                                    content.str=content.str.replace('$loc',"");
                                    return;
                                }
                                var addComp = rs.addressComponents;
                                content.str=content.str.replace('$loc',addComp.street+""+addComp.streetNumber);
                            });
                            map.addOverlay(marker);

                            addClickHandler(content, marker,optsS);
                            obj2.markerMap[nodes[i].id] = marker;
                        }
                    }
                    return false;
                },onDblClick: function(){

                }
            }
        };
        function expandNodes(treeObj,nodes) {
            if (!nodes) return;
            for (var i=0, l=nodes.length; i<l; i++) {
                treeObj.expandNode(nodes[i], true, false, false);
                if (nodes[i].isParent && nodes[i].zAsync) {
                    expandNodes(treeObj,nodes[i].children);
                }
            }
        }
        $(document).ready(function(){
            $.get("${ctx}/sys/office/treeData?type=3&"
                + new Date().getTime(), function(zNodes){
                // 初始化树结构
                tree1 = $.fn.zTree.init($("#tree"), setting1, zNodes);

                // 默认展开一级节点
                var nodes = tree1.getNodesByParam("level", 0);
                for(var i=0; i<nodes.length; i++) {
                    tree1.expandNode(nodes[i], true, false, false);
                }
                //异步加载子节点（加载用户）
                var nodesOne = tree1.getNodesByParam("isParent", true);
                for(var j=0; j<nodesOne.length; j++) {
                    tree1.reAsyncChildNodes(nodesOne[j],"!refresh",true);
                }

            });
            obj1.key = $("#key");
            obj1.lastVal="";
            obj1.key.bind("focus", focusKey).bind("blur", blurKey).bind("change cut input propertychange", function () {
                searchNode(tree1,$.trim(obj1.key.get(0).value),obj1);
            });
            obj1.key.bind('keydown', function (e){if(e.which == 13){searchNode(tree1,$.trim(obj1.key.get(0).value),obj1);}});

            //站点树
            $.get("${ctx}/wo/woLocation/getStations?"
                + new Date().getTime(), function(zNodes){
                // 初始化树结构
                tree2 = $.fn.zTree.init($("#treeStation"), setting2, zNodes);

                // 默认展开一级节点
                var nodes = tree2.getNodesByParam("level", 0);
                for(var i=0; i<nodes.length; i++) {
                    tree2.expandNode(nodes[i], true, false, false);
                }

            });
            obj2.key = $("#keyStation");
            obj2.lastVal="";
            obj2.key.bind("focus", focusKey1).bind("blur", blurKey1).bind("change cut input propertychange", function () {
                searchNode(tree2,$.trim(obj2.key.get(0).value),obj2);
            });
            obj2.key.bind('keydown', function (e){if(e.which == 13){searchNode(tree2,$.trim(obj2.key.get(0).value),obj2);}});

        });


        function focusKey(e) {
            if (obj1.key.hasClass("empty")) {
                obj1.key.removeClass("empty");
            }
        }
        function blurKey(e) {
            if (obj1.key.get(0).value === "") {
                obj1.key.addClass("empty");
            }
            searchNode(tree1, $.trim(obj1.key.get(0).value),obj1);
        }
        function focusKey1(e) {
            if (obj2.key.hasClass("empty")) {
                obj2.key.removeClass("empty");
            }
        }
        function blurKey1(e) {
            if (obj2.key.get(0).value === "") {
                obj2.key.addClass("empty");
            }
            searchNode(tree2, $.trim(obj2.key.get(0).value),obj2);
        }


        //搜索节点
        function searchNode(treeObj,keyVal,obj) {


            // 按名字查询
            var keyType = "name";<%--
			if (key.hasClass("empty")) {
				value = "";
			}--%>

            // 如果和上次一次，就退出不查了。
            if (obj.lastVal === keyVal) {
                return;
            }

            // 保存最后一次
            obj.lastVal = keyVal;

            var nodes = treeObj.getNodes();
            // 如果要查空字串，就退出不查了。
            if (keyVal == "") {
                showAllNode(treeObj,nodes);
                return;
            }
            hideAllNode(treeObj,nodes);
            var nodeList = treeObj.getNodesByParamFuzzy(keyType, keyVal);
            updateNodes(treeObj,nodeList);
        }

        //隐藏所有节点
        function hideAllNode(treeObj,nodes){
            nodes = treeObj.transformToArray(nodes);
            for(var i=nodes.length-1; i>=0; i--) {
                treeObj.hideNode(nodes[i]);
            }
        }

        //显示所有节点
        function showAllNode(treeObj,nodes){
            nodes = treeObj.transformToArray(nodes);
            for(var i=nodes.length-1; i>=0; i--) {
                /* if(!nodes[i].isParent){
                 tree.showNode(nodes[i]);
                 }else{ */
                if(nodes[i].getParentNode()!=null){
                    treeObj.expandNode(nodes[i],false,false,false,false);
                }else{
                    treeObj.expandNode(nodes[i],true,true,false,false);
                }
                treeObj.showNode(nodes[i]);
                showAllNode(treeObj,nodes[i].children);
                /* } */
            }
        }

        //更新节点状态
        function updateNodes(treeObj,nodeList) {
            treeObj.showNodes(nodeList);
            for(var i=0, l=nodeList.length; i<l; i++) {

                //展开当前节点的父节点
                treeObj.showNode(nodeList[i].getParentNode());
                //tree.expandNode(nodeList[i].getParentNode(), true, false, false);
                //显示展开符合条件节点的父节点
                while(nodeList[i].getParentNode()!=null){
                    treeObj.expandNode(nodeList[i].getParentNode(), true, false, false);
                    nodeList[i] = nodeList[i].getParentNode();
                    treeObj.showNode(nodeList[i].getParentNode());
                }
                //显示根节点
                treeObj.showNode(nodeList[i].getParentNode());
                //展开根节点
                treeObj.expandNode(nodeList[i].getParentNode(), true, false, false);
            }
        }

        function refreshData() {
            obj1.key.val("");
            obj2.key.val("");
            map.clearOverlays();
            $.get("${ctx}/sys/office/treeData?type=3&"
                + new Date().getTime(), function(zNodes){
                // 初始化树结构
                tree1 = $.fn.zTree.init($("#tree"), setting1, zNodes);

                // 默认展开一级节点
                var nodes = tree1.getNodesByParam("level", 0);
                for(var i=0; i<nodes.length; i++) {
                    tree1.expandNode(nodes[i], true, false, false);
                }
                //异步加载子节点（加载用户）
                var nodesOne = tree1.getNodesByParam("isParent", true);
                for(var j=0; j<nodesOne.length; j++) {
                    tree1.reAsyncChildNodes(nodesOne[j],"!refresh",true);
                }

            });
            $.get("${ctx}/wo/woLocation/getStations?"
                + new Date().getTime(), function(zNodes){
                // 初始化树结构
                tree2 = $.fn.zTree.init($("#treeStation"), setting2, zNodes);

                // 默认展开一级节点
                var nodes = tree2.getNodesByParam("level", 0);
                for(var i=0; i<nodes.length; i++) {
                    tree2.expandNode(nodes[i], true, false, false);
                }

            });


        }

    </script>

</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content  animated fadeInRight">

        <div class="row">
            <div class="col-sm-3">
                <div class="ibox float-e-margins">

                    <div class="ibox-content">
                        <a class="pull-right" style="margin-top: 9px;margin-right: 19px; " onclick="refreshData();" ><i class="fa fa-refresh"></i>&nbsp;刷新</a>
                        <div class="tabs-container">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true">工程师</a>
                                </li>
                                <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">站点</a>
                                </li>
                            </ul>
                            <div class="tab-content">
                                <div id="tab-1" class="tab-pane active">
                                    <div id="search" class="control-group" style="padding:10px 0 0 15px;">
                                        <label for="key" class="control-label" style="float:left;padding:5px 5px 3px;">关键字：</label>
                                        <input type="text" class="empty" id="key" name="key" class="form-control" maxlength="50" style="width:110px;">

                                    </div>
                                    <div id="tree" class="ztree" style="padding:15px 20px;"></div>

                                </div>
                                <div id="tab-2" class="tab-pane ">
                                    <div id="searchStation" class="control-group" style="padding:10px 0 0 15px;">
                                        <label for="keyStation" class="control-label" style="float:left;padding:5px 5px 3px;">关键字：</label>
                                        <input type="text" class="empty" id="keyStation" name="key" maxlength="50" style="width:110px;">
                                    </div>
                                    <div id="treeStation" class="ztree" style="padding:15px 20px;"></div>

                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <div class="col-sm-9">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>实时定位</h5>

                    </div>
                    <div class="ibox-content">

                        <div id="allmap" style="height: 500px;"></div>

                </div>
            </div>
        </div>
    </div>
   
    <script>
        // 百度地图API功能
        var map = new BMap.Map("allmap");
        map.centerAndZoom(new BMap.Point(121.403083, 31.219781), 15);
        map.enableScrollWheelZoom();
        map.enableContinuousZoom();
        var geoc = new BMap.Geocoder();
        var normIcon = new BMap.Icon("${lh}${ctxStatic}/images/rykx(2).png", new BMap.Size(36, 28),{offset: new BMap.Size(10, 25)});
        var busyIcon = new BMap.Icon("${lh}${ctxStatic}/images/ryml1.png", new BMap.Size(36, 28),{offset: new BMap.Size(10, 25) });
        var stationIcon = new BMap.Icon("${lh}${ctxStatic}/images/zd3.png", new BMap.Size(35, 38),{offset: new BMap.Size(10, 25)});
        var opts = {
            width : 250,     // 信息窗口宽度
            height: 80,     // 信息窗口高度
            title : "" , // 信息窗口标题
            enableMessage:false//设置允许信息窗发送短息
        };
        var optsS={ width : 250,     // 信息窗口宽度
            height: 80,     // 信息窗口高度
            title : "" , // 信息窗口标题
            enableMessage:false//设置允许信息窗发送短息
        };
        function addClickHandler(content,marker,opts){
            marker.addEventListener("click",function(e){
                openInfo(content,e,opts)}
            );
        }
        function openInfo(content,e,opts){
            var p = e.target;
            var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
            var infoWindow = new BMap.InfoWindow(content.str,opts);  // 创建信息窗口对象
            map.openInfoWindow(infoWindow,point); //开启信息窗口
        }
    </script>
    </div>
</body>

</html>
