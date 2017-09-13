
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>工单管理</title>
  <%@ include file="/WEB-INF/views/include/head.jsp"%>
  <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=R0ixKO15Bk0xVcEmVKvNVZxb7bbTFq5S"></script>
  <style>
    .feeTable{
      margin-bottom: 10px;
    }
    .feeTable input[type=text],.feeTable input[type=number]{
      float: left;
      border: medium none;
      background: none repeat scroll 0 0 rgba(0,0,0,0);
    }
    .feeTable input[type=text]:focus,.feeTable input[type=number]:focus{
      box-shadow: none;
      outline: 0;
    }
    tbody td,tfoot td{
      text-align:left;
    }
  </style>
  <script type="text/javascript">
    var options="<option value=''>请选择</option><option value='0'>17%销售增值税专用发票</option>" +
            "<option value='1'>11%工程安装交运增值税专用发票</option><option value='2'>6%维护服务增值税专用发票" +
            "</option><option value='3'>3%简易征收增值税专用发票</option><option value='4'>增值税普票</option>" +
            "<option value='5'>其他发票</option>";
    var totCb= 0,totOCb=0;
    $(document).ready(function() {
      var trafficFee=${empty woWorksheet.trafficFee?0:woWorksheet.trafficFee};
      var trafficFeeOut=${empty woWorksheet.trafficFeeOut?0:woWorksheet.trafficFeeOut};
      var stationFee=${empty woWorksheet.woStation.trafficFee?0:woWorksheet.woStation.trafficFee};
      if(trafficFee<=0){
        $("#trafficFee").val(fmtMoney(stationFee));
        $("#trafficFee").attr("data-oral",stationFee);
      }
      if(trafficFeeOut<=0) {
        $("#trafficFeeOut").val(fmtMoney(stationFee));
        $("#trafficFeeOut").attr("data-oral",stationFee);
      }
      $("#trafficFee").on("blur",function(){

        $("#totalCb").attr("data-oral",totCb+parseFloat($(this).attr("data-oral")));
        $("#totalCb").html(fmtMoney(totCb+parseFloat($(this).attr("data-oral"))));
      });
      $("#trafficFeeOut").on("blur",function(){

        $("#totalOCb").attr("data-oral",totOCb+parseFloat($(this).attr("data-oral")));
        $("#totalOCb").html(fmtMoney(totOCb+parseFloat($(this).attr("data-oral"))));
      });
      var tot= 0,totO=0,npbNumTot= 0,zpbNumTot=0;
      $("#cailiaoTable tbody tr").each(function(i){
        $(this).find(".tindex").html(i+1);
        var totOTemp=parseFloat($(this).find(".outPrice").attr("data-oral")==undefined?"0":$(this).find(".outPrice").attr("data-oral"));
        var totTemp=parseFloat($(this).find(".cost").attr("data-oral")==undefined?"0":$(this).find(".cost").attr("data-oral"));
        tot+=totTemp;
        totO+=totOTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $("#cailiaoTable").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $("#cailiaoTable").find(".cbOut").attr("data-oral",totO).html(fmtMoney(totO));
      $("#cailiaoTable").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $("#cailiaoTable").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));
      var tot= 0,npbNumTot= 0,zpbNumTot=0;
     /* $("#fenbaoTable tbody tr").each(function(i){
        $(this).find(".tindex").html(i+1);
        var totTemp=parseFloat($(this).find(".cost").attr("data-oral")==undefined?"0":$(this).find(".cost").attr("data-oral"));
        tot+=totTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $("#fenbaoTable").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $("#fenbaoTable").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $("#fenbaoTable").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));*/
      var tot= 0,totO=0,npbNumTot= 0,zpbNumTot=0;
      $("#rengongTable tbody tr").each(function(i){
        $(this).find(".tindex").html(i+1);
        var totOTemp=parseFloat($(this).find(".outPrice").attr("data-oral")==undefined?"0":$(this).find(".outPrice").attr("data-oral"));
        var totTemp=parseFloat($(this).find(".cost").attr("data-oral")==undefined?"0":$(this).find(".cost").attr("data-oral"));
        tot+=totTemp;
        totO+=totOTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $("#rengongTable").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $("#rengongTable").find(".cbOut").attr("data-oral",totO).html(fmtMoney(totO));
      $("#rengongTable").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $("#rengongTable").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));

      var tot= 0,totO=0,npbNumTot= 0,zpbNumTot=0;
      $("#jiaotongTable tbody tr").each(function(i){
        $(this).find(".tindex").html(i+1);
        var totOTemp=parseFloat($(this).find(".outPrice").attr("data-oral")==undefined?"0":$(this).find(".outPrice").attr("data-oral"));
        var totTemp=parseFloat($(this).find(".cost").attr("data-oral")==undefined?"0":$(this).find(".cost").attr("data-oral"));
        tot+=totTemp;
        totO+=totOTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $("#jiaotongTable").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $("#jiaotongTable").find(".cbOut").attr("data-oral",totO).html(fmtMoney(totO));
      $("#jiaotongTable").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $("#jiaotongTable").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));
     /* $("#qitaTable tbody tr").each(function(i){
        $(this).find(".tindex").html(i+1);
        var totTemp=parseFloat($(this).find(".moneyNum").attr("data-oral")==undefined?"0":$(this).find(".moneyNum").attr("data-oral"));
        tot+=totTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $("#qitaTable").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $("#qitaTable").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $("#qitaTable").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));*/

      $(".moneyNum").on("keyup", formatMN);
      $(".moneyNum").on("focus",inputFocus);
      $(".moneyNum").on("blur",inputBlur);
      $(".per").on("keyup", formatMN);
      $(".per").on("focus",inputFocus);
      $(".per").on("blur",inputBlur);
      $(".outPer").on("keyup", formatMN);
      $(".outPer").on("focus",inputFocus);
      $(".outPer").on("blur",inputBlur);
      //$("select.bill").children().remove();

      //$("select.bill").append(options);
      $("select.bill").on("change",selectChange);


      var totnpb= 0,zpbtot=0;
      $(".cb").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totCb+=tcb;
      });
      $(".cbOut").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totOCb+=tcb;
      });
      $(".npbt").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totnpb+=tcb;
      });
      $(".zpbt").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        zpbtot+=tcb;
      });
      $("#totalCb").html(fmtMoney(totCb));
      $("#totalOCb").html(fmtMoney(totOCb));
      $("#totalnpb").html(fmtMoney(totnpb));
      $("#totalzpb").html(fmtMoney(zpbtot));

        $("#deviceRelateButton").click(function(){
            top.layer.open({
                type:2,
                //content:"${ctx}/wo/woStation/tableSelect?id=${woWorksheet.woStation.id}&woClient.id="+stationId,
                content:"${ctx}/wo/woDevice/tableSelect?woStation.id=${woWorksheet.woStation.id}&woWorksheetId=${woWorksheet.id}",
                title:"关联设备",
                area:['600px', '520px'],
                btn:["确定","关闭"],
                yes:function(index,layero){
                    if(layero.find("iframe")[0].contentWindow.usable=="true"){
                          debugger
                          var deviceIdArrays = layero.find("iframe")[0].contentWindow.invNoStr;
                          if(deviceIdArrays.length > 0){
                              deviceIdArrays = deviceIdArrays.substring(0,deviceIdArrays.length-1);
                          }
                          //取出当前工单id,保存该工单关联的设备数据(aaa数组)
                          $.ajax({
                              url: "${ctx}/wo/woWorksheet/saveWorksheetDevices?worksheetId=${woWorksheet.id}&deviceIds="+deviceIdArrays,
                              type: "POST",
                              dataType: "json",
                              beforeSend: function () {
                                  loading("设备关联中...")
                              },
                              success: function (data) {
                                  debugger
                                  if(data){
                                      showTip("关联成功！");
                                  }else{
                                      showTip("关联失败！")
                                  }
                              },
                              complete: function () {
                                  top.layer.close(top.mask);
                              },
                              error: function () {
                                  showTip("关联失败！")
                              }
                          });


//                        $("#woDevice").val(layero.find("iframe")[0].contentWindow.selectedId);
//                        $("#deviceName").val(layero.find("iframe")[0].contentWindow.selectedLabel);
                    }else{
                        showTip("无效的选择！");
                    }
                    top.layer.close(index);
                },
                success:function(layero,index){
                    layero.find("iframe")[0].contentWindow.dblFunc=this.yes;
                }
            });
        });

    });
    function selectChange(){
      var npb=$(this).parents("tr").find(".npb");
      var zpb=$(this).parents("tr").find(".zpb");
      var moneyNum=parseFloat($(this).parents("tr").find(".cost").attr("data-oral"));
      var oMoneyNum=parseFloat($(this).parents("tr").find(".outPrice").attr("data-oral"));
      if($(this).val()=='0'){
        var npbNum=moneyNum/(1+0.17);
        var zpbNum=moneyNum-npbNum;
        $(npb).val(fmtMoney(npbNum));
        $(zpb).val(fmtMoney(zpbNum));
        $(npb).attr("data-oral",npbNum);
        $(zpb).attr("data-oral",zpbNum);
      }else if($(this).val()=='1'){
        var npbNum=moneyNum/(1+0.11);
        var zpbNum=moneyNum-npbNum;
        $(npb).val(fmtMoney(npbNum));
        $(zpb).val(fmtMoney(zpbNum));
        $(npb).attr("data-oral",npbNum);
        $(zpb).attr("data-oral",zpbNum);
      }else if($(this).val()=='2'){
        var npbNum=moneyNum/(1+0.06);
        var zpbNum=moneyNum-npbNum;
        $(npb).val(fmtMoney(npbNum));
        $(zpb).val(fmtMoney(zpbNum));
        $(npb).attr("data-oral",npbNum);
        $(zpb).attr("data-oral",zpbNum);
      }else if($(this).val()=='3'){
        var npbNum=moneyNum/(1+0.03);
        var zpbNum=moneyNum-npbNum;
        $(npb).val(fmtMoney(npbNum));
        $(zpb).val(fmtMoney(zpbNum));
        $(npb).attr("data-oral",npbNum);
        $(zpb).attr("data-oral",zpbNum);
      }else if($(this).val()=='4'){
        var npbNum=moneyNum/(1);
        var zpbNum=moneyNum-npbNum;
        $(npb).val(fmtMoney(npbNum));
        $(zpb).val(fmtMoney(zpbNum));
        $(npb).attr("data-oral",npbNum);
        $(zpb).attr("data-oral",zpbNum);
      }else if($(this).val()=='5'){
        var npbNum=moneyNum/(1);
        var zpbNum=moneyNum-npbNum;
        $(npb).val(fmtMoney(npbNum));
        $(zpb).val(fmtMoney(zpbNum));
        $(npb).attr("data-oral",npbNum);
        $(zpb).attr("data-oral",zpbNum);
      }
      var tot= 0,totO=0,npbNumTot= 0,zpbNumTot=0;
      $(this).parents("tbody").find("tr").each(function(){
        var totOTemp=parseFloat($(this).find(".outPrice").attr("data-oral")==undefined?"0":$(this).find(".outPrice").attr("data-oral"));
        var totTemp=parseFloat($(this).find(".cost").attr("data-oral")==undefined?"0":$(this).find(".cost").attr("data-oral"));
        tot+=totTemp;
        totO+=totOTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $(this).parents("table").find(".cbOut").attr("data-oral",totO).html(fmtMoney(totO));
      $(this).parents("table").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $(this).parents("table").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $(this).parents("table").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));
      totCb= 0;totOCb=0;
      var totnpb= 0,zpbtot=0;
      $(".cb").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totCb+=tcb;
      });
      $(".cbOut").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totOCb+=tcb;
      });
      $(".npbt").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totnpb+=tcb;
      });
      $(".zpbt").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        zpbtot+=tcb;
      });
      $("#totalCb").html(fmtMoney(totCb+parseFloat($("#trafficFee").attr("data-oral")==undefined?0:$("#trafficFee").attr("data-oral"))));

      $("#totalOCb").html(fmtMoney(totOCb+parseFloat($("#trafficFeeOut").attr("data-oral")==undefined?0:$("#trafficFeeOut").attr("data-oral"))));
      $("#totalnpb").html(fmtMoney(totnpb));
      $("#totalzpb").html(fmtMoney(zpbtot));
    }

    function calCost(ele){
      var oPerEle=$(ele).parents("tr").find(".outPer");
      var oPer=oPerEle.attr("data-oral")==undefined?0:oPerEle.attr("data-oral");
      var perEle=$(ele).parents("tr").find(".per");
      var per=perEle.attr("data-oral")==undefined?0:perEle.attr("data-oral");
      var num=$(ele).parents("tr").find(".num").val();
      $(ele).parents("tr").find(".cost").attr("data-oral",per*num).val(fmtMoney(per*num));
      $(ele).parents("tr").find(".outPrice").attr("data-oral",oPer*num).val(fmtMoney(oPer*num));
      var tot= 0,totO=0,npbNumTot= 0,zpbNumTot=0;
      $(ele).parents("tbody").find("tr").each(function(){
        var totOTemp=parseFloat($(this).find(".outPrice").attr("data-oral")==undefined?"0":$(this).find(".outPrice").attr("data-oral"));
        var totTemp=parseFloat($(this).find(".cost").attr("data-oral")==undefined?"0":$(this).find(".cost").attr("data-oral"));
        tot+=totTemp;
        totO+=totOTemp;
        var npbTemp=parseFloat($(this).find(".npb").attr("data-oral")==undefined?"0":$(this).find(".npb").attr("data-oral"));
        npbNumTot+=npbTemp;
        var zpbTemp=parseFloat($(this).find(".zpb").attr("data-oral")==undefined?"0":$(this).find(".zpb").attr("data-oral"));
        zpbNumTot+=zpbTemp;
      });
      $(ele).parents("table").find(".cbOut").attr("data-oral",totO).html(fmtMoney(totO));
      $(ele).parents("table").find(".cb").attr("data-oral",tot).html(fmtMoney(tot));
      $(ele).parents("table").find(".npbt").attr("data-oral",npbNumTot).html(fmtMoney(npbNumTot));
      $(ele).parents("table").find(".zpbt").attr("data-oral",zpbNumTot).html(fmtMoney(zpbNumTot));
      totCb= 0;totOCb=0;
      var totnpb= 0,zpbtot=0;
      $(".cb").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totCb+=tcb;
      });
      $(".cbOut").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totOCb+=tcb;
      });
      $(".npbt").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        totnpb+=tcb;
      });
      $(".zpbt").each(function(){
        var tcb=parseFloat($(this).attr("data-oral")==undefined ?"0":$(this).attr("data-oral"));
        zpbtot+=tcb;
      });
      $("#totalCb").html(fmtMoney(totCb));

      $("#totalOCb").html(fmtMoney(totOCb));
      $("#totalnpb").html(fmtMoney(totnpb));
      $("#totalzpb").html(fmtMoney(zpbtot));
    }
    function updateAdvTime(){
      layer.open({
        type:1,
        title:"修改巡检模拟开始时间",
        area:["300px","200px"],
        content:"<div style='margin: 20px;'><input type='text' id='advTime'readonly onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});\"  class='form-control Wdate' /></div>",
        btn:["确认","取消"],
        yes:function(index,layero){
          $.ajax({
            url:"${ctx}/wo/woWorksheet/updateAdvanceTime",
            type:"POST",
            data:"id=${woWorksheet.id}&advanceTime="+$("#advTime",layero).val(),
            beforeSend:function(){
              loading();
            },
            success:function(data){
              if(data.success){
                showTip("操作成功！");
                $("#advTimeSp").html($("#advTime",layero).val());
              }else{
                showTip("操作失败！"+data.msg);
              }
              layer.close(index);
            },
            complete:function(){
              top.layer.close(top.mask);
            }
          });
        },
        success:function(layero,index){
          $("#advTime",layero).val($("#advTimeSp").html());
        }
      });
    }

    function updateWoNo(){
      layer.open({
        type:1,
        title:"输入WO号",
        area:["300px","200px"],
        content:"<div style='margin: 20px;'><input type='text' id='snNo' placeholder='请输入工单WO号' class='form-control' /></div>",
        btn:["确认","取消"],
        yes:function(index,layero){
          $.ajax({
            url:"${ctx}/wo/woWorksheet/checkSn",
            type:"GET",
            data:{oldSn:"${woWorksheet.snNo}",snNo:$("#snNo",layero).val()},
            success:function(data){
              if(data=="true"){
                $.ajax({
                  url:"${ctx}/wo/woWorksheet/updateWoNo",
                  type:"POST",
                  data:"id=${woWorksheet.id}&snNo="+$("#snNo",layero).val(),
                  beforeSend:function(){
                    loading();
                  },
                  success:function(data){
                    if(data.success){
                      showTip("操作成功！");
                      $("#woNoSp").html(data.data.snNo);
                    }else{
                      showTip("操作失败！"+data.msg);
                    }
                    layer.close(index);
                  },
                  complete:function(){
                    top.layer.close(top.mask);
                  }
                });
              }else{
                  showTip("WO号已存在！");
              }
            }
          });
        },
        success:function(layero,index){
          $("#snNo",layero).val($("#woNoSp").html());
        }
      });
    }

    function updateStatus(){
      layer.open({
        type:1,
        title:"执行情况",
        area:["300px","230px"],
        content:"<div style='margin:20px;'><textarea id='description' rows='3' class='form-control' placeholder='输入执行情况'></textarea></div>",
        btn:["确认","关闭"],
        yes:function(index,layero){
          $.ajax({
            url:"${ctx}/wo/woWorksheet/updateDes",
            type:"POST",
            data:"id=${woWorksheet.id}&description="+$("#description",layero).val(),
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
                $("#desc").html(data.data.description);
              }else{
                showTip("操作失败！");
              }
            }
          });

        },
        success:function(layero,index){
          $("#description",layero).val($("#desc").html());
        }
      });
    }

    function saveFee(sts){
      var totOCb=parseFloat($("#totalOCb").html().replace(/%2C/g,""));
      if(sts==1&&totOCb<=0){
        showTip("费用销售金额需大于0，费用提交失败！");
        return;
      }
      $.ajax({
        url:"${ctx}/wo/woWorksheet/feeAjaxSave",
        type:"POST",
        data:$("#feeForm").serialize().replace(/%2C/g,"")+"&feeStatus="+sts,
        dataType:"json",
        beforeSend:function(){
          loading();
        },
        success:function(data){
          if(data.success){
            showTip("费用列表保存成功！");
            window.location.href="${ctx}/wo/woWorksheet/detail?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}";
          }else{
            showTip("保存失败！");
          }
        },
        complete:function(){
          top.layer.close(top.mask);
        }
      });
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
        return this.value;
      }
    }
    function formatMN(e){
      this.value = this.value.replace(/[^\d\.\-]/g,"");
      $(this).attr("data-oral", parseFloat(e.target.value.replace(/[^\d\.-]/g, "")));
    }
    function cailiao(ele){
      if($(ele).children("i").hasClass("fa-plus")){
        var index=$("#cailiaoTable tbody tr").length;

        var ipt="<input type='hidden' name='feeItemList["+tIndex+"].delFlag' value='0'/> <input type='hidden' name='feeItemList["+tIndex+"].id'/> " ;
        var tr="<tr tindex='"+tIndex+"'> <td> <input type='hidden' name='feeItemList["+tIndex+"].feeType' value='1'/><span class='tindex'> "+(index-1)+"</span></td> <td><input  type='text' style='width:100px;' placeholder='请输入材料名称' name ='feeItemList["+tIndex+"].name'/></td>" +
                " <td><input  type='text' placeholder='成本单价' style='width:60px;'onblur='calCost(this);' name='feeItemList["+tIndex+"].price'  class='per'/></td>"+
                "<td><input  type='number' placeholder='数量' style='width:60px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].num' class='num' /></td>"+
                " <td><input type='text' style='width:80px;' placeholder='请输入金额' class='moneyNum cost' readonly name='feeItemList["+tIndex+"].cost'/></td>"
                +"<td><select class='bill' name='feeItemList["+tIndex+"].billType' > <option>其他票种</option> </select> </td> <td><input  type='text' style='width:80px;' readonly='readonly' name='feeItemList["+tIndex+"].npb' class='npb'/></td> " +
                "<td><input style='width:80px;'  type='text'readonly='readonly' name='feeItemList["+tIndex+"].zpb'  class='zpb'/></td>"+
                "<td><input  type='text' placeholder='单价' style='width:60px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].outPer'  class='outPer'/></td>"
                +" <td><input type='text' style='width:80px;' placeholder='请输入金额' class='moneyNum outPrice'  name='feeItemList["+tIndex+"].outPrice'/></td>"
                +"<td><a  onclick='cailiao(this)'><i class='fa fa-plus'></i>&nbsp;</a></td> </tr>";
        $("#cailiaoTable tbody").append(ipt);
        $("#cailiaoTable tbody").append(tr);
        tIndex++;
        var trEle=$("#cailiaoTable tbody tr:eq("+index+")");
        $(trEle).find(".moneyNum").on("keyup", formatMN);
        $(trEle).find(".moneyNum").on("focus",inputFocus);
        $(trEle).find(".moneyNum").on("blur",inputBlur);
        $(trEle).find(".per").on("keyup", formatMN);
        $(trEle).find(".per").on("focus",inputFocus);
        $(trEle).find(".per").on("blur",inputBlur);
        $(trEle).find(".outPer").on("keyup", formatMN);
        $(trEle).find(".outPer").on("focus",inputFocus);
        $(trEle).find(".outPer").on("blur",inputBlur);
        var selectEle=$(trEle).find("select.bill");
        $(selectEle).children().remove();
        $(selectEle).append(options);
        $(selectEle).on("change",selectChange);
        $(ele).children("i").removeClass("fa-plus").addClass("fa-times");
      }else{
        var tr=$(ele).parents("tr");
        $("input[name='feeItemList["+$(tr).attr("tindex")+"].delFlag']").val("1");
        tr.remove();
      }

      $("#cailiaoTable tbody tr").each(function(i){
        $(this).find(".tindex").html(i+1);
      });


    }

   /* function fenbao(ele){
      if($(ele).children("i").hasClass("fa-plus")){
        var index=$("#fenbaoTable tbody tr").length;
        var ipt="<input type='hidden' name='feeItemList["+tIndex+"].delFlag' value='0'/> <input type='hidden' name='feeItemList["+tIndex+"].id'/> " ;
        var tr="<tr tindex='"+tIndex+"'> <td> <input type='hidden' name='feeItemList["+tIndex+"].feeType' value='2'/><span class='tindex'> "+(index-1)+"</span></td> <td><input  type='text' placeholder='请输入分包合同说明' name ='feeItemList["+tIndex+"].name'/></td>" +
                " <td><input type='text' placeholder='请输入金额' class='moneyNum' name='feeItemList["+tIndex+"].cost'/></td> <td>"
                +"<select class='bill' name='feeItemList["+tIndex+"].billType' > <option>其他票种</option> </select> </td> <td><input  type='text' readonly='readonly' name='feeItemList["+tIndex+"].npb' class='npb'/></td> " +
                "<td><input  type='text'readonly='readonly' name='feeItemList["+tIndex+"].zpb'  class='zpb'/></td>"
                +"<td><a  onclick='fenbao(this)'><i class='fa fa-plus'></i>&nbsp;</a></td> </tr>";
        $("#fenbaoTable tbody").append(ipt);
        $("#fenbaoTable tbody").append(tr);
        tIndex++;
        var trEle=$("#fenbaoTable tbody tr:eq("+index+")");
        $(trEle).find(".moneyNum").on("keyup", formatMN);
        $(trEle).find(".moneyNum").on("focus",inputFocus);
        $(trEle).find(".moneyNum").on("blur",inputBlur);
        var selectEle=$(trEle).find("select.bill");
        $(selectEle).children().remove();
        $(selectEle).append(options);
        $(selectEle).on("change",selectChange);
        $(ele).children("i").removeClass("fa-plus").addClass("fa-times");
      }else{
        var tr=$(ele).parents("tr");
        $("input[name='feeItemList["+$(tr).attr("tindex")+"].delFlag]'").val("1");
        tr.remove();
      }

      $("#fenbaoTable tbody tr").each(function(i){

        $(this).find(".tindex").html(i+1);
      });


    }
*/
    function rengong(ele) {
      if ($(ele).children("i").hasClass("fa-plus")) {
        var index = $("#rengongTable tbody tr").length;
        var ipt="<input type='hidden' name='feeItemList["+tIndex+"].delFlag' value='0'/> <input type='hidden' name='feeItemList["+tIndex+"].id'/> " ;
        var tr= "<tr tindex='"+tIndex+"'> <td> <input type='hidden' name='feeItemList["+tIndex+"].feeType' value='3'/><span class='tindex'> "+(index-1)+"</span></td> <td><input  type='text' style='width:100px;' placeholder='请输入人工说明' name ='feeItemList["+tIndex+"].name'/></td>" +
                " <td><input  type='text' placeholder='成本单价' style='width:60px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].price'  class='per'/></td>"+

                "<td><input  type='number' placeholder='数量' style='width:80px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].num' class='num' /></td>"+
                " <td><input type='text' placeholder='请输入金额'style='width:80px;' class='moneyNum cost' readonly  name='feeItemList["+tIndex+"].cost'/></td>"

                +"<td><select class='bill' name='feeItemList["+tIndex+"].billType' > <option>其他票种</option> </select> </td> <td><input  type='text'style='width:80px;' readonly='readonly' name='feeItemList["+tIndex+"].npb' class='npb'/></td> " +
                "<td><input  type='text'readonly='readonly' style='width:80px;'name='feeItemList["+tIndex+"].zpb'  class='zpb'/></td>"+
                " <td><input  type='text' placeholder='单价' style='width:60px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].outPer'  class='outPer'/></td>"
                +"<td><input type='text' placeholder='请输入金额'style='width:80px;' class='moneyNum outPrice'   name='feeItemList["+tIndex+"].outPrice'/></td>"
                +"<td><a  onclick='rengong(this)'><i class='fa fa-plus'></i>&nbsp;</a></td> </tr>";
        $("#rengongTable tbody").append(ipt);
        $("#rengongTable tbody").append(tr);
        tIndex++;
        var trEle=$("#rengongTable tbody tr:eq("+index+")");
        $(trEle).find(".moneyNum").on("keyup", formatMN);
        $(trEle).find(".moneyNum").on("focus",inputFocus);
        $(trEle).find(".moneyNum").on("blur",inputBlur);
        $(trEle).find(".per").on("keyup", formatMN);
        $(trEle).find(".per").on("focus",inputFocus);
        $(trEle).find(".per").on("blur",inputBlur);
        $(trEle).find(".outPer").on("keyup", formatMN);
        $(trEle).find(".outPer").on("focus",inputFocus);
        $(trEle).find(".outPer").on("blur",inputBlur);
        var selectEle=$(trEle).find("select.bill");
        $(selectEle).children().remove();
        $(selectEle).append(options);
        $(selectEle).on("change",selectChange);
        $(ele).children("i").removeClass("fa-plus").addClass("fa-times");
      } else {
        var tr=$(ele).parents("tr");
        $("input[name='feeItemList["+$(tr).attr("tindex")+"].delFlag']").val("1");
        tr.remove();
      }

      $("#rengongTable tbody tr").each(function (i) {

        $(this).find(".tindex").html(i+1);
      });
    }
    function jiaotong(ele) {
      if ($(ele).children("i").hasClass("fa-plus")) {
        var index = $("#jiaotongTable tbody tr").length;
        var ipt="<input type='hidden' name='feeItemList["+tIndex+"].delFlag' value='0'/> <input type='hidden' name='feeItemList["+tIndex+"].id'/> " ;
        var tr= "<tr tindex='"+tIndex+"'> <td> <input type='hidden' name='feeItemList["+tIndex+"].feeType' value='4'/><span class='tindex'> "+(index-1)+"</span></td> <td><input  type='text' style='width:100px;' placeholder='请输入交通费说明' name ='feeItemList["+tIndex+"].name'/></td>" +
                " <td><input  type='text' placeholder='成本单价' style='width:60px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].price'  class='per'/></td>"+

                "<td><input  type='number' placeholder='数量' style='width:80px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].num' class='num' /></td>"+
                " <td><input type='text' placeholder='请输入金额'style='width:80px;' class='moneyNum cost' readonly  name='feeItemList["+tIndex+"].cost'/></td>"

                +"<td><select class='bill' name='feeItemList["+tIndex+"].billType' > <option>其他票种</option> </select> </td> <td><input  type='text'style='width:80px;' readonly='readonly' name='feeItemList["+tIndex+"].npb' class='npb'/></td> " +
                "<td><input  type='text'readonly='readonly' style='width:80px;'name='feeItemList["+tIndex+"].zpb'  class='zpb'/></td>"+
                " <td><input  type='text' placeholder='单价' style='width:60px;' onblur='calCost(this);' name='feeItemList["+tIndex+"].outPer'  class='outPer'/></td>"
                +"<td><input type='text' placeholder='请输入金额'style='width:80px;' class='moneyNum outPrice'   name='feeItemList["+tIndex+"].outPrice'/></td>"
                +"<td><a  onclick='rengong(this)'><i class='fa fa-plus'></i>&nbsp;</a></td> </tr>";
        $("#jiaotongTable tbody").append(ipt);
        $("#jiaotongTable tbody").append(tr);
        tIndex++;
        var trEle=$("#jiaotongTable tbody tr:eq("+index+")");
        $(trEle).find(".moneyNum").on("keyup", formatMN);
        $(trEle).find(".moneyNum").on("focus",inputFocus);
        $(trEle).find(".moneyNum").on("blur",inputBlur);
        $(trEle).find(".per").on("keyup", formatMN);
        $(trEle).find(".per").on("focus",inputFocus);
        $(trEle).find(".per").on("blur",inputBlur);
        $(trEle).find(".outPer").on("keyup", formatMN);
        $(trEle).find(".outPer").on("focus",inputFocus);
        $(trEle).find(".outPer").on("blur",inputBlur);
        var selectEle=$(trEle).find("select.bill");
        $(selectEle).children().remove();
        $(selectEle).append(options);
        $(selectEle).on("change",selectChange);
        $(ele).children("i").removeClass("fa-plus").addClass("fa-times");
      } else {
        var tr=$(ele).parents("tr");
        $("input[name='feeItemList["+$(tr).attr("tindex")+"].delFlag']").val("1");
        tr.remove();
      }

      $("#jiaotongTable tbody tr").each(function (i) {

        $(this).find(".tindex").html(i+1);
      });
    }
      /*function qita(ele){
        if($(ele).children("i").hasClass("fa-plus")){
          var index=$("#qitaTable tbody tr").length;
          var ipt="<input type='hidden' name='feeItemList["+tIndex+"].delFlag' value='0'/> <input type='hidden' name='feeItemList["+tIndex+"].id'/> ";
          var tr="<tr tindex='"+tIndex+"'> <td> <input type='hidden' name='feeItemList["+tIndex+"].feeType' value='4'/><span class='tindex'> "+(index-1)+"</span></td> <td><input  type='text' placeholder='请输入其他说明' name ='feeItemList["+tIndex+"].name'/></td>" +
                  " <td><input type='text' placeholder='请输入金额' class='moneyNum' name='feeItemList["+tIndex+"].cost'/></td> <td>"
                  +"<select class='bill' name='feeItemList["+tIndex+"].billType' > <option>其他票种</option> </select> </td> <td><input  type='text' readonly='readonly' name='feeItemList["+tIndex+"].npb' class='npb'/></td> " +
                  "<td><input  type='text'readonly='readonly' name='feeItemList["+tIndex+"].zpb'  class='zpb'/></td>"
                  +"<td><a  onclick='qita(this)'><i class='fa fa-plus'></i>&nbsp;</a></td> </tr>";
          $("#qitaTable tbody").append(ipt);
          $("#qitaTable tbody").append(tr);
          tIndex++;
          var trEle=$("#qitaTable tbody tr:eq("+index+")");
          $(trEle).find(".moneyNum").on("keyup", formatMN);
          $(trEle).find(".moneyNum").on("focus",inputFocus);
          $(trEle).find(".moneyNum").on("blur",inputBlur);
          var selectEle=$(trEle).find("select.bill");
          $(selectEle).children().remove();
          $(selectEle).append(options);
          $(selectEle).on("change",selectChange);
          $(ele).children("i").removeClass("fa-plus").addClass("fa-times");
          $(ele).children("i").removeClass("fa-plus").addClass("fa-times");
        }else{
          var tr=$(ele).parents("tr");
          $("input[name='feeItemList["+$(tr).attr("tindex")+"].delFlag']").val("1");
          tr.remove();
        }

        $("#qitaTable tbody tr").each(function(i){

          $(this).find(".tindex").html(i+1);

        });
    }*/


    function needReAssign(woId,snNo){
      layer.open({
        content:$("#needReAssignBox").html(),
        title:"请求转派",
        area:['300px', '300px'],
        btn:["发送","关闭"],
        yes:function(index,layero){
          loading();
          window.location.href="${ctx}/wo/woWorksheet/needReAssign?id="+woId+"${woWorksheet.self?"&self=true":""}"+"&msg="+$("#areason",layero).val();
        },
        success:function(layero,index){
          $("#asNo",layero).html(snNo)
        }
      });
    }
    function needAssistance(woId,snNo){
      layer.open({
        content:$("#needHelpBox").html(),
        title:"请求协助",
        area:['300px', '350px'],
        btn:["发送","关闭"],
        yes:function(index,layero){
          loading();
          window.location.href="${ctx}/wo/woWorksheet/needAssistance?id="+woId+"${woWorksheet.self?"&self=true":""}"+"&nhNum="+$("#nhNum",layero).val()+"&msg="+$("#reason",layero).val();
        },
        success:function(layero,index){
          $("#sNo",layero).html(snNo)
        }
      });
    }
    function uploadFile(){
      layer.open({
        content:$("#uploadBox").html(),
        title:"上传附件",
        btn:["新增附件","上传"],
        yes:function (index,layero) {
          //var index = $("#uploadbtndiv",layero).children().length;
          $("#uploadbtndiv",layero).append("<input  name=\"files\" type=\"file\" />");
        },
        btn2:function(index,layero){
          $("#uploadForm",layero).submit();
        }
      });
    }
    var locPoints=[],posIndex=0;
    function queryLoc() {
        if($("input[name='queryEng']:checked").length<=0){
            showTip(" 请选择要回放的工程师！");
            return;
        }
        $("#queryLocBtn").attr("disabled",true);
        $.ajax({
            type:"post",
            url:"${ctx}/wo/woEngineerPos/queryHistory",
            data:{"worksheet.id":"${woWorksheet.id}","engineer.id":$("#queryLocForm")[0].queryEng.value},
            /*data:{"worksheet.id":"d0cdc73431874f9d8ae9d7efc514bf46","engineer.id":"27621b5b52984ef09b6cfddfbaf6ee5e"},*/
            success:function (data) {
                locPoints=data;
                map.clearOverlays();
                if(data.length==0){
                    showTip(" 该工程师没有位置记录数据！");
                    $("#queryLocBtn").attr("disabled",false);
                    return;
                }
                var startPos=new BMap.Point(locPoints[0].lon,locPoints[0].lat);
                var engMarker = new BMap.Marker(startPos,{icon:normIcon});
                engMarker.setRotation(90);
                map.centerAndZoom(startPos, 15);
                map.addOverlay(engMarker);
                var content = "<b>" + locPoints[posIndex].engineer.name + "</b><br/>位置：" + locPoints[posIndex].lat + "/" + locPoints[posIndex].lon + "<br/>" +
                    "上报时间："+locPoints[posIndex].reportDate;
                addClickHandler(content, engMarker);
                posIndex=1;
                setTimeout(function () {
                    resetMkPoint()
                },500);
            },error:function(){
                $("#queryLocBtn").attr("disabled",false);
            }

        });

    }
    function startWait(){
        layer.open({
            content:$("#startWaitBox").html(),
            title:"开始等待",
            btn:["提交","关闭"],
            yes:function (index,layero) {

                $.ajax({
                   url:"${ctx}/wo/woWorksheet/startWait?id=${woWorksheet.id}&reason="+$("#wreason",layero).val(),
                    type:"GET",
                    beforeSend:function () {
                      loading();
                    },
                    success:function (data) {
                        if(data.success){
                            showTip("操作成功！","success");
                            setTimeout(function () {
                                window.location.reload();
                            },1500);
                        }else{
                            showTip(data.msg,"error");
                        }
                    },
                    complete:function(){
                        top.layer.close(top.mask);
                    }
                });
                layer.close(index);
            }
        });
    }
    function endWait(){
        $.ajax({
            url:"${ctx}/wo/woWorksheet/endWait?id=${woWorksheet.id}",
            type:"GET",
            beforeSend:function () {
                loading();
            },
            success:function (data) {
                if(data.success){
                    showTip("操作成功！","success");
                    setTimeout(function () {
                        window.location.reload();
                    },1500);
                }else{
                    showTip(data.msg,"error");
                }
            },
            complete:function(){
                top.layer.close(top.mask);
            }
        });
    }
    function resetMkPoint(){
        var engMarker = new BMap.Marker(new BMap.Point(locPoints[posIndex].lon,locPoints[posIndex].lat),{icon:normIcon});
        engMarker.setRotation(90);
        map.addOverlay(engMarker);
        var content = "<b>" + locPoints[posIndex].engineer.name + "</b><br/>位置：" + locPoints[posIndex].lat + "/" + locPoints[posIndex].lon + "<br/>" +
            "上报时间："+locPoints[posIndex].reportDate;
        addClickHandler(content, engMarker);
        if(posIndex < locPoints.length-1){
            setTimeout(function(){
                posIndex++;
                resetMkPoint(posIndex);
            },100);
        }else{
            $("#queryLocBtn").attr("disabled",false);
        }
    }
    var opts = {
        width : 250,     // 信息窗口宽度
        height: 60,     // 信息窗口高度
        title : "" , // 信息窗口标题
        enableMessage:false//设置允许信息窗发送短息
    };
    function addClickHandler(content,marker){
        marker.addEventListener("click",function(e){
            openInfo(content,e)}
        );
    }
    function openInfo(content,e){
        var p = e.target;
        var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
        var infoWindow = new BMap.InfoWindow(content,opts);  // 创建信息窗口对象
        map.openInfoWindow(infoWindow,point); //开启信息窗口
    }



  </script>
</head>
<body>
<div class="wrapper wrapper-content animated fadeInRight">
  <div id="startWaitBox" class="hide">
    <div id="startWaitForm" style="text-align:center;height:auto;"  >
      <div id="waitForm" style="text-align:center;height:auto;" class="row" >

        <label style="float:left;padding-left: 10px;" > 工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单：</label><span id="woNo" style="float:left;" >${woWorksheet.woNo}</span><br/><br/>
        <label style="float:left;padding-left: 10px;">原因描述：</label><div class="col-xs-7 no-padding"><textarea id="wreason" name="reason" class="form-control" rows="4"></textarea></div>
      </div>

    </div>
  </div>
  <div id="uploadBox" class="hide ">
    <form id="uploadForm" action="${ctx}/wo/woWorksheet/upload" method="post" enctype="multipart/form-data"
          style="padding-left:10px;text-align:center;" class="form-search " onsubmit="loading('正在上传，请稍等...');"><br/>
      <div  style="text-align:center;height:auto;" class="row" >
        <input type="hidden" name="id" value="${woWorksheet.id}"/>
        <c:if test="${woWorksheet.self}">
          <input type="hidden" name="self" value="true"/>
        </c:if>
        <label style="float:left;padding-left: 10px;" > 工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单：</label><span  style="float:left;" >${woWorksheet.woNo}</span><br/><br/>
        <label style="float:left;padding-left: 10px;">附&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件：</label>
        <div class="col-xs-7 no-padding" id="uploadbtndiv">
          <input  name="files" type="file" />
        </div><br/><br/>
        <label style="float:left;padding-left: 10px;">备&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注：</label><div class="col-xs-7 no-padding"><textarea id="remark" name="remarks" class="form-control" rows="4"></textarea></div>
        </div>
    </form>
  </div>
  <div id="needReAssignBox" class="hide">
    <div id="reAssignForm" style="text-align:center;height:auto;"  >
      <div id="assignForm" style="text-align:center;height:auto;" class="row" >
        <label style="float:left;padding-left: 10px;" > 工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单：</label><span id="asNo" style="float:left;" ></span><br/><br/>
        <label style="float:left;padding-left: 10px;">原因描述：</label><div class="col-xs-7 no-padding"><textarea id="areason" name="msg" class="form-control" rows="4"></textarea></div>
      </div>

    </div>
  </div>
  <div id="needHelpBox" class="hide">
    <div id="reportForm" style="text-align:center;height:auto;"  >
      <div id="helpForm" style="text-align:center;height:auto;" class="row" >
        <label style="float:left;padding-left: 10px;" > 工&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;单：</label><span id="sNo" style="float:left;" ></span><br/><br/>
        <label style="float:left;padding-left: 10px;">协助人数：</label><div class="col-xs-7 no-padding"><input id="nhNum" type="number" class="form-control"></div><br/><br/>
        <label style="float:left;padding-left: 10px;">原因描述：</label><div class="col-xs-7 no-padding"><textarea id="reason" name="msg" class="form-control" rows="4"></textarea></div>
      </div>

    </div>
  </div>
  <ul class="nav nav-tabs">
    <li><shiro:hasPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/${woWorksheet.self?"self":""}"></shiro:hasPermission><shiro:lacksPermission name="wo:woWorksheet:manager"><a href="${ctx}/wo/woWorksheet/self"></shiro:lacksPermission>工单列表</a></li>
    <li class="active"><a href="${ctx}/wo/woWorksheet/detail?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}">工单查看</a></li>
  </ul>
  <sys:message content="${message}"/>
  <div class="ibox">
    <div class="ibox-content" style="border:0;">
      <div class="row">
        <div class="col-sm-12">
          <div class="m-b-md">
            <div class="pull-right">
            <shiro:hasPermission name="wo:woWorksheet:accept">
              <c:if test="${fns:contains(fns:getUser(),woWorksheet.unCheckedUsers )}">
                &nbsp;&nbsp; <a href="${ctx}/wo/woWorksheet/accept?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}" class="btn btn-primary btn-xs pull-right">接受工单</a>
              </c:if>
            </shiro:hasPermission>
                &nbsp;&nbsp; <a id="deviceRelateButton" href="javascript:" class="btn btn-primary btn-xs " >关联设备</a>
            <shiro:hasPermission name="wo:woWorksheet:assign">
              <c:if test="${woWorksheet.woStatus ne '5' and woWorksheet.woStatus ne '6' }">
                &nbsp;&nbsp; <a href="${ctx}/wo/woWorksheet/assign?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}" class="btn btn-primary btn-xs " >指派</a>
              </c:if>
            </shiro:hasPermission>

            <shiro:hasPermission name="wo:woWorksheet:needReAssign">
              <c:if test="${woWorksheet.woStatus eq '4'}">
                &nbsp;&nbsp; <a href="javascript:void(0)" onclick="needReAssign('${woWorksheet.id}','${woWorksheet.woNo}')" class="btn btn-primary btn-xs " >请求转派</a>
              </c:if>
            </shiro:hasPermission>
            <shiro:hasPermission name="wo:woWorksheet:needAssistance">
              <c:if test="${woWorksheet.woStatus eq '4'}">
                &nbsp;&nbsp;<a href="javascript:void(0)" onclick="needAssistance('${woWorksheet.id}','${woWorksheet.woNo}')" class="btn btn-primary btn-xs" >请求协助</a>
              </c:if>
            </shiro:hasPermission>
            <shiro:hasPermission name="wo:woWorksheet:start">
              <c:if test="${woWorksheet.envStatus ne '2'}">
                <c:if test="${woWorksheet.woStatus eq '3'}"> &nbsp;&nbsp;<a href="${ctx}/wo/woWorksheet/start?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}" onclick="return confirmx('是否要开始执行该工单？', this.href)" class="btn btn-primary btn-xs">开始</a></c:if>
                <c:if test="${woWorksheet.woStatus eq '4'}">
                  &nbsp;&nbsp;<a href="${ctx}/wo/woWorksheet/start?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}"  class="btn btn-primary btn-xs" >编辑</a>
                </c:if>
              </c:if>
            </shiro:hasPermission>
              <shiro:hasPermission name="wo:woWorksheet:close">
                <c:if test="${woWorksheet.woStatus ne '5' and woWorksheet.woStatus ne '6'}">
                  <a href="${ctx}/wo/woWorksheet/close?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}" class="btn btn-primary btn-xs">关闭</a>
                </c:if>
              </shiro:hasPermission>
              <shiro:hasPermission name="wo:woWorksheet:edit">
                <c:if test="${woWorksheet.woStatus=='1'}">
                  <a href="${ctx}/wo/woWorksheet/delete?id=${woWorksheet.id}${woWorksheet.self?"&self=true":""}" onclick="return confirmx('确认要删除该工单吗？', this.href)" class="btn btn-primary btn-xs">删除</a>
                </c:if>
              </shiro:hasPermission>
              <c:if test="${woWorksheet.woStatus ne '5' and woWorksheet.woStatus ne '6'}">
                &nbsp;&nbsp;<a  href="javascript:void(0);"onclick="uploadFile()"  class="btn btn-primary btn-xs">上传附件</a>
              </c:if>

              <c:if test="${woWorksheet.woStatus eq '4'}">
                <a id="startWaitBtn" href="javascript:void(0);" onclick="startWait()" class="btn btn-primary btn-xs ">开始等待</a>
              </c:if>
              <c:if test="${woWorksheet.woStatus eq '7'}">
                <a id="endWaitBtn" href="javascript:void(0);" onclick="endWait()" class="btn btn-primary btn-xs ">结束等待</a>
              </c:if>
              </div>
            <h2>&nbsp;&nbsp;${woWorksheet.woNo}&nbsp;&nbsp;<c:if test="${woWorksheet.woType eq '2'}"> <span class="label label-primary">${woWorksheet.calculateType eq '1'?"单独报价":"非单独报价"}</span></c:if></h2>
          </div>
          <dl class="dl-horizontal">
            <dt>状态：</dt>
            <dd><span class="label label-primary">${fns:getDictLabel(woWorksheet.woStatus,'worksheet_status','' )}</span>
            </dd>
          </dl>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-5">
          <dl class="dl-horizontal">
            <dt>WO号：</dt>
            <dd><span id="woNoSp">${woWorksheet.snNo}</span> <shiro:hasPermission name="wo:woWorksheet:edit"><c:if test="${woWorksheet.woStatus ne '6'}">&nbsp;&nbsp;<a onclick="updateWoNo()"><i class="fa fa-pencil-square-o"></i></a></c:if></shiro:hasPermission> </dd>
            <dt>站点：</dt>
            <dd>${woWorksheet.woStation.name}</dd>
            <dt>项目经理：</dt>
            <dd>${woWorksheet.woStation.pm.name}</dd>
            <dt>客户：</dt>
            <dd>${woWorksheet.woClient.name}</dd>
            <dt>类型：</dt>
            <dd>${fns:getDictLabel(woWorksheet.woType,'worksheet_type','')}</dd>
            <dt>紧急度：</dt>
            <dd>${fns:getDictLabel(woWorksheet.emGrade,'worksheet_emgrade','' )}</dd>
            <dt>始发时间：</dt>
            <dd><fmt:formatDate value="${woWorksheet.actStartTime}" pattern="yyyy-MM-dd HH:mm:ss"/></dd>
            <dt>接受类型：</dt>
            <dd>${fns:getDictLabel(woWorksheet.acpType,'worksheet_acp_type','' )}</dd>
            <dt>其他说明：</dt>
            <dd>${woWorksheet.other}</dd>
            <dt>任务要求：</dt>
            <dd>${woWorksheet.remarks}</dd>
          </dl>
        </div>
        <div class="col-sm-7" id="cluster_info">
          <dl class="dl-horizontal">
            <%--<dt>交通费：</dt>
            <dd>${woWorksheet.woStation.trafficFee}</dd>--%>
            <dt>计划开始时间：</dt>
            <dd><span id="advTimeSp"><fmt:formatDate value="${woWorksheet.advanceTime}" pattern="yyyy-MM-dd HH:mm:ss"/></span>
              <shiro:hasPermission name="wo:woWorksheet:edit"><c:if test="${woWorksheet.woStatus eq '1' or woWorksheet.woStatus eq '2'or woWorksheet.woStatus eq '3'}">&nbsp;&nbsp;<a onclick="updateAdvTime()"><i class="fa fa-pencil-square-o"></i></a></c:if></shiro:hasPermission>
            </dd>

            <dt>最后更新：</dt>
            <dd><fmt:formatDate value="${woWorksheet.updateDate}" pattern="yyyy-MM-dd HH:mm:ss"/> </dd>
            <dt>创建于：</dt>
            <dd><fmt:formatDate value="${woWorksheet.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></dd>
            <dt>团队成员：</dt>
            <dd class="project-people">
                <c:forEach items="${woWorksheet.checkedUsers}" var="checkedUser">
                  ${checkedUser.name}（确认）&nbsp;&nbsp;
                </c:forEach>
                <c:forEach items="${woWorksheet.unCheckedUsers}" var="unCheckedUser">
                  ${unCheckedUser.name}（未确认）&nbsp;&nbsp;
                </c:forEach>
            </dd>
            <c:if test="${woWorksheet.envStatus=='1'}">
              <dt>协助人数：</dt>
              <dd>${woWorksheet.needAssitNum}</dd>
              <dt>需协助原因：</dt>
              <dd>${woWorksheet.reason}</dd>
            </c:if>
              <c:if test='${woWorksheet.woStatus ne "7" and (woWorksheet.woStatus eq "5" or woWorksheet.woStatus eq "6") }'>
                <c:set var="totTime" value="${fns:getDistanceTimeOfTwoDate(woWorksheet.beginTime,woWorksheet.completeTime )}"/>
              </c:if>
              <c:if test ='${woWorksheet.woStatus eq "7" or woWorksheet.woStatus eq "4"}'>
                <c:set var="totTime" value="${fns:pastTimes(woWorksheet.beginTime)}"/>
              </c:if>
              <c:if test="${woWorksheet.woStatus eq '7'}">
                <c:if test="${empty woWorksheet.waitTime}">
                  <c:set var="totWaitTime" value="${fns:pastTimes(woWorksheet.startWaitTime)}" />
                </c:if>
                <c:if test="${!empty woWorksheet.waitTime}">
                  <c:set var="totWaitTime" value="${woWorksheet.waitTime +fns:pastTimes(woWorksheet.startWaitTime)}" />
                </c:if>
              </c:if>

              <c:if test="${woWorksheet.woStatus ne '7'}">
                <c:set var="totWaitTime" value="${empty woWorksheet.waitTime?0:woWorksheet.waitTime}"/>
              </c:if>

              <dt>任务总耗时</dt>
              <dd>${fns:toTimeString(totTime)}</dd>
              <dt>任务等待耗时</dt>
              <dd>${fns:toTimeString(totWaitTime)}</dd>
              <dt>任务实际耗时</dt>
              <dd>${fns:toTimeString(totTime-woWorksheet.waitTime)}</dd>

          </dl>
        </div>
      </div>
      <div class="row">
        <div class="col-sm-12">
          <dl class="dl-horizontal">
            <dt>执行情况：</dt>
            <dd>
              <span id="desc">${woWorksheet.description}</span><shiro:hasPermission name="wo:woWorksheet:edit"><c:if test="${woWorksheet.envStatus ne '2'and woWorksheet.woStatus ne '6'}">&nbsp;&nbsp;<a onclick="updateStatus()"><i class="fa fa-pencil-square-o"></i></a></c:if></shiro:hasPermission>
            </dd>
          </dl>
        </div>
      </div>
      <div class="row m-t-sm">
        <div class="col-sm-12">
          <div class="panel blank-panel">
            <div class="panel-heading">
              <div class="panel-options">
                <ul class="nav nav-tabs">
                  <li class="active"><a href="#tab-1" data-toggle="tab">状态流转</a>
                  </li>
<c:if test="${woWorksheet.woType==1}">
                  <li id="taskDetail"><a href="#tab-2" data-toggle="tab">巡检项</a>
                  </li>
  </c:if>
                  <li><a href="#tab-3" data-toggle="tab">附件列表</a>
                  </li>
                  <c:if test="${woWorksheet.woStatus gt 2}">
                  <li><a href="#tab-5" data-toggle="tab">人员轨迹</a>
                  </li>
                  </c:if>
                  <shiro:hasPermission name="wo:woWorksheet:feeAdd">
                  <li><a href="#tab-4" data-toggle="tab">费用列表</a>
                  </li>
                  </shiro:hasPermission>

                </ul>
              </div>
            </div>

            <div class="panel-body">

              <div class="tab-content">

                <div class="tab-pane active" id="tab-1">
                  <table class="table table-striped">
                    <thead>
                    <tr>
                      <th>操作状态</th>
                      <th>操作员</th>
                      <th>操作日期</th>
                      <th>操作日志</th>
                      <th>描述</th>
                    </tr>
                    </thead>
                    <tbody>
                  <c:forEach items="${statusLogs}" var="statusLog">
                    <tr>
                      <td>${fns:getDictLabel(statusLog.opStatus,'worksheet_status','' )}</td>
                      <td>${statusLog.operator.name}</td>
                      <td><fmt:formatDate value="${statusLog.opDate}" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                      <td>${statusLog.opLog}</td>
                      <td>${statusLog.remarks}</td>
                    </tr>
                  </c:forEach>
                    </tbody>
                  </table>
                </div>
<c:if test="${woWorksheet.woType==1}">
                <div class="tab-pane" id="tab-2">
                  <table class="table table-striped">
                    <thead>
                    <tr>
                      <th>序号</th>
                      <th>状态</th>
                      <th>名称</th>
                      <th>标准</th>
                      <th>巡检结果</th>
                      <th>结果描述</th>
                      <th>图片</th>
                      <th>备注</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${woWorksheet.detailList}" var="detail" varStatus="index">
                      <tr>
                        <td>${index.index+1}</td>
                        <td>
                          <span class="label label-primary">${fns:getDictLabel(detail.status,'worksheet_detail_status','未定义')}</span>
                        </td>
                        <td>
                            ${detail.name}
                        </td>
                        <td>${detail.content}</td>
                        <td>
                          <span class="label label-primary">${fns:getDictLabel(detail.tag,'worksheet_detail_tag','')}</span>
                        </td>
                        <td>
                            ${detail.result}
                        </td>
                        <td>
                          <input type="hidden" id="detailImage${index.index}"  value="${detail.attachFiles}" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                          <sys:ckfinder input="detailImage${index.index}" type="images" uploadPath="" maxWidth="38" maxHeight="38" readonly="true" selectMultiple="true"/>
                        </td>
                        <td>
                            ${detail.remarks}
                        </td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>


                </div>
  </c:if>
                <div class="tab-pane" id="tab-3">

                  <table class="table table-striped">
                    <thead>
                    <tr>
                      <th>附件名</th>
                      <th>附件</th>
                      <th>上传人</th>
                      <th>上传时间</th>
                      <th>备注</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${attachFiles}" var="worksheetFile" varStatus="index">
                      <tr>
                        <td>${worksheetFile.name}</td>
                        <td>
                          <input type="hidden" id="detailFile${index.index}"  value="${worksheetFile.atthFile}" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                          <sys:ckfinder input="detailFile${index.index}" type="images" uploadPath="" maxWidth="38" maxHeight="38" readonly="true" selectMultiple="false"/>
                        </td>
                        <td>
                          ${worksheetFile.uploadBy.name}
                        </td>
                        <td><fmt:formatDate value="${worksheetFile.uploadDate}" pattern="yyyy年MM月dd日 HH:mm:ss"/></td>
                        <td>${worksheetFile.remarks}</td>
                      </tr>
                    </c:forEach>
                    </tbody>
                  </table>

                </div>
                <c:if test="${woWorksheet.woStatus gt 2}">
                <div class="tab-pane" id="tab-5">
                  <div > <form id="queryLocForm" class=" well"><label >人员：</label>
                    <c:forEach items="${woWorksheet.checkedUsers}" var="engineer">
                      <input type="radio" name="queryEng" value="${engineer.id}"/>${engineer.name}
                    </c:forEach>
                    &nbsp;&nbsp;&nbsp;&nbsp;<input type="button" id="queryLocBtn" class="btn btn-primary" value="回放" onclick="queryLoc()"/>
                  </form> </div>
                  <div id="locMap" style="width: 100%;height:400px;"></div>
                  <script>
                      var map = new BMap.Map("locMap");
                      map.centerAndZoom(new BMap.Point(121.403083, 31.219781), 15);
                      map.enableScrollWheelZoom();
                      map.enableContinuousZoom();
                      var normIcon = new BMap.Icon("${lh}${ctxStatic}/images/ryml1.png", new BMap.Size(36, 28),{offset: new BMap.Size(10, 25)});

                  </script>
                </div>
                </c:if>
                <shiro:hasPermission name="wo:woWorksheet:feeAdd">
                <div class="tab-pane" id="tab-4">
                  <form id="feeForm">
                    <input type="hidden" name="id" value="${woWorksheet.id}"/>
                  <table id="cailiaoTable" delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                   <thead>
                   <tr>
                     <td width="7%"><b>序号</b></td>
                     <td width="20%"><b>材料名称</b></td>
                     <td width="12%"><b>成本单价</b></td>
                     <td width="8%"><b>数量</b></td>
                     <td width="10%"><b>成本</b></td>
                     <td width="14%"><b>票种</b></td>
                     <td width="10%"><b>不含税价</b></td>
                     <td width="10%"><b>增值税进项</b></td>
                     <td width="12%"><b>单价</b></td>
                     <td width="10%"><b>销售金额</b></td>
                     <td width="7%"></td>
                   </tr>
                   </thead>
                    <tbody>
                    <c:set var="tindex" value="0"/>
                    <c:forEach items="${cailiaoItems}" var="cailiao" varStatus="status">
                      <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                      <input type="hidden" name="feeItemList[${tindex}].id" value="${cailiao.id}"/>
                      <tr tindex="${tindex}">
                        <td>

                          <input type="hidden" name="feeItemList[${tindex}].feeType" value="1"/>

                          <span class='tindex'>${tindex+1}</span>
                        </td>
                        <td><input  type="text" style="width:100px;" name="feeItemList[${tindex}].name" value="${cailiao.name}" placeholder="请输入材料名称"/></td>
                        <td><input  type="text" placeholder="成本单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].price" data-oral="${cailiao.price}" value="${fns:fmtMoney(cailiao.price)}" class="per"/></td>

                        <td><input  type="number" placeholder="数量" style="width:60px;" onblur="calCost(this);"  name="feeItemList[${tindex}].num"  value="${cailiao.num}" class="num"/></td>
                        <td><input  type="text" style="width:80px;" name="feeItemList[${tindex}].cost" data-oral="${cailiao.cost}" readonly value="${fns:fmtMoney(cailiao.cost)}" placeholder="请输入金额" class="moneyNum cost"/></td>

                        <td>
                          <select  name="feeItemList[${tindex}].billType" class='bill'>
                            <option value="">请选择</option>
                            <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                              <option value="${item.value}" <c:if test="${item.value eq cailiao.billType}">selected="selected"</c:if> >${item.label}</option>
                            </c:forEach>
                          </select>
                        </td>
                        <td><input  type="text"style="width:80px;"  readonly="readonly" name="feeItemList[${tindex}].npb" data-oral="${cailiao.npb}" value="${fns:fmtMoney(cailiao.npb)}"   class="npb" /></td>
                        <td><input  type="text" style="width:80px;" readonly="readonly" name="feeItemList[${tindex}].zpb" data-oral="${cailiao.zpb}" value="${fns:fmtMoney(cailiao.zpb)}" class="zpb" /></td>
                        <td><input  type="text" placeholder="单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].outPer" data-oral="${cailiao.outPer}" value="${fns:fmtMoney(cailiao.outPer)}" class="outPer"/></td>
                        <td><input  type="text" style="width:80px;" name="feeItemList[${tindex}].outPrice" data-oral="${cailiao.outPrice}"  value="${fns:fmtMoney(cailiao.outPrice)}" placeholder="请输入金额" class="moneyNum outPrice"/></td>
                        <td><a onclick='cailiao(this)'><i class="fa fa-times"></i>&nbsp;</a></td>
                        <c:set value="${tindex+1}" var="tindex"/>
                      </tr>
                    </c:forEach>
                    <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                    <input type="hidden" name="feeItemList[${tindex}].id" id="clFeeId"/>
                    <tr tindex="${tindex}">
                      <td>

                        <input type="hidden" name="feeItemList[${tindex}].feeType" value="1"/>
                        <span class='tindex'>${tindex+1}</span>
                      </td>
                      <td><input  type="text" style="width:100px;"  placeholder="请输入材料名称" name="feeItemList[${tindex}].name"  /></td>
                      <td><input  type="text" placeholder="成本单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].price" id="clPer" class="per"/></td>

                      <td><input  type="number" placeholder="数量" style="width:60px;" onblur="calCost(this);"  name="feeItemList[${tindex}].num" class="num" id="clNum"/></td>
                      <td><input  type="text" style="width:80px;" placeholder="请输入金额" readonly class="moneyNum cost"  name="feeItemList[${tindex}].cost" id="clcost"/></td>

                      <td>
                        <select class='bill' name="feeItemList[${tindex}].billType" id="clbillType">
                          <option value="">请选择</option>
                          <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                            <option value="${item.value}">${item.label}</option>
                          </c:forEach>
                        </select>
                      </td>
                      <td><input  type="text" style="width:80px;" readonly="readonly" name="feeItemList[${tindex}].npb" class="npb" id="clnpb" /></td>
                      <td><input  type="text" style="width:80px;" readonly="readonly" class="zpb" name="feeItemList[${tindex}].zpb" id="clzpb" /></td>
                      <td><input  type="text" placeholder="单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].outPer" id="clOutPer" class="outPer"/></td>
                      <td><input  type="text" style="width:80px;" placeholder="请输入金额" class="moneyNum outPrice"  name="feeItemList[${tindex}].outPrice" id="cloutPrice"/></td>
                      <td><a onclick='cailiao(this)'><i class="fa fa-plus"></i>&nbsp;</a></td>
                    </tr>
                    </tbody>
                    <tfoot>
                    <tr>
                      <td style="text-align: center" colspan="4">
                        <b>材料小计</b>
                      </td>
                      <td >
                        <span id="cailiaoxj" class="cb"></span>
                      </td>
                      <td></td>
                      <td><span id="cailiaonpb" class="npbt"></span></td>
                      <td><span id="cailiaozpb" class="zpbt"></span></td>
                      <td></td>
                      <td >
                        <span id="cailiaooutxj" class="cbOut"></span>
                      </td>
                      <td></td>
                    </tr>
                    </tfoot>
                  </table>


                    <table id="rengongTable"  delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                      <thead>
                      <tr>
                        <td width="7%"><b>序号</b></td>
                        <td width="20%"><b>人工说明</b></td>
                        <td width="12%"><b>成本单价</b></td>

                        <td width="8%"><b>数量</b></td>
                        <td width="10%"><b>成本</b></td>

                        <td width="14%"><b>票种</b></td>
                        <td width="15%"><b>不含税价</b></td>
                        <td width="15%"><b>增值税进项</b></td>
                        <td width="12%"><b>单价</b></td>
                        <td ><b>销售金额</b></td>
                        <td width="7%"></td>
                      </tr>
                      </thead>
                      <tbody>
                      <c:set var="tindex" value="${tindex+1}"/>
                      <c:forEach items="${rengongItems}" var="rengong" varStatus="status">
                        <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                        <input type="hidden" name="feeItemList[${tindex}].id" value="${rengong.id}"/>
                        <tr tindex="${tindex}">
                          <td>
                            <input type="hidden" name="feeItemList[${tindex}].feeType" value="3"/>


                            <span class='tindex'>${tindex+1}</span>
                          </td>
                          <td><input  type="text" style="width:100px;"  placeholder="请输入人工说明" name="feeItemList[${tindex}].name" value="${rengong.name}"/></td>
                          <td><input  type="text" placeholder="成本单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].price" data-oral="${rengong.price}" value="${fns:fmtMoney(rengong.price)}" class="per"/></td>

                          <td><input  type="number" placeholder="数量" style="width:60px;" onblur="calCost(this);"  name="feeItemList[${tindex}].num" value="${rengong.num}" class="num"/></td>
                          <td><input  type="text" placeholder="请输入金额"style="width:80px;" name="feeItemList[${tindex}].cost" readonly data-oral="${rengong.cost}" value="${fns:fmtMoney(rengong.cost)}" class="moneyNum cost"/></td>

                          <td>
                            <select  name="feeItemList[${tindex}].billType" class='bill'>
                              <option value="">请选择</option>
                              <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                                <c:set var="selectedStr" value=""/>
                                <c:if test="${item.value ==rengong.billType}">
                                  <c:set var="selectedStr" value="selected"/>
                                </c:if>
                                <option value="${item.value}"  ${selectedStr}>${item.label}</option>
                              </c:forEach>
                            </select>
                          </td>
                          <td><input  type="text"style="width:80px;" readonly="readonly" name="feeItemList[${tindex}].npb" data-oral="${rengong.npb}" value="${fns:fmtMoney(rengong.npb)}" class="npb"/></td>
                          <td><input  type="text"style="width:80px;" readonly="readonly" name="feeItemList[${tindex}].zpb" data-oral="${rengong.zpb}" value="${fns:fmtMoney(rengong.zpb)}" class="zpb"/></td>
                          <td><input  type="text" placeholder="单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].outPer" data-oral="${rengong.outPer}" value="${fns:fmtMoney(rengong.outPer)}" class="outPer"/></td>
                          <td><input  type="text" placeholder="请输入金额"style="width:80px;" name="feeItemList[${tindex}].outPrice" readonly data-oral="${rengong.outPrice}" value="${fns:fmtMoney(rengong.outPrice)}" class="moneyNum outPrice"/></td>
                          <td><a onclick="rengong(this)"><i class="fa fa-times"></i>&nbsp;</a></td>
                          <c:set var="tindex" value="${tindex+1}"/>
                        </tr>
                      </c:forEach>
                      <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                      <input type="hidden" name="feeItemList[${tindex}].id" id="rgId"/>
                      <tr tindex="${tindex}">
                        <td>
                          <input type="hidden" name="feeItemList[${tindex}].feeType" value="3"/>


                          <span class='tindex'>${tindex}</span>
                        </td>
                        <td><input  type="text" style="width:100px;"  placeholder="请输入人工说明" name="feeItemList[${tindex}].name" id="rgName"/></td>
                        <td><input  type="text" placeholder="成本单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].price" id="rgPer"  class="per"/></td>

                        <td><input  type="number" placeholder="数量" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].num" class="num" id="rgNum"/></td>
                        <td><input  type="text" placeholder="请输入金额" style="width:80px;" class="moneyNum cost" readonly name="feeItemList[${tindex}].cost" id="rgCost"/></td>

                        <td>
                          <select class='bill' name="feeItemList[${tindex}].billType" id="rgbillType">
                            <option value="">请选择</option>
                            <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                              <option value="${item.value}">${item.label}</option>
                            </c:forEach>
                          </select>
                        </td>
                        <td><input style="width:80px;"  type="text" readonly="readonly" name="feeItemList[${tindex}].npb" class="npb" id="rgnpb"/></td>
                        <td><input style="width:80px;"  type="text" readonly="readonly" name="feeItemList[${tindex}].zpb" class="zpb" id="rgzpb"/></td>
                        <td><input  type="text" placeholder="单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].outPer" id="rgOutPer"  class="outPer"/></td>
                        <td><input  type="text" placeholder="请输入金额" style="width:80px;" class="moneyNum outPrice" readonly  name="feeItemList[${tindex}].outPrice" id="rgOut"/></td>
                        <td><a onclick="rengong(this)"><i class="fa fa-plus"></i>&nbsp;</a></td>
                      </tr>
                      </tbody>
                      <tfoot>
                      <tr>
                        <td style="text-align: center" colspan="4">
                          <b>人工小计</b>
                        </td>
                        <td >
                          <span id="rengongxj" class="cb"></span>
                        </td>
                        <td></td>
                        <td><span id="rengongnpb" class="npbt"></span></td>
                        <td><span id="rengongzpb" class="zpbt"></span></td>
                        <td></td>
                        <td >
                          <span id="rengongoutxj" class="cbOut"></span>
                        </td>
                        <td></td>
                      </tr>
                      </tfoot>
                    </table>
                    <table id="jiaotongTable"  delNum="0" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                      <thead>
                      <tr>
                        <td width="7%"><b>序号</b></td>
                        <td width="20%"><b>交通费说明</b></td>
                        <td width="12%"><b>成本单价</b></td>
                        <td width="8%"><b>数量</b></td>
                        <td width="10%"><b>成本</b></td>
                        <td width="14%"><b>票种</b></td>
                        <td width="15%"><b>不含税价</b></td>
                        <td width="15%"><b>增值税进项</b></td>
                        <td width="12%"><b>单价</b></td>
                        <td ><b>销售金额</b></td>
                        <td width="7%"></td>
                      </tr>
                      </thead>
                      <tbody>
                      <c:set var="tindex" value="${tindex+1}"/>
                      <c:forEach items="${jiaotongItems}" var="jiaotong" varStatus="status">
                        <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                        <input type="hidden" name="feeItemList[${tindex}].id" value="${jiaotong.id}"/>
                        <tr tindex="${tindex}">
                          <td>
                            <input type="hidden" name="feeItemList[${tindex}].feeType" value="4"/>


                            <span class='tindex'>${tindex+1}</span>
                          </td>
                          <td><input  type="text" style="width:100px;"  placeholder="请输入交通费说明" name="feeItemList[${tindex}].name" value="${jiaotong.name}"/></td>
                          <td><input  type="text" placeholder="成本单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].price" data-oral="${jiaotong.price}" value="${fns:fmtMoney(jiaotong.price)}" class="per"/></td>

                          <td><input  type="number" placeholder="数量" style="width:60px;" onblur="calCost(this);"  name="feeItemList[${tindex}].num" value="${jiaotong.num}" class="num"/></td>
                          <td><input  type="text" placeholder="请输入金额"style="width:80px;" name="feeItemList[${tindex}].cost" readonly data-oral="${jiaotong.cost}" value="${fns:fmtMoney(jiaotong.cost)}" class="moneyNum cost"/></td>

                          <td>
                            <select  name="feeItemList[${tindex}].billType" class='bill'>
                              <option value="">请选择</option>
                              <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                                <c:set var="selectedStr" value=""/>
                                <c:if test="${item.value ==jiaotong.billType}">
                                  <c:set var="selectedStr" value="selected"/>
                                </c:if>
                                <option value="${item.value}"  ${selectedStr}>${item.label}</option>
                              </c:forEach>
                            </select>
                          </td>
                          <td><input  type="text"style="width:80px;" readonly="readonly" name="feeItemList[${tindex}].npb" data-oral="${jiaotong.npb}" value="${fns:fmtMoney(jiaotong.npb)}" class="npb"/></td>
                          <td><input  type="text"style="width:80px;" readonly="readonly" name="feeItemList[${tindex}].zpb" data-oral="${jiaotong.zpb}" value="${fns:fmtMoney(jiaotong.zpb)}" class="zpb"/></td>
                          <td><input  type="text" placeholder="单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].outPer" data-oral="${jiaotong.outPer}" value="${fns:fmtMoney(jiaotong.outPer)}" class="outPer"/></td>
                          <td><input  type="text" placeholder="请输入金额"style="width:80px;" name="feeItemList[${tindex}].outPrice" readonly data-oral="${jiaotong.outPrice}" value="${fns:fmtMoney(jiaotong.outPrice)}" class="moneyNum outPrice"/></td>
                          <td><a onclick="jiaotong(this)"><i class="fa fa-times"></i>&nbsp;</a></td>
                          <c:set var="tindex" value="${tindex+1}"/>
                        </tr>
                      </c:forEach>
                      <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                      <input type="hidden" name="feeItemList[${tindex}].id" id="jtId"/>
                      <tr tindex="${tindex}">
                        <td>
                          <input type="hidden" name="feeItemList[${tindex}].feeType" value="4"/>


                          <span class='tindex'>${tindex}</span>
                        </td>
                        <td><input  type="text" style="width:100px;"  placeholder="请输入交通费说明" name="feeItemList[${tindex}].name" id="jtName"/></td>
                        <td><input  type="text" placeholder="成本单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].price" id="jtPer"  class="per"/></td>

                        <td><input  type="number" placeholder="数量" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].num" class="num" id="jtNum"/></td>
                        <td><input  type="text" placeholder="请输入金额" style="width:80px;" class="moneyNum cost" readonly name="feeItemList[${tindex}].cost" id="jtCost"/></td>

                        <td>
                          <select class='bill' name="feeItemList[${tindex}].billType" id="jtbillType">
                            <option value="">请选择</option>
                            <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                              <option value="${item.value}">${item.label}</option>
                            </c:forEach>
                          </select>
                        </td>
                        <td><input style="width:80px;"  type="text" readonly="readonly" name="feeItemList[${tindex}].npb" class="npb" id="jtnpb"/></td>
                        <td><input style="width:80px;"  type="text" readonly="readonly" name="feeItemList[${tindex}].zpb" class="zpb" id="jtzpb"/></td>
                        <td><input  type="text" placeholder="单价" style="width:60px;" onblur="calCost(this);" name="feeItemList[${tindex}].outPer" id="jtOutPer"  class="outPer"/></td>
                        <td><input  type="text" placeholder="请输入金额" style="width:80px;" class="moneyNum outPrice" readonly  name="feeItemList[${tindex}].outPrice" id="jtOut"/></td>
                        <td><a onclick="jiaotong(this)"><i class="fa fa-plus"></i>&nbsp;</a></td>
                      </tr>
                      </tbody>
                      <tfoot>
                      <tr>
                        <td style="text-align: center" colspan="4">
                          <b>交通费小计</b>
                        </td>
                        <td >
                          <span id="jiaotongxj" class="cb"></span>
                        </td>
                        <td></td>
                        <td><span id="jiaotongnpb" class="npbt"></span></td>
                        <td><span id="jiaotongzpb" class="zpbt"></span></td>
                        <td></td>
                        <td >
                          <span id="jiaotongoutxj" class="cbOut"></span>
                        </td>
                        <td></td>
                      </tr>
                      </tfoot>
                    </table>
                   <%-- <c:set var="tindex" value="${tindex+1}"/>
                  <table id="fenbaoTable"  delNum="0" class="hide table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                    <thead>
                    <tr>
                      <td width="7%"><b>序号</b></td>
                      <td width="20%"><b>分包合同名称</b></td>
                      <td width="15%"><b>分包成本</b></td>
                      <td width="14%"><b>票种</b></td>
                      <td width="15%"><b>不含税价</b></td>
                      <td width="22%"><b>增值税进项</b></td>
                      <td width="7%"></td>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${fenbaoItems}" var="fenBao" varStatus="status">
                      <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                      <input type="hidden" name="feeItemList[${tindex}].id" value="${fenBao.id}"/>
                      <tr tindex="${tindex}">
                        <td>
                          <input type="hidden" name="feeItemList[${tindex}].feeType" value="2"/>


                          <span class='tindex'>${tindex+1}</span>
                        </td>
                        <td><input  type="text" placeholder="请输入分包合同说明" name="feeItemList[${tindex}].name" value="${fenBao.name}" /></td>
                        <td><input  type="text" placeholder="请输入金额" name="feeItemList[${tindex}].cost" data-oral="${fenBao.cost}" value="${fns:fmtMoney(fenBao.cost)}"  class="moneyNum"/></td>
                        <td>
                          <select  name="feeItemList[${tindex}].billType" class='bill'>
                            <option value="">请选择</option>
                            <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                              <c:set var="selectedStr" value=""/>
                              <c:if test="${item.value ==fenBao.billType}">
                                <c:set var="selectedStr" value="selected"/>
                              </c:if>
                              <option value="${item.value}" ${selectedStr} >${item.label}</option>
                            </c:forEach>
                          </select>
                        </td>
                        <td><input  type="text" readonly="readonly" name="feeItemList[${tindex}].npb" data-oral="${fenBao.npb}" value="${fns:fmtMoney(fenBao.npb)}" class="npb"/></td>
                        <td><input  type="text" readonly="readonly" name="feeItemList[${tindex}].zpb" data-oral="${fenBao.zpb}" value="${fns:fmtMoney(fenBao.zpb)}" class="zpb"/></td>
                        <td><a onclick="fenbao(this)"><i class="fa fa-times"></i>&nbsp;</a></td>
                        <c:set var="tindex" value="${tindex+1}"/>
                      </tr>
                    </c:forEach>
                    <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                    <input type="hidden" name="feeItemList[${tindex}].id" id="fbId"/>
                    <tr tindex="${tindex}">
                      <td>
                        <input type="hidden" name="feeItemList[${tindex}].feeType" value="2"/>


                        <span class='tindex'>${tindex+1}</span>
                      </td>
                      <td><input  type="text" placeholder="请输入分包合同说明" name="feeItemList[${tindex}].name" id="fbName"/></td>
                      <td><input  type="text" placeholder="请输入金额" class="moneyNum" name="feeItemList[${tindex}].cost" id="fbCost"/></td>
                      <td>
                        <select class='bill' name="feeItemList[${tindex}].billType" id="fbbillType">
                          <option value="">请选择</option>
                          <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                            <option value="${item.value}">${item.label}</option>
                          </c:forEach>
                        </select>
                      </td>
                      <td><input  type="text" readonly="readonly" name="feeItemList[${tindex}].npb" class="npb" id="fbnpb"/></td>
                      <td><input  type="text" readonly="readonly" name="feeItemList[${tindex}].zpb" class="zpb" id="fbzpb"/></td>
                      <td><a onclick="fenbao(this)"><i class="fa fa-plus"></i>&nbsp;</a></td>
                    </tr>
                    </tbody>
                    <tfoot>
                    <tr>
                      <td colspan="2">
                        <b>分包小计</b>
                      </td>
                      <td>
                        <span id="fenbaoxj" class="cb"></span>
                      </td>
                      <td></td>
                      <td><span id="fenbaonpb" class="npbt"></span></td>
                      <td><span id="fenbaozpb" class="zpbt"></span></td>
                      <td></td>
                    </tr>
                    </tfoot>
                  </table>


                  <table id="qitaTable"  delNum="0" class="hide table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                    <thead>
                      <tr>
                        <td width="7%"><b>序号</b></td>
                        <td width="20%"><b>其他说明</b></td>
                        <td width="15%"><b>其他成本</b></td>
                        <td width="14%"><b>票种</b></td>
                        <td width="15%"><b>不含税价</b></td>
                        <td width="22%"><b>增值税进项</b></td>
                        <td width="7%"></td>
                      </tr>
                    </thead>
                    <tbody>
                    <c:set var="tindex" value="${tindex+1}"/>
                    <c:forEach items="${qitaItems}" var="qita" varStatus="status">
                      <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                      <input type="hidden" name="feeItemList[${tindex}].id" value="${qita.id}"/>
                      <tr tindex="${tindex}">
                        <td>
                          <input type="hidden" name="feeItemList[${tindex}].feeType" value="4"/>


                          <span class='tindex'>${tindex+1}</span>
                        </td>
                        <td><input  type="text" placeholder="请输入其他说明" name="feeItemList[${tindex}].name" value="${qita.name}"/></td>
                        <td><input  type="text" placeholder="请输入金额" name="feeItemList[${tindex}].cost" data-oral="${qita.cost}" value="${fns:fmtMoney(qita.cost)}" class="moneyNum"/></td>
                        <td>
                          <select  name="feeItemList[${tindex}].billType" class='bill'>
                            <option value="">请选择</option>
                            <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                              <c:set var="selectedStr" value=""/>
                              <c:if test="${item.value ==qita.billType}">
                                <c:set var="selectedStr" value="selected"/>
                              </c:if>
                              <option value="${item.value}"  ${selectedStr}>${item.label}</option>
                            </c:forEach>
                          </select>
                        </td>
                        <td><input  type="text" readonly="readonly" class="npb" name="feeItemList[${tindex}].npb" value="${fns:fmtMoney(qita.npb)}" data-oral="${qita.npb}"/></td>
                        <td><input  type="text" readonly="readonly" class="zpb" name="feeItemList[${tindex}].zpb" value="${fns:fmtMoney(qita.zpb)}" data-oral="${qita.zpb}"/></td>
                        <td><a onclick="qita(this)"><i class="fa fa-times"></i>&nbsp;</a></td>
                        <c:set var="tindex" value="${tindex+1}"/>
                      </tr>
                    </c:forEach>
                    <input type="hidden" name="feeItemList[${tindex}].delFlag" value="0"/>
                    <input type="hidden" name="feeItemList[${tindex}].id" id="qtId"/>
                    <tr tindex="${tindex}">
                      <td>
                        <input type="hidden" name="feeItemList[${tindex}].feeType" value="4"/>


                        <input type="hidden" name="feeItemList[${tindex}].sort" />
                        <span class='tindex'>${tindex+1}</span>
                      </td>
                      <td><input  type="text" placeholder="请输入其他说明" name="feeItemList[${tindex}].name" id="qtName"/></td>
                      <td><input  type="text" placeholder="请输入金额" name="feeItemList[${tindex}].cost" class="moneyNum" id="qtCost"/></td>
                      <td>
                        <select class='bill' name="feeItemList[${tindex}].billType" id="qtbillType">
                          <option value="">请选择</option>
                          <c:forEach items="${fns:getDictList('bill_type')}" var="item">
                            <option value="${item.value}">${item.label}</option>
                          </c:forEach>
                        </select>
                      </td>
                      <td><input  type="text" readonly="readonly" name="feeItemList[${tindex}].npb" class="npb" id="qtnpb"/></td>
                      <td><input  type="text" readonly="readonly" name="feeItemList[${tindex}].zpb" class="zpb" id="qtzpb"/></td>
                      <td><a onclick="qita(this)"><i class="fa fa-plus"></i>&nbsp;</a></td>
                    </tr>
                    </tbody>
                    <tfoot>
                    <tr>
                      <td colspan="2">
                        <b>其他小计</b>
                      </td>
                      <td >
                        <span id="qitaxj" class="cb"></span>
                      </td>
                      <td></td>
                      <td><span id="qitanpb" class="npbt"></span></td>
                      <td><span id="qitazpb" class="zpbt"></span></td>
                      <td></td>
                    </tr>
                    </tfoot>
                  </table>--%>
                 <%-- <table id="jiaoTongTable" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                    <thead>
                      <tr>
                        <td width="7%"><b>序号</b></td>
                        <td width="20%"><b>交通费</b></td>
                        <td width="15%"><b>成本</b></td>
                        <td width="14%"><b>金额</b></td>
                      </tr>
                    </thead>
                    <tbody>
                      <tr>
                        <td>1</td>
                        <td><input  type="text"  placeholder="请输入交通费说明" name="trafficDesc" value="${woWorksheet.trafficDesc}"/></td>
                        <td><input  type="text" class="moneyNum" placeholder="请输入交通费" name="trafficFee" data-oral="${woWorksheet.trafficFee}"  value="${fns:fmtMoney(woWorksheet.trafficFee)}" id="trafficFee"/></td>
                        <td> <input  type="text" class="moneyNum" placeholder="请输入交通费" name="trafficFeeOut" data-oral="${woWorksheet.trafficFeeOut}"  value="${fns:fmtMoney(woWorksheet.trafficFeeOut)}" id="trafficFeeOut"/></td>
                      </tr>
                    </tbody>
                  </table>--%>
                  <table id="chenbTable" class="table table-bordered table-condensed table-hover text-center feeTable" style="font-size: 13px;">
                    <tfoot>
                    <tr>
                      <td style="text-align: center" rowspan="2">
                        <b>成本小计</b>
                      </td>
                      <td style="text-align: center"width=15% >
                        <b>成本</b>
                      </td>

                      <td style="text-align: center" width="15%">
                       <b>不计税价</b>
                      </td>
                      <td style="text-align: center" width="12%">
                        <b>增值税进项</b>
                      </td>
                      <td style="text-align: center" width=15% >
                        <b>销售金额</b>
                      </td>
                    </tr>
                    <tr>

                      <td width=15% >
                        <span id="totalCb" ></span>
                      </td>

                      <td width="15%">
                        <span id="totalnpb" ></span>
                      </td>
                      <td width="12%">
                        <span id="totalzpb" ></span>
                      </td>
                      <td width=15% >
                        <span id="totalOCb" ></span>
                      </td>
                    </tr>
                    </tfoot>
                  </table>
                    <script>var tIndex=${tindex+1};</script>
                    <c:if test="${woWorksheet.feeStatus eq 0}">

                      <input type="button" class="btn btn-primary pull-right" onclick="return confirmx('提交后，无法再次修改费用列表！',function(){
                      saveFee(1)
                      },function(){});" value="提交"/>
                      <input type="button" class="btn btn-primary pull-right" style="margin-right:10px;" onclick="saveFee(0)" value="保存"/>
                    </c:if>
                  </form>
                </div>
                </shiro:hasPermission>
              </div>

            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</div>

</body>
</html>
