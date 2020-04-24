//评论回复表单按钮
function show_reply_form(event) {
    event.preventDefault();
    var $this = $(this);
    var comment_id = $this.data('comment-id');
    var parent_id = $this.data('parent-id');
    $('#id_reply_pk').val(comment_id);
    $('#id_reply_fk').val(parent_id);
    $('#form-comment').appendTo($this.closest('.media-body'));
    $('#cancel_reply').show();
}
//评论关闭按钮
function cancel_reply_form(event) {
    event.preventDefault();
    $('#comment_content').val('');
    $('#id_reply_pk').val('0');
    $('#id_reply_fk').val('0');
    $('#form-comment').appendTo($('#wrap-form-comment'));
    $('#cancel_reply').hide();
}
function comment_submit(event){
    var $this = $(this);
    var islogin = $this.data('islogin');
	if (islogin) {
        event.preventDefault();
    }
    var url = "/admin/comments/add";
	var object_pk = $("#id_object_pk").val();
    var object_pk_type = $("#id_object_pk_type").val();
    if (!object_pk_type) {
        object_pk_type = 0
    }
    var reply_pk = $('#id_reply_pk').val();
    var reply_fk = $('#id_reply_fk').val();
    var comment_content = $("#comment_content").val();
	if (comment_content !== ''){
		$("#comment_content").val('').focus();
        var timestamp = (new Date).getTime()+parseInt(10*Math.random(),10);
        var security_hash = hex_md5(reply_pk + timestamp + "@YO!r52w!D2*I%Ov");
        // alert((new Date).getTime());
		$.ajax({
			type:'POST',
			data:{
				'object_pk': object_pk,
                'object_pk_type': object_pk_type,
                'reply_pk': reply_pk,
                'reply_fk': reply_fk,
                'comment_content': comment_content,
				'security_hash':security_hash,
                'timestamp': timestamp
				},
			url:url,
			cache:true,
			dataType:"html",
			success: function(data){
                var err = JSON.parse(data).err;
                var msg = JSON.parse(data).msg;
                if (err === "false") {
                    alert('评论失败,原因:'+msg);
                } else {
                    setTimeout(function () {
                        $.ajax({
                            type: 'GET',
                            data: {},
                            url: location.pathname,
                            cache: true,
                            dataType: "html",
                            success: function (data) {
                                $('#form-comment').appendTo($('#wrap-form-comment'));
                                $('#cancel_reply').hide();
                                $("#wrap-comments-list").html($(data).find("#comments-list"));
                                initcommentslist();
                                $(".comments_length").html($(data).find(".comments_length p"));
                                $("#id_reply_pk").val('0');
                                $("#id_reply_fk").val('0');
                            }
                        });
                    },300);
                }
			},
			error: function(){
				alert("失败,评论过于频繁!");
			}
		});
	}
}
$(document).ready(function(){
	$('#cancel_reply').hide();
	var parent_all = $('#wy-delegate-all');
    parent_all.on('click','.comment_reply_link',show_reply_form);
    parent_all.on('click','#cancel_reply',cancel_reply_form);
    parent_all.on('click','#comment_submit',comment_submit);
});
