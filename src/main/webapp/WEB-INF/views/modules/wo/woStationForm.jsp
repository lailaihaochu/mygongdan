<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>站点管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=R0ixKO15Bk0xVcEmVKvNVZxb7bbTFq5S"></script>
	<script type="text/javascript">
		var map,marker,selectLat,selectLon;
		$(document).ready(function() {


			//$("#name").focus();
			$("#inputForm").validate();

			$("#areaButton").click(function(){
				var url="/wo/clientArea/treeData?woClient.id="+$("#woClientId").val();
				// 正常打开
				top.layer.open({
					type:2,
					content:"${ctx}/tag/treeselect?url=" + encodeURIComponent(url) + "&checked=&selectIds=" + $("#areaId").val(),
					title:"选择区域",
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
						$("#areaId").val(ids.join(",").replace(/u_/ig,""));
						$("#areaName").val(names.join(","));
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
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function selectPos() {
			layer.open({
			    type:1,
				content:"<div id='mapDiv' style='width=800px;height:439px;'></div><div style='width:250px;position: absolute;left: 20px;top: 20px;' class='input-group'><input id='searchLoc' class='form-control' style='width: 210px;' type='text'/><span class='input-group-btn'><a id='searchLocBtn' class='btn btn-primary' style='height: 34px;'><i class='fa fa-search'></i></a></span></div>",
				title:"选择位置",
				area:['800px','550px'],
                btn:['确定','关闭'],
                yes:function(index, layero){
					$("#lat").val(selectLat);
					$("#lon").val(selectLon);
					$("#latLon").val(selectLat+"/"+selectLon);
					layer.close(index);
				},

                cancel: function(index){ //或者使用btn2
                //按钮【按钮二】的回调

				},
				success:function(layero, index){
                    map = new BMap.Map("mapDiv");
                    map.enableScrollWheelZoom();
                    map.enableContinuousZoom();
                    var lat=parseFloat($("#lat").val())||31.219781;
                    var lon=parseFloat($("#lon").val())||121.403083;
                    var point = new BMap.Point(lon, lat);
                    map.centerAndZoom(point, 16);
                    marker = new BMap.Marker(point);
                    map.addOverlay(marker);
                    map.addEventListener("click",function (e) {
                        selectLat=e.point.lat;
                        selectLon=e.point.lng;
						marker.setPosition(e.point);
                    });
                    $("#searchLocBtn").click(function () {
                        var myGeo = new BMap.Geocoder();
                        myGeo.getPoint($("#searchLoc",layero).val(), function(point){
                            if (point) {
                                map.centerAndZoom(point, 16);
                                marker.setPosition(point);
                            }else{
                                showTip("输入的地址没有解析到结果!");
                            }
                        });
                    });
                    /*$("#searchLoc",layero).bind('input propertychange', function() {

                    });*/

                }

                });
        }
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			$(obj).parent().parent().remove();
		}
		function tableSelectCallBack(contentWindow,ele){
			var prefix=$(ele).attr("id").replace("_idId","");
			$("#"+prefix+"_phone").val(contentWindow.selectedPhone);
			$("#"+prefix+"_email").val(contentWindow.selectedEmail);
		}

	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">

	<ul class="nav nav-tabs">
		<li><a href="${ctx}/wo/woStation/">站点列表</a></li>
		<li class="active"><a href="${ctx}/wo/woStation/form?id=${woStation.id}">站点<shiro:hasPermission name="wo:woStation:edit">${not empty woStation.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="wo:woStation:edit">查看</shiro:lacksPermission></a></li>
	</ul><br/>
	<form:form id="inputForm" modelAttribute="woStation" action="${ctx}/wo/woStation/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>		
		<div class="form-group">
			<label class="col-sm-2 control-label">归属客户：</label>
			<div class="col-sm-3">
				<sys:tableselect  id="woClient" name="woClient.id" value="${woStation.woClient.id}" labelName="woClient.name" labelValue="${woStation.woClient.name}"
								   url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户"  cssClass="required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">归属区域：</label>
			<div class="col-sm-3">
				<div class="input-group">
					<input id="areaId" name="area.id" type="hidden" value="${woStation.area.id}"/>
					<input id="areaName" name="area.name" readonly="readonly" type="text" value="${woStation.area.name}"
					class="form-control "/><span class="input-group-btn"><button id="areaButton" type="button" class="btn btn-primary "><i class="fa fa-search" ></i>&nbsp;</button></span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">项目经理：</label>
			<div class="col-sm-3">
				<sys:treeselect id="pm" name="pm.id" value="${woStation.pm.id}" labelName="pmName" labelValue="${woStation.pm.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="input-xxlarge required" allowClear="true" notAllowSelectParent="true"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">站点名称：</label>
			<div class="col-sm-3">
				<form:input path="name" htmlEscape="false" maxlength="200" class="form-control required"/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">定位：</label>
			<div class="col-sm-3">
				<form:hidden path="lat" />
				<form:hidden path="lon"/>
				<div class="input-group">
					<input id="latLon" class="form-control" readonly value="${woStation.lat}/${woStation.lon}">
					<span class="input-group-btn"><button type="button" class="btn btn-primary" onclick="selectPos();"><i class="fa fa-map-marker" ></i>&nbsp;</button></span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">地址：</label>
			<div class="col-sm-4">
				<form:input path="addr" htmlEscape="false" maxlength="255" class="form-control "/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">交通费：</label>
			<div class="col-sm-4">
				<form:input path="trafficFee" htmlEscape="false" maxlength="100" class="form-control "/>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">站点描述：</label>
			<div class="col-sm-6">
				<form:textarea path="description" htmlEscape="false" rows="4" maxlength="255" class="form-control "/>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">联系人：</label>
			<div class="col-sm-8">
				<table id="contentTable" class="table table-striped table-bordered table-condensed">
					<thead>
					<tr>
						<th>姓名</th>
						<th>联系电话</th>
						<th>邮箱</th>
						<th>操作</th>
					</tr>
					</thead>
					<tbody id="contactList">
					</tbody>
					<shiro:hasPermission name="wo:woStation:edit"><tfoot>
					<tr><td colspan="4"><a href="javascript:" onclick="addRow('#contactList', contactRowIdx, contactTpl);contactRowIdx = contactRowIdx + 1;" class="btn btn-primary">新增</a></td></tr>
					</tfoot></shiro:hasPermission>
				</table>
				<script type="text/template" id="contactTpl">//<!--
						<tr id="contactList{{idx}}">
							<td class="col-sm-4">
							<input id="contactList{{idx}}_id" name="contactList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
							<sys:tableselect id="contactList{{idx}}_id" name="contactList[{{idx}}]_id" value="{{row.id}}" labelName="contactList{{idx}}_name" labelValue="{{row.name}}"
								title="选择联系人" url="${ctx}/wo/woEmployee/tableSelect?id=" paramEle="Id" callBack="tableSelectCallBack"/>
							</td>
							<td class="col-sm-4"><input id="contactList{{idx}}_phone" readonly=true name="contactList[{{idx}}].phone" type="text" value="{{row.phone}}" maxlength="100" class="form-control"/></td>
							<td class="col-sm-4">
								<input id="contactList{{idx}}_email" readonly=true name="contactList[{{idx}}].email" type="text" value="{{row.email}}" maxlength="255" class="form-control"/>
							</td>
							<shiro:hasPermission name="wo:woStation:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#contactList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
				</script>
				<script type="text/javascript">
					var contactRowIdx = 0, contactTpl = $("#contactTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
					$(document).ready(function() {
						var data = ${fns:toJson(woStation.contactList)};
						for (var i=0; i<data.length; i++){
							addRow('#contactList', contactRowIdx, contactTpl, data[i]);
							contactRowIdx = contactRowIdx + 1;
						}
					});
				</script>
			</div>
		</div>
		<div class="form-group">
			<label class="col-sm-2 control-label">运维工程师：</label>
			<div class="col-sm-8">
				<table id="userTable" class="table table-striped table-bordered table-condensed">
					<thead>
					<tr>
						<th>姓名</th>
						<th>联系电话</th>
						<th>邮箱</th>
						<th>操作</th>
					</tr>
					</thead>
					<tbody id="engineerList">

					</tbody>
					<shiro:hasPermission name="wo:woStation:edit"><tfoot>
					<tr><td colspan="4"><a href="javascript:" onclick="addRow('#engineerList', engineerRowIdx, engineerTpl);engineerRowIdx = engineerRowIdx + 1;" class="btn btn-primary">新增</a></td></tr>
					</tfoot></shiro:hasPermission>
				</table>
				<script type="text/template" id="engineerTpl">//<!--
						<tr id="contactList{{idx}}">
							<td class="col-sm-4">
							<input id="engineerList{{idx}}_id" name="engineerList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
							<sys:tableselect id="engineerList{{idx}}_id" name="engineerList[{{idx}}]_id" value="{{row.id}}" labelName="engineerList{{idx}}_name" labelValue="{{row.name}}"
								title="选择工程师" url="${ctx}/sys/user/tableSelect?id=" paramEle="Id" callBack="tableSelectCallBack"/>
							</td>
							<td class="col-sm-4"><input id="engineerList{{idx}}_phone" readonly=true name="engineerList[{{idx}}].phone" type="text" value="{{row.phone}}" maxlength="100" class="form-control"/></td>
							<td class="col-sm-4">
								<input id="engineerList{{idx}}_email" readonly=true name="engineerList[{{idx}}].email" type="text" value="{{row.email}}" maxlength="255" class="form-control"/>
							</td>
							<shiro:hasPermission name="wo:woStation:edit"><td class="text-center" width="10">
								{{#delBtn}}<span class="close" onclick="delRow(this, '#engineerList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
							</td></shiro:hasPermission>
						</tr>//-->
				</script>
				<script type="text/javascript">
					var engineerRowIdx = 0, engineerTpl = $("#engineerTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
					$(document).ready(function() {
						var data = ${fns:toJson(woStation.engineerList)};
						for (var i=0; i<data.length; i++){
							addRow('#engineerList', engineerRowIdx, engineerTpl, data[i]);
							engineerRowIdx = engineerRowIdx + 1;
						}
					});
				</script>
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
				<shiro:hasPermission name="wo:woStation:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
				<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
			</div>
		</div>

	</form:form>
</div>
</body>
</html>