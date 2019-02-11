<%@page contentType="text/html; charset=utf-8"%>
<html><head>
<link href="${path}/css/header.css?ver=4" rel="stylesheet">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link href="https://fonts.googleapis.com/css?family=Nunito:300i" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300i|Roboto:400,900i" rel="stylesheet">
<meta name="viewport" content="width=device-width, user-scalable=no">
</head>
<script>

var sessionid=null;
$(window).scroll(function() {
    var st = $(this).scrollTop();
    $('.nav-body').animate({top:st},0);
   $('.alert').animate({top:st},0);
});
function alert_close(){
		$('.alert').fadeOut('slow');
		$('.alert h1').fadeOut('slow');
}
function alert_call(result,text){
	$('.alert').fadeIn('slow');
	if(result){
		$('.alert_success').text(text);
		$('.alert_success').fadeIn('slow');
	}else{
		$('.alert_fail').text(text);
		$('.alert_fail').fadeIn('slow');
	}
	setTimeout(function(){
	alert_close();
	},1500);
}

	$(document).ready(function() {

		$('.alert_close').click(function(){
			alert_close();
		})
		//로그아웃버튼 클릭
		$(document).on('click','.logout_btn',function(){
	 		$.ajax({
	 			url:'/memberlogout',
	 			type:'GET',
	 			success:function(){
	 				$(this).attr('class', 'menu-toggle');
					$('.nav-body').fadeOut('fast');
	 				$('.session_menu1').html('<a href="/login" style="fontfamliy:TmonMonsori" data-text="로그인">로그인</a>');
					$('.session_menu2').html('<a href="/join" style="fontfamliy:TmonMonsori" data-text="회원가입">회원가입</a>');
	 				alert_call(true,"로그아웃 완료");
	 				setTimeout(function(){
	 					window.location.href="/";
	 				},1000)
	 			
	 			}
	 			,error:function(){
	 				alert_call(false,"로그아웃 중 오류발생");
	 				setTimeout(function(){
	 					location.reload();
	 				},1000)
	 			}
	 		})
	 	})
	 	
	 	//세션체크
		$.ajax({
			url:'/sessioncheck',
			type:'post',
			success:function(result){
				console.log(result);
				if(result!="logout"){
					sessionid=result;
					$('.session_menu1').html('<a href="/mypage" data-text="예약내역">예약내역</a>');
					$('.session_menu2').html('<a class="logout_btn" data-text="로그아웃">로그아웃</a>');
				
				}else{
					$('.session_menu1').html('<a href="/login" style="fontfamliy:TmonMonsori" data-text="로그인">로그인</a>');
					$('.session_menu2').html('<a href="/join" style="fontfamliy:TmonMonsori" data-text="회원가입">회원가입</a>');
			
				}
			}
		})
		
		//메뉴 토글
		$("#menu-toggle").click(function() {
			var name = $(this).prop('class');
			if (name == 'menu-toggle') {
				$(this).attr('class', 'change');
				$('.nav-body').fadeIn('slow');
			} else {
				$(this).attr('class', 'menu-toggle');
				$('.nav-body').fadeOut('slow');
			}
		});
		$(".nav-body").click(function(){
			$('.change').attr('class', 'menu-toggle');
			$('.nav-body').fadeOut('slow');
		});
	//메인 로고 클릭
	$('.logo').click(function(){
		window.location.href="/";
	});

})
</script>
	<nav class="header">
		<h1 class="logo" data-text="Gyutae's Hotel">Gyutae's Hotel</h1>
		<div id="menu-toggle" class="menu-toggle">
			<div class="one"></div>
			<div class="two"></div>
			<div class="three"></div>
		</div>

	</nav>
	<div class="nav-body">
	
		<ul class="nav-menu">
		<li><a href="/" data-text="메인화면">메인화면</a></li>
		<li><a href="/info" data-text="이용안내">이용안내</a></li>
		<li><a href="/room" data-text="객실예약">객실예약</a></li>
		<li><a href="/board" data-text="고객센터">고객센터</a></li>
		<li><h4 style="color: tomato">. . . . . . . . . . . .</h4></li>
		<li class="session_menu1"></li>
		<li class="session_menu2"></li>
		</ul>

	</div>
	<div class="alert">
	<div class="alert_close">
		<div class="alert_left"></div>
		<div class="alert_right"></div>
	</div>
		<h1 class="alert_success">어떤것이 잘못되었습니다.</h1>
		<h1 class="alert_fail">어떤것이 잘못되었습니다.</h1>
	</div>

</html>