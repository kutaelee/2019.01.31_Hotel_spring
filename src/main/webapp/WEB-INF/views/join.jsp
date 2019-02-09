<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@ page session="false"%>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>

<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/join.css?ver=12" rel="stylesheet">
</head>
<script>
var id_check=false;
var pw_check=false;
var pw2_check=false;
var email_check=false;
var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
var re = /[~!@\#$%^&*\()\-=+_']/gi; 
$(document).ready(function(){

	$('.id').change(function(){
	
		var id=$(this).val();
		
		if(re.test(id)){
			$(".id").val(id.replace(re,"")); 
		}else{
			if(id.length>=4){
				$.ajax({
					url:'/idcheck',
					type:'post',
					data:{'id':id},
					success:function(result){
						if(result){
							$('.info').css({'color':'yellowgreen'});
							$('.info').text("사용해도 좋은 아이디 입니다.");
							id_check=true;
						}else{
							$('.info').css({'color':'salmon'});
							$('.info').text("이미 존재하는 아이디 입니다.");
							id_check=false;
						}
						
					}		
				})		
			}else{
				$('.info').css({'color':'salmon'});
				$('.info').text("아이디는 4자리 이상 입력하셔야 합니다.");
				id_check=false;
			}
		}
		

	})
	$('.password').change(function(){
		var password=$(this).val();
		var password2=$('.password2').val();
		if(password.length<4){
			$('.info').css({'color':'salmon'});
			$('.info').text("비밀번호는 4자리 이상 입력하셔야 합니다.");
		}else{
			if(password!=password2){
				if(password2!=null||password2!="")
				{
					$('.info').css({'color':'salmon'});
						$('.info').text("비밀번호가 서로 다릅니다.");
						pw_check=false;
						pw2_check=false;
				}
			}else{
				$('.info').css({'color':'yellowgreen'});
				$('.info').text("사용하셔도 좋은 비밀번호 입니다.");
				
				pw_check=true;
				pw2_check=true;
			}
			
		}
	});
	$('.password2').keyup(function(){
		var password=$('.password').val();
		var password2=$(this).val();
		if(password.length<4){
			$('.info').css({'color':'salmon'});
			$('.info').text("비밀번호는 4자리 이상 입력하셔야 합니다.");
		}else{
			if(password!=password2){
				if(password!=null||password!="")
				{
					$('.info').css({'color':'salmon'});
					$('.info').text("비밀번호가 서로 다릅니다.");
					pw_check=false;
					pw2_check=false;
				}
			}else{
				$('.info').css({'color':'yellowgreen'});
				$('.info').text("비밀번호가 일치합니다.");
		
				pw_check=true;
				pw2_check=true;
			}
			
		}
	});
	//이메일 유효성과 유니크여부 체크
	$('.email').change(function(){
		var email=$('.email').val();
		$('.info').text("");
		
		if(exptext.test(email)){
			$.ajax({
				url:'/emailcheck',
				type:'post',
				data:{'email':email},
				success:function(result){
					if(result){
						$('.info').css({'color':'yellowgreen'});
						$('.info').text("사용해도 좋은 이메일 입니다.");
						email_check=true;
					}else{
						$('.info').css({'color':'salmon'});
						$('.info').text("이미 존재하는 이메일 입니다!");
					}
				}
			})
		
		}else{
			$('.info').css({'color':'salmon'});
			$('.info').text("이메일 형식에 맞춰주세요!");
		}
	})

	$('.join_btn').click(function(){
		if(id_check&&pw_check&&pw2_check&&email_check){
		var data=$('#joinform').serialize();
		$.ajax({
			url:'/memberjoin',
			type:'post',
			data:data,
			success:function(result){
				if(result){
					alert_call(true,"가입완료!");
					setTimeOut(function(){
						window.location.href="/";
					},500)
					
				}else{
					alert_call(false,"가입 도중 문제가 발생했습니다!")
						setTimeOut(function(){
							location.reload();
					},500)			
				}
				
			}
		
		})
		}else{
			if(id_check==false){
				
				alert_call(false,"입력하신 아이디에 문제가있습니다.");
			}else if(pw_check==false||pw_check2==false){
			
				alert_call(false,"입력하신 비밀번호에 문제가있습니다.");
			}else{
				
				alert_call(false,"입력하신 이메일에 문제가있습니다.");
			}
		}
	})
	
})
</script>
<body>
<div class="title"><h1>Join</h1></div>
<div class="join_div">
	<div class="left">
	</div>
	<div class="right">
	<div class="formBox">
	<form id="joinform">
		<p>ID</p>
		<input type="text" name="id" class="id" placeholder="사용하고 싶은 ID" maxlength="15">
		<p>E-mail</p>
		<input type="email" name="email" class="email" placeholder="ID찾기에 이용됩니다!" maxlength="30">
		<p>Password</p>
		<input type="password" name="password" class="password" placeholder="사용하고 싶은 비밀번호" maxlength="15">
		</form>
		<p>Password Check</p>
		<input type="password" class="password2" placeholder="위 비밀번호 한번 더 입력" maxlength="15">

		<button class="join_btn">회원가입</button>
		<a href="/login">아이디가 이미 있으신가요?</a>
		<br/><br/>
		<p class="info"></p>
	</div>

	</div>
</div>
</body>
</html>