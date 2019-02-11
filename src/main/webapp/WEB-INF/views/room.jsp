<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@ page session="false"%>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>

<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/room.css?ver=11" rel="stylesheet"> 
<link rel="stylesheet" href="http://code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" type="text/css" />  
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>  
<script src="http://code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>  
<style>
.ui-datepicker{ font-size: 15px; width: 250px; background:white; }
.ui-widget-header{background:salmon}
.ui-datepicker-title{color:white}
.ui-datepicker select.ui-datepicker-month{ width:30%; font-size: 11px; }
.ui-datepicker select.ui-datepicker-year{ width:40%; font-size: 11px; }
</style>
<script>
var room;
$(document).ready(function(){
	var cur_room="room1";
	var margin=0;
	var sw=true;
	var listcnt=0;
	var curimgnum=0;
	var slidesw=true;
	var pay;
	

	function checkout_room(room){

		$('.remaining_table').html('<tr><th>번호</th>');
		$('.remaining_table tr').append('<th>객실명</th>');
		$('.remaining_table tr').append('<th>날짜</th>');
		$('.remaining_table tr').append('<th>남은객실</th></tr>');

		if(room[0].room_type=="room1"){
			type="스텐다드";
		}else if(room[0].room_type=="room2"){
			type="슈페리어"; 
		}else{
			type="디럭스";
		}
		for(var i=0; i<room.length;i++){
		
			$('.remaining_table').append('<tr class="'+room[i].room_seq+'">');
			$('.'+room[i].room_seq).append('<td>'+(i+1)+'</td>');
			$('.'+room[i].room_seq).append('<td>'+type+'</td>');
			$('.'+room[i].room_seq).append('<td>'+room[i].room_date+'</td>');
			$('.'+room[i].room_seq).append('<td>'+room[i].room_rem+'</td>');
			$('.remaining_table').append('</tr>');
		}
		$('.remaining_div').fadeIn('slow');
	}

	//계산기 기능
	function carcur(){
		

	var room=$('.room_select').text();
	var days=staydate();
	console.log(days);
	if(days==0)
		days=1;

	var person=0;
	person=person_count();
		if(room=='스텐다드'){ 

		$('.stay_person').text("숙박인원 : "+person+"인");
		$('.stay_room').text("스텐다드 룸 :"+Math.ceil(person/2)+"개");
		$('.stay_date').text("머무는기간 : "+days+"일");
		$('.stay_pay').text("가격은 총 "+Math.ceil(person/2)*10*days+"만원 입니다.");
		$('.stay_pay').append("<br/><h4>이대로 결제하시겠어요?</h4>");
		
		}else if(room=='슈페리어'){
			if(person<4)
				person=4;
			$('.stay_person').text(person+"명이 이용하신다면");
			$('.stay_room').text("슈페리어 (최대 4인 숙박)="+Math.ceil(person/4)+"개 가 필요하고");
			$('.stay_date').text(days+"일 동안 머무신다면");
			$('.stay_cal').text('방'+Math.ceil(person/4)+'개 x 19만원'+' x '+days+'일');
			$('.stay_pay').text("가격은 총 "+Math.ceil(person/4)*19*days+"만원 입니다.");
			
		}else{
			if(person<8)
				person=6;
		
			$('.stay_person').text(person+"명이 이용하신다면");
			$('.stay_room').text("디럭스 (최대 8인 숙박)="+Math.ceil(person/8)+"개 가 필요하고");
			$('.stay_date').text(days+"일 동안 머무신다면");
			$('.stay_cal').text('방'+Math.ceil(person/8)+'개 x 36만원'+' x '+days+'일');
			$('.stay_pay').text("가격은 총 "+Math.ceil(person/8)*36*days+"만원 입니다.");
		
		}

	}
	//사람 수 체크 함수
	function person_count(){
		var person=$('.person_select').text();
		if(person=='성인 2인'){
			return 2;
		}else if(person=='성인 3~4인'){
			return 4;
		}else if(person=='성인 5~6인'){
			return 6;
		}else{
			return person;
		}
	}

	function roomsubmit(){
		if(sessionid==null){
			alert_call(false,"로그인 후 이용해주세요!");
			$('modal').fadeOut('slow');
		}else{
			var person=0;
			person=person_count();
			var needrooms=0;
			var room=$('.room_select').text();
			var days=staydate();
			var book_checkin=$('#checkin_date').val();
			if(room=='스텐다드'){
				needrooms=Math.ceil(person/2);
				room="room1";
			}else if(room=='슈페리어'){
				needrooms=Math.ceil(person/4);
				room="room2";
			}else{
				needrooms=Math.ceil(person/8);
				room="room3";
			}
			$.ajax({
				url:'/roomcheck',
				type:'post',
				data:{'checkin':book_checkin,'stay':days,'room_type':room,'need_rooms':needrooms},
				success:function(result){
					if(result=="ok"){
						book_insert(room,days,book_checkin,person,needrooms);
					}else{
						alert_call(false,result+"일의 남은 방이 모자릅니다.");
					}
				}
			})
		}
	}
	// 머무르는 기간 함수
	function staydate(){
		var checkin_month=$('#checkin_date').val().substring(5,7);
		var checkin_day=$('#checkin_date').val().substring(8,10);
		var checkout_month=$('#checkout_date').val().substring(5,7);
		var checkout_day=$('#checkout_date').val().substring(8,10);
		var imsi=Number(checkout_day); //형변환 임시변수
		var leftmargin=0; //슬라이드 마진 변수
		
		
		if(checkin_month!=checkout_month){
			if(checkin_month=='01'||checkin_month=='03'){

				return 31-checkin_day+imsi;
			}else if(checkin_month=='02'){
				if($('#checkin_date').val().substring(0,4)%400==0){
			
					return 29-checkin_day+imsi;
					
				}else{
			
					return 28-checkin_day+imsi;
				}
			}else{
				
				return 30-checkin_day+imsi;
			}
		}else{
			return checkout_day-checkin_day;
		}
		
		
	}

	$('.remaining_div h3').click(function(){
		$('.remaining_div').fadeOut();
	})
	
	//룸박스 토글
	$('.person_select').click(function(){
		$('.room_dropbox').hide();
		$('.person_dropbox').toggle();		
	})
	$('.person_dropbox div').click(function(){
		$('.person_select').text($(this).text());
		$('.person_dropbox').toggle();
	})
		$('.room_select').click(function(){
		$('.person_dropbox').hide();	
		$('.room_dropbox').toggle();
	})
	$('.room_dropbox div').click(function(){
		$('.room_select').text($(this).text());
		$('.room_dropbox').toggle();
	})
	

	//슬라이드 왼쪽버튼 클릭 함수
	$('.slide_left').click(function(){

		if(curimgnum>0){
		$('.active_img').removeAttr('class');
		curimgnum-=1;
		$('#'+curimgnum).attr('class','active_img');

		margin+=50;
		$('.imgbox').stop().animate({'margin-left':margin+'%'},700);
		if(curimgnum==0){
			margin-=25;
		}
	
		}else{
			if(slidesw){
				curimgnum=0;
				margin=25;
				$('.imgbox').stop().animate({'margin-left':margin+'%'},700);
				margin=0;
				slidesw=false;
			}else{
				alert_call(true,"마지막 이미지로 갑니다. ");
				curimgnum=listcnt-1;
				margin=-50*(listcnt-1)+25;
				$('.imgbox').stop().animate({'margin-left':margin+'%'},700);
				$('.active_img').removeAttr('class');
				$('#'+curimgnum).attr('class','active_img');
			}
	
		}
	})

	//슬라이드 오른쪽버튼 클릭 함수
	$('.slide_right').click(function(){
		slidesw=false;
		
		if(curimgnum<listcnt-1){
		
			if(curimgnum==0||curimgnum==listcnt-1){
				margin+=25;
			}
				
		$('.active_img').removeAttr('class');
		curimgnum+=1;
		$('#'+curimgnum).attr('class','active_img');
		margin-=50;
		$('.imgbox').stop().animate({'margin-left':margin+'%'},700);	
		}else{
			alert_call(true,"처음으로 돌아갑니다.");
			curimgnum=0;
			margin=25;
			$('.imgbox').stop().animate({'margin-left':margin+'%'},700);
			$('.active_img').removeAttr('class');
			$('#'+curimgnum).attr('class','active_img');
			margin=0;
		}	
		
	})
	//슬라이드 이미지 클릭
	$(document).on('click','.slider img',function(){
		$('.active_img').removeAttr('class');
		curimgnum=Number($(this).prop('id'));
		$('#'+curimgnum).attr('class','active_img');
		if(curimgnum==0){
			margin=25;
			$('.imgbox').stop().animate({'margin-left':margin+'%'},700);
			margin=0;
		}else{
			margin=-50*curimgnum+25;
			$('.imgbox').stop().animate({'margin-left':margin+'%'},700);
		}
		
	})
		//데이트피커
	        $.datepicker.regional['ko'] = {
			 changeMonth: false, 
	         dayNames: ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'],
	         dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
	         monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
	         monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    	  dateFormat: "yy-mm-dd",
	    	  minDate:1,
              maxDate:31,
          };
	 $.datepicker.setDefaults($.datepicker.regional['ko']);
	var currentDate = new Date();
	currentDate.setDate(currentDate.getDate()+1);
    $('#checkin_date').datepicker();
    $("#checkout_date").datepicker( "option", "minDate", 31 );

    $('#checkin_date').datepicker("option", "onClose", function ( selectedDate ) {
        $("#checkout_date").datepicker( "option", "minDate", selectedDate );
    });
	$( "#checkin_date" ).datepicker( "setDate", currentDate);
    $('#checkout_date').datepicker();
    $('#checkout_date').datepicker("option", "minDate", $("#checkin_date").val());
    $('#checkout_date').datepicker("option", "onClose", function ( selectedDate ) {
        $("#checkin_date").datepicker( "option", "maxDate", selectedDate );
    });


	$( "#checkout_date" ).datepicker( "setDate", 2);
	
	//객실 예약 함수
	function book_insert(room,days,book_checkin,person,needrooms){

		var book_checkout=$('#checkout_date').val();
		if(days==0)
			days=1;
	
		var pay;
	if(room=='room1'){
		pay=Math.ceil(person/2)*10*days
	}else if(room=='room2'){
		pay=Math.ceil(person/4)*19*days
	}else{
		pay=Math.ceil(person/8)*36*days
	}
		$.ajax({
			url:'/bookinsert',
			type:'post',
			data:{'room':room,'pay':pay,'stay':days,'checkin':book_checkin,'checkout':book_checkout,'person':sessionid,'needrooms':needrooms},
			success:function(result){
				$('body').html(result);
			}
		})
	}

	//객실예약
	$(document).on('click','.room_submit',function(){
		$('.modal').fadeIn('slow');
		carcur();
	})
	$('.ok').click(function(){
		roomsubmit();
	})
	$('.no').click(function(){
		$('.modal').fadeOut('slow');
	})

	//남은객실 확인
	$('.remaining_btn').click(function(){
		if(cur_room=="room4")
			cur_room="room3";
		$.ajax({
			url:'/remainingrooms',
			type:'post',
			data:{'room':cur_room},
			success:function(result){
				checkout_room(result);
			}
		})
	})
	
	$('.person4').click(function(){
		$('.person_select').toggle();
		$('.toggle_person').toggle();
	})
	
	// 사람수 직접입력 기능
	$('#person_input').keyup(function(){
		if($('#person_input').val()>100){
			$('#person_input').val(100);
		}
			$('.person_select').text($('#person_input').val());

		})
		//룸 선택 시 함수
		function roomselect(data){
		slidesw=true;
		$('.imgbox').text("");
		$('.slider').text("");
		$.ajax({
			url:'/roomselect',
			type:'post',
			data:{'room':data},
			dataType:'json',
			success:function(result){
				listcnt=result.length;
				for(var i=0;i<result.length;i++){
					$('.imgbox').append('<img src="${path}/img/'+data+'/'+result[i]+'">');
					$('.slider').append('<img id="'+i+'" src="${path}/img/'+data+'/'+result[i]+'">');
				
					if(i==0){
						$('#'+curimgnum).attr('class','active_img');
					}
				}
			}
		})
	}
	
	//기본 룸 세팅
	roomselect("room1");
	//룸 선택 버튼 클릭 함수
		$('.btn_box button').click(function(){
			
			margin=0;
			$('.imgbox').stop().animate({'margin-left':margin+'%'},500);
			cur_room=$(this).prop('id');
			curimgnum=0;
			roomselect(cur_room);
			$('.remaining_div').fadeOut('slow');
			

		})
		
		
		
	
	
});

</script>
</head>
<body>
<div class="modal">
<div class="carcurlator">
<h1>가격표</h1>

<p class="stay_person"></p>
<p class="stay_room"></p>
<p class="stay_date"> </p>
<p class="stay_cal"> </p>
<h4 class="stay_pay"> </h4>
<button class="ok">결제</button>
<button class="no">취소</button>
</div>
</div>
<div class="remaining_div">
<h3>X</h3>  
<table class="remaining_table">
<tr class="remaining_head">

</tr>
</table>

</div>
<div class="btn_box">
<button class="room1_btn" id="room1">스텐다드</button>
<button class="room2_btn" id="room2">슈페리어</button>
<button class="room3_btn" id="room3">디럭스</button>
<button class="room3_btn" id="room4">공통시설</button>
</div>
<div class="slide_btn">
<button class="slide_left">＜</button>
<button class="slide_right">＞</button>
</div>
<div class="slidebox">
<div class="blur_box_left"></div>
<div class="blur_box_right"></div>
<div class="imgbox">
</div>
</div>
<div class="roombox">
<h1>객실 예약 </h1>

  <p>체크인 </p><input type="text" name="checkin" id="checkin_date" readonly="readonly">
  <p>체크아웃 </p><input type="text" name="checkout" id="checkout_date" readonly="readonly">
  <p>객실 선택</p>
  <div class="room_select">스텐다드</div>
  <div class="room_dropbox">
  <div class="room1">스텐다드</div>
  <div class="room2">슈페리어</div>
  <div class="room3">디럭스</div>
	</div>
    <p>인원 선택</p>
    <div class="toggle_person">
  	<input type="number" max="100" id="person_input">인
    </div>
  <div class="person_select">성인 2인</div>
  <div class="person_dropbox">
  <div class="person1">성인 2인</div>
  <div class="person2">성인 3~4인</div>
  <div class="person3">성인 5~6인</div>
  <div class="person4">직접입력</div>
	</div>
  <br><br>
  <button class="room_submit"> 확인 </button>

</div>


<div class="slider">
<div class="slider_imgbox"></div>
</div>
<div class="checkout_room">
<button class="remaining_btn">잔여객실</button>

</div>



</body>
</html>