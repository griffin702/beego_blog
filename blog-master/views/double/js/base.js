function sure_logout() {
    return confirm('确定退出登录吗？');
}

$(document).ready(function(){
    //修复导航栏active不自动切换
    $("ul:first.nav.navbar-nav").find("li").each(function() {
        var a = $(this).find("a:first");
        if (a.attr("href") === location.pathname) {
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        } else if (a.attr("href") === '/life.html') {
            if (location.pathname.indexOf('/article') > -1) {
                a.parent().addClass("active");
                a.parent().siblings().removeClass("active");
            }
        }
    });
    //处理分页ajax
    $("#wy-delegate-all").on("click","ul.pagination li a",function(event){
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
    //顶底滚动处理
    $("#to_top").click(function (event) {
        event.preventDefault();
        $('html,body').animate({
            scrollTop: 0
        }, 500);
    });
    $("#to_down").click(function (event) {
        event.preventDefault();
        $('html,body').animate({
            scrollTop: document.body.scrollHeight
        }, 500);
    });
    window.addEventListener('scroll', function(){
        var t = document.documentElement.scrollTop || document.body.scrollTop;
        var s = document.body.scrollHeight * 0.5;
        if (t < s) {
            $("#to_top").removeClass('show').addClass('hidden');
        } else {
            $("#to_top").removeClass('hidden').addClass('show');
        }
    });
    $("[data-toggle='popover']").popover();
    $("#wechat_btn").click(function(event){
        event.stopPropagation();
        $("#wechat_btn").popover('toggle');
    });
    $(document).on('click touchstart', function(){
        $("#wechat_btn").popover('destroy');
        $("[data-toggle='popover']").popover();
    });
    //图片加载失败处理
    $("img.img-thumbnail").error(function(){
        var num=Math.floor(Math.random()*9.9);
        $(this).attr('src','/static/upload/default/blog-default-' + num + '.png');
    });
    $("img.wyavater").error(function(){
        $(this).attr('src','/static/upload/default/user-default-60x60.png');
    });
    $("img.moodimg").error(function(){
        $(this).attr('src','');
    });
    $('#wy-login-submit').on("click",function(evt){
        evt.preventDefault();
        var account = $('#wy-login-form input#account').val(),
            password = $('#wy-login-form input[name=password]').val(),
            dosubmit = $('#wy-login-form input[name=dosubmit]').val(),
            remember = $('#wy-login-form input[name=remember]').val();
        var checked = $('input[name=remember]').is(':checked');
        var data;
        if (checked) {
            data = {
                'dosubmit': dosubmit,
                'account': account,
                'password': password,
                'remember': remember
            }
        } else {
            data = {
                'dosubmit': dosubmit,
                'account': account,
                'password': password
            }
        }
        $.ajax({
            type: 'POST',
            url: '/admin/login',
            data: data,
            success: function(data){
                var msg = $(data).find('.alert-warning');
                $('#wy-login-form .alert-warning').remove();
                $('#wy-login-form').prepend(msg);
                if (!msg.html()) {
                    $('#wy-login-form input[name=password]').val('');
                    $('#wy-login-form input[name=remember]').val('');
                    window.location.reload();
                }
            },
            error: function(){
                alert("登录失败");
            }
        });
    });
    $('#wy-register-submit').on("click",function(evt){
        evt.preventDefault();
        var username = $('#wy-regist-form input[name=username]').val(),
            password = $('#wy-regist-form input[name=password]').val(),
            password2 = $('#wy-regist-form input[name=password2]').val(),
            email = $('#wy-regist-form input[name=email]').val(),
            dosubmit = $('#wy-regist-form input[name=dosubmit]').val();
        var data = {
                'dosubmit': dosubmit,
                'username': username,
                'password': password,
                'password2': password2,
                'email': email,
            };
        $.ajax({
            type: 'POST',
            url: '/admin/register',
            data: data,
            success: function(data){
                var msg = $(data).find('.alert-warning');
                $('#wy-regist-form .alert-warning').remove();
                $('#wy-regist-form').prepend(msg);
                if (!msg.html()) {
                    $('#wy-regist-form input[name=username]').val('');
                    $('#wy-regist-form input[name=password]').val('');
                    $('#wy-regist-form input[name=password2]').val('');
                    $('#wy-regist-form input[name=email]').val('');
                    alert("账号："+username+"注册成功,请使用该账号登录!")
                    $('.relogin').click();
                }
            },
            error: function(){
                alert("登录失败");
            }
        });
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
            $("#wrap-comments-list").html($(data).find("#comments-list"));
            $(window).scrollTop(400);
        },
        error: function(){
            alert("false");
        }
    })}, timewait);
}