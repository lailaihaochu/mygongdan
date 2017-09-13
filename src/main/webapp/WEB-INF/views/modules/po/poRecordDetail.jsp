<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>PO订单管理</title>
  <%@ include file="/WEB-INF/views/include/head.jsp"%>
  <script type="text/javascript">

    var options="<option value=''>请选择</option><option value='0'>17%销售增值税专用发票</option>" +
            "<option value='1'>11%工程安装交运增值税专用发票</option><option value='2'>6%维护服务增值税专用发票" +
            "</option><option value='3'>3%简易征收增值税专用发票</option><option value='4'>增值税普票</option>" +
            "<option value='5'>其他发票</option>";
<c:if test="${poRecord.status ne '2'}">
    var unsaved=false;
    var isFirst=true;
    </c:if>
    $(document).ready(function() {
      $("#comments").focus();
      $("#inputForm").validate();
      //$("select.bill").append(options);
      <c:if test="${poRecord.status ne '2'}">
      $("#contact,#contPhone,#seller").on("keyup",function () {
          unsaved=true;
      });
        </c:if>
      $("select.bill").on("change",selectChange);
      $("#kaiPiao,#proj,#accep").on("keyup", formatMN);
      $("#kaiPiao,#proj,#accep").on("focus",inputFocus);
      $("#kaiPiao,#proj,#accep").on("blur",inputBlur);
      $("#proj,#accep").on("blur",selectChange);
      $("#checkAll").change(function(){
        $("input[name='worksheets']").prop("checked",$(this).prop("checked"));
      });
      selectChange();
    });
    function exportBrief(sts){
      <c:if test="${poRecord.status ne '2'}">
      if(unsaved){
        confirmx("是否保存当前操作？",function(){
            saveData();
        });
        unsaved=false;
        return;
      }
      </c:if>
      confirmx("确认要导出PO订单数据吗？",function(){
        window.location.href="${ctx}/po/poRecord/briefExport?id=${poRecord.id}&sts="+sts;
      });
    }
    function passAudit(){
      $.ajax({
        url:"${ctx}/po/poRecord/passAudit?id=${poRecord.id}",
        type:"GET",
        dataType:"json",
        beforeSend:function(){
          loading();
        },
        complete:function(){
          top.layer.close(top.mask);
        },
        success:function(data){
          if(data.success){
            showTip("操作成功！");

          }else{
            showTip("操作失败！"+data.msg);
          }
        }
      });
    }
    function rejectAudit(){
      if($("input[name='worksheets']:checked").length<=0){
        showTip(" 请选择要驳回的工单！");
        return;
      }
      layer.open({
        type:1,
        title:"驳回原因",
        area:["300px","230px"],
        content:"<div style='margin:20px;'><textarea id='remarks' rows='3' class='form-control' placeholder='输入驳回原因'></textarea></div>",
        btn:["确认","关闭"],
        yes:function(index,layero){
          $.ajax({
            url:"${ctx}/po/poRecord/rejectAudit",
            type:"POST",
            data:"id=${poRecord.id}&"+$("#rejForm").serialize()+"&remarks="+$("#remarks",layero).val(),
            dataType:"json",
            beforeSend:function(){
              loading()
            },
            complete:function(){
              top.layer.close(top.mask);
            },
            success:function(data){
              layer.close(index);
              if(data.success){
                showTip("操作成功！");
              }else{
                showTip("操作失败！");
              }
            }
          });

        }
      });
    }
    function saveData(){
      $.ajax({
        url:"${ctx}/po/poRecord/ajaxSave",
        type:"POST",
        data:{id:"${poRecord.id}",seller:$("#seller").val(),contact:$("#contact").val(),contPhone:$("#contPhone").val(),
            pCost:$("#cbTot").attr("data-oral"),pNCost:$("#npbTot").attr("data-oral"),cost:$("#kaiPiao").attr("data-oral"),billType:$("select.bill").val(),shiGongFee:$("#proj").attr("data-oral"),
          kaiPiao:$("#contractM").attr("data-orig"),kpType:$("select.bill").val(),cntCost:$("#contractMC").attr("data-orig"),sellCost:$("#sellM").attr("data-orig"),
          sellTax:$("#sellTax").attr("data-orig"),incTax:$("#incTax").attr("data-oral"),otherTax:$("#otherTax").attr("data-orig"),maoli:$("#maoli").attr("data-orig"),
          maolip:$("#maolip").attr("data-orig"),totCost:$("#cmc").attr("data-orig"),cmpTax:$("#cmpTax").attr("data-orig"),pureEarn:$("#earn").attr("data-orig"),
          pureEarnp:$("#earnp").attr("data-orig"),
          zhaoDaiFee:$("#accep").attr("data-oral"),remarks:$("#remarks").val()},
        dataType:"json",
        beforeSend: function () {
          loading();
        },
        success:function(data){
          if(data.success){
            showTip("保存成功！");
          }else{
            showTip("操作失败！"+data.msg);
          }
        },
        complete: function () {
          top.layer.close(top.mask);
        }
      });
    }
    function detailClick(ele){
      if($(ele).find("i").hasClass("fa-chevron-down")){
        $("#rowSpan").attr("rowspan",parseInt($("#rowSpan").attr("rowspan"))+1);
        $(ele).find("i").removeClass("fa-chevron-down").addClass("fa-chevron-up");
      }else{
        $("#rowSpan").attr("rowspan",parseInt($("#rowSpan").attr("rowspan"))-1);
        $(ele).find("i").removeClass("fa-chevron-up").addClass("fa-chevron-down");
      }
    }
    function selectChange(){
  <c:if test="${poRecord.status ne '2'}">
        if(isFirst)
            isFirst=false;
        else
            unsaved=true;
        </c:if>
      var pm=1;
      if($("select.bill").val()=='0'){
        pm=1.17;
      }else if($("select.bill").val()=='1'){
        pm=1.11;
      }else if($("select.bill").val()=='2'){
        pm=1.06;
      }else if($("select.bill").val()=='3'){
        pm=1.03;
      }else if($("select.bill").val()=='4'){
        pm=1;
      }else if($("select.bill").val()=='5'){
        pm=1
      }else {
        return;
      }
      var kaipao=poTcbo*pm;
      $("#kaiPiao").val(fmtMoney(kaipao));
      $("#kaiPiao").attr("data-orig",kaipao);
      $("#contractM").attr("data-orig",kaipao);
      $("#contractM").html(fmtMoney(kaipao));
      $("#contractMC").attr("data-orig",kaipao);
      $("#contractMC").html(fmtMoney(kaipao));
      var cntMoney=kaipao;
      var incTax=parseFloat($("#incTax").attr("data-oral")==undefined||$("#incTax").attr("data-oral")==""?"0":$("#incTax").attr("data-oral"));
      var proj=parseFloat($("#proj").attr("data-oral")==undefined||$("#proj").attr("data-oral")==""?"0":$("#proj").attr("data-oral"));
      var accep=parseFloat($("#accep").attr("data-oral")==undefined||$("#accep").attr("data-oral")==""?"0":$("#accep").attr("data-oral"));

      var cbTot=parseFloat($("#cbTot").attr("data-oral"));
      var npbTot=parseFloat($("#npbTot").attr("data-oral"));
      var sellM=cntMoney/pm;
      var sellTax=cntMoney-sellM;
      var otherTax=sellTax-incTax<0?0:((sellTax-incTax)*1.07);
      var tempV=npbTot;
      if($("select.bill").val()=='3'){
        tempV=cbTot;
        otherTax=(sellTax-0)*1.07;
        $("#incTax").attr("data-oral",0);
        $("#incTax").html(fmtMoney(0));
      }
      $("#otherTax").attr("data-orig",otherTax);
      $("#otherTax").html(fmtMoney(otherTax));
      var maoli=sellM-tempV-((otherTax*0.07)/1.07);
      var maolip=maoli*100/sellM;
      $("#maoli").attr("data-orig",maoli);
      $("#maoli").html(fmtMoney(maoli));
      $("#maolip").attr("data-orig",maolip);
      $("#maolip").html(fmtMoney(maolip)+"%");
      var cmc=sellM*0.12;
      $("#cmc").attr("data-orig",cmc);
      $("#cmc").html(fmtMoney(cmc));
      var cmpTax=(maoli-cmc)*0.25-accep*0.1;
      if(cmpTax<0)
        cmpTax=0;
      var earn=maoli-cmc-cmpTax;
      var earnp=earn*100/sellM;
      $("#cmpTax").attr("data-orig",cmpTax);
      $("#cmpTax").html(fmtMoney(cmpTax));
      $("#earn").attr("data-orig",earn);
      $("#earn").html(fmtMoney(earn));
      $("#earnp").attr("data-orig",earnp);
      $("#earnp").html(fmtMoney(earnp)+"%");
      $("#sellM").attr("data-orig",sellM);
      $("#sellM").html(fmtMoney(sellM));
      $("#sellTax").attr("data-orig",sellTax);
      $("#sellTax").html(fmtMoney(sellTax));
      $("#contractBillType").html($("select.bill").find("option:selected").text());
    }
    function fmtMoney(s){
      if (s == "" || isNaN(s)) {
        //return "0";
        s="0";
      }
      s = parseFloat((s + "").replace(/[^\d\.\-]/g, "")).toFixed(2) + "";
      var l = s.split(".")[0].split("").reverse(),
              r = s.split(".")[1];
      var t = "";
      var temp;
      for (var i = 0; i < l.length; i++) {
        t += l[i] + ((i + 1) % 3 == 0 && (i + 1) != l.length && (l[i + 1] != '-') ? "," : "");
      }
      temp = t.split("").reverse().join("") + "." + r;
      return temp;
    }
    function inputFocus(e){
      $(this).attr("data-fmt",$(this).val()); //将当前值存入自定义属性
    }
    function inputBlur(e) {
      var oldVal = $(this).attr("data-fmt"); //获取原值
      var newVal = $(this).val(); //获取当前值
      if (oldVal != newVal) {
        if (newVal == "" || isNaN(newVal)) {
          this.value = "";
          return this.value;
        }
        var s = this.value;


        if (/.+(\..*\.|\-).*/.test(s)) {
          return;
        }
        this.value = fmtMoney(s);
        if($(this).attr("id")=="kaiPiao"){
          $("#contractM").html(this.value);
          $("#contractMC").html(this.value);
        }
        return this.value;
      }
    }
    function formatMN(e){
      this.value = this.value.replace(/[^\d\.\-]/g,"");
      $(this).attr("data-oral", parseFloat(e.target.value.replace(/[^\d\.-]/g, "")));
    }
  </script>
  <style>
    .feeTable{
      margin-bottom: 10px;
    }
    .feeTable input[type=text]{
      float: left;
      border: medium none;
      background: none repeat scroll 0 0 rgba(0,0,0,0);
    }
    .feeTable input[type=text]:focus{
      box-shadow: none;
      outline: 0;
    }
  </style>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
  <ul class="nav nav-tabs">
    <li><a href="${ctx}/po/poRecord/">PO订单列表</a></li>
    <li class="active"><a href="${ctx}/po/poRecord/form?id=${poRecord.id}&name=${poRecord.poNo}">PO订单<shiro:hasPermission name="po:poRecord:edit">${not empty poRecord.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="po:poRecord:edit">查看</shiro:lacksPermission></a></li>
  </ul>
  <table id="content" delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
    <tr>
      <td><b>甲方</b></td>
      <td  colspan="4">${poRecord.client.fullName}</td>
      <td colspan="2"><b>订单PO号</b></td>
      <td colspan="3">${poRecord.poNo}</td>
    </tr>
    <tr>
      <td><b>联系人</b></td>
      <td colspan="2"><input type="text" placeholder="请输入联系人" id="contact" value="${poRecord.contact}"/></td>
      <td><b>联系电话</b></td>
      <td><input type="text" placeholder="请输入联系电话" id="contPhone" value="${poRecord.contPhone}"/></td>
      <td><b>项目经理</b></td>
      <td>${poRecord.pm.name}</td>
      <td><b>销售</b></td>
      <td colspan="2"><input type="text" id="seller" value="${poRecord.seller}" placeholder="输入销售人员"></td>
    </tr>
    <tr>
      <td><b>乙方</b></td>
      <td colspan="4">上海金曜电子工程有限公司</td>
      <td colspan="2"><b>归属分公司</b></td>
      <td colspan="3">${poRecord.partB.name}</td>
    </tr>
    <tr>
      <td><b>项目名称</b></td>
      <td colspan="4"><input type="text" placeholder="请输入项目名称" value="${poRecord.projectName}"/></td>
      <td colspan="2"><b>评审号</b></td>
      <td colspan="3">${poRecord.snNo}</td>
    </tr>
    <tr>
      <td><b>上包合同</b></td>
      <td colspan="4"><input type="text" id="kaiPiao" data-oral="${poRecord.cost}" readonly value="${fns:fmtMoney(poRecord.cost)}" placeholder="请输入开票金额"/></td>
      <td colspan="2"><b>发票类型</b></td>
      <td colspan="3">
        <select class='bill'>
          <option value="">请选择</option>
          <c:forEach items="${fns:getDictList('bill_type')}" var="item">
            <option value="${item.value}" <c:if test="${item.value eq poRecord.billType}">selected="selected"</c:if> >${item.label}</option>
          </c:forEach>
        </select>
      </td>
    </tr>
    <tr>
      <td id="rowSpan" rowspan="${fn:length(poRecord.woWorksheets)+3}"><b>计划成本</b></td>
      <td width="3%"><input type="checkbox" id="checkAll"/> </td>
      <td  width="12%"><b>工单号</b></td>
      <td ><b>站点</b></td>
      <td width="12%"><b>WO号</b></td>
      <td width="12%"><b>成本</b></td>
      <td ><b>不含税价</b></td>
      <td ><b>增值税进项</b></td>
      <td width="12%"><b>销售金额</b></td>
      <td width="3%"></td>
    </tr>
    <c:set value="0" var="poTcb"/>
    <c:set value="0" var="poTTF"/>
    <c:set value="0" var="poTnpb"/>
    <c:set value="0" var="poTzpb"/>
    <form id="rejForm" >
    <c:forEach items="${poRecord.woWorksheets}" var="worksheet" varStatus="postatus">
      <tr>
        <td><input type="checkbox" name="worksheets" value="${worksheet.id}" /> </td>
        <td >${worksheet.woNo}</td>
        <td >${worksheet.woStation.name}</td>
        <td>${worksheet.snNo}</td>
        <td><span id="cbT${postatus.index}"></span></td>
        <td><span id="noTaxT${postatus.index}"></span></td>
        <td><span id="taxT${postatus.index}"></span></td>
        <td><span id="cbOutT${postatus.index}"></span></td>
        <td><a onclick="detailClick(this);" data-toggle='collapse'href='#feeDetail${postatus.index}'><i class="fa fa-chevron-down"></i></a></td>
      </tr>
      <tr id='feeDetail${postatus.index}' class='panel-collapse collapse' aria-expanded='false'>
        <td colspan="9">
          <div>
              <table name="cailiaoTable" delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                <thead>
                <tr>
                  <td><b>序号</b></td>
                  <td><b>材料名称</b></td>
                  <td><b>成本单价</b></td>

                  <td><b>数量</b></td>
                  <td><b>成本</b></td>

                  <td><b>票种</b></td>
                  <td><b>不含税价</b></td>
                  <td><b>增值税进项</b></td>
                  <td><b>单价</b></td>
                  <td><b>销售金额</b></td>
                </tr>
                </thead>
                <tbody>
                <c:set var="tindex" value="0"/>
                <c:set value="0" var="cailiaoCost"/>
                <c:set value="0" var="cailiaoOP"/>
                <c:set value="0" var="cailiaoNoTax"/>
                <c:set value="0" var="cailiaoTax"/>
                <c:forEach items="${worksheet.cailiaoList}" var="cailiao" varStatus="status">

                  <tr tindex="${tindex}">
                    <td>
                      <span class='tindex'>${tindex+1}</span>
                    </td>
                    <td>${cailiao.name}</td>
                    <td>${fns:fmtMoney(cailiao.price)}</td>

                    <td>${cailiao.num}</td>
                    <td>${fns:fmtMoney(cailiao.cost)}</td>

                    <c:set var="cailiaoCost" value="${cailiaoCost+cailiao.cost}"/>
                    <c:set var="cailiaoOP" value="${cailiaoOP+cailiao.outPrice}"/>
                    <td>
                      ${fns:getDictLabel(cailiao.billType,"bill_type" ,"")}
                    </td>
                    <td>${fns:fmtMoney(cailiao.npb)}</td>
                    <c:set var="cailiaoNoTax" value="${cailiaoNoTax+cailiao.npb}"/>
                    <td>${fns:fmtMoney(cailiao.zpb)}</td>
                    <td>${fns:fmtMoney(cailiao.outPer)}</td>
                    <td>${fns:fmtMoney(cailiao.outPrice)}</td>
                    <c:set value="${cailiaoTax+cailiao.zpb}" var="cailiaoTax"/>
                    <c:set value="${tindex+1}" var="tindex"/>
                  </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                <tr>
                  <td colspan="4">
                    <b>材料小计</b>
                  </td>
                  <td >
                    <span id="cailiaoxj" class="cb">${fns:fmtMoney(cailiaoCost)}</span>
                  </td>
                  <td></td>
                  <td><span id="cailiaonpb" class="npbt">${fns:fmtMoney(cailiaoNoTax)}</span></td>
                  <td><span id="cailiaozpb" class="zpbt">${fns:fmtMoney(cailiaoTax)}</span></td>
                  <td></td>
                  <td >
                    <span id="cailiaoxjO" class="cbOp">${fns:fmtMoney(cailiaoOP)}</span>
                  </td>
                </tr>
                </tfoot>
              </table>
            <table name="rengongTable"  delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
              <thead>
              <tr>
                <td ><b>序号</b></td>
                <td ><b>人工说明</b></td>
                <td ><b>成本单价</b></td>

                <td ><b>数量</b></td>
                <td ><b>成本</b></td>

                <td ><b>票种</b></td>
                <td ><b>不含税价</b></td>
                <td ><b>增值税进项</b></td>
                <td ><b>单价</b></td>
                <td ><b>销售金额</b></td>
              </tr>
              </thead>
              <tbody>
              <c:set var="tindex" value="0"/>
              <c:set value="0" var="rengongCost"/>
              <c:set value="0" var="rengongOP"/>
              <c:set value="0" var="rengongNoTax"/>
              <c:set value="0" var="rengongTax"/>
              <c:forEach items="${worksheet.rengongList}" var="rengong" varStatus="status">

                <tr tindex="${tindex}">
                  <td>
                    <span class='tindex'>${tindex+1}</span>
                  </td>
                  <td>${rengong.name}</td>
                  <td>${fns:fmtMoney(rengong.price)}</td>

                  <td>${rengong.num}</td>
                  <td>${fns:fmtMoney(rengong.cost)}</td>

                  <c:set value="${rengongCost+rengong.cost}" var="rengongCost"/>
                  <c:set value="${rengongOP+rengong.outPrice}" var="rengongOP"/>
                  <td>
                      ${fns:getDictLabel(rengong.billType,"bill_type" ,"")}
                  </td>
                  <td>${fns:fmtMoney(rengong.npb)}</td>
                  <c:set value="${rengongNoTax+rengong.npb}" var="rengongNoTax"/>
                  <td>${fns:fmtMoney(rengong.zpb)}</td>
                  <td>${fns:fmtMoney(rengong.outPer)}</td>
                  <td>${fns:fmtMoney(rengong.outPrice)}</td>
                  <c:set value="${rengongTax+rengong.zpb}" var="rengongTax"/>
                  <c:set var="tindex" value="${tindex+1}"/>
                </tr>
              </c:forEach>

              </tbody>
              <tfoot>
              <tr>
                <td colspan="4">
                  <b>人工小计</b>
                </td>
                <td >
                  <span id="rengongxj" class="cb">${fns:fmtMoney(rengongCost)}</span>
                </td>

                <td></td>
                <td><span id="rengongnpb" class="npbt">${fns:fmtMoney(rengongNoTax)}</span></td>
                <td><span id="rengongzpb" class="zpbt">${fns:fmtMoney(rengongTax)}</span></td>
                <td></td>
                <td >
                  <span id="rengongxjO" class="cb">${fns:fmtMoney(rengongOP)}</span>
                </td>

              </tr>
              </tfoot>
            </table>
            <%--    <c:set var="tindex" value="0"/>
              <table name="fenbaoTable"  delNum="0" class="hide table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                <thead>
                <tr>
                  <td ><b>序号</b></td>
                  <td ><b>分包合同名称</b></td>
                  <td ><b>分包成本</b></td>
                  <td ><b>票种</b></td>
                  <td ><b>不含税价</b></td>
                  <td ><b>增值税进项</b></td>
                </tr>
                </thead>
                <tbody>
                <c:set value="0" var="fenbaoCost"/>
                <c:set value="0" var="fenbaoNoTax"/>
                <c:set value="0" var="fenbaoTax"/>
                <c:forEach items="${worksheet.fenbaoList}" var="fenBao" varStatus="status">

                  <tr tindex="${tindex}">
                    <td>
                      <span class='tindex'>${tindex+1}</span>
                    </td>
                    <td>${fenBao.name}</td>
                    <td>${fns:fmtMoney(fenBao.cost)}</td>
                    <c:set var="fenbaoCost" value="${fenbaoCost+fenBao.cost}"/>
                    <td>
                        ${fns:getDictLabel(fenBao.billType,"bill_type" ,"")}
                    </td>
                    <td>${fns:fmtMoney(fenBao.npb)}</td>
                    <c:set var="fenbaoNoTax" value="${fenbaoNoTax+fenBao.npb}"/>
                    <td>${fns:fmtMoney(fenBao.zpb)}</td>
                    <c:set value="${fenbaoTax+fenBao.zpb}" var="fenbaoTax"/>
                    <c:set var="tindex" value="${tindex+1}"/>
                  </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                <tr>
                  <td colspan="2">
                    <b>分包小计</b>
                  </td>
                  <td>
                    <span id="fenbaoxj" class="cb">${fns:fmtMoney(fenbaoCost)}</span>
                  </td>
                  <td></td>
                  <td><span id="fenbaonpb" class="npbt">${fns:fmtMoney(fenbaoNoTax)}</span></td>
                  <td><span id="fenbaozpb" class="zpbt">${fns:fmtMoney(fenbaoTax)}</span></td>
                </tr>
                </tfoot>
              </table>



              <table name="qitaTable"  delNum="0" class="hide table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                <thead>
                <tr>
                  <td ><b>序号</b></td>
                  <td ><b>其他说明</b></td>
                  <td ><b>其他成本</b></td>
                  <td ><b>票种</b></td>
                  <td ><b>不含税价</b></td>
                  <td ><b>增值税进项</b></td>
                </tr>
                </thead>
                <tbody>
                <c:set var="tindex" value="0"/>
                <c:set value="0" var="qitaCost"/>
                <c:set value="0" var="qitaNoTax"/>
                <c:set value="0" var="qitaTax"/>
                <c:forEach items="${worksheet.qitaList}" var="qita" varStatus="status">
                  <tr tindex="${tindex}">
                    <td>
                      <span class='tindex'>${tindex+1}</span>
                    </td>
                    <td>${qita.name}</td>
                    <td>${fns:fmtMoney(qita.cost)}</td>
                    <c:set value="${qitaCost+qita.cost}" var="qitaCost"/>
                    <td>
                      ${fns:getDictLabel(qita.billType,"bill_type" ,"")}
                    </td>
                    <td>${fns:fmtMoney(qita.npb)}</td>
                    <c:set value="${qitaNoTax+qita.npb}" var="qitaNoTax"/>
                    <td>${fns:fmtMoney(qita.zpb)}</td>
                    <c:set value="${qitaTax+qita.zpb}" var="qitaTax"/>
                    <c:set var="tindex" value="${tindex+1}"/>
                  </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                <tr>
                  <td colspan="2">
                    <b>其他小计</b>
                  </td>
                  <td >
                    <span id="qitaxj" class="cb">${fns:fmtMoney(qitaCost)}</span>
                  </td>
                  <td></td>
                  <td><span id="qitanpb" class="npbt">${fns:fmtMoney(qitaNoTax)}</span></td>
                  <td><span id="qitazpb" class="zpbt">${fns:fmtMoney(qitaTax)}</span></td>
                </tr>
                </tfoot>
              </table>--%>
            <table name="jiaotongTable"  delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
              <thead>
              <tr>
                <td ><b>序号</b></td>
                <td ><b>交通费说明</b></td>
                <td ><b>成本单价</b></td>
                <td ><b>数量</b></td>
                <td ><b>成本</b></td>
                <td ><b>票种</b></td>
                <td ><b>不含税价</b></td>
                <td ><b>增值税进项</b></td>
                <td ><b>单价</b></td>
                <td ><b>销售金额</b></td>
              </tr>
              </thead>
              <tbody>
              <c:set var="tindex" value="0"/>
              <c:set value="0" var="jiaotongCost"/>
              <c:set value="0" var="jiaotongOP"/>
              <c:set value="0" var="jiaotongNoTax"/>
              <c:set value="0" var="jiaotongTax"/>
              <c:forEach items="${worksheet.qitaList}" var="jiaotong" varStatus="status">

                <tr tindex="${tindex}">
                  <td>
                    <span class='tindex'>${tindex+1}</span>
                  </td>
                  <td>${jiaotong.name}</td>
                  <td>${fns:fmtMoney(jiaotong.price)}</td>

                  <td>${jiaotong.num}</td>
                  <td>${fns:fmtMoney(jiaotong.cost)}</td>

                  <c:set value="${jiaotongCost+jiaotong.cost}" var="jiaotongCost"/>
                  <c:set value="${jiaotongOP+jiaotong.outPrice}" var="jiaotongOP"/>
                  <td>
                      ${fns:getDictLabel(jiaotong.billType,"bill_type" ,"")}
                  </td>
                  <td>${fns:fmtMoney(jiaotong.npb)}</td>
                  <c:set value="${jiaotongNoTax+jiaotong.npb}" var="jiaotongNoTax"/>
                  <td>${fns:fmtMoney(jiaotong.zpb)}</td>
                  <td>${fns:fmtMoney(jiaotong.outPer)}</td>
                  <td>${fns:fmtMoney(jiaotong.outPrice)}</td>
                  <c:set value="${jiaotongTax+jiaotong.zpb}" var="jiaotongTax"/>
                  <c:set var="tindex" value="${tindex+1}"/>
                </tr>
              </c:forEach>

              </tbody>
              <tfoot>
              <tr>
                <td colspan="4">
                  <b>交通费小计</b>
                </td>
                <td >
                  <span id="jiaotongxj" class="cb">${fns:fmtMoney(jiaotongCost)}</span>
                </td>

                <td></td>
                <td><span id="jiaotongnpb" class="npbt">${fns:fmtMoney(jiaotongNoTax)}</span></td>
                <td><span id="jiaotongzpb" class="zpbt">${fns:fmtMoney(jiaotongTax)}</span></td>
                <td></td>
                <td >
                  <span id="jiaotongxjO" class="cb">${fns:fmtMoney(jiaotongOP)}</span>
                </td>
              </tr>
              </tfoot>
            </table>
              </div>
        </td>
        <script>
            $("#cbT${postatus.index}").html("${fns:fmtMoney(cailiaoCost+rengongCost+jiaotongCost)}");
            $("#noTaxT${postatus.index}").html("${fns:fmtMoney(cailiaoNoTax+rengongNoTax+jiaotongNoTax)}");
            $("#taxT${postatus.index}").html("${fns:fmtMoney(cailiaoTax+rengongTax+jiaotongTax)}");
            $("#cbOutT${postatus.index}").html("${fns:fmtMoney(cailiaoOP+rengongOP+jiaotongOP)}");
        </script>
      </tr>
      <%--<c:set value="${cailiaoCost+fenbaoCost+rengongCost+qitaCost+poTcb}" var="poTcb"/>
      <c:set value="${cailiaoNoTax+fenbaoNoTax+rengongNoTax+qitaNoTax+poTnpb}" var="poTnpb"/>
      <c:set value="${cailiaoTax+fenbaoTax+rengongTax+qitaTax+poTzpb}" var="poTzpb"/>--%>
      <c:set value="${cailiaoOP+rengongOP+jiaotongOP+poTcbO}" var="poTcbO"/>
      <c:set value="${cailiaoCost+rengongCost+jiaotongCost+poTcb}" var="poTcb"/>
      <c:set value="${cailiaoNoTax+rengongNoTax+jiaotongNoTax+poTnpb}" var="poTnpb"/>
      <c:set value="${cailiaoTax+rengongTax+jiaotongTax+poTzpb}" var="poTzpb"/>

    </c:forEach>
    </form>
    <script>
      var poTcbo=${poTcbO};
      //$("#kaiPiao").val("${fns:fmtMoney(poTcbO)}");
      //$("#kaiPiao").attr("data-oral","${poTcbO}");
    </script>
    <tr>
      <td colspan="4" rowspan="2"><b>成本小计：</b></td>
      <td ><b>成本</b></td>

      <td><b>不计税价</b></td>
      <td ><b>增值税进项</b></td>
      <td><b>销售金额</b></td>
      <td></td>
    </tr>
    <tr>
      <td ><span id="cbTot" data-oral="${poTcb}">${fns:fmtMoney(poTcb)}</span></td>
      <td ><span id="npbTot" data-oral="${poTnpb}">${fns:fmtMoney(poTnpb)}</span></td>
      <td >${fns:fmtMoney(poTzpb)}</td>
      <td >${fns:fmtMoney(poTcbO)}</td>
      <td></td>
    </tr>
    <tr>
      <td rowspan="2"><b>销售开票和税金</b></td>
      <td ><b>开票金额</b></td>
      <td colspan="2"><b>票种</b></td>
      <td><b>合同总金额</b></td>
      <td><b>销售金额</b></td>
      <td><b>销项税额</b></td>
      <td><b>进项抵税额</b></td>
      <td colspan="2"><b>应缴增值税</b></td>
    </tr>
    <tr>
      <td><span id="contractM"></span></td>
      <td colspan="2"><span id="contractBillType"></span></td>
      <td><span id="contractMC"></span></td>
      <td><span id="sellM"></span></td>
      <td><span id="sellTax"></span></td>
      <td><span id="incTax" data-oral="${poTzpb}" >${fns:fmtMoney(poTzpb)}</span></td>
      <td colspan="2"><span id="otherTax"></span></td>
    </tr>
    <tr class="hide">
      <td><b>管理预估成本</b></td>
      <td colspan="3"><b>工程实施费</b></td>
      <%--<td colspan="2"><input type="text" id="proj" data-oral="${poRecord.shiGongFee}" value="${fns:fmtMoney(poRecord.shiGongFee)}" placeholder="请输入金额"/></td>--%>
      <td colspan="2"><input type="text" id="proj" data-oral="0" value="0.00" placeholder="请输入金额"/></td>
      <td><b>招待费</b></td>
      <%--<td colspan="3"><input type="text" id="accep" data-oral="${poRecord.zhaoDaiFee}" value="${fns:fmtMoney(poRecord.zhaoDaiFee)}" placeholder="请输入金额"/></td>--%>
      <td colspan="3"><input type="text" id="accep" data-oral="0" value="0.00" placeholder="请输入金额"/></td>
    </tr>
    <tr>
      <td><b>毛利及毛利率预估</b></td>
      <td colspan="3"><b>税后毛利</b></td>
      <td colspan="2"><span id="maoli"></span></td>
      <td><b>税后毛利率</b></td>
      <td colspan="3"><span id="maolip"></span></td>
    </tr>
    <tr>
      <td><b>综合管理费</b></td>
      <td colspan="3"><b>综合运营成本</b></td>
      <td colspan="2"><span id="cmc"></span></td>
      <td><b>企业所得税</b></td>
      <td colspan="3"><span id="cmpTax"></span></td>
    </tr>
    <tr>
      <td><b>项目净利预估</b></td>
      <td colspan="3"><b>净利润</b></td>
      <td colspan="2"><span id="earn"></span></td>
      <td><b>净利润率</b></td>
      <td colspan="3"><span id="earnp"></span></td>
    </tr>
    <tr>
      <td><b>备注</b></td>
      <td colspan="10"><input type="text" id="remarks" placeholder="备注"/></td>
    </tr>
  </table>
  <div class="hr-line-dashed"></div>
  <div class="form-group">
    <div class="col-sm-8 col-sm-offset-2">
<c:if test="${poRecord.status ne '2'}">
      <shiro:hasPermission name="po:poRecord:audit"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="passAudit()" value="审核通过"/>&nbsp;</shiro:hasPermission>
      <shiro:hasPermission name="po:poRecord:audit"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="rejectAudit()" value="审核驳回"/>&nbsp;</shiro:hasPermission>
      <shiro:hasPermission name="po:poRecord:editData"><input id="btnSubmit" class="btn btn-primary" type="button" onclick="saveData()" value="保存"/>&nbsp;</shiro:hasPermission>
  </c:if>
      <input id="btnCancel" class="btn" type="button" value="返 回" onclick="window.location.href='${ctx}/po/poRecord/'"/>&nbsp;
      <input id="btnSubmit" class="btn btn-primary" type="button" onclick="exportBrief(0)" value="导出简报"/>&nbsp;
      <input id="btnSubmit" class="btn btn-primary" type="button" onclick="exportBrief(1)" value="导出明细"/>&nbsp;
    </div>
  </div>
</div>
</body>
</html>
