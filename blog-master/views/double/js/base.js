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
        } else if (a.attr("href") === '/life.html' && location.pathname.indexOf('/article') > -1) {
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        } else if (a.attr("href") === '/category.html' && location.pathname.indexOf('/category') > -1) {
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
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
    $("#to_top").on('click',function (event) {
        event.preventDefault();
        $('html,body').animate({
            scrollTop: 0
        }, 500);
    });
    $("#to_down").on('click',function (event) {
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
    $("#wechat_btn").on('click',function(event){
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
        $(this).remove();
    });
    $('#wy-login-modal,#wy-register-modal').on("shown.bs.modal",function(){
        $('input[name=username]').focus();
    });
    $('#wy-login-submit').on("click",function(evt){
        evt.preventDefault();
        var username = $('input[name=username]').val(),
            password = $('input[name=password]').val(),
            dosubmit = $('input[name=dosubmit]').val();
        var q_remember = $('input[name=remember]');
        var remember = q_remember.val();
        var checked = q_remember.is(':checked');
        var data;
        if (checked) {
            data = {
                'dosubmit': dosubmit,
                'username': username,
                'password': password,
                'remember': remember
            }
        } else {
            data = {
                'dosubmit': dosubmit,
                'username': username,
                'password': password
            }
        }
        $.ajax({
            type: 'POST',
            url: '/admin/login',
            data: data,
            success: function(data){
                var msg = $(data).find('.alert-warning');
                $('.alert-warning').remove();
                $('#wy-login-form').prepend(msg);
                if (!msg.html()) {
                    $('input[name=password]').val('');
                    $('input[name=remember]').val('');
                    setTimeout(window.location.reload(),800);
                }
            },
            error: function(){
                alert("登录失败");
            }
        });
    });
    $('#wy-register-submit').on("click",function(evt){
        evt.preventDefault();
        var username1 = $('input[name=username1]').val(),
            password1 = $('input[name=password1]').val(),
            password2 = $('input[name=password2]').val(),
            nickname = $('input[name=nickname]').val(),
            email = $('input[name=email]').val(),
            dosubmit = $('input[name=dosubmit]').val();
        var data = {
                'dosubmit': dosubmit,
                'username1': username1,
                'password1': password1,
                'password2': password2,
                'nickname': nickname,
                'email': email
            };
        $.ajax({
            type: 'POST',
            url: '/admin/register',
            data: data,
            success: function(data){
                var msg = $(data).find('.alert-warning');
                $('.alert-warning').remove();
                $('#wy-regist-form').prepend(msg);
                if (!msg.html()) {
                    $('input[name=username]').val('');
                    $('input[name=password]').val('');
                    $('input[name=password2]').val('');
                    $('input[name=email]').val('');
                    alert("账号："+username1+"注册成功,请使用该账号登录!")
                    $('.relogin').click();
                }
            },
            error: function(){
                alert("注册失败");
            }
        });
    });
    //处理评论回复超过3条则隐藏
    initcommentslist();
    $("#wy-delegate-all").on("click", "#comments-list .comment_parent button.open-more", function (event) {
        $(this).parent().siblings().removeClass('hidden');
        var close_more = $("<button class='btn btn-info close-more'><<收起过往回复</button>");
        $(this).parent().append(close_more);
        $(this).remove();
    });
    $("#wy-delegate-all").on("click", "#comments-list .comment_parent button.close-more", function (event) {
        var num = $(this).parent().siblings(".comment_child").length;
        $(this).parent().siblings(".comment_child").each(function () {
            if (num > 3) {
                $(this).addClass('hidden');
            }
            num--;
        });
        var more = $("<button class='btn btn-info open-more'>展开过往回复>></button>");
        $(this).parent().append(more);
        $(this).remove();
    });
    if(location.hash){
        var target = $(location.hash);
        if(target.length===1){
            var top = target.offset().top-82;
            if(top > 0){
                $('html,body').animate({scrollTop:top}, 800);
            }
            target.css('color','red');
        }
    }
    $("ul.newcomment li").find('a:last').on("click", function(event){
        var thispath = $(this).attr('href');
        if (thispath.split('#')[0] === window.location.pathname) {
            var target = $('#'+thispath.split('#')[1]);
            if(target.length===1){
                event.preventDefault();
                var top = target.offset().top-82;
                if(top > 0){
                    $('html,body').animate({scrollTop:top}, 300);
                }
                $('.comment_parent .media-body').css('color','');
                location.hash = '#'+thispath.split('#')[1];
                target.css('color','red');
            }
        }
    });
    //利用lightgallery处理文章页图片点击显示大图
    $("#mdinfos img").each(function (index) {
        var is_emoji = $(this).hasClass('emoji');
        if (!is_emoji) {
            var smallsrc = $(this).attr('src');
            var src = smallsrc.replace(/_small/, "");
            var lightgallery = "<ul id=\"lightgallery-"+index+"\" class=\"list-unstyled\">" +
                "<li data-src=\""+src+"\"><a href=\"#\">" +
                "<img src=\""+smallsrc+"\"></a></li></ul>" +
                "<script>lightGallery(document.getElementById('lightgallery-"+index+"'));</script>";
            var parent = $(this).parent();
            $(this).remove();
            parent.append(lightgallery);
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
            var has_form = $('#wrap-form-comment').children('#form-comment').length;
            if (has_form === 0) {
                $('#form-comment').appendTo($('#wrap-form-comment'));
                $('#cancel_reply').hide();
            }
            $("#wrap-comments-list").html($(data).find("#comments-list"));
            initcommentslist();
        },
        error: function(){
            alert("false");
        }
    })}, timewait);
}

function initcommentslist() {
    $('.comment_parent').each(function() {
        var num = $(this).children('.comment_child').length;
        $(this).find('.comment_child').each(function () {
            if (num > 3) {
                $(this).addClass('hidden');
            }
            if (num === 3) {
                var more = $("<div class='comment_child col-lg-11 col-md-11 col-sm-11 col-xs-11 column'><button class='btn btn-info open-more'>展开过往回复>></button></div>");
                $(this).parent().append(more);
            }
            num--;
        });
    });
}