<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>PO订单管理</title>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#comments").focus();
			$("#inputForm").validate();
			<c:if test="${woWorksheet.calculateType==2}">
				$("#checkAll").click(function(){
					$("input[name='worksheets']").prop("checked",$(this).prop("checked"));
				});
			</c:if>

		});
		function confirmForm(){
			if($("input[name='worksheets']:checked").length<=0){
				showTip("请选择要生成订单的工单！");
				return;
			}
			layer.open({
				type:1,
				title:"输入订单PO号",
				area:["300px","200px"],
				content:"<div style='margin: 20px;'><input type='text' id='poNo' placeholder='请输入订单PO号' class='form-control' /></div>",
				btn:["确认","取消"],
				yes:function(index,layero){
					var dataStr=$("#inputForm").serialize();
					$.ajax({
						url:"${ctx}/po/poRecord/create",
						type:"POST",
						data:dataStr+"&poNo="+$("#poNo",layero).val(),
						beforeSend:function(){
							loading();
						},
						success:function(data){
							if(data.success){
								showTip("操作成功！");
								window.location.href="${ctx}/po/poRecord/form?id="+data.data.id;
							}else{
								showTip("操作失败！"+data.msg);
							}
							layer.close(index);
						},
						complete:function(){
							top.layer.close(top.mask);
						}
					});
				}
			});
		}
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			if($("input[name='woClient.id']").val()==''){
				showTip("请选择归属客户！");
				return false;
			}
			if($("input[name='woStation.pm.id']").val()==''){
				showTip("请选择项目经理！");
				return false;
			}
			$("#searchForm").submit();
			return false;
		}
	</script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
	<ul class="nav nav-tabs">
		<li><a href="${ctx}/po/poRecord/">PO订单列表</a></li>
		<li class="active"><a href="${ctx}/po/poRecord/preForm">PO订单添加</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="woWorksheet" action="${ctx}/po/poRecord/preForm" method="post" class="form-inline well">
				<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
				<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
				<label >归属客户：</label>
				<sys:tableselect  id="woClient" name="woClient.id" value="${woWorksheet.woClient.id}" labelName="woClient.name" labelValue="${woWorksheet.woClient.name}"
								  url="${ctx}/wo/woClient/tableSelect?id=" paramEle="Id" title="选择客户" cssClass="required"/>
				<label>项目经理：</label>
				<sys:treeselect id="pm" name="woStation.pm.id" value="${woWorksheet.woStation.pm.id}" labelName="woStation.pm.name" labelValue="${woWorksheet.woStation.pm.name}"
								title="用户" url="/sys/office/treeData?type=3" cssClass="input-xxlarge required" allowClear="true" notAllowSelectParent="true"/>
				<label>是否独立核算：</label>
				<form:select id="type" path="calculateType" class="form-control chosen-select"><form:option value="" label="请选择"/><form:options items="${fns:getDictList('worksheet_cal_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/></form:select>
				<br/><br/><label>日期范围：&nbsp;</label><input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
														   value="<fmt:formatDate value="${woWorksheet.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
				<label>&nbsp;&nbsp;--&nbsp;&nbsp;&nbsp;&nbsp;</label><input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
																			value="<fmt:formatDate value="${woWorksheet.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;&nbsp;

				&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
			</form:form>
			<form:form id="inputForm" modelAttribute="poRecord" action="${ctx}/po/poRecord/form" method="post" class="form-horizontal">
				<table id="contentTable" class="table table-striped table-bordered table-condensed">
					<thead>
					<tr>
						<th><c:if test="${woWorksheet.calculateType==2}"><input type="checkbox" id="checkAll" /> </c:if><c:if test="${woWorksheet.calculateType==1}">选择</c:if> </th>
						<th>工单号</th>
						<th>WO号</th>
						<th>归属客户</th>
						<th>站点</th>
						<th>项目经理</th>
						<th>创建人</th>
						<th>完成时间</th>
					</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="worksheet">
						<tr>
							<td><input type="${woWorksheet.calculateType=="1"?"radio":"checkbox"}" name="worksheets" value="${worksheet.id}"/> </td>
							<td>
									${worksheet.woNo}
							</td>
							<td>
									${worksheet.snNo}
							</td>
							<td>
									${worksheet.woClient.name}
							</td>
							<td>
									${worksheet.woStation.name}
							</td>
							<td>
									${worksheet.woStation.pm.name}
							</td>
							<td>
									${worksheet.createBy.name}
							</td>
							<td>
								<fmt:formatDate value="${worksheet.completeTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<div class="pagination">${page}</div>
				<div class="hr-line-dashed"></div>
				<div class="form-group">
					<div class="col-sm-4 col-sm-offset-2">
						<shiro:hasPermission name="po:poRecord:edit"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="confirmForm()" value="确 认"/>&nbsp;</shiro:hasPermission>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input id="btnCancel" class="btn" type="button" value="返 回" onclick="window.location.href='${ctx}/po/poRecord/'"/>
					</div>
				</div>
			</form:form>
	</div>
</body>
</html>
