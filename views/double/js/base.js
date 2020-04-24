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
    // 登录、注册相关
    let login_modal = $('#wy-login-modal');
    let register_modal = $('#wy-register-modal');
    let loginForm = $('.login-form');
    let registerForm = $('.register-form');
    login_modal.on("show.bs.modal",function(){
        $('#captcha-img').click();
    });
    login_modal.on("shown.bs.modal",function(){
        $('input[name=username]').focus();
    });
    login_modal.on("hide.bs.modal",function(){
        $('input[name=username]').val('');
        $('input[name=password]').val('');
        loginForm.data("bootstrapValidator").resetForm()
    });
    register_modal.on("show.bs.modal",function(){
        $('#captcha-img2').click();
    });
    register_modal.on("hide.bs.modal",function(){
        $('input[name=username1]').val('');
        $('input[name=password1]').val('');
        $('input[name=password2]').val('');
        $('input[name=email]').val('');
        $('input[name=nickname]').val('');
        registerForm.data("bootstrapValidator").resetForm()
    });
    loginForm.bootstrapValidator({
        // feedbackIcons: {
        //     valid: 'glyphicon glyphicon-ok',
        //     invalid: 'glyphicon glyphicon-remove',
        //     validating: 'glyphicon glyphicon-refresh'
        // },
        fields: {
            username: {
                validators: {
                    regexp: {
                        regexp: /^[a-zA-Z0-9_\.]+$/,
                        message: '用户名只允许英文字母、数字与"_"的组合'
                    }
                }
            },
            password: {
                validators: {
                    notEmpty: {
                        message: '密码不能为空'
                    },
                    stringLength: {
                        min: 6,
                        message: '密码长度不得小于6位'
                    },
                    different: {
                        field: 'username',
                        message: '密码不能与用户名相同'
                    }
                }
            },
            captcha: {
                validators: {
                    callback: {
                        message: '您输入的验证码错误',
                        callback: function (value, validator) {
                            return checkLoginCode(value)
                        }
                    }
                }
            }
        }
    }).on("success.form.bv",function(evt){
        evt.preventDefault();
        let username = $('input[name=username]').val(),
            password = $('input[name=password]').val(),
            captcha = $('#captcha').val();
        let data = JSON.stringify({
            'username': username,
            'password': password,
            'captcha': captcha,
        });
        $.ajax({
            type: 'POST',
            url: '/admin/login',
            data: data,
            success: function(data){
                if (data.status) {
                    window.location.reload();
                }
                $('input[name=password]').val('').focus();
                $('#captcha').val('');
                $('#captcha-img').click();
                loginForm.data("bootstrapValidator").updateStatus("password",  "NOT_VALIDATED",  null );
                loginForm.data("bootstrapValidator").updateStatus("captcha",  "NOT_VALIDATED",  null );
                alert(data.msg);
            },
            error: function(){
                alert("登录失败");
            }
        });
    });
    registerForm.bootstrapValidator({
        // feedbackIcons: {
        //     valid: 'glyphicon glyphicon-ok',
        //     invalid: 'glyphicon glyphicon-remove',
        //     validating: 'glyphicon glyphicon-refresh'
        // },
        fields: {
            username1: {
                trigger: 'blur',
                validators: {
                    notEmpty: {
                        message: '用户名不能为空'
                    },
                    stringLength: {
                        min: 6,
                        max: 30,
                        message: '用户名必须为大于6小于30的字符'
                    },
                    regexp: {
                        regexp: /^[a-zA-Z0-9_\.]+$/,
                        message: '用户名只允许英文字母、数字与"_"的组合'
                    },
                    different: {
                        field: 'password',
                        message: '用户名不能与密码相同'
                    },
                    // callback: {
                    //     message: '该用户名已被注册',
                    //     callback: function(value, validator) {
                    //         return !checkIsExist(0, value)
                    //     }
                    // }
                }
            },
            email: {
                trigger: 'blur',
                validators: {
                    notEmpty : {
                        message : '邮箱不能为空'
                    },
                    emailAddress: {
                        message: 'Email格式不正确'
                    }
                }
            },
            nickname : {
                trigger: 'blur',
                validators : {
                    notEmpty : {
                        message : '手机号码不能为空'
                    },
                    stringLength: {
                        max: 6,
                        message: '昵称必须小于6个字符'
                    }
                }
            },
            password1: {
                validators: {
                    notEmpty: {
                        message: '密码不能为空'
                    },
                    stringLength: {
                        min: 6,
                        message: '密码长度不得小于6位'
                    },
                    different: {
                        field: 'username1',
                        message: '密码不能与用户名相同'
                    }
                }
            },
            password2: {
                validators: {
                    notEmpty: {
                        message: '密码不能为空'
                    },
                    identical: {
                        field: 'password1',
                        message: '两次输入的密码不一致'
                    }
                }
            },
            captcha2: {
                validators: {
                    callback: {
                        message: '您输入的验证码错误',
                        callback: function (value, validator) {
                            return checkLoginCode(value)
                        }
                    }
                }
            }
        }
    }).on("success.form.bv",function(evt){
        evt.preventDefault();
        let username1 = $('input[name=username1]').val(),
            password1 = $('input[name=password1]').val(),
            password2 = $('input[name=password2]').val(),
            nickname = $('input[name=nickname]').val(),
            email = $('input[name=email]').val(),
            captcha = $('#captcha2').val();
        let data = JSON.stringify({
            'username1': username1,
            'password1': password1,
            'password2': password2,
            'nickname': nickname,
            'email': email,
            'captcha': captcha,
        });
        $.ajax({
            type: 'POST',
            url: '/admin/register',
            data: data,
            success: function(data){
                if (data.status) {
                    window.location.reload();
                }
                $('input[name=password1]').val('');
                $('input[name=password2]').val('');
                $('#captcha2').val('');
                $('#captcha-img2').click();
                registerForm.data("bootstrapValidator").updateStatus("password1",  "NOT_VALIDATED",  null );
                registerForm.data("bootstrapValidator").updateStatus("password2",  "NOT_VALIDATED",  null );
                registerForm.data("bootstrapValidator").updateStatus("captcha2",  "NOT_VALIDATED",  null );
                alert(data.msg);
            },
            error: function(){
                alert("注册失败");
            }
        });
    });
    // 验证码图片处理
    let captcha_click = 0;
    $("#captcha-img").on('click', function () {
        captcha_click++;
        this.src = '/v1/login/captcha?num=' + captcha_click;
        $("#captcha").val('');
        loginForm.data('bootstrapValidator').updateStatus("captcha",  "NOT_VALIDATED",  null );
    })
    $("#captcha-img2").on('click', function () {
        captcha_click++;
        this.src = '/v1/login/captcha?num=' + captcha_click;
        $("#captcha2").val('');
        registerForm.data('bootstrapValidator').updateStatus("captcha2",  "NOT_VALIDATED",  null );
    })
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

// 检查验证码
function checkLoginCode(value) {
    let url = '/v1/login/captcha/check';
    let data = {
        captcha: value
    };
    let isTrue = false;
    $.ajax({
        type: 'POST',
        headers: {
            "Content-Type": "application/json; charset=utf-8"
        },
        async:false,
        url: url,
        data: JSON.stringify(data),
        success: function(data){
            isTrue = data.status
        },
        error: function(){
            confirm_alert('请求失败', false);
        }
    });
    return isTrue
}

// 全局消息通知
function confirm_alert(msg, status) {
    let color = status ? 'green' : 'red'
    $.confirm({
        title: '消息',
        content: msg,
        type: color,
        animation: 'top',
        icon: 'glyphicon glyphicon-question-sign',
        keyboardEnabled: true,
        buttons: {
            ok: {
                text: '确认',
                btnClass: 'btn-primary',
                keys: ['enter'],
            }
        }
    });
}
