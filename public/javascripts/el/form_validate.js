var register_validate = true;

function login_validate() {
	var profile_login = $("#profile_login").val();
	var patrn = /^(\w){6,16}$/;
	if(!patrn.exec(profile_login)) {
		register_validate = false;
		$("#login_error").show();
	} else {
		$("#login_error").hide();
	}

	$.ajax({
		type : 'GET',
		url : '/profile/validate_login',
		data : {
			'login' : profile_login
		},
		success : function(data) {
			if(data == 'false') {
					$("#login_exist").show();
					register_validate = false;

			}
		}
	});
}

function mail_validate() {
	var profile_mail = $("#profile_mail").val();
	var patrn = /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i;
	if(!patrn.exec(profile_mail)) {
		register_validate = false;
		$("#mail_error").show();
	} else {
		$("#mail_error").hide();
	}

	$.ajax({
		type : 'GET',
		url : '/profile/validate_mail',
		data : {
			'mail' : profile_mail
		},
		success : function(data) {
			if(data == 'false') {
					$("#mail_exist").show();
					register_validate = false;
			}
		}
	});
}

function password_validate() {
	var profile_password = $("#profile_password").val();
	var patrn = /.{6,16}/;
	if(!patrn.exec(profile_password)) {
		register_validate = false;
		$("#password_error").show();
	} else {
		$("#password_error").hide();
	}
}

function password_confirmation_validate() {
	var profile_password = $("#profile_password").val();
	var profile_password_confirmation = $("#profile_password_confirmation").val();
	if(profile_password != profile_password_confirmation) {
		register_validate = false;
		$("#password_confirmation_error").show();
	} else {
		$("#password_confirmation_error").hide();
	}
}

function total_validate() {
	register_validate = true;
	login_validate();
	mail_validate();
	password_validate();
	password_confirmation_validate();
}

$(document).ready(function() {

	$("#profile_login").blur(function() {
		login_validate();
	});
	$("#profile_mail").blur(function() {
		mail_validate();
	});
	$("#profile_password").blur(function() {
		password_validate();
	});
	$("#profile_password_confirmation").blur(function() {
		password_confirmation_validate();
	})
	$("#profile_submit").click(function() {
		total_validate();
		if(register_validate == true) {
			$("#profile_new").submit()
		}
	})
	$(window).keypress(function(e) {
		if(e.keyCode == 13) {
			total_validate();
			if(register_validate == true) {
				$("#profile_new").submit()
			}
		}
	});
})