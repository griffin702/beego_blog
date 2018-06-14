
function checkall(name, obj) {
	$(":checkbox[name='"+name+"']").each(function(o) {
		$(this).prop('checked', obj.checked);
	});
}

function del_confirm() {
	return confirm('一旦删除将不可恢复，确定吗？');
}

$(document).ready(function(){
    //修复导航栏active不自动切换
    $("ul.nav.navbar-nav").find("li").each(function(){
        var a = $(this).find("a:first");
        if (a.attr("href") == location.pathname){
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        }
        a.click(function(evt){
            //处理手机浏览时，导航栏点开后不自动关闭
            if ($(window).width() <= 750){
                $("#phonenavbar").click();
            }
            // evt.preventDefault(); // 阻止默认的跳转操作
        });
    });
});