<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@ page session="false"%>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<meta name="viewport" content="width=device-width, user-scalable=no">
<html>
<head>
<%@ include file="header.jsp"%>
<script>

	$(document).ready(function() {
		$('body').fadeIn('slow');
		var info_offset = $(".video_div").offset();
		var videosw = true;

		$('.video_div').click(function() {
			if (videosw) {
				$('video').trigger('pause');
				videosw = !videosw;
			} else {
				$('video').trigger('play');
				videosw = !videosw;
			}

		})
		$('.other_menu div').click(function(){
			var location=$(this).prop('id');
			window.location.href="/"+location;
		})
	
		
		
		
		$(window).scroll(function() {
			var st = $(this).scrollTop();
			var offset=$('body').outerHeight();
			if (st > offset/10) {
				$('#back_video').trigger('pause');
				videosw = !videosw;
			} else {
				$('#back_video').trigger('play');
				videosw = !videosw;
			}
			if(st>offset/5){
				$('.main-img0').fadeIn('slow');
			}
			if(st>offset/1.2){
				$('.main-img1').fadeIn('slow');
				$('.img-text1').fadeIn('slow');
			}
			if(st>offset/1.2){
				$('.main-img2').fadeIn('slow');
				$('.img-text2').fadeIn('slow');
				$('.other_div').fadeIn('slow');
				$('.other_menu').fadeIn('slow');
			}
	
		});

	})
</script>
<link href="${path}/css/home.css?ver=4" rel="stylesheet">

<title>Home</title>
</head>
<body>
	<div class="video_div">
		<video  autoPlay muted loop id="back_video">
			<source src="${path}/file/Hotel.mp4" type="video/mp4" />
		</video>
	</div>

	<div class="info_div">
		<h4 style="margin-top: 5%">지친 일상에서 떠나보세요.</h4>
		<h4 style="color: tomato">. . . . . . . . .</h4>
		<h1>
			최고의 호텔이<br /> <br /> 고객님을 위해 기다리고 있습니다.
		</h1>
		<h4 style="color: tomato">. . . . . . . . .</h4>
		<h4>후회없는 선택이 될겁니다.</h4>
	</div>

	<div class="main_div">
		<img src="${path}/img/restaurant-2697945_1920.jpg" class="main-img0">
		<div class="img-text1">
			<h4>최고의 쉐프</h4>
			<h1>항상 새롭고 맛있는 요리를 위해</h1>
			<h1>끊임없이 매일 연구하고</h1>
			<h1>고민합니다.</h1>
			<p>. . . . . . . . .</p>
		</div>
		<img src="${path}/img/chefs-3701718_1920.jpg" class="main-img1">
		<div class="img-text2">
			<h4>샴페인과 함께..</h4>
			<h1>저희 호텔은 생일인 고객님께</h1>
			<h1>샴페인을 무료로 제공하고 있습니다.</h1>
			<h1>사랑하는 사람과 파티를 즐겨보세요</h1>
			<p>. . . . . . . . .</p>
		</div>
		<img src="${path }/img/champagne-2876137_1920.jpg" class="main-img2">
		<div class="other_div">
			<h1>about</h1>
			<p>. . . . . . . . .</p>
		</div>
		<div class="other_menu">

			<div id="info"><a>이용안내</a><img src="${path }/img/liege-2396802_1920.jpg"> </div> 
			<div id="room"><a>객실예약</a> <img src="${path }/img/alex-block-607886-unsplash.jpg"></div> 
			<div id="board"><a>고객센터</a><img src="${path }/img/omar-lopez-742108-unsplash.jpg"></div>

		</div>
	</div>

</body>

</html>
