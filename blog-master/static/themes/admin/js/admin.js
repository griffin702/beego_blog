
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
});
