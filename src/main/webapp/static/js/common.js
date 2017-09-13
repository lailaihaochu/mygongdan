// 获取URL地址参数
function getQueryString(name, url) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    if (!url || url == ""){
        url = window.location.search;
    }else{
        url = url.substring(url.indexOf("?"));
    }
    r = url.substr(1).match(reg)
    if (r != null) return unescape(r[2]); return null;
}

//获取字典标签
function getDictLabel(data, value, defaultValue){
    for (var i=0; i<data.length; i++){
        var row = data[i];
        if (row.value == value){
            return row.label;
        }
    }
    return defaultValue;
}
// 引入js和css文件
function include(id, path, file){
    if (document.getElementById(id)==null){
        var files = typeof file == "string" ? [file] : file;
        for (var i = 0; i < files.length; i++){
            var name = files[i].replace(/^\s|\s$/g, "");
            var att = name.split('.');
            var ext = att[att.length - 1].toLowerCase();
            var isCSS = ext == "css";
            var tag = isCSS ? "link" : "script";
            var attr = isCSS ? " type='text/css' rel='stylesheet' " : " type='text/javascript' ";
            var link = (isCSS ? "href" : "src") + "='" + path + name + "'";
            document.write("<" + tag + (i==0?" id="+id:"") + attr + link + "></" + tag + ">");
        }
    }
}

// 打开一个窗体
function windowOpen(url, name, width, height){
    var top=parseInt((window.screen.height-height)/2,10),left=parseInt((window.screen.width-width)/2,10),
        options="location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,"+
            "resizable=yes,scrollbars=yes,"+"width="+width+",height="+height+",top="+top+",left="+left;
    window.open(url ,name , options);
}

function getImageWidth(url,callback){
    var img = new Image();
    img.src = url;

    // 如果图片被缓存，则直接返回缓存数据
    if(img.complete){
        callback(img.width, img.height);
    }else{
        // 完全加载完毕的事件
        img.onload = function(){
            callback(img.width, img.height);
        }
    }

}

var icons={};
icons["info"]=0;
icons["success"]=1;
icons["warning"]=0;
icons["error"]=2;
icons["loading"]=16;

//显示提示框
function showTip(mess, type, timeout, lazytime){
    resetTip();
    setTimeout(function(){
        top.layer.msg(mess, {icon:(type == undefined || type == '' ? icons['info'] : icons[type]),time:(timeout == undefined ? 2000 : timeout)});
    }, lazytime == undefined ? 500 : lazytime);
}
// 恢复提示框显示
function resetTip(){
    top.tipMess = null;
}
// 显示加载框
function loading(mess){
    resetTip();
    if (mess == undefined || mess == ""){
        mess = "正在提交，请稍等...";
    }
    top.mask=top.layer.msg(mess,{icon:16,time:0,shade:[0.1,'#000',true]});
}

// 警告对话框
function alertx(mess, closed){

    top.layer.alert(mess, {title:'提示',icon:icons['warning']},function(index){
        if (typeof closed == 'function') {
            closed();
        }
        top.layer.close(index);
    });
}

// 确认对话框
function confirmx(mess, href, closed){
    top.layer.confirm(mess,{icon: 3, title:'系统提示'},function(index){
        if (typeof href == 'function') {
            href();
        }else{
            resetTip();
            top.mask=top.layer.load();
            location = href;
        }
        top.layer.close(index);

    },function(index){
        if (typeof closed == 'function') {
            closed();
        }
        top.layer.close(index);
    });
    return false;
}

// cookie操作
function cookie(name, value, options) {
    if (typeof value != 'undefined') { // name and value given, set cookie
        options = options || {};
        if (value === null) {
            value = '';
            options.expires = -1;
        }
        var expires = '';
        if (options.expires && (typeof options.expires == 'number' || options.expires.toUTCString)) {
            var date;
            if (typeof options.expires == 'number') {
                date = new Date();
                date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
            } else {
                date = options.expires;
            }
            expires = '; expires=' + date.toUTCString(); // use expires attribute, max-age is not supported by IE
        }
        var path = options.path ? '; path=' + options.path : '';
        var domain = options.domain ? '; domain=' + options.domain : '';
        var secure = options.secure ? '; secure' : '';
        document.cookie = [name, '=', encodeURIComponent(value), expires, path, domain, secure].join('');
    } else { // only name given, get cookie
        var cookieValue = null;
        if (document.cookie && document.cookie != '') {
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = jQuery.trim(cookies[i]);
                // Does this cookie string begin with the name we want?
                if (cookie.substring(0, name.length + 1) == (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
}

// 数值前补零
function pad(num, n) {
    var len = num.toString().length;
    while(len < n) {
        num = "0" + num;
        len++;
    }
    return num;
}

// 转换为日期
function strToDate(date){
    return new Date(date.replace(/-/g,"/"));
}

// 日期加减
function addDate(date, dadd){
    date = date.valueOf();
    date = date + dadd * 24 * 60 * 60 * 1000;
    return new Date(date);
}

//截取字符串，区别汉字和英文
function abbr(name, maxLength){
    if(!maxLength){
        maxLength = 20;
    }
    if(name==null||name.length<1){
        return "";
    }
    var w = 0;//字符串长度，一个汉字长度为2
    var s = 0;//汉字个数
    var p = false;//判断字符串当前循环的前一个字符是否为汉字
    var b = false;//判断字符串当前循环的字符是否为汉字
    var nameSub;
    for (var i=0; i<name.length; i++) {
        if(i>1 && b==false){
            p = false;
        }
        if(i>1 && b==true){
            p = true;
        }
        var c = name.charCodeAt(i);
        //单字节加1
        if ((c >= 0x0001 && c <= 0x007e) || (0xff60<=c && c<=0xff9f)) {
            w++;
            b = false;
        }else {
            w+=2;
            s++;
            b = true;
        }
        if(w>maxLength && i<=name.length-1){
            if(b==true && p==true){
                nameSub = name.substring(0,i-2)+"...";
            }
            if(b==false && p==false){
                nameSub = name.substring(0,i-3)+"...";
            }
            if(b==true && p==false){
                nameSub = name.substring(0,i-2)+"...";
            }
            if(p==true){
                nameSub = name.substring(0,i-2)+"...";
            }
            break;
        }
    }
    if(w<=maxLength){
        return name;
    }
    return nameSub;
}

//设置validate的默认值
$.validator.setDefaults({
    submitHandler: function(form) {
        loading('正在提交，请稍等...');
        form.submit();
    },
    errorPlacement: function(error, element) {
        $("#messageBox").text("输入有误，请先更正！").removeClass("alert-success").addClass("alert-error");
        if ( element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append") ){
            error.appendTo(element.parent().parent());
        } else {
            error.insertAfter(element.parent());
        }
    }
});
function goHome() {
    var pathName = window.location.pathname.substring(1);
    var webName = pathName == '' ? '' : pathName.substring(0, pathName.indexOf('/'));
    if (webName == "") {
        window.location.href=window.location.protocol + '//' + window.location.host;
    }
    else {
        window.location.href=window.location.protocol + '//' + window.location.host + '/' + webName;
    }
}



$(document).ready(function() {
    var config = {
        '.chosen-select': {no_results_text: '没有找到匹配项',search_contains: true},
        '.chosen-select-deselect': {allow_single_deselect: true},
        '.chosen-select-no-single': {disable_search_threshold: 10},
        '.chosen-select-width': {width: "95%"}
    }
    for (var selector in config) {
        $(selector).chosen(config[selector]);
    }
    if(window.top === window.self){
        var gohome='<div class="gohome"><a class="animated bounceInUp" href="javascript:goHome();" title="返回首页"><i class="fa fa-home"></i></a></div>';
        $("body").append(gohome);
    }
});

/*
 *使用范例
 * <form id="post-form">
 * <label>姓名</label><input name="name" type="text" /><br/>
 * <label>性别</label><input name="sex" type="text" /><br/>
 * <b>联系方式：</b><label>手机</label><input name="contact.phone" type="text" /><label>邮箱</label><input name="contact.email" type="text" />
 * <b>成绩：</b><br />
 * <ol>
 * <li>
 * <p>语文<input name="score.index" type="hidden" value="s_1" /><input name="score[s_1].title" type="hidden" value="语文" /></p>
 * <p><input name="score[s_1].value" type="text" /></p>
 * </li>
 * <li>
 * <p>数学<input name="score.index" type="hidden" value="s_2" /><input name="score[s_2].title" type="hidden" value="语文" /></p>
 * <p><input name="score[s_2].value" type="text" /></p>
 * </li>
 * <li>
 * <p>其他成绩<input name="score.index" type="hidden" value="s_3" /><input name="score[s_3].title" type="hidden" value="其他成绩" /></p>
 * <p>
 * <ul>
 *      <li>
 *          <p>德<input name="score[s_3].value.index" type="hidden" value="s3_1" /><input name="score[s_3].value[s3_1].title" type="hidden" value="其他成绩" /></p>
 *          <p>
 *              <label><input name="score[s_3].value[s3_1].value" type="radio" value="差" />差</label>
 *              <label><input name="score[s_3].value[s3_1].value" type="radio" value="一般" />一般</label>
 *              <label><input name="score[s_3].value[s3_1].value" type="radio" value="很好" />很好</label>
 *          </p>
 *      </li>
 *      <li>
 *          <p>智<input name="score[s_3].value.index" type="hidden" value="s3_2" /><input name="score[s_3].value[s3_2].title" type="hidden" value="智" /></p>
 *          <p>
 *              <label><input name="score[s_3].value[s3_2].value" type="radio" value="差" />差</label>
 *              <label><input name="score[s_3].value[s3_2].value" type="radio" value="一般" />一般</label>
 *              <label><input name="score[s_3].value[s3_2].value" type="radio" value="很好" />很好</label>
 *          </p>
 *      </li>
 *      <li>
 *          <p>体育特长<input name="score[s_3].value.index" type="hidden" value="s3_3" /><input name="score[s_3].value[s3_3].title" type="hidden" value="体育特长" /></p>
 *          <p>
 *              <label><input name="score[s_3].value[s3_3].value" type="checkbox" value="跑步" />跑步</label>
 *              <label><input name="score[s_3].value[s3_3].value" type="checkbox" value="跳高" />跳高</label>
 *              <label><input name="score[s_3].value[s3_3].value" type="checkbox" value="足球" />足球</label>
 *              <label><input name="score[s_3].value[s3_3].value" type="checkbox" value="篮球" />篮球</label>
 *              <label><input name="score[s_3].value[s3_3].value" type="checkbox" value="其他" />其他</label>
 *          </p>
 *      </li>
 * </ul>
 * </p>
 * </li>
 * </ol>
 * </form>
 * <script>
 * $(function(){
 *      console.log($.formHelper.getObject($('#post-form').serialize()));
 * //得到的结构是：
 * {
 *      name:'',
 *      sex:'',
 *      contact:{
 *          phone:'',
 *          email:''
 *      }
 *      score:[
 *          {
 *              title:'语文',value:''
 *          }
 *          {
 *              title:'数学',value:''
 *          }
 *          {
 *              title:'其他成绩'
 *              value:[
 *                  {title:'德',value:''}
 *                  {title:'智',value:''}
 *                  {title:'体育特长',value:[]}
 *              ]
 *          }
 *      ]
 * }
 *
 *
 * });
 * </script>
 */
jQuery.formHelper = {
    getObject: function (urlserialize) {
        if (urlserialize) {
            urlserialize = decodeURI(urlserialize);
            var kvs = $.map((urlserialize).split('&'), function (e, i) {
                var kv = (e + '').split('=');
                return { key: kv[0], value: kv[1] };
            });
            var params = {};
            for (var key in kvs) {
                var _key = kvs[key].key;
                var value = null;
                if (typeof (params[_key]) == 'undefined') {
                    if ($.grep(kvs, function (e, i) { return e.key == _key; }).length > 1) {
                        value = [];
                        value.push(kvs[key].value);
                        params[_key] = value;
                    } else {
                        value = kvs[key].value;
                        params[_key] = value;
                    }
                } else if (typeof (params[_key]) == 'object') {
                    value = params[_key] ? params[_key] : [];
                    value.push(kvs[key].value);
                    params[_key] = value;
                } else {
                    value = kvs[key].value;
                    params[_key] = value;
                }
            }
            var resultParams = {};
            var objectParams = [];
            var indexs = {};
            for (var key in params) {
                var lstKey = key.substr(key.length - 6, 6);
                var subKey = key.substr(0, key.length - 6);
                var isIndex = (lstKey == '.index' && (urlserialize.indexOf(subKey + '[') == 0 || urlserialize.indexOf('&' + subKey + '[') > 0));
                var indexArr = key.match(/\[([^\]]+)\]/ig);
                if (indexArr) {
                    var __key = key;
                    for (var i = 0; i < indexArr.length; i++) {
                        var _index = (indexArr[i] + '');//.replace(/[\[\]]/g, '');
                        var indexof = __key.indexOf(indexArr[i]);
                        if (typeof (indexs[__key.substr(0, indexof)]) == 'undefined') {
                            indexs[__key.substr(0, indexof)] = [];
                        }
                        if (indexs[__key.substr(0, indexof)].indexOf(_index) < 0) {
                            indexs[__key.substr(0, indexof)].push(_index);
                        }
                        __key = __key.replace('[', '_').replace(']', '_');

                    }

                    //console.log(__key);
                    var keys = key.split('.');
                    var path = '';
                    var _path = '';
                    var __path = '';
                    for (var ik in keys) {
                        var ikey = keys[ik];
                        if (path == '') {
                            path = keys[ik];
                        } else {
                            path = path + '.' + keys[ik];
                        }
                        var pathArr = path.match(/\[([^\]]+)\]/ig);
                        if (__path == '') {
                            __path = path;
                        } else {
                            __path = __path + '.' + ikey;
                        }
                        if (_path == '') {
                            _path = path;
                        } else {
                            _path = _path + '.' + ikey;
                        }
                        //_path = path;
                        for (var ip in pathArr) {
                            var ipath = pathArr[ip];
                            var indexof = __path.indexOf(ipath);
                            var _index = __path.substr(0, indexof).replace('[', '_').replace(']', '_');
                            if (indexof > -1) {
                                _path = _path.replace(ipath, '[' + indexs[_index].indexOf(ipath) + ']');
                                _path = _path.replace('[', '{').replace(']', '}');
                            }
                            if (_path.indexOf('[') < 0) {
                                if (!isIndex) {
                                    //初始化定义开始
                                    var evelCode = 'resultParams.' + _path.replace(/\{/g, '[').replace(/\}/g, ']');
                                    if (evelCode.substr(evelCode.length - 1, 1) == ']') {
                                        if (typeof (eval(evelCode.substr(0, evelCode.lastIndexOf('[')))) == 'undefined') {
                                            eval(evelCode.substr(0, evelCode.lastIndexOf('[')) + '=[];');
                                        } else {
                                            //console.log("hv", eval(evelCode.substr(0, evelCode.lastIndexOf('['))));
                                        }
                                    }
                                    try {
                                        if (typeof (eval(evelCode)) == 'undefined') {
                                            eval(evelCode + '={};');
                                        }
                                    } catch (e) {
                                        //console.log('error', evelCode);
                                    }
                                    //定义结束
                                    //赋值
                                    if (typeof (params[key]) != 'undefined') {
                                        var keyArrays = key.split('.');
                                        var codeArrays = evelCode.split('.');
                                        if (keyArrays[keyArrays.length - 1] == codeArrays[codeArrays.length - 1]) {
                                            try {
                                                eval(evelCode + '=params[key];');
                                            } catch (e) {
                                                //console.log(path);
                                            }
                                        }
                                    }
                                }

                            }
                        }
                        __path = __path.replace('[', '_').replace(']', '_');
                    }
                } else {
                    if (!isIndex) {
                        var keys = key.split('.');
                        var path = 'resultParams';
                        for (var ik in keys) {
                            path = path + '.' + keys[ik];
                            try {
                                if (typeof (eval(path)) == 'undefined') {
                                    eval(path + '={};');
                                }
                            } catch (e) {
                                //忽略不规则的
                            }
                        }
                        try {
                            eval(path + '=params[key];');
                        } catch (e) {
                            //忽略不规则的
                        }
                    }
                }
            }
            return resultParams;
        }
        return null;
    }
};
