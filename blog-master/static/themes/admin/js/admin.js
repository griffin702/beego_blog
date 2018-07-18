
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

function upImage() {
    $('#picture').xheditor({
        tools:'full',
        skin:'default',
        showBlocktag:true,
        internalScript:false,
        internalStyle:false,
        width:600,
        height:500,
        loadCSS:'/static/xheditor/css/base.css',
        fullscreen:false,
        sourceMode:false,
        forcePtag:true,
        html5Upload:false,
        upMultiple:1,
        upImgUrl:"/admin/upload/?type=2&w=100&h=100",
        upImgExt:"jpg,jpeg,png"
    }).showDialog("xheUpload").open();
}

$(document).ready(function(){
    //修复导航栏active不自动切换
    $("ul.nav.navbar-nav").find("li").each(function(){
        var a = $(this).find("a:first");
        if (a.attr("href") == location.pathname){
            a.parent().addClass("active");
            a.parent().siblings().removeClass("active");
        }
    });
    $('#content1').xheditor({
        tools:'full',
        skin:'default',
        showBlocktag:true,
        internalScript:false,
        internalStyle:false,
        width:600,
        height:500,
        loadCSS:'/static/xheditor/css/base.css',
        fullscreen:false,
        sourceMode:false,
        forcePtag:true,
        html5Upload:false,
        upMultiple:1,
        upImgUrl:"/admin/upload",
        upImgExt:"jpg,jpeg,gif,png"
    });
});
