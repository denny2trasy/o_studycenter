// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/el_studycenter/admin/schedules/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/el_studycenter/admin/schedules/resize"
    });
}

function showEventDetails(event){
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Edit</a>");
    title = event.title;
	$('#add_customer_event').html("<a href = 'javascript:void(0);' onclick ='add_customerEvent(" + event.id + ")'>Add Customer</a>");
    $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete</a>");
	$('#enter_user_list').html("<a href = 'javascript:void(0);' onclick = 'listEvent(" + event.id + ", " + false + ")'>User list</a>");
	$('#webex_user_list').html("<a href = 'javascript:void(0);' onclick = 'webexListEvent("+event.id +")'>Webex list</a>");
    
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy')
        }
        
    });
    
}


function editEvent(event_id){
    jQuery.ajax({
        data: 'id=' + event_id,
        dataType: 'script',
        type: 'get',
        url: "/el_studycenter/admin/schedules/"+event_id+"/edit"
    });
}

function add_customerEvent(event_id){
    jQuery.ajax({
        data: 'id=' + event_id,
        dataType: 'script',
        type: 'get',
        url: "/el_studycenter/admin/schedules/customer_list/"
    });
}

function deleteEvent(event_id, delete_all){
    jQuery.ajax({
        data: 'id=' + event_id + '&delete_all='+delete_all,
        dataType: 'script',
        type: 'delete',
        url: "/el_studycenter/admin/schedules/"+event_id+""
    });
}

function listEvent(event_id){
	jQuery.ajax({
		data: '',
		dataType: 'script',
		type: 'get',
		url: "/el_studycenter/admin/schedules/"+event_id+""
	});
}

function webexListEvent(event_id){
	window.location.href="/el_studycenter/admin/webex_users?utf8=✓&search%5Bid%5D="+event_id+"&commit=Search";
	/*jQuery.ajax({
		data: '',
		dataType: 'script',
		type: 'get',
		url: "/el_studycenter/admin/schedules/"+event_id+""
	});*/
}

function webexLogin(wid,pw){
	jQuery.ajax({
		data: "AT=LI&PW="+pw+"&WID="+wid,
		dataType: 'script',
		type: 'get',
		url: "https://eleutian.webex.com.cn/eleutian/p.php",
		
		success: function(data,textStatus){
			setMeetingType();
		}
		
	});
}

function setMeetingType(){
	jQuery.ajax({
		data: "AT=ST&SP=EC",
		dataType: "script",
		type: "get",
		url: "https://eleutian.webex.com.cn/eleutian/o.php",
		
		success: function(data,textStatus){
			//alert("set meeting"+data);
		}
	});
}

function scheduleMeeting(mo,da,du,en,enre,ho,jpw,mi,mt,tz,ye,bu){
	jQuery.ajax({
		data: "AT=SE&MO="+mo+"&DA="+da+"&DU="+du+"&EN="+en+"&ENRE="+enre+"&HO="+ho+"&JPW="+jpw+"&MI="+mi+"&MT="+mt+"&TZ="+tz+"&YE="+ye+"&BU="+bu,
		dataType: "script",
		type: "get",
		url: "https://eleutian.webex.com.cn/eleutian/m.php",
		
		success: function(data,textStatus){
			//alert("schedule meeting success"+data);
		}
	});
}

function getContents(content_id){
	 $.ajax({
		type: "get",
		url: '/el_studycenter/contents/get_items',
      	data: 'content_type='+$("#schedule_content_type").val(),
       	dataType: 'json',

		beforeSend: function(XMLHttpRequest){

		//ShowLoading();
		},
		success: function(data, textStatus){
			var datas = data;
			$("#lesson_select").html("<select name='schedule[content_id]' id='schedule_content_id'></select>");  
			$.each(datas,function(i){  
				var selected = "";
				if(datas[i].id == content_id){
					selected = "selected='selected'";
				}
				else{
					selected = "";
				}
				 	
          		$("<option value='"+datas[i].id+"' "+selected+">Lesson"+datas[i].id+"---"+datas[i].name+"</option>").appendTo($("#schedule_content_id"));   
      		});
		},

		complete: function(XMLHttpRequest, textStatus){
		//HideLoading();
		},
		error: function(){
			$("<option value='error'>Error</option>").appendTo($("#content_id")); 
		//请求出错处理
		}
		});
};

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }
    
    
    
    
}

function show_no_course_message(){
	$('#no_course_message').html("Please activate a product code to access this feature.");
}
