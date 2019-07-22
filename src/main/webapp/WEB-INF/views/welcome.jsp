<%@page contentType="text/html; charset=utf-8"%>
<html>
<head>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<meta name="viewport" content="width=device-width, user-scalable=no">
<link href="${path}/css/welcome.css?ver=11" rel="stylesheet">
</head>
<script>
function skip(){
		$('.main_loding').fadeOut('slow');
		setTimeout(function(){
		$.ajax({
			url:'/',
			type:'post',
			success:function(result){
				$('body').hide();
				$('body').html(result);
				
			},error:function(){
				alert("메인화면을 가져오는 도중 문제발생!");
			}
		})
		},500);
		
}
setTimeout(function(){
	$('.skip h1').trigger('click');
},6000);
$(document).ready(function(){
	$('.skip h1').click(function(){
		{
			skip();
		}
	})
}) 

</script>
<body>
<div class="main_loding">
<section>
<video src="${path}/file/smoke.mp4" autoplay muted></video>
<h1 class="loding_h1">
<span>G</span>
<span>Y</span>
<span>U</span>
<span>T</span>
<span>A</span>
<span>E</span>
<span> </span>
<span>H</span>
<span>O</span>
<span>T</span>
<span>E</span>
<span>L</span>
</h1>
</section>
</div>
<div class="skip">
<h1>SKIP▶</h1>
</div>
</body>
</html>