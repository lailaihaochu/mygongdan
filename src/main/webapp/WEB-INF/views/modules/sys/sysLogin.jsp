<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>${fns:getConfig('productName')} 登录</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="keywords" content="">
  <meta name="description" content="">
  <link rel="shortcut icon" href="favicon.ico">
  <link href="${ctxStatic}/css/bootstrap.css?v=3.3.6" rel="stylesheet">
  <link href="${ctxStatic}/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">

  <link href="${ctxStatic}/css/animate.min.css" rel="stylesheet">
  <link href="${ctxStatic}/css/style.min.css?v=4.1.0" rel="stylesheet">
  <!--[if lt IE 9]>
  <meta http-equiv="refresh" content="0;ie.html" />

  <![endif]-->

  <style type="text/css">
    * { word-wrap: break-word; outline: none; }
    html,
    body { height: 100%; margin: 0; -webkit-text-size-adjust: none; }
    body {  color:#fff; font-family: "Microsoft YaHei", "Lucida Grande", "Lucida Sans Unicode", Tahoma, Helvetica, Arial, sans-serif; -webkit-background-size: cover; -moz-background-size: cover; -o-background-size: cover; background-size: cover; width: 100%; height: 100%; }
    ul,li { margin: 0; padding: 0; border: 0; list-style-image: none; list-style-type: none; }
    #supersized-loader { position: absolute; top: 50%; left: 50%; z-index: 0; width: 60px; height: 60px; margin: -30px 0 0 -30px; text-indent: -999em; background: url(${ctxStatic}/images/loading.gif) no-repeat center center; }
    #supersized { display: block; position: fixed; left: 0; top: 0; overflow: hidden; z-index: -999; height: 100%; width: 100%; }
    #supersized img { width: auto; height: auto; position: relative; display: none; outline: none; border: none; }
    #supersized.speed img { -ms-interpolation-mode: nearest-neighbor; image-rendering: -moz-crisp-edges; }	/*Speed*/
    #supersized.quality img { -ms-interpolation-mode: bicubic; image-rendering: optimizeQuality; }			/*Quality*/
    #supersized li { display: block; list-style: none; z-index: -30; position: fixed; overflow: hidden; top: 0; left: 0; width: 100%; height: 100%; background: #111; }
    #supersized a { width: 100%; height: 100%; display: block; }
    #supersized li.prevslide { z-index: -20; }
    #supersized li.activeslide { z-index: -10; }
    #supersized li.image-loading { background: #111 url(${ctxStatic}/images/loading.gif) no-repeat center center; width: 100%; height: 100%; }
    #supersized li.image-loading img { visibility: hidden; }
    #supersized li.prevslide img,
    #supersized li.activeslide img { display: inline; }
    #supersized img { max-width: none !important }
    #supersized i { _zoom: 110;}
    #login-wraper {
      -webkit-border-radius: 15px;
      -moz-border-radius: 15px;
      -ms-border-radius: 15px;
      -o-border-radius: 15px;
      border-radius: 15px;
      -webkit-box-shadow: 0 0 8px rgba(0, 0, 0, 0.2);
      -moz-box-shadow: 0 0 8px rgba(0, 0, 0, 0.2);
      box-shadow: 0 0 8px rgba(0, 0, 0, 0.2);

      padding: 25px;
      width: 100%;
      background: rgba(0, 0, 0, 0.2);
    }
    .form-signin-heading{font-family:Helvetica, Georgia, Arial, sans-serif, 黑体;font-size:36px;margin-bottom:0; margin-top:0;color:#0663a2;}
    .form-signin{position:relative;text-align:left;width:300px;padding:25px 29px 29px;margin:0 auto 20px;background-color:#fff;border:1px solid #e5e5e5;
      -webkit-border-radius:5px;-moz-border-radius:5px;border-radius:5px;-webkit-box-shadow:0 1px 2px rgba(0,0,0,.05);-moz-box-shadow:0 1px 2px rgba(0,0,0,.05);box-shadow:0 1px 2px rgba(0,0,0,.05);}
    .form-signin .checkbox{margin-bottom:10px;color:#0663a2;} .form-signin .input-label{font-size:16px;line-height:23px;color:#999;}
    .form-signin .input-block-level{font-size:16px;height:auto;margin-bottom:15px;padding:7px;*width:283px;*padding-bottom:0;_padding:7px 7px 9px 7px;}
    .form-signin .btn.btn-large{font-size:16px;} .form-signin #themeSwitch{position:absolute;right:15px;bottom:10px;}
    .form-signin div.validateCode {padding-bottom:15px;} .mid{vertical-align:middle;}
    /*.header{height:80px;padding-top:20px;} .alert{position:relative;width:300px;margin:0 auto;*padding-bottom:0px;}*/
   /* label.error{background:none;width:270px;font-weight:normal;color:inherit;margin:0;}*/
  </style>
  <style type="text/css">
    .control-group{border-bottom:0px;}
    #qrcode .menu-t-c .list ul,#qrcode .menu-t-c .list li {
      margin:0px;
      padding:0px;
      float:left;
      list-style-type:none;
    }
    #menu-b-l {
      width:218px;
      height:34px;
      right:-144px;
      bottom:0px;
      position:absolute;
    }
    #menu-b-l .left {
      width:5px;
      height:34px;
      float:left;
      background:url(${ctxStatic}/images/tudou-menu-b-l.gif) no-repeat;
    }
    #menu-b-l .content {
      width:213px;
      height:34px;
      float:left;
      background:url(${ctxStatic}/images/tudou-menu-b-c.gif) repeat-x;
    }
    #menu-b-l #mini {
      width:68px;
      height:34px;
      float:left;
      cursor:pointer;
      line-height:25px;
      color:#fff;
      padding:5px;
    }


    #qrcode {
      width:213px;
      height:278px;
      right:4px;
      bottom:-288px;
      position:fixed;
      background:#fff;
    }
    #qrcode .menu-top {
      width:213px;
      height:24px;
      float:left;
      background:url(${ctxStatic}/images/tudou-menu-top1.png) no-repeat;
    }
    #qrcode .menu-top span {
      width:15px;
      height:15px;
      float:right;
      cursor:pointer;
      display:inline;
      margin:5px 5px 0 0;
    }
    #qrcode .menu-t-c {
      width:213px;
      height:253px;
      float:left;
      padding:5px;
      border-top:1px solid #3c3c3c;
      border-left:1px solid #3c3c3c;
      border-right:1px solid #3c3c3c;
      background:url(${ctxStatic}/images/tudou-menu-bg.gif) repeat-x;
    }

    #qrcode .menu-t-c .img {
      width:200px;
      height:200px;
      float:left;
      padding:0;
      background:#1a1a1a;
      border:1px solid #4e4e4e;
    }
    #qrcode .menu-t-c .list {
      width:200px;
      height:auto;
      float:left;
      padding:3px 0;

    }
    #qrcode .menu-t-c .list li {
      width:200px;
      height:20px;
      line-height:20px;
      text-align:left;
      text-indent:10px;

    }

    #qrcode .menu-t-c .list li a {
      color:#afafaf;
      text-decoration:none;
    }
    #qrcode .menu-t-c .list li a:hover {
      text-decoration:underline;
    }

  </style>
  <script>if(window.top !== window.self){ window.top.location = window.location;}</script>
</head>
<body >
<div class=" full-height full-width">
  <!--[if lte IE 6]><br/><div class='alert alert-block' style="text-align:left;padding-bottom:10px;"><a class="close" data-dismiss="alert">x</a><h4>温馨提示：</h4><p>你使用的浏览器版本过低。为了获得更好的浏览体验，我们强烈建议您 <a href="http://browsehappy.com" target="_blank">升级</a> 到最新版本的IE浏览器，或者使用较新版本的 Chrome、Firefox、Safari 等。</p></div><![endif]-->

<div class="middle-box text-center loginscreen animated fadeInDown">
  <div >
    <div id="messageBox" class="alert alert-danger alert-dismissable ${empty message ? 'hide' : ''}">
      <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
      <label id="loginError" class="error">${message}</label>
    </div>

    <div>
      <h1 class="logo-name form-signin-heading" style="font-family:'华文行楷'" >SRV</h1>
    </div>
    <div id="login-wraper">
    <form class="m-t" role="form" class="form-signin" action="${ctx}/login" method="post">
      <div class="input-group " style="margin-bottom: 20px;">
        <span class="input-group-addon" style="color:black;"><i class="fa fa-user"></i></span>
        <input type="text" style="color:black;" class="form-control" name="username" placeholder="登录名" required="">
      </div>
      <div class="input-group "  style="margin-bottom: 20px;">
        <span class="input-group-addon" style="color:black;"><i class="fa fa-lock"></i></span>
        <input type="password" style="color:black;" class="form-control" name="password" placeholder="密码" required="">
      </div>
      <div class="form-group pull-left">
        <label class="" ><input type="checkbox" id="rememberMe" name="rememberMe">记住我</label>
      </div>

     <%-- <c:if test="${isValidateCodeLogin}">
        <div class="form-group pull-right">
          <label class="" for="validateCode">验证码：</label>
          <sys:validateCode name="validateCode" inputCssStyle="margin-bottom:0;color:black;"/>
        </div>
      </c:if>--%>
      <button type="submit" class="btn btn-primary block full-width m-b">Login</button>

    </form>
    </div>
    <p class="m-t"> Copyright &copy; ${fns:getConfig('copyrightYear')} <a style="color:#fff;text-decoration: dashed; " href="${pageContext.request.contextPath}${fns:getFrontPath()}">${fns:getConfig('productName')}</a> - Powered By <a style="color:#fff;" href="http://www.jinyao.com.cn/" target="_blank">Jinyao</a> ${fns:getConfig('version')} </p>
  </div>

</div>
</div>
<div id="qrcode">
  <div class="menu-top"><span id="close"></span><span id="tittle"style="margin-right: 60px;color:#fff;font-weight: bold;width: auto;height:24px;line-height: 24px;margin-top: 0;">App 下载</span></div>
  <div class="menu-t-c">
    <div class="img"><img src="http://120.27.215.69:8899/userfiles/1/files/app/1474814986.png" /></div>
    <div class="list">
      <ul>
        <li><i class="icon-download"></i>&nbsp;&nbsp;<a href="${ctx}/sys/appVersion/workTask.apk" target="_blank">android下载地址</a></li>
        <%--<li><i class="icon-download"></i>&nbsp;&nbsp;<a href="https://itunes.apple.com/us/app/dian-zhan-yun-guan-jia/id1031556233?mt=8" target="_blank">ios下载地址</a></li>--%>
      </ul>
    </div>
  </div>
</div>
<div id="menu-b-l">
  <div class="left"></div>
  <div class="content">
    <span id='mini' >App 下载</span>
  </div>
</div>

<script src="${ctxStatic}/js/qrScan.js" type="text/javascript"></script>
<script type="text/javascript">
  window.onload = function(){
    var oMini = document.getElementById('mini');
    var oMleft = document.getElementById('menu-b-l');
    var oMtop = document.getElementById('qrcode');
    var oClose = document.getElementById('close');
    //点击oMini显示
    oMini.onclick = function(){
      oMini.className = '';
      doMove(oMleft, {right:2}, {
        callback : function(){
          doMove(oMtop, {bottom:34});
        }
      });
    };
    //点击oClose隐藏
    oClose.onclick = function(){
      doMove(oMtop, {bottom:-288}, {
        callback : function(){
          doMove(oMleft, {right:-144});
        }
      });
    };
  };

</script>
<script src="${ctxStatic}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctxStatic}/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${ctxStatic}/js/jquery.supersized.min.js"></script>
<script>
  $(function() {
    $.supersized({

      // 功能
      slide_interval: 4000,
      transition: 1,
      transition_speed: 1000,
      performance: 1,

      // 大小和位置
      min_width: 0,
      min_height: 0,
      vertical_center: 1,
      horizontal_center: 1,
      fit_always: 0,
      fit_portrait: 1,
      fit_landscape: 0,

      // 组件
      slide_links: 'blank',
      slides: [
        {image: '${ctxStatic}/images/login/1.jpg'},
        {image: '${ctxStatic}/images/login/2.jpg'},
        {image: '${ctxStatic}/images/login/3.jpg'},
        {image: '${ctxStatic}/images/login/4.jpg'},
        {image: '${ctxStatic}/images/login/5.jpg'}
      ]

    });
  });
</script>
</body>
</html>
