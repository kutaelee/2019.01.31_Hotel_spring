<%@page contentType="text/html; charset=utf-8"%>
<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/mypage.css?ver=4" rel="stylesheet">
<script>
var array;
$(document).ready(function(){
	function mybooklist(result){
		var desosit;
		var roomtype;
		$('.book_table').html("<tr class='thead'>");
		$('.thead').append("<th>결제번호</th>");
		$('.thead').append("<th>아이디</th>");
		$('.thead').append("<th>객실타입</th>");
		$('.thead').append("<th>체크인</th>");
		$('.thead').append("<th>체크아웃</th>");
		$('.thead').append("<th>결제시간</th>");
		$('.thead').append("<th>결제금액</th>");
		$('.thead').append("<th>입금계좌</th>");
		$('.thead').append("<th>결제여부</th>");
		$('.thead').append("<th>예약취소</th>");
		$('.book_table').append("</tr>");
		
		for(var i=0;i<result.length;i++){
		if(result[i].book_deposit=="Y"){
			deposit="결제완료";
		}else{
			deposit="결제대기중";
		}
		if(result[i].book_type=="room1"){
			roomtype="스텐다드";
		}else if(result[i].book_type=="room2"){
			roomtype="슈페리어";
		}else{
			roomtype="디럭스";
		}
			$('.book_table').append('<tr class="'+result[i].book_seq+'">');
			$('.'+result[i].book_seq).append("<td >"+result[i].book_seq+"</td>");
			$('.'+result[i].book_seq).append("<td >"+result[i].book_person+"</td>");
			$('.'+result[i].book_seq).append("<td >"+roomtype+"</td>");
			$('.'+result[i].book_seq).append("<td>"+result[i].book_checkin+"</td>");
			$('.'+result[i].book_seq).append("<td >"+result[i].book_checkout+"</td>");
			$('.'+result[i].book_seq).append("<td >"+result[i].book_date+"</td>");
			$('.'+result[i].book_seq).append("<td >"+result[i].book_pay+"만원</td>");
			$('.'+result[i].book_seq).append("<td >"+result[i].book_account+"</td>");
			$('.'+result[i].book_seq).append("<td >"+deposit+"</td>");
			$('.'+result[i].book_seq).append("<td><button class='cansle_btn' id='"+i+"'>예약취소</button></td>");

			$('.book_table').append('</tr>')
			
			$('.input_div').append('<form" id="form'+i+'">');
			$('#form'+i).append('<input type="hidden" class="seq" value="'+result[i].book_seq+'">');
			$('#form'+i).append('<input type="hidden" class="type" value="'+result[i].book_type+'">');
			$('#form'+i).append('<input type="hidden" class="checkin" value="'+result[i].book_checkin+'">');
			$('#form'+i).append('<input type="hidden" class="stay" value="'+result[i].stay+'">');
			$('#form'+i).append('<input type="hidden" class="pay" value="'+result[i].book_pay+'">');
			$('.input_div').append('</form>');
		}
	
	}

	$(document).on('click','.cansle_btn',function(){
		var index=$(this).prop('id');
		var type=$('#form'+index).children('.type').val();
		var checkin=$('#form'+index).children('.checkin').val();
		var stay=$('#form'+index).children('.stay').val();
		var pay=$('#form'+index).children('.pay').val();
		var seq=$('#form'+index).children('.seq').val();
		$.ajax({
			url:'/mybookdelete',
			type:'post',
			data:{'type':type,'checkin':checkin,'stay':stay,'pay':pay,'seq':seq},
			success:function(result){
				if(result){
					alert_call(true,"삭제완료!");
					setTimeout(function(){
						location.reload();
					},1500);
				}
			},
			error:function(e){
				alert_call("삭제 중 문제가 발생했습니다!");
				setTimeout(function(){
					location.reload();
				},1500);
			}
		})
	})
	setTimeout(function(){
		$.ajax({
			url:'/mybookselect',
			type:'post',
			data:{'id':sessionid},
			success:function(result){
				array=result;
				mybooklist(result);
			
			},
			error:function(e){
				console.log(e);
			}
		})
	},100);
	
	setTimeout(function(){
		if(sessionid==null){
			alert_call(false,"로그인 후 이용해주세요!");
			setTimeout(function(){
				window.location.href="/";
			},1500)
		}
	},300)
})

</script>
</head>

<body>
<div class="mypage_div">
<h4 class="mypage_head">Booking History</h4>
<div class="book_div">
<table class="book_table">

</table>
<div class="input_div">

</div>
</div>
</div>
</body>
</html>