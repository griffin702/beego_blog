
function checkall(name, obj) {
	$(":checkbox[name='"+name+"']").each(function(o) {
		$(this).prop('checked', obj.checked);
	});
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

$(document).ready(function(){
    // $("body").onload = function () {
    //     $("#account").focus();
    // };
    //修复导航栏active不自动切换
    $("ul.nav.navbar-nav").find("li").each(function(){
        var a = $(this).find("a:first");
        if (a.attr("href") == location.pathname){
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        }
    });
    $('#content').xheditor({
        tools:'full',
        skin:'default',
        showBlocktag:true,
        internalScript:false,
        internalStyle:false,
        cleanPaste:3,
        width:600,
        height:500,
        loadCSS:'/static/xheditor/css/base.css',
        fullscreen:false,
        sourceMode:false,
        forcePtag:false,
        html5Upload:false,
        upMultiple:1,
        upImgUrl:"/admin/upload",
        upImgExt:"jpg,jpeg,gif,png"
    });
    //处理上传
    $('#newcover').on('change', function() {
        var file = this.files[0];
        var reader = new FileReader();
        var formData = new FormData();
        var autoview = document.querySelector('#autoview');
        reader.readAsDataURL(file);
        reader.onload = function () {
            autoview.src = this.result;
            var upwidth = autoview.width;
            var upheight = autoview.height;
            var upurl = '/admin/upload/?type=2&w=' + upwidth + '&h='+ upheight;
            formData.append('filedata', dataURLtoFile(this.result, file.name));
            $('#uploadimg').on('click', function() {
                $.ajax({
                    url: upurl,
                    method: 'POST',
                    data: formData,
                    contentType: false,
                    processData: false,
                    cache: false,
                    success: function(data) {
                        $('#picture').val(JSON.parse(JSON.stringify(data)).msg);
                        formData = new FormData();
                    },
                    error: function (err) {
                        alert(err);
                        formData = new FormData();
                    }
                });
            });
        };
    });
    //处理分页ajax
    $("#wy-delegate-admin").on("click","ul.pagination li a",function(event){
        event.preventDefault();
        var ourl = $(this).attr('href');
        var otitle = document.title;
        if (ourl) {
            ajax_Main("GET", {}, ourl);
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
            ajax_Main("GET",{},state.url);
        }
    }, false);
    if ('scrollRestoration' in history) {
        history.scrollRestoration = 'manual';
    }
});

function ajax_Main(type,data,url){
    $.ajax({
        type:type,
        data:data,
        url:url,
        cache:true,
        dataType:"html",
        success: function(data){
            $("table").html($(data).find("table"));
            $(window).scrollTop(0);
        },
        error: function(){
            alert("false");
        }
    });
}