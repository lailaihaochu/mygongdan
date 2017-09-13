<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html style="overflow-x:hidden;overflow-y:auto;">
<head>
    <title>图标选择</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
    <style type="text/css">
		.the-icons {padding:25px 10px 15px;list-style:none;}
		.the-icons li {float:left;width:22%;line-height:25px;margin:2px 5px;cursor:pointer;}
		.the-icons i {margin:1px 5px;} .the-icons li:hover {background-color:#efefef;}
        .the-icons li.active {background-color:#0088CC;color:#ffffff;}
    </style>
    <script type="text/javascript">
        var dblfunc;
	    $(document).ready(function(){
	    	$("#icons a").click(function(){
	    		$("#icons a").removeClass("active");
	    		$("#icons a i").removeClass("icon-white");
	    		$(this).addClass("active");
	    		$(this).children("i").addClass("icon-white");
	    		$("#icon").val($(this).text().trim());
	    	});
	    	$("#icons a").each(function(){
	    		if ($(this).text().trim()=="${value}"){
	    			$(this).click();
	    		}
	    	});
	    	$("#icons a").dblclick(function(){
                var index=parent.layer.getFrameIndex(window.name);
                dblfunc(index,$("#layui-layer"+index,window.parent.document));
	    	});
	    });
    </script>
</head>
<body>
<input type="hidden" id="icon" value="${value}" />
<div id="icons" class="row fontawesome-icon-list">

    <div class="fa-hover col-md-3 col-sm-4"><a href="#adjust"><i class="fa fa-adjust"></i> adjust</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#anchor"><i class="fa fa-anchor"></i> anchor</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#archive"><i class="fa fa-archive"></i> archive</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#area-chart"><i class="fa fa-area-chart"></i> area-chart</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#arrows"><i class="fa fa-arrows"></i> arrows</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#arrows-h"><i class="fa fa-arrows-h"></i> arrows-h</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#arrows-v"><i class="fa fa-arrows-v"></i> arrows-v</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#asterisk"><i class="fa fa-asterisk"></i> asterisk</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#at"><i class="fa fa-at"></i> at</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#car"><i class="fa fa-automobile"></i> automobile </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#balance-scale"><i class="fa fa-balance-scale"></i> balance-scale</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#ban"><i class="fa fa-ban"></i> ban</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#university"><i class="fa fa-bank"></i> bank </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bar-chart"><i class="fa fa-bar-chart"></i> bar-chart</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bar-chart"><i class="fa fa-bar-chart-o"></i> bar-chart-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#barcode"><i class="fa fa-barcode"></i> barcode</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bars"><i class="fa fa-bars"></i> bars</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-empty"><i class="fa fa-battery-0"></i> battery-0 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-quarter"><i class="fa fa-battery-1"></i> battery-1 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-half"><i class="fa fa-battery-2"></i> battery-2 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-three-quarters"><i class="fa fa-battery-3"></i> battery-3 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-full"><i class="fa fa-battery-4"></i> battery-4 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-empty"><i class="fa fa-battery-empty"></i> battery-empty</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-full"><i class="fa fa-battery-full"></i> battery-full</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-half"><i class="fa fa-battery-half"></i> battery-half</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-quarter"><i class="fa fa-battery-quarter"></i> battery-quarter</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#battery-three-quarters"><i class="fa fa-battery-three-quarters"></i> battery-three-quarters</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bed"><i class="fa fa-bed"></i> bed</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#beer"><i class="fa fa-beer"></i> beer</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bell"><i class="fa fa-bell"></i> bell</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bell-o"><i class="fa fa-bell-o"></i> bell-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bell-slash"><i class="fa fa-bell-slash"></i> bell-slash</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bell-slash-o"><i class="fa fa-bell-slash-o"></i> bell-slash-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bicycle"><i class="fa fa-bicycle"></i> bicycle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#binoculars"><i class="fa fa-binoculars"></i> binoculars</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#birthday-cake"><i class="fa fa-birthday-cake"></i> birthday-cake</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bolt"><i class="fa fa-bolt"></i> bolt</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bomb"><i class="fa fa-bomb"></i> bomb</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#book"><i class="fa fa-book"></i> book</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bookmark"><i class="fa fa-bookmark"></i> bookmark</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bookmark-o"><i class="fa fa-bookmark-o"></i> bookmark-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#briefcase"><i class="fa fa-briefcase"></i> briefcase</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bug"><i class="fa fa-bug"></i> bug</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#building"><i class="fa fa-building"></i> building</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#building-o"><i class="fa fa-building-o"></i> building-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bullhorn"><i class="fa fa-bullhorn"></i> bullhorn</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bullseye"><i class="fa fa-bullseye"></i> bullseye</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bus"><i class="fa fa-bus"></i> bus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#taxi"><i class="fa fa-cab"></i> cab </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calculator"><i class="fa fa-calculator"></i> calculator</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calendar"><i class="fa fa-calendar"></i> calendar</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calendar-check-o"><i class="fa fa-calendar-check-o"></i> calendar-check-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calendar-minus-o"><i class="fa fa-calendar-minus-o"></i> calendar-minus-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calendar-o"><i class="fa fa-calendar-o"></i> calendar-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calendar-plus-o"><i class="fa fa-calendar-plus-o"></i> calendar-plus-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#calendar-times-o"><i class="fa fa-calendar-times-o"></i> calendar-times-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#camera"><i class="fa fa-camera"></i> camera</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#camera-retro"><i class="fa fa-camera-retro"></i> camera-retro</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#car"><i class="fa fa-car"></i> car</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-down"><i class="fa fa-caret-square-o-down"></i> caret-square-o-down</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-left"><i class="fa fa-caret-square-o-left"></i> caret-square-o-left</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-right"><i class="fa fa-caret-square-o-right"></i> caret-square-o-right</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-up"><i class="fa fa-caret-square-o-up"></i> caret-square-o-up</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cart-arrow-down"><i class="fa fa-cart-arrow-down"></i> cart-arrow-down</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cart-plus"><i class="fa fa-cart-plus"></i> cart-plus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cc"><i class="fa fa-cc"></i> cc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#certificate"><i class="fa fa-certificate"></i> certificate</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#check"><i class="fa fa-check"></i> check</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#check-circle"><i class="fa fa-check-circle"></i> check-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#check-circle-o"><i class="fa fa-check-circle-o"></i> check-circle-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#check-square"><i class="fa fa-check-square"></i> check-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#check-square-o"><i class="fa fa-check-square-o"></i> check-square-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#child"><i class="fa fa-child"></i> child</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#circle"><i class="fa fa-circle"></i> circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#circle-o"><i class="fa fa-circle-o"></i> circle-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#circle-o-notch"><i class="fa fa-circle-o-notch"></i> circle-o-notch</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#circle-thin"><i class="fa fa-circle-thin"></i> circle-thin</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#clock-o"><i class="fa fa-clock-o"></i> clock-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#clone"><i class="fa fa-clone"></i> clone</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#times"><i class="fa fa-close"></i> close </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cloud"><i class="fa fa-cloud"></i> cloud</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cloud-download"><i class="fa fa-cloud-download"></i> cloud-download</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cloud-upload"><i class="fa fa-cloud-upload"></i> cloud-upload</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#code"><i class="fa fa-code"></i> code</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#code-fork"><i class="fa fa-code-fork"></i> code-fork</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#coffee"><i class="fa fa-coffee"></i> coffee</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cog"><i class="fa fa-cog"></i> cog</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cogs"><i class="fa fa-cogs"></i> cogs</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#comment"><i class="fa fa-comment"></i> comment</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#comment-o"><i class="fa fa-comment-o"></i> comment-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#commenting"><i class="fa fa-commenting"></i> commenting</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#commenting-o"><i class="fa fa-commenting-o"></i> commenting-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#comments"><i class="fa fa-comments"></i> comments</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#comments-o"><i class="fa fa-comments-o"></i> comments-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#compass"><i class="fa fa-compass"></i> compass</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#copyright"><i class="fa fa-copyright"></i> copyright</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#creative-commons"><i class="fa fa-creative-commons"></i> creative-commons</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#credit-card"><i class="fa fa-credit-card"></i> credit-card</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#crop"><i class="fa fa-crop"></i> crop</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#crosshairs"><i class="fa fa-crosshairs"></i> crosshairs</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cube"><i class="fa fa-cube"></i> cube</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cubes"><i class="fa fa-cubes"></i> cubes</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cutlery"><i class="fa fa-cutlery"></i> cutlery</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tachometer"><i class="fa fa-dashboard"></i> dashboard </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#database"><i class="fa fa-database"></i> database</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#desktop"><i class="fa fa-desktop"></i> desktop</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#diamond"><i class="fa fa-diamond"></i> diamond</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#dot-circle-o"><i class="fa fa-dot-circle-o"></i> dot-circle-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#download"><i class="fa fa-download"></i> download</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#pencil-square-o"><i class="fa fa-edit"></i> edit </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#ellipsis-h"><i class="fa fa-ellipsis-h"></i> ellipsis-h</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#ellipsis-v"><i class="fa fa-ellipsis-v"></i> ellipsis-v</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#envelope"><i class="fa fa-envelope"></i> envelope</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#envelope-o"><i class="fa fa-envelope-o"></i> envelope-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#envelope-square"><i class="fa fa-envelope-square"></i> envelope-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#eraser"><i class="fa fa-eraser"></i> eraser</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#exchange"><i class="fa fa-exchange"></i> exchange</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#exclamation"><i class="fa fa-exclamation"></i> exclamation</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#exclamation-circle"><i class="fa fa-exclamation-circle"></i> exclamation-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#exclamation-triangle"><i class="fa fa-exclamation-triangle"></i> exclamation-triangle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#external-link"><i class="fa fa-external-link"></i> external-link</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#external-link-square"><i class="fa fa-external-link-square"></i> external-link-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#eye"><i class="fa fa-eye"></i> eye</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#eye-slash"><i class="fa fa-eye-slash"></i> eye-slash</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#eyedropper"><i class="fa fa-eyedropper"></i> eyedropper</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#fax"><i class="fa fa-fax"></i> fax</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#rss"><i class="fa fa-feed"></i> feed </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#female"><i class="fa fa-female"></i> female</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#fighter-jet"><i class="fa fa-fighter-jet"></i> fighter-jet</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-archive-o"><i class="fa fa-file-archive-o"></i> file-archive-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-audio-o"><i class="fa fa-file-audio-o"></i> file-audio-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-code-o"><i class="fa fa-file-code-o"></i> file-code-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-excel-o"><i class="fa fa-file-excel-o"></i> file-excel-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-image-o"><i class="fa fa-file-image-o"></i> file-image-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-video-o"><i class="fa fa-file-movie-o"></i> file-movie-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-pdf-o"><i class="fa fa-file-pdf-o"></i> file-pdf-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-image-o"><i class="fa fa-file-photo-o"></i> file-photo-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-image-o"><i class="fa fa-file-picture-o"></i> file-picture-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-powerpoint-o"><i class="fa fa-file-powerpoint-o"></i> file-powerpoint-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-audio-o"><i class="fa fa-file-sound-o"></i> file-sound-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-video-o"><i class="fa fa-file-video-o"></i> file-video-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-word-o"><i class="fa fa-file-word-o"></i> file-word-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#file-archive-o"><i class="fa fa-file-zip-o"></i> file-zip-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#film"><i class="fa fa-film"></i> film</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#filter"><i class="fa fa-filter"></i> filter</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#fire"><i class="fa fa-fire"></i> fire</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#fire-extinguisher"><i class="fa fa-fire-extinguisher"></i> fire-extinguisher</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#flag"><i class="fa fa-flag"></i> flag</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#flag-checkered"><i class="fa fa-flag-checkered"></i> flag-checkered</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#flag-o"><i class="fa fa-flag-o"></i> flag-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bolt"><i class="fa fa-flash"></i> flash </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#flask"><i class="fa fa-flask"></i> flask</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#folder"><i class="fa fa-folder"></i> folder</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#folder-o"><i class="fa fa-folder-o"></i> folder-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#folder-open"><i class="fa fa-folder-open"></i> folder-open</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#folder-open-o"><i class="fa fa-folder-open-o"></i> folder-open-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#frown-o"><i class="fa fa-frown-o"></i> frown-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#futbol-o"><i class="fa fa-futbol-o"></i> futbol-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#gamepad"><i class="fa fa-gamepad"></i> gamepad</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#gavel"><i class="fa fa-gavel"></i> gavel</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cog"><i class="fa fa-gear"></i> gear </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#cogs"><i class="fa fa-gears"></i> gears </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#gift"><i class="fa fa-gift"></i> gift</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#glass"><i class="fa fa-glass"></i> glass</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#globe"><i class="fa fa-globe"></i> globe</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#graduation-cap"><i class="fa fa-graduation-cap"></i> graduation-cap</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#users"><i class="fa fa-group"></i> group </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-rock-o"><i class="fa fa-hand-grab-o"></i> hand-grab-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-lizard-o"><i class="fa fa-hand-lizard-o"></i> hand-lizard-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-paper-o"><i class="fa fa-hand-paper-o"></i> hand-paper-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-peace-o"><i class="fa fa-hand-peace-o"></i> hand-peace-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-pointer-o"><i class="fa fa-hand-pointer-o"></i> hand-pointer-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-rock-o"><i class="fa fa-hand-rock-o"></i> hand-rock-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-scissors-o"><i class="fa fa-hand-scissors-o"></i> hand-scissors-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-spock-o"><i class="fa fa-hand-spock-o"></i> hand-spock-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hand-paper-o"><i class="fa fa-hand-stop-o"></i> hand-stop-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hdd-o"><i class="fa fa-hdd-o"></i> hdd-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#headphones"><i class="fa fa-headphones"></i> headphones</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#heart"><i class="fa fa-heart"></i> heart</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#heart-o"><i class="fa fa-heart-o"></i> heart-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#heartbeat"><i class="fa fa-heartbeat"></i> heartbeat</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#history"><i class="fa fa-history"></i> history</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#home"><i class="fa fa-home"></i> home</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bed"><i class="fa fa-hotel"></i> hotel </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass"><i class="fa fa-hourglass"></i> hourglass</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-start"><i class="fa fa-hourglass-1"></i> hourglass-1 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-half"><i class="fa fa-hourglass-2"></i> hourglass-2 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-end"><i class="fa fa-hourglass-3"></i> hourglass-3 </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-end"><i class="fa fa-hourglass-end"></i> hourglass-end</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-half"><i class="fa fa-hourglass-half"></i> hourglass-half</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-o"><i class="fa fa-hourglass-o"></i> hourglass-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#hourglass-start"><i class="fa fa-hourglass-start"></i> hourglass-start</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#i-cursor"><i class="fa fa-i-cursor"></i> i-cursor</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#picture-o"><i class="fa fa-image"></i> image </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#inbox"><i class="fa fa-inbox"></i> inbox</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#industry"><i class="fa fa-industry"></i> industry</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#info"><i class="fa fa-info"></i> info</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#info-circle"><i class="fa fa-info-circle"></i> info-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#university"><i class="fa fa-institution"></i> institution </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#key"><i class="fa fa-key"></i> key</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#keyboard-o"><i class="fa fa-keyboard-o"></i> keyboard-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#language"><i class="fa fa-language"></i> language</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#laptop"><i class="fa fa-laptop"></i> laptop</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#leaf"><i class="fa fa-leaf"></i> leaf</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#gavel"><i class="fa fa-legal"></i> legal </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#lemon-o"><i class="fa fa-lemon-o"></i> lemon-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#level-down"><i class="fa fa-level-down"></i> level-down</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#level-up"><i class="fa fa-level-up"></i> level-up</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#life-ring"><i class="fa fa-life-bouy"></i> life-bouy </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#life-ring"><i class="fa fa-life-buoy"></i> life-buoy </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#life-ring"><i class="fa fa-life-ring"></i> life-ring</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#life-ring"><i class="fa fa-life-saver"></i> life-saver </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#lightbulb-o"><i class="fa fa-lightbulb-o"></i> lightbulb-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#line-chart"><i class="fa fa-line-chart"></i> line-chart</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#location-arrow"><i class="fa fa-location-arrow"></i> location-arrow</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#lock"><i class="fa fa-lock"></i> lock</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#magic"><i class="fa fa-magic"></i> magic</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#magnet"><i class="fa fa-magnet"></i> magnet</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#share"><i class="fa fa-mail-forward"></i> mail-forward </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#reply"><i class="fa fa-mail-reply"></i> mail-reply </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#reply-all"><i class="fa fa-mail-reply-all"></i> mail-reply-all </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#male"><i class="fa fa-male"></i> male</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#map"><i class="fa fa-map"></i> map</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#map-marker"><i class="fa fa-map-marker"></i> map-marker</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#map-o"><i class="fa fa-map-o"></i> map-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#map-pin"><i class="fa fa-map-pin"></i> map-pin</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#map-signs"><i class="fa fa-map-signs"></i> map-signs</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#meh-o"><i class="fa fa-meh-o"></i> meh-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#microphone"><i class="fa fa-microphone"></i> microphone</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#microphone-slash"><i class="fa fa-microphone-slash"></i> microphone-slash</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#minus"><i class="fa fa-minus"></i> minus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#minus-circle"><i class="fa fa-minus-circle"></i> minus-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#minus-square"><i class="fa fa-minus-square"></i> minus-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#minus-square-o"><i class="fa fa-minus-square-o"></i> minus-square-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#mobile"><i class="fa fa-mobile"></i> mobile</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#mobile"><i class="fa fa-mobile-phone"></i> mobile-phone </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#money"><i class="fa fa-money"></i> money</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#moon-o"><i class="fa fa-moon-o"></i> moon-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#graduation-cap"><i class="fa fa-mortar-board"></i> mortar-board </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#motorcycle"><i class="fa fa-motorcycle"></i> motorcycle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#mouse-pointer"><i class="fa fa-mouse-pointer"></i> mouse-pointer</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#music"><i class="fa fa-music"></i> music</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bars"><i class="fa fa-navicon"></i> navicon </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#newspaper-o"><i class="fa fa-newspaper-o"></i> newspaper-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#object-group"><i class="fa fa-object-group"></i> object-group</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#object-ungroup"><i class="fa fa-object-ungroup"></i> object-ungroup</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#paint-brush"><i class="fa fa-paint-brush"></i> paint-brush</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#paper-plane"><i class="fa fa-paper-plane"></i> paper-plane</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#paper-plane-o"><i class="fa fa-paper-plane-o"></i> paper-plane-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#paw"><i class="fa fa-paw"></i> paw</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#pencil"><i class="fa fa-pencil"></i> pencil</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#pencil-square"><i class="fa fa-pencil-square"></i> pencil-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#pencil-square-o"><i class="fa fa-pencil-square-o"></i> pencil-square-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#phone"><i class="fa fa-phone"></i> phone</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#phone-square"><i class="fa fa-phone-square"></i> phone-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#picture-o"><i class="fa fa-photo"></i> photo </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#picture-o"><i class="fa fa-picture-o"></i> picture-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#pie-chart"><i class="fa fa-pie-chart"></i> pie-chart</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#plane"><i class="fa fa-plane"></i> plane</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#plug"><i class="fa fa-plug"></i> plug</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#plus"><i class="fa fa-plus"></i> plus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#plus-circle"><i class="fa fa-plus-circle"></i> plus-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#plus-square"><i class="fa fa-plus-square"></i> plus-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#plus-square-o"><i class="fa fa-plus-square-o"></i> plus-square-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#power-off"><i class="fa fa-power-off"></i> power-off</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#print"><i class="fa fa-print"></i> print</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#puzzle-piece"><i class="fa fa-puzzle-piece"></i> puzzle-piece</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#qrcode"><i class="fa fa-qrcode"></i> qrcode</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#question"><i class="fa fa-question"></i> question</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#question-circle"><i class="fa fa-question-circle"></i> question-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#quote-left"><i class="fa fa-quote-left"></i> quote-left</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#quote-right"><i class="fa fa-quote-right"></i> quote-right</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#random"><i class="fa fa-random"></i> random</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#recycle"><i class="fa fa-recycle"></i> recycle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#refresh"><i class="fa fa-refresh"></i> refresh</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#registered"><i class="fa fa-registered"></i> registered</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#times"><i class="fa fa-remove"></i> remove </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#bars"><i class="fa fa-reorder"></i> reorder </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#reply"><i class="fa fa-reply"></i> reply</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#reply-all"><i class="fa fa-reply-all"></i> reply-all</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#retweet"><i class="fa fa-retweet"></i> retweet</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#road"><i class="fa fa-road"></i> road</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#rocket"><i class="fa fa-rocket"></i> rocket</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#rss"><i class="fa fa-rss"></i> rss</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#rss-square"><i class="fa fa-rss-square"></i> rss-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#search"><i class="fa fa-search"></i> search</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#search-minus"><i class="fa fa-search-minus"></i> search-minus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#search-plus"><i class="fa fa-search-plus"></i> search-plus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#paper-plane"><i class="fa fa-send"></i> send </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#paper-plane-o"><i class="fa fa-send-o"></i> send-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#server"><i class="fa fa-server"></i> server</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#share"><i class="fa fa-share"></i> share</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#share-alt"><i class="fa fa-share-alt"></i> share-alt</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#share-alt-square"><i class="fa fa-share-alt-square"></i> share-alt-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#share-square"><i class="fa fa-share-square"></i> share-square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#share-square-o"><i class="fa fa-share-square-o"></i> share-square-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#shield"><i class="fa fa-shield"></i> shield</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#ship"><i class="fa fa-ship"></i> ship</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#shopping-cart"><i class="fa fa-shopping-cart"></i> shopping-cart</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sign-in"><i class="fa fa-sign-in"></i> sign-in</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sign-out"><i class="fa fa-sign-out"></i> sign-out</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#signal"><i class="fa fa-signal"></i> signal</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sitemap"><i class="fa fa-sitemap"></i> sitemap</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sliders"><i class="fa fa-sliders"></i> sliders</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#smile-o"><i class="fa fa-smile-o"></i> smile-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#futbol-o"><i class="fa fa-soccer-ball-o"></i> soccer-ball-o </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort"><i class="fa fa-sort"></i> sort</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-alpha-asc"><i class="fa fa-sort-alpha-asc"></i> sort-alpha-asc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-alpha-desc"><i class="fa fa-sort-alpha-desc"></i> sort-alpha-desc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-amount-asc"><i class="fa fa-sort-amount-asc"></i> sort-amount-asc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-amount-desc"><i class="fa fa-sort-amount-desc"></i> sort-amount-desc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-asc"><i class="fa fa-sort-asc"></i> sort-asc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-desc"><i class="fa fa-sort-desc"></i> sort-desc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-desc"><i class="fa fa-sort-down"></i> sort-down </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-numeric-asc"><i class="fa fa-sort-numeric-asc"></i> sort-numeric-asc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-numeric-desc"><i class="fa fa-sort-numeric-desc"></i> sort-numeric-desc</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort-asc"><i class="fa fa-sort-up"></i> sort-up </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#space-shuttle"><i class="fa fa-space-shuttle"></i> space-shuttle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#spinner"><i class="fa fa-spinner"></i> spinner</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#spoon"><i class="fa fa-spoon"></i> spoon</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#square"><i class="fa fa-square"></i> square</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#square-o"><i class="fa fa-square-o"></i> square-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#star"><i class="fa fa-star"></i> star</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#star-half"><i class="fa fa-star-half"></i> star-half</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#star-half-o"><i class="fa fa-star-half-empty"></i> star-half-empty </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#star-half-o"><i class="fa fa-star-half-full"></i> star-half-full </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#star-half-o"><i class="fa fa-star-half-o"></i> star-half-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#star-o"><i class="fa fa-star-o"></i> star-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sticky-note"><i class="fa fa-sticky-note"></i> sticky-note</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sticky-note-o"><i class="fa fa-sticky-note-o"></i> sticky-note-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#street-view"><i class="fa fa-street-view"></i> street-view</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#suitcase"><i class="fa fa-suitcase"></i> suitcase</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sun-o"><i class="fa fa-sun-o"></i> sun-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#life-ring"><i class="fa fa-support"></i> support </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tablet"><i class="fa fa-tablet"></i> tablet</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tachometer"><i class="fa fa-tachometer"></i> tachometer</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tag"><i class="fa fa-tag"></i> tag</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tags"><i class="fa fa-tags"></i> tags</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tasks"><i class="fa fa-tasks"></i> tasks</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#taxi"><i class="fa fa-taxi"></i> taxi</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#television"><i class="fa fa-television"></i> television</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#terminal"><i class="fa fa-terminal"></i> terminal</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#thumb-tack"><i class="fa fa-thumb-tack"></i> thumb-tack</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#thumbs-down"><i class="fa fa-thumbs-down"></i> thumbs-down</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#thumbs-o-down"><i class="fa fa-thumbs-o-down"></i> thumbs-o-down</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#thumbs-o-up"><i class="fa fa-thumbs-o-up"></i> thumbs-o-up</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#thumbs-up"><i class="fa fa-thumbs-up"></i> thumbs-up</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#ticket"><i class="fa fa-ticket"></i> ticket</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#times"><i class="fa fa-times"></i> times</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#times-circle"><i class="fa fa-times-circle"></i> times-circle</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#times-circle-o"><i class="fa fa-times-circle-o"></i> times-circle-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tint"><i class="fa fa-tint"></i> tint</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-down"><i class="fa fa-toggle-down"></i> toggle-down </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-left"><i class="fa fa-toggle-left"></i> toggle-left </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#toggle-off"><i class="fa fa-toggle-off"></i> toggle-off</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#toggle-on"><i class="fa fa-toggle-on"></i> toggle-on</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-right"><i class="fa fa-toggle-right"></i> toggle-right </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#caret-square-o-up"><i class="fa fa-toggle-up"></i> toggle-up </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#trademark"><i class="fa fa-trademark"></i> trademark</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#trash"><i class="fa fa-trash"></i> trash</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#trash-o"><i class="fa fa-trash-o"></i> trash-o</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tree"><i class="fa fa-tree"></i> tree</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#trophy"><i class="fa fa-trophy"></i> trophy</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#truck"><i class="fa fa-truck"></i> truck</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#tty"><i class="fa fa-tty"></i> tty</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#television"><i class="fa fa-tv"></i> tv </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#umbrella"><i class="fa fa-umbrella"></i> umbrella</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#university"><i class="fa fa-university"></i> university</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#unlock"><i class="fa fa-unlock"></i> unlock</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#unlock-alt"><i class="fa fa-unlock-alt"></i> unlock-alt</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#sort"><i class="fa fa-unsorted"></i> unsorted </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#upload"><i class="fa fa-upload"></i> upload</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#user"><i class="fa fa-user"></i> user</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#user-plus"><i class="fa fa-user-plus"></i> user-plus</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#user-secret"><i class="fa fa-user-secret"></i> user-secret</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#user-times"><i class="fa fa-user-times"></i> user-times</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#users"><i class="fa fa-users"></i> users</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#video-camera"><i class="fa fa-video-camera"></i> video-camera</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#volume-down"><i class="fa fa-volume-down"></i> volume-down</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#volume-off"><i class="fa fa-volume-off"></i> volume-off</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#volume-up"><i class="fa fa-volume-up"></i> volume-up</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#exclamation-triangle"><i class="fa fa-warning"></i> warning </a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#wheelchair"><i class="fa fa-wheelchair"></i> wheelchair</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#wifi"><i class="fa fa-wifi"></i> wifi</a></div>

    <div class="fa-hover col-md-3 col-sm-4"><a href="#wrench"><i class="fa fa-wrench"></i> wrench</a></div>

</div>
</body>