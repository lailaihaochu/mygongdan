<%@ page import="com.jinbang.gongdan.modules.sys.entity.Menu" %>
<%@ page import="java.util.List" %>
<%@ page import="com.jinbang.gongdan.modules.sys.utils.UserUtils" %>
<%@ page import="com.google.common.collect.Lists" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>

<head>
  
  <title>${fns:getConfig('productName')}</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="renderer" content="webkit">
  <meta http-equiv="Cache-Control" content="no-siteapp" />
  <meta name="keywords" content="">
  <meta name="description" content="">

  <!--[if lt IE 9]>
  <meta http-equiv="refresh" content="0;ie.html" />
  <![endif]-->
  <link rel="shortcut icon" href="favicon.ico">
  <link href="${ctxStatic}/css/bootstrap.css?v=3.3.6" rel="stylesheet">
  <link href="${ctxStatic}/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
  <link href="${ctxStatic}/css/plugins/chosen/chosen.css" rel="stylesheet">
  <link href="${ctxStatic}/css/animate.min.css" rel="stylesheet">
  <link href="${ctxStatic}/css/style.min.css?v=4.1.0" rel="stylesheet">
  <script src="${ctxStatic}/js/jquery.min.js?v=2.1.4"></script>
  <script src="${ctxStatic}/js/bootstrap.min.js?v=3.3.6"></script>
  <script src="${ctxStatic}/js/plugins/metisMenu/jquery.metisMenu.js"></script>
  <script src="${ctxStatic}/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
  <script src="${ctxStatic}/js/plugins/layer/layer.js"></script>
  <script src="${ctxStatic}/js/jiot.js?v=4.1.0"></script>
  <script type="text/javascript" src="${ctxStatic}/js/contabs.js"></script>
  <script src="${ctxStatic}/js/plugins/pace/pace.min.js"></script>
  <script src="${ctxStatic}/plugins/My97DatePicker/WdatePicker.js" type="text/javascript"></script>
  <script>
    var mask,mess,tipMess;
    $(document).ready(function() {
      setInterval(refreshMsg,60000);
    });
    function refreshMsg(){
      $.get("${ctx}/oa/oaNotify/self/count",function(data){
        $("#msgCount").html(data);
        $("#msgC").html(data);
      });
    }
  </script>
</head>

<body class="fixed-sidebar full-height-layout gray-bg skin-1" style="overflow:hidden">
<div id="wrapper">
  <!--左侧导航开始-->
  <nav class="navbar-default navbar-static-side" role="navigation">
    <div class="nav-close"><i class="fa fa-times-circle"></i>
    </div>
    <div class="sidebar-collapse">
      <ul class="nav" id="side-menu">
        <li class="nav-header" >
          <div class="dropdown profile-element">
            <img src="${ctxStatic}/images/logo.png"/>
            <%--<h1>RC</h1>--%>
          </div>
          <div class="logo-element">
           <img src="${ctxStatic}/images/shortcut.png"/>
            <%--<h1>RC</h1>--%>
          </div>
        </li>

        <li class="active">
          <a class="J_menuItem" href="${ctx}/home" data-index="0" ><i class="fa fa-home"></i><span class="nav-label">主页</span></a>
        </li>
        <c:set var="menuList" value="${fns:getMenuList()}"/>
        <%
          List<Menu> firstMenu= Lists.newArrayList();
          Menu.sortList(firstMenu, (List<Menu>) pageContext.getAttribute("menuList"),"1",false);
        %>

        <c:forEach items="<%=firstMenu%>" var="menu" varStatus="idxStatus">
          <c:if test="${menu.parent.id eq '1' && menu.isShow eq '1'}">
        <%
          List<Menu> secMenus= Lists.newArrayList();
          Menu.sortList(secMenus, (List<Menu>) pageContext.getAttribute("menuList"),((Menu)pageContext.getAttribute("menu")).getId(),false);
        %>
            <li >
              <c:if test="<%=secMenus.size()>0%>" >
                <a href="#">
                  <i class="fa fa-${menu.icon}"></i>
                  <span class="nav-label">${menu.name}</span>
                  <span class="fa arrow"></span>
                </a>
                <ul class="nav nav-second-level" >
                  <c:forEach items="<%=secMenus%>" var="secMenu" varStatus="idxStatus">
                    <c:if test="${secMenu.isShow eq '1'&& fns:contains(secMenu,menuList)}" >
                    <li>
                      <%
                        List<Menu> thdMenus= Lists.newArrayList();
                        Menu.sortList(thdMenus, (List<Menu>) pageContext.getAttribute("menuList"),((Menu)pageContext.getAttribute("secMenu")).getId(),false);
                      %>
                      <c:if test="<%=thdMenus.size()>0%>" >
                        <a  href="#">
                          <i class="fa fa-${secMenu.icon}"></i>
                          <span class="nav-label">${secMenu.name}</span>
                          <span class="fa arrow"></span>
                        </a>
                        <ul class="nav nav-third-level" >
                          <c:forEach items="<%=thdMenus%>" var="thdMenu" varStatus="idzStatus">
                            <c:if test="${thdMenu.isShow eq '1'&&fns:contains(thdMenu,menuList)}">
                              <li>
                                <a class="J_menuItem" href="${fn:indexOf(thdMenu.href, '://') eq -1?ctx:''}${not empty thdMenu.href?thdMenu.href:'/404'}"><i class="fa fa-${thdMenu.icon}"></i><span class="nav-label">${thdMenu.name}</span></a>
                              </li>
                            </c:if>
                          </c:forEach>
                        </ul>
                      </c:if>
                      <c:if test="<%=thdMenus.size()<1%>" >
                        <a class="J_menuItem" href="${fn:indexOf(secMenu.href, '://') eq -1?ctx:''}${not empty secMenu.href?secMenu.href:'/404'}"><i class="fa fa-${secMenu.icon}"></i><span class="nav-label">${secMenu.name}</span></a>
                      </c:if>
                    </li>
                    </c:if>
                  </c:forEach>
                </ul>
          </c:if>
              <c:if test="<%=secMenus.size()<1 %>" >
                <a class="J_menuItem" href="${fn:indexOf(menu.href, '://') eq -1?ctx:''}${not empty menu.href?menu.href:'/404'}"><i class="fa fa-${menu.icon}"></i><span class="nav-label">${menu.name}</span></a>
              </c:if>
            </li>
          </c:if>
        </c:forEach>
      </ul>
    </div>
  </nav>
  <!--左侧导航结束-->
  <!--右侧部分开始-->
  <div id="page-wrapper" class="gray-bg dashbard-1">
    <div class="row border-bottom">
      <nav class="navbar navbar-static-top" role="navigation" style="margin-bottom: 0">
        <div class="navbar-header"><a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
          <form role="search" class="navbar-form-custom" method="post" action="search_results.html">
            <div class="form-group">
              <input type="text" placeholder="请输入您需要查找的内容 …" class="form-control" name="top-search" id="top-search">
            </div>
          </form>
        </div>
        <ul class="nav navbar-top-links navbar-right">
          <li class="dropdown">
            <a class="J_menuItem count-info" href="${ctx}/oa/oaNotify/self">
              <i class="fa fa-envelope"></i> <span id="msgCount"  class="label label-warning">0</span>
            </a>
          </li>
         <%-- <li class="hidden-xs">
            <a href="index_v1.html" class="J_menuItem" data-index="0"><i class="fa fa-cart-arrow-down"></i> 购买</a>
          </li>--%>
          <li class="dropdown hidden-xs">
            <a data-toggle="dropdown"  class="dropdown-toggle " style="padding-top: 15px;padding-bottom: 15px; max-widows:120px;min-height:30px;" aria-expanded="false">
              <img alt="image" class="img-circle" height="30" width="30"
                   <c:if test="${empty fns:getUser().photo}">
                      src="${ctxStatic}/images/profile_small.jpg"
                   </c:if>
                      <c:if test="${! empty fns:getUser().photo}">
                        src="${fns:getUser().photo}"
                      </c:if>
                      />
             <strong class="font-bold">${fns:getUser().name}</strong>

            </a>
            <ul class="dropdown-menu animated fadeInRight m-t-xs">
              <li><a class="J_menuItem" href="${ctx}/sys/user/modifyPwd">修改密码</a>
              </li>
              <li><a class="J_menuItem" href="${ctx}/sys/user/info">个人信息</a>
              </li>
              <li class="divider"></li>
              <li><a href="${ctx}/logout">安全退出</a>
              </li>
            </ul>
          </li>
        </ul>
      </nav>
    </div>
    <div class="row content-tabs">
      <button class="roll-nav roll-left J_tabLeft"><i class="fa fa-backward"></i>
      </button>
      <nav class="page-tabs J_menuTabs">
        <div class="page-tabs-content">
          <a href="javascript:;" class="active J_menuTab" data-id="${ctx}/home">首页</a>
        </div>
      </nav>
      <button class="roll-nav roll-right J_tabRight"><i class="fa fa-forward"></i>
      </button>
      <div class="btn-group roll-nav roll-right">
        <button class="dropdown J_tabClose" data-toggle="dropdown">关闭操作<span class="caret"></span>

        </button>
        <ul role="menu" class="dropdown-menu dropdown-menu-right">
          <li class="J_tabShowActive"><a>定位当前选项卡</a>
          </li>
          <li class="divider"></li>
          <li class="J_tabCloseAll"><a>关闭全部选项卡</a>
          </li>
          <li class="J_tabCloseOther"><a>关闭其他选项卡</a>
          </li>
        </ul>
      </div>
      <a href="${ctx}/logout" class="roll-nav roll-right J_tabExit"><i class="fa fa fa-sign-out"></i> 退出</a>
    </div>
    <div class="row J_mainContent" id="content-main">
      <iframe class="J_iframe" name="iframe0" width="100%" height="100%" src="${ctx}/home" frameborder="0" data-id="${ctx}/home" seamless></iframe>
    </div>
    <div class="footer">
      <div class="pull-right">&copy; 2015xxxxxxxxxx-2016 <a href="http://www.jinyao.com.cn/" target="_blank">Jinyao</a>
      </div>
    </div>
  </div>
  <!--右侧部分结束-->
 <!--右侧边栏开始-->
 <%-- <div id="right-sidebar">
    <div class="sidebar-container">

      <ul class="nav nav-tabs navs-3">

        <li class="active">
          <a data-toggle="tab" href="#tab-1">
            <i class="fa fa-gear"></i> 主题
          </a>
        </li>
        <li class=""><a data-toggle="tab" href="#tab-2">
          通知
        </a>
        </li>
        <li><a data-toggle="tab" href="#tab-3">
          项目进度
        </a>
        </li>
      </ul>

      <div class="tab-content">
        <div id="tab-1" class="tab-pane active">
          <div class="sidebar-title">
            <h3> <i class="fa fa-comments-o"></i> 主题设置</h3>
            <small><i class="fa fa-tim"></i> 你可以从这里选择和预览主题的布局和样式，这些设置会被保存在本地，下次打开的时候会直接应用这些设置。</small>
          </div>
          <div class="skin-setttings">
            <div class="title">主题设置</div>
            <div class="setings-item">
              <span>收起左侧菜单</span>
              <div class="switch">
                <div class="onoffswitch">
                  <input type="checkbox" name="collapsemenu" class="onoffswitch-checkbox" id="collapsemenu">
                  <label class="onoffswitch-label" for="collapsemenu">
                    <span class="onoffswitch-inner"></span>
                    <span class="onoffswitch-switch"></span>
                  </label>
                </div>
              </div>
            </div>
            <div class="setings-item">
              <span>固定顶部</span>

              <div class="switch">
                <div class="onoffswitch">
                  <input type="checkbox" name="fixednavbar" class="onoffswitch-checkbox" id="fixednavbar">
                  <label class="onoffswitch-label" for="fixednavbar">
                    <span class="onoffswitch-inner"></span>
                    <span class="onoffswitch-switch"></span>
                  </label>
                </div>
              </div>
            </div>
            <div class="setings-item">
                                <span>
                        固定宽度
                    </span>

              <div class="switch">
                <div class="onoffswitch">
                  <input type="checkbox" name="boxedlayout" class="onoffswitch-checkbox" id="boxedlayout">
                  <label class="onoffswitch-label" for="boxedlayout">
                    <span class="onoffswitch-inner"></span>
                    <span class="onoffswitch-switch"></span>
                  </label>
                </div>
              </div>
            </div>
            <div class="title">皮肤选择</div>
            <div class="setings-item default-skin nb">
                                <span class="skin-name ">
                         <a href="#" class="s-skin-0">
                           默认皮肤
                         </a>
                    </span>
            </div>
            <div class="setings-item blue-skin nb">
                                <span class="skin-name ">
                        <a href="#" class="s-skin-1">
                          蓝色主题
                        </a>
                    </span>
            </div>
            <div class="setings-item yellow-skin nb">
                                <span class="skin-name ">
                        <a href="#" class="s-skin-3">
                          黄色/紫色主题
                        </a>
                    </span>
            </div>
          </div>
        </div>
        <div id="tab-2" class="tab-pane">

          <div class="sidebar-title">
            <h3> <i class="fa fa-comments-o"></i> 最新通知</h3>
            <small><i class="fa fa-tim"></i> 您当前有10条未读信息</small>
          </div>

          <div>

            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a1.jpg">

                  <div class="m-t-xs">
                    <i class="fa fa-star text-warning"></i>
                    <i class="fa fa-star text-warning"></i>
                  </div>
                </div>
                <div class="media-body">

                  据天津日报报道：瑞海公司董事长于学伟，副董事长董社轩等10人在13日上午已被控制。
                  <br>
                  <small class="text-muted">今天 4:21</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a2.jpg">
                </div>
                <div class="media-body">
                  HCY48之音乐大魔王会员专属皮肤已上线，快来一键换装拥有他，宣告你对华晨宇的爱吧！
                  <br>
                  <small class="text-muted">昨天 2:45</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a3.jpg">

                  <div class="m-t-xs">
                    <i class="fa fa-star text-warning"></i>
                    <i class="fa fa-star text-warning"></i>
                    <i class="fa fa-star text-warning"></i>
                  </div>
                </div>
                <div class="media-body">
                  写的好！与您分享
                  <br>
                  <small class="text-muted">昨天 1:10</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a4.jpg">
                </div>

                <div class="media-body">
                  国外极限小子的炼成！这还是亲生的吗！！
                  <br>
                  <small class="text-muted">昨天 8:37</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a8.jpg">
                </div>
                <div class="media-body">

                  一只流浪狗被收留后，为了减轻主人的负担，坚持自己觅食，甚至......有些东西，可能她比我们更懂。
                  <br>
                  <small class="text-muted">今天 4:21</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a7.jpg">
                </div>
                <div class="media-body">
                  这哥们的新视频又来了，创意杠杠滴，帅炸了！
                  <br>
                  <small class="text-muted">昨天 2:45</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a3.jpg">

                  <div class="m-t-xs">
                    <i class="fa fa-star text-warning"></i>
                    <i class="fa fa-star text-warning"></i>
                    <i class="fa fa-star text-warning"></i>
                  </div>
                </div>
                <div class="media-body">
                  最近在补追此剧，特别喜欢这段表白。
                  <br>
                  <small class="text-muted">昨天 1:10</small>
                </div>
              </a>
            </div>
            <div class="sidebar-message">
              <a href="#">
                <div class="pull-left text-center">
                  <img alt="image" class="img-circle message-avatar" src="img/a4.jpg">
                </div>
                <div class="media-body">
                  我发起了一个投票 【你认为下午大盘会翻红吗？】
                  <br>
                  <small class="text-muted">星期一 8:37</small>
                </div>
              </a>
            </div>
          </div>

        </div>
        <div id="tab-3" class="tab-pane">

          <div class="sidebar-title">
            <h3> <i class="fa fa-cube"></i> 最新任务</h3>
            <small><i class="fa fa-tim"></i> 您当前有14个任务，10个已完成</small>
          </div>

          <ul class="sidebar-list">
            <li>
              <a href="#">
                <div class="small pull-right m-t-xs">9小时以后</div>
                <h4>市场调研</h4> 按要求接收教材；

                <div class="small">已完成： 22%</div>
                <div class="progress progress-mini">
                  <div style="width: 22%;" class="progress-bar progress-bar-warning"></div>
                </div>
                <div class="small text-muted m-t-xs">项目截止： 4:00 - 2015.10.01</div>
              </a>
            </li>
            <li>
              <a href="#">
                <div class="small pull-right m-t-xs">9小时以后</div>
                <h4>可行性报告研究报上级批准 </h4> 编写目的编写本项目进度报告的目的在于更好的控制软件开发的时间,对团队成员的 开发进度作出一个合理的比对

                <div class="small">已完成： 48%</div>
                <div class="progress progress-mini">
                  <div style="width: 48%;" class="progress-bar"></div>
                </div>
              </a>
            </li>
            <li>
              <a href="#">
                <div class="small pull-right m-t-xs">9小时以后</div>
                <h4>立项阶段</h4> 东风商用车公司 采购综合综合查询分析系统项目进度阶段性报告武汉斯迪克科技有限公司

                <div class="small">已完成： 14%</div>
                <div class="progress progress-mini">
                  <div style="width: 14%;" class="progress-bar progress-bar-info"></div>
                </div>
              </a>
            </li>
            <li>
              <a href="#">
                <span class="label label-primary pull-right">NEW</span>
                <h4>设计阶段</h4>
                <!--<div class="small pull-right m-t-xs">9小时以后</div>-->
                项目进度报告(Project Progress Report)
                <div class="small">已完成： 22%</div>
                <div class="small text-muted m-t-xs">项目截止： 4:00 - 2015.10.01</div>
              </a>
            </li>
            <li>
              <a href="#">
                <div class="small pull-right m-t-xs">9小时以后</div>
                <h4>拆迁阶段</h4> 科研项目研究进展报告 项目编号: 项目名称: 项目负责人:

                <div class="small">已完成： 22%</div>
                <div class="progress progress-mini">
                  <div style="width: 22%;" class="progress-bar progress-bar-warning"></div>
                </div>
                <div class="small text-muted m-t-xs">项目截止： 4:00 - 2015.10.01</div>
              </a>
            </li>
            <li>
              <a href="#">
                <div class="small pull-right m-t-xs">9小时以后</div>
                <h4>建设阶段 </h4> 编写目的编写本项目进度报告的目的在于更好的控制软件开发的时间,对团队成员的 开发进度作出一个合理的比对

                <div class="small">已完成： 48%</div>
                <div class="progress progress-mini">
                  <div style="width: 48%;" class="progress-bar"></div>
                </div>
              </a>
            </li>
            <li>
              <a href="#">
                <div class="small pull-right m-t-xs">9小时以后</div>
                <h4>获证开盘</h4> 编写目的编写本项目进度报告的目的在于更好的控制软件开发的时间,对团队成员的 开发进度作出一个合理的比对

                <div class="small">已完成： 14%</div>
                <div class="progress progress-mini">
                  <div style="width: 14%;" class="progress-bar progress-bar-info"></div>
                </div>
              </a>
            </li>

          </ul>

        </div>
      </div>

    </div>
  </div>--%>
  <!--右侧边栏结束-->

</div>


</body>

</html>
