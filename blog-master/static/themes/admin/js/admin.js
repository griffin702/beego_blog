
function checkall(name, obj) {
	$(":checkbox[name='"+name+"']").each(function(o) {
		$(this).prop('checked', obj.checked);
	});
}

function sure_logout() {
    return confirm('确定退出登录吗？');
}

function del_confirm() {
	return confirm('一旦删除将不可恢复，确定吗？');
}

function del_comment() {
    return confirm('确定删除吗？');
}

function dataURLtoFile(dataurl, filename) {//将base64转换为文件
    var arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1],
        bstr = atob(arr[1]), n = bstr.length, u8arr = new Uint8Array(n);
    while(n--){
        u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, {type:mime});
}

function bindUploadFile() {
    $("#filevideo").bind("change", function(){
        var file = this.files[0];
        var uptype = $(this).data('uptype');
        var upurl = '/admin/uploadfile/?type=' + uptype;
        var formData = new FormData();
        formData.append('filemedia', file);
        $.ajax({
            url: upurl,
            method: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            cache: false,
            success: function(data) {
                var ret = JSON.parse(JSON.stringify(data));
                alert(ret.message);
                var num = Math.floor(Math.random() * 9.9);
                var str = "<video controls=\"\" preload=\"none\" " +
                    "poster=\"" + ret.jpgurl + "\">" +
                    "<source src=\"" + ret.url + "\" type=\"video/mp4\"></video>\n";
                mdEditor.cm.replaceSelection(str);
                formData = new FormData();
            },
            error: function () {
                alert("false");
                formData = new FormData();
            }
        });
    });
    $("#fileaudio").bind("change", function(){
        var file = this.files[0];
        var uptype = $(this).data('uptype');
        var upurl = '/admin/uploadfile/?type=' + uptype;
        var formData = new FormData();
        formData.append('filemedia', file);
        $.ajax({
            url: upurl,
            method: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            cache: false,
            success: function(data) {
                var ret = JSON.parse(JSON.stringify(data));
                alert(ret.message);
                var str = "<audio controls=\"\" preload=\"none\"><source src=\"" + ret.url + "\"></audio>\n";
                mdEditor.cm.replaceSelection(str);
                formData = new FormData();
            },
            error: function () {
                alert("false");
                formData = new FormData();
            }
        });
    });
}

$(document).ready(function(){
    //修复导航栏active不自动切换
    $("ul.nav.navbar-nav").find("li").each(function(){
        var a = $(this).find("a:first");
        if (a.attr("href") === location.pathname){
            a.parent().parent().parent().addClass("active");
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        }
    });
    var is_watch;
    if ($(window).width()<772){is_watch=false}else{is_watch=true}
    $(function() {
        if ($("#content").length > 0) {
            mdEditor = editormd("content", {
                width: "100%",
                height: 680,
                path: '/static/markdown/lib/',
                toolbarIcons : function() {
                    return ["undo", "redo", "emoji", "bold", "del", "italic", "quote",
                        "ucwords", "uppercase", "lowercase", "list-ul", "list-ol", "hr",
                        "link", "image", "fileaudio", "filevideo", "code", "code-block",
                        "table", "datetime", "html-entities", "|", "goto-line", "watch",
                        "preview", "fullscreen", "help", "info"]
                },
                toolbarCustomIcons: {
                    filevideo: "<div class=\"editormd-file-input2\">" +
                    "<input id=\"filevideo\" type=\"file\" accept=\".mp4\" data-uptype=\"4\" />" +
                    "<input type=\"submit\" value=\"视频\"></div>",
                    fileaudio: "<div class=\"editormd-file-input2\">" +
                    "<input id=\"fileaudio\" type=\"file\" accept=\".mp3\" data-uptype=\"5\" />" +
                    "<input type=\"submit\" value=\"音频\"></div>",
                },
                theme: "default",
                previewTheme: "default",
                editorTheme: "mdn-like",
                markdown: '',
                codeFold: true,
                //syncScrolling : false,
                saveHTMLToTextarea: true,    // 保存 HTML 到 Textarea
                searchReplace: true,
                watch: is_watch,                // 关闭实时预览
                htmlDecode: "style,script,iframe|on*",            // 开启 HTML 标签解析，为了安全性，默认不开启
                //toolbar  : false,             //关闭工具栏
                //previewCodeHighlight : false, // 关闭预览 HTML 的代码块高亮，默认开启
                emoji: true,
                taskList: true,
                tocm: true,                  // Using [TOCM]
                // tex : true,                   // 开启科学公式TeX语言支持，默认关闭
                flowChart: true,             // 开启流程图支持，默认关闭
                // sequenceDiagram : true,       // 开启时序/序列图支持，默认关闭,
                //dialogLockScreen : false,   // 设置弹出层对话框不锁屏，全局通用，默认为true
                //dialogShowMask : false,     // 设置弹出层对话框显示透明遮罩层，全局通用，默认为true
                //dialogDraggable : false,    // 设置弹出层对话框不可拖动，全局通用，默认为true
                //dialogMaskOpacity : 0.4,    // 设置透明遮罩层的透明度，全局通用，默认值为0.1
                //dialogMaskBgColor : "#000", // 设置透明遮罩层的背景颜色，全局通用，默认为#fff
                imageUpload: true,
                imageFormats: ["jpg", "jpeg", "gif", "png"],
                imageUploadURL: "/admin/upload",
                onload: function () {
                    //console.log('onload', this);
                    //this.fullscreen();
                    //this.unwatch();
                    //this.watch().fullscreen();
                    //this.width("100%");
                    //this.height(480);
                    //this.resize("100%", 640);
                    bindUploadFile();
                },
            });
        }
        if ($("#moodcontent").length > 0) {
            mdEditor = editormd("moodcontent", {
                width: "100%",
                height: 800,
                path: '/static/markdown/lib/',
                toolbarIcons : function() {
                    return ["undo", "redo", "emoji", "bold", "del", "italic", "quote",
                        "ucwords", "uppercase","lowercase", "list-ul", "list-ol", "hr",
                        "link", "fileaudio", "filevideo", "code", "code-block", "table",
                        "datetime", "html-entities", "|", "goto-line", "watch", "preview",
                        "fullscreen", "help", "info"]
                },
                toolbarCustomIcons: {
                    filevideo: "<div class=\"editormd-file-input2\">" +
                    "<input id=\"filevideo\" type=\"file\" accept=\".mp4\" data-uptype=\"4\" />" +
                    "<input type=\"submit\" value=\"视频\"></div>",
                    fileaudio: "<div class=\"editormd-file-input2\">" +
                    "<input id=\"fileaudio\" type=\"file\" accept=\".mp3\" data-uptype=\"5\" />" +
                    "<input type=\"submit\" value=\"音频\"></div>",
                },
                theme: "default",
                previewTheme: "default",
                editorTheme: "mdn-like",
                markdown: '',
                codeFold: true,
                saveHTMLToTextarea: true,
                searchReplace: true,
                watch: is_watch,
                htmlDecode: "style,script,iframe|on*",
                emoji: true,
                taskList: true,
                tocm: true,
                flowChart: false,
                imageUpload: false,
                onload : function(){
                    bindUploadFile();
                }
            });
        }
    });
    //处理图片上传
    var autoview = document.querySelector('#autoview');
    var uptype, upurl, albumid;
    $('#newcover').on('change', function() {
        var file = this.files[0];
        uptype = $(this).data('uptype');
        albumid = $(this).data('albumid');
        if (!uptype) {
            uptype = 2
        }
        var reader = new FileReader();
        var oldwidth = autoview.width;
        var oldheight = autoview.height;
        reader.readAsDataURL(file);
        reader.onload = function () {
            var image = new Image();
            image.onload = function () {
                var upwidth = image.width;
                var upheight = image.height;
                var max_w = 200;
                var max_h = 200;
                var prop;
                if (upwidth < upheight && upheight > max_h) {
                    prop = max_h/upheight;
                    upheight = max_h;
                    upwidth = upwidth * prop;
                } else if (upwidth >= upheight && upwidth > max_w) {
                    prop = max_w/upwidth;
                    upwidth = max_w;
                    upheight = upheight * prop;
                }
                if (uptype === 3) {
                    autoview.width = upwidth;
                    autoview.height = upheight;
                    upurl = '/admin/upload/?type=' + uptype + '&albumid=' + albumid;
                } else {
                    upurl = '/admin/upload/?type=' + uptype + '&w=' + oldwidth + '&h=' + oldheight;
                }
            };
            image.src = this.result;
            autoview.src = this.result;
            autoview.name = file.name;
        };
    });
    $('#uploadimg').on('click', function() {
        var formData = new FormData();
        var newupurl;
        if (uptype === 2 || (uptype === 3 && albumid === 0)) {
            var lastsrc = $('#picture').val();
            newupurl = upurl + '&lastsrc=' + lastsrc;
        } else {
            newupurl = upurl;
        }
        formData.append('editormd-image-file', dataURLtoFile(autoview.src, autoview.name));
        $.ajax({
            url: newupurl,
            method: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            cache: false,
            success: function(data) {
                var ret = JSON.parse(JSON.stringify(data));
                if (!ret.success) {
                    if (ret.success === undefined) {
                        alert("不允许上传!");
                    } else {
                        alert(ret.message);
                    }
                } else {
                    $('#picture').val(ret.url);
                    if (uptype === 3 && albumid > 0) {
                        ajax_Main("GET", {}, '/admin/photo/list?albumid='+albumid, 500);
                    }
                }
                // autoview.src = '/static/upload/default/yulan-190x135.png';
                formData = new FormData();
            },
            error: function () {
                alert("false");
                formData = new FormData();
            }
        });
    });
    //处理分页ajax
    $("#wy-delegate-admin").on("click","ul.pagination li a",function(event){
        event.preventDefault();
        var ourl = $(this).attr('href');
        var otitle = document.title;
        if (ourl) {
            ajax_Main("GET", {}, ourl, 50);
            if (history.pushState) {
                var state = ({
                    url: ourl, title: otitle
                });
                window.history.pushState(state, state.title, state.url);
            } else {
                window.location.href = "#!";
            } // 如果不支持，使用旧的解决方案
            return false;
        }
    });
    //新增事件监听浏览器返回前进操作
    window.addEventListener('popstate', function(e){
        if (history.state){
            //取出上一次状态
            var state=e.state;
            //修改当前标题为历史标题
            document.title=state.title;
            ajax_Main("GET", {}, state.url, 50);
        }
    }, false);
    //图片加载失败处理
    $("#autoview").error(function(){
        if ($(this).attr('width') === '60' && $(this).attr('height') === '60') {
            $(this).attr('src','/static/upload/default/user-default-60x60.png');
        } else {
            var num = Math.floor(Math.random() * 9.9);
            $(this).attr('src', '/static/upload/default/blog-default-' + num + '.png');
        }
    });
});

function ajax_Main(type, data, url, timewait){
    setTimeout(function () {$.ajax({
        type:type,
        data:data,
        url:url,
        cache:true,
        dataType:"html",
        success: function(data){
            $(".table-responsive").html($(data).find("table.table"));
            $(window).scrollTop(0);
        },
        error: function(){
            alert("false");
        }
    })}, timewait);
}