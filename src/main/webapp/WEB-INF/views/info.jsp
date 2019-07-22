<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@ page session="false"%>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>

<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/info.css?ver=2" rel="stylesheet">
<script>

var i=1;

setInterval(function(){	
		$('.info_img img').fadeOut('fast');
		$('.info_img'+i).fadeIn('slow');
		i++;
		if(i>2){
			i=0;
		}
	},3000);
</script>
</head>
<body>
<div class="info_img">
<img src="${path}/img/hotelroom.jpg" class="info_img0">
<img src="${path}/img/maximilien-t-scharner-318691-unsplash.jpg" class="info_img1" style="display:none;">
<img src="${path}/img/davidcohen-127022-unsplash.jpg" class="info_img2" style="display:none;">
</div>
<div class="info_div">
	<h1> 호텔 이용 시 안내사항 </h1>
	<br><br>
	객실 인터넷 무료 제공<br><br>
그린 캠페인 참여 고객 기념품 증정<br><br>
신규 수영장 오픈 안내<br><br>
기존 실내, 외 수영장 및 부대시설은 평소와 같이 이용 가능합니다.<br><br>
상기 요금은 2인 1실 기준 1박 요금 입니다.(세금 봉사료 별도)<br><br>
해당 내용은 기상 상황 또는 호텔 사정에 의해 장소 변경 및 취소 될 수 있습니다.<br><br>
조식(2인), 라운지 S(2인)를 제외한 모든 특전은 투숙당 1회 제공됩니다.<br><br>
당일 Check-Out 고객은 수영장은 15시까지 이용가능 합니다.<br><br>
쾌적한 환경을 위해 전 객실 금연실로 운영합니다.<br><br>
호텔 체크인은 오후 2시이며, 체크 아웃은 오전 11시 입니다.<br><br>
예약 취소 및 변경시 숙박 예정일 7일 전 24시까지는 위약금이 없습니다.<br><br>
숙박 예정일 6일 전 ~ 숙박 예정일 1일 전 취소하실 경우 총 숙박요금의 20%,<br><br>
숙박 예정일 당일 취소(No Show 포함)하실 경우<br><br> 총 숙박요금의 80%가 위약금으로 부과됩니다.<br><br>
</div>
</body>
</html>