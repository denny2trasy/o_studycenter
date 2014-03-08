$(document).ready(function() {
		$('#msg_button').click(function() {
			msg_submit();
		})
		$('#ask_button').click(function(){
			ask_submit();
		})
		$(window).keypress(function(e) {
			if(e.keyCode == 13) {
				msg_submit();
			}
		});
	})
	function msg_submit() {
		if($('#message_content').val() != '') {
			$.ajax({
				type : 'POST',
				url : '/el_studycenter/messages',
				data : $("#message_form").serialize(),
				success : function() {
					$('#message_content').val('');
				}
			});
		}
	}
	function ask_submit() {
		if($('#message_content').val() != '') {
			$('#message_msg_type').val(true) ;
			$.ajax({
				type : 'POST',
				url : '/el_studycenter/messages',
				data : $("#message_form").serialize(),
				success : function() {
					$('#message_content').val('');
					$('#message_msg_type').val(false) ;
				}
			});
		}
	}