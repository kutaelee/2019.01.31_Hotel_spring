<%@page contentType="text/html; charset=utf-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/booking.css?ver=2" rel="stylesheet">
<script>
	$(document).ready(function(){
		$('.booking_btn').click(function(){
			window.location.href="/mypage";
		})
	})
</script>
</head>
<body>
<div class="booking_div">
<h1>결제 정보</h1><br/>
<h4 class="account">계좌번호: 농협 110-***-*******</h4>
<h4> 현재사이트는 데모버전이므로 입금완료처리 됩니다.</h4>
<h4> 확인버튼을 누르시면 결제내역으로 이동합니다!</h4>
<button class="booking_btn">확인</button>
</div>
</body>
</html>
