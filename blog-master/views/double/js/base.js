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
    $(document).click(function(){
        $("#wechat_btn").popover('destroy');
        $("[data-toggle='popover']").popover();
    });
});

function ajax_Main(type,data,url){
    $.ajax({
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
    });
}