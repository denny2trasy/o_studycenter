// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

	$("button[type=submit]").click( function(e){
		alert("prev function");
	});
	
	$("button[type=button]").click( function(e){
		alert("next function");
		$.ajax(
			async: false,
			type: 'GET',
			url: "/dvg/" + this.id,
			success : function (data) {
				$('#time_sliding').empty().append(data);
				time_line_work();
			}
		);
	});
});

function next_question(index) {

}