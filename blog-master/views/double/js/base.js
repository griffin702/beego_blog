$(document).ready(function(){
    //修复导航栏active不自动切换
    $("ul:first.nav.navbar-nav").find("li").each(function(){
        var a = $(this).find("a:first");
        if (a.attr("href") === location.pathname){
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        }
    });
});
