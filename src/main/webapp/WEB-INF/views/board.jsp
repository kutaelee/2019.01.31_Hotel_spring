<%@page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>
<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/board.css?ver=1" rel="stylesheet">
</head>
<script>

var curpagenum="1"; //현재 페이지번호 변수
var curseq="";
var curdocument=null;
var lastcomment_top = 0;
var lastcomment=0;
var cur_doc_path;
function toggle_effect(id){
	var i=0;
	while(i<4){
		$('.'+id).fadeOut('fast');
		$('.'+id).fadeIn('fast');
		i++;
	}
}
//댓글 불러오는 함수
function commentlist(list){
	$('.comment_table').html("<tr class='comment_head'><td><a>Comments</a> <a style='font-weight:bold'>'"+Object.keys(list).length+"'</a></td></tr>");
	var color="white";
	for(var i=0;i<Object.keys(list).length;i++){

		$('.comment_table').append("<tr class='comment_content'id='comment_tr"+list[i].comment_seq+"'>");
		$('#comment_tr'+list[i].comment_seq).append("<td class='"+list[i].comment_seq+"'><a class='comment_writer'>작성자:"+list[i].writer+"</a><a class='comment_reg_date'>날짜:"+list[i].reg_date+"</a> <img class='dat_update_icon' src='${path}/img/icon/edit-16.jpg'>  <img class='dat_delete_icon'src='${path}/img/icon/delete-16.jpg'> <br/><p>"+list[i].content+"</p>");
		$('.'+list[i].comment_seq).append("</tr>");
		if(list[i].modified=='Y'){
			$('.'+list[i].comment_seq).children().eq(1).append('<a class="comment_modified">수정됨</a>');
		}
	}
	if(i!=0){
		lastcomment=list[i-1].comment_seq;
		lastcomment_top = $('.'+list[i-1].comment_seq).offset();
	}	
}
//댓글 불러오는 함수
function commentload(){
	$.ajax({
		url:'/commentlist',
		type:'post',
		data:{'seq':curseq},
		success:function(result){
			$('.board_content').css({'margin-top':'5%'});
			$('.tag').css({'margin-top':'7%'});
			$('.header').css({'position':'fixed'});	
				commentlist(result);				
		}
		
	})
}

//선택글 img 파일 가져오는 함수
function fileread(path){
	$.ajax({
		url:'/fileread',
		type:'post',
		data:{'path':path},
		success:function(result){
			for(var i=0;i<result.length;i++){
				$('.read_content').parent().prepend('<img class="read_img"src="${path}/userfile/'+path+'/'+result[i]+'"><br/>');
			}
			
		}
	})
}
/* 선택글 출력 함수*/
function readformcall(){
	$.ajax({
		url:'/boardreadform',
		type:'post',
		success:function(result){
			$('.board_content').html(result);
			$.ajax({
				url:'/boardread',
				type:'post',
				data:{"seq":curseq},
				datatype:'json',
				success:function(result){
					curdocument=result;
					$('.read_title').append(result.title);
					$('.read_info').append('<a>작성자 :'+result.writer+'</a>');
					$('.read_info').append('<a>날짜 :'+result.regDate+'</a>');
					$('.read_info').append('<a>조회수 :'+result.cnt+'</a>');
					$('.nav-menu').css({'padding-top':'10%'});
				
					if(result.filepath){
						cur_doc_path=result.filepath;
						fileread(result.filepath);
					}else{
						cur_doc_path=null;
					}
					if($('body').prop('class')=='mobile'){
						$('.board_info').hide();
						$('.board_info2').hide();
						$('.board_content').css({'position':'absolute'});	
						$('.nav-menu').css({'padding-top':'30%'});
					}
					$('.read_content').append(result.content);
					
					commentload();
				},
				error:function(e){
					alert("글 읽기 중 문제가 발생했습니다!");
				}		
			});
		},
		error:function(e){
			alert("글 읽기 폼 로드중 문제가 발생했습니다!");
		}		
	});
}

/* 글쓰기폼 출력 함수 */
function writeform(update){
	$('.board_btn_div').hide();
	$.ajax({
		url:'/boardwriteform',
		type:'post',
		success:function(result){
			$('.board_content').html(result);
			$('.file_list').hide();
			if(update){
	
				$('.board_insert_btn').attr('class','board_update_btn');
				$('.input_title').val(curdocument.title);
				$('.input_content').val(curdocument.content.replace(/<br>/g, "\n"));
				$('.board_insert_form').append('<input type="hidden" id="input_seq" name="seq" value="'+curseq+'">');
				setTimeout(function(){
					if(cur_doc_path!=null){
						
						$.ajax({
							url:'/fileread',
							type:'post',
							data:{'path':cur_doc_path},
							success:function(result){
								console.log(result.length);
								$('.file_list').append("<h4>이전 파일 목록</h4>");
								for(var i=0; i<result.length;i++){
									$('.file_list').fadeIn();
									$('.file_list').append('<img id="update_img"class="'+i+'"src="${path}/userfile/'+cur_doc_path+'/'+result[i]+'"><br/>');
									$('.file_list').append('<p id="'+result[i]+'">'+result[i]+'<button class="'+i+'">X</button></p>');
									
								}
								
							}
						})
					
					}
				},300)
		
				
			}else{
				$('.board_update_btn').attr('class','board_insert_btn');
			}
		},
		error:function(e){
			alert("글쓰기 폼을 가져오던 중 문제가 발생했습니다!");
		}	
	})
}

/* 특수문자 치환 */
function ConvertSystemSourcetoHtml(str){
 str = str.replace(/</g,"&lt;");
 str = str.replace(/>/g,"&gt;");
 str = str.replace(/\"/g,"&quot;");
 str = str.replace(/\'/g,"&#39;");
 str = str.replace(/(?:\r\n|\r|\n)/g, '<br>');
 return str;
}
/* 고객센터 페이지 로드 함수*/
function pageload(pagenum){

	$.ajax({
		url:'/boardpaging',
		type:'post',
		data:{'i':pagenum},
		datatype:'json',
		success:function(result){
			tableload(result);
		},
		error:function(e){
			alert("페이징 도중 문제가 발생했습니다!");
		}
	})
}
/* 게시판 붙여넣는 함수*/
function tableload(list){

	$('.board_content').text("");
	$('.board_content').append('<table class="board_table"><tr class="thead"><th class="th_seq">번호</th><th class="th_title">제목</th><th class="th_writer">작성자</th><th class="th_date">날짜</th><th class="th_cnt">조회수</th></tr></table>');
	for(var i=0;i<Object.keys(list).length;i++)
		{
		if(list[i].security=="Y"){
			$('.board_table').append('<tr class="board_list_lock"id="'+list[i].seq+'">');
		}else{
			$('.board_table').append('<tr class="board_list"id="'+list[i].seq+'">');
		}
		$('#'+list[i].seq).append('<td class="seq">'+list[i].seq+'</td>');
		if(list[i].security=="Y"){
			$('#'+list[i].seq).append('<td class="title">'+list[i].title+'<img src="${path}/img/icon/padlock-16.jpg" style="margin-left:3"></td>');
		}else{
			$('#'+list[i].seq).append('<td class="title">'+list[i].title+'</td>');
		}

		$('#'+list[i].seq).append('<td class="writer">'+list[i].writer+'</td>');
		$('#'+list[i].seq).append('<td class="regDate">'+list[i].regDate+'</td>');
		$('#'+list[i].seq).append('<td class="cnt">'+list[i].cnt+'</td>');
		$('.board_table').append('</tr>');
		}
	$('.board_table').append('</table>');
	$('.board_btn_div').fadeIn();
}

//댓글 수정취소 시 다시 로드
function commentreload(lastdatseq,datbuffer){
	if(lastdatseq>0){
		$('.'+lastdatseq).html(datbuffer);
	}
	
}
function commentdelete(seq){
	$.ajax({
		url:'/commentdelete',
		type:'post',
		data:{'seq':seq,'id':sessionid},
		success:function(result){
			if(result){
				commentlist(result);
				alert_call(true,"댓글 삭제 완료!");
			}else{
				alert_call(false,"권한이 없습니다!");
			}
		
		},
		error:function(){
			alert_call(false,'댓글 삭제 중 문제발생');
		}
	});
}
$(document).ready(function(){
	/* 페이징,테이블 기준변수  */
	var count=${count}; //총 게시글 갯수
	var i=1; //게시글 행 1씩 증가
	var j=10; //게시글 목록당 수 10씩 증가
	var update_file_list = []; //글 수정 이전 파일리스트
	var lastdatseq=0; //댓글 수정버튼 클릭한 댓글번호
	var datbuffer=null; //수정취소 시 붙여넣을 내용 버퍼
	var callback=false;
	/*mobile*/
	if($('body').width()<450){
		$('body').attr('class','mobile');
		$('.tag').removeAttr('class').attr('class','tag_mobile');
		$('.nav-menu').css({'padding-top':'padding-top: 18%'});	
	}
	
	//댓글 삭제
	$(document).on('click','.dat_delete_icon',function(){

		var delete_seq=$(this).parent().prop('class');
		if(window.confirm("댓글을 삭제하시겠습니까?")){
			commentdelete(delete_seq);
		}
		
	});
	//댓글 수정
	$(document).on('click','.dat_update_submit',function(){
		
		var content=ConvertSystemSourcetoHtml($('.dat_content').val());

		$.ajax({
			url:'/commentupdate',
			type:'post',
			data:{'seq':lastdatseq,'content':content,'id':sessionid},
			success:function(result){
				if(result){
					$('.'+lastdatseq).html("<a class='comment_writer'>작성자:"+result.writer+"</a><a class='comment_reg_date'>날짜:"+result.reg_date+"</a> <img class='dat_update_icon' src='${path}/img/icon/edit-16.jpg'>  <img class='dat_delete_icon'src='${path}/img/icon/delete-16.jpg'> <br/><p>"+result.content+"</p>");	
					$('.'+lastdatseq+' .comment_reg_date').append("<a class='comment_modified'>수정됨</a> ");
					lastdatseq=0;
					datbuffer=null;
				}else{
					alert_call(false,"권한이 없습니다.");
				} 
				
			},
			error:function(){
				alert_call(false,"댓글 수정 중 문제가 발생했습니다.");
				
				setTimeout(function(){
					location.reload();
				},1000);
		
			}
		});
	});


	//댓글 수정폼 출력
	$(document).on('click','.dat_update_icon',function(){
		commentreload(lastdatseq,datbuffer);
		lastdatseq=$(this).parent().prop('class');
		datbuffer=$(this).parent().html();
		$(this).parent().html('<input type="text" class="dat_content"><button class="dat_update_submit">확인</button><button class="dat_update_cansle">취소</button>');
		
	});
	//댓글 수정 취소
	$(document).on('click','.dat_update_cansle',function(){
		commentreload(lastdatseq,datbuffer);
	})
	//수정할 파일 리스트 푸쉬
	$(document).on('click','.file_list button',function(){
		$(this).parent().fadeOut('slow');
		$('.'+$(this).prop('class')).fadeOut('slow');
		update_file_list.push($(this).parent().prop('id'));
	
	})
	/* 페이징 함수 */
	function paging(){
		if(i>10){
			$('.paging_span').append('<button class="prev">≪</button>');
		}		
		for(i;i<count/10+1&&i<=j;i++){
			if(j-i==9){
				$('.paging_span').append('<button class="pagenum_active">'+i+'</button>');
			}else{
				$('.paging_span').append('<button class="pagenum">'+i+'</button>');
			}
		}
		
			if(i>j){
				if(count>j*10)
				$('.paging_span').append('<button class="next">≫</button>');
				j+=10;
			}
			
	}
	/*이전버튼 페이징*/
	function prevpaging(){
		if(i%10==1){
			j-=20;
			i-=20;
		}else{
			i-=i%10+9;
			j-=10;
		}
	
		if(i>10){
			$('.paging_span').append('<button class="prev">≪</button>');
		}
		for(i;i<count/10+1&&i<=j;i++){
			if(j-i==9){
				$('.paging_span').append('<button class="pagenum_active">'+i+'</button>');
			}else{
				$('.paging_span').append('<button class="pagenum">'+i+'</button>');
			}
			}
		
			if(i>j){
				if(count>j*10)
				$('.paging_span').append('<button class="next">≫</button>');
				j+=10;
			}
			
	}
	/* 페이징 호출 */
	if(count<10){
		$('.paging_span').append("<button>1</button>");
	}else if(count>j){	
		paging();
	}
	/* 고객센터 페이지 로드 함수 호출*/
	pageload("1");
	
	/* 페이지번호 버튼 기능 */
	$(document).on('click','.pagenum',function(){
		$('.pagenum_active').attr('class','pagenum');
		$(this).attr('class','pagenum_active');
		var pagenum=$(this).text();
		pageload(pagenum);
	})

	/*이전 버튼 기능*/
	$(document).on('click','.prev',function(){
		$('.paging_span').text("");
		pageload(i-20);
		prevpaging();
		})
	
	/* 다음 버튼 기능 */
	$(document).on('click','.next',function(){
		$('.paging_span').text("");
		pageload(i);
		paging();
	})
	/* 테이블 마우스 오버 css*/
		$(document).on('mouseover','.board_table tr',function(){
		$('.board_table td').css({
			'border':'none'
		})
		$(this).mouseout(function(){
			$('.board_table td').css({
				'border-bottom':'1px solid' 
			})
		})
	})
	/* 태그 위치 조절 */
	$(document).on('click','.back_btn',function(){
		$('.header').css({'position':'relative'});
		$('.board_content').css({'margin-top':'0'});
		$('.tag').css({'margin-top':'2%'});
	
		$('.tag').css({'margin-left':'20%'});
		if($('body').prop('class')=='mobile'){
			$('.board_info').show();
			$('.board_info2').show();
			$('.board_content').css({'position':'relative'});
			$('.nav-menu').css({'padding-top':'18%'});
		}else{
			$('.nav-menu').css({'padding-top':'5%'});
			
		}
	
	})
	$(document).on('click','.back_span',function(){
		$('.board_content').css({'margin-top':'0'});
		$('.tag').css({'margin-top':'2%'});
		$('.header').css({'position':'relative'});
	
		$('.tag').css({'margin-left':'20%'});
		if($('body').prop('class')=='mobile'){
			$('.board_info').show();
			$('.board_info2').show();
			$('.board_content').css({'position':'relative'});
			$('.nav-menu').css({'padding-top':'18%'});
		}else{
			$('.nav-menu').css({'padding-top':'5%'});
		}
		pageload(curpagenum);
	})
	
	/* 선택한 글 출력 */
	$(document).on('click','.board_list',function(){
		$('.tag').css({'margin-left':'30%'});
		curpagenum=$('.pagenum_active').text();
		$('.board_btn_div').hide();
		curseq=$(this).children('.seq').text();
		readformcall();
	})
	/*잠긴 글 작성자 확인 후 출력*/
	$(document).on('click','.board_list_lock',function(){
		curseq=$(this).children('.seq').text();
		$.ajax({
			url:'/securitycheck',
			type:'post',
			data:{'sessionid':sessionid,'seq':curseq},
			success:function(result){
				if(result){
					$('.tag').css({'margin-left':'30%'});
					curpagenum=$('.pagenum_active').text();
					$('.board_btn_div').hide();
					readformcall();
				}else{
					alert_call(false,"비밀글은 작성자와 관리자만 읽을 수 있습니다.");
				}
			}
		})
	})

	
	/* 글쓰기 페이지 출력 */
	$('.board_write_btn').click(function(){
	
		if(sessionid!=null){
			if($('body').prop('class')=='mobile'){
				$('.board_info').hide();
				$('.board_info2').hide();
		
			}
			
			writeform(false);
		}else{
			alert_call(false,"로그인 후 이용해주세요");
		}

		
	})
	/*선택글 수정 버튼*/
	$(document).on('click','.update_btn',function(){
		$.ajax({
			url:'/securitycheck',
			type:'post',
			data:{'sessionid':sessionid,'seq':curseq},
			success:function(result){
				if(result){
					if($('body').prop('class')=='mobile')
					{
						$('.header').css({'position':'relative'});
					}
					
					update_file_list=[];
					writeform(true);
				}else{
					alert_call(false,"권한이 없습니다.");
				}
			}
			});
	

	})
	/* 글등록 */
		$(document).on('click','.board_insert_btn',function(){	
			if($('.input_title').val().length==0||$('.input_title').val()==""||$('.input_content').val().length==0||$('.input_content').val()==""){
				alert_call(false,"제목이나 내용에 빈 값이 있습니다!");
			}else{
				
			
			if($('.input_lock').is(":checked")){
				$('.input_hidden').val("Y");
			}else{
				$('.input_hidden').val("N");
			}
			$('.input_writer').val(sessionid);
			var content=$('.input_content').val();
			var title=$('.input_title').val();
			$('.input_title').val(ConvertSystemSourcetoHtml(title));
			$('.input_content').val(ConvertSystemSourcetoHtml(content));
			var form = new FormData(document.getElementById('board_insert_form'));
			$.ajax({
			url:'/boardinsert',
			type:'post',
			data:form,
			async: false,
		    cache: false,
		    contentType: false,
		    processData: false,
			success:function(result){
				$('.pagenum_active').attr('class','pagenum');
				$('.paging_span').children().first().attr('class','pagenum_active');
				pageload('1');
				tableload(result);
			},
			error:function(e){
				alert("글쓰기 도중 문제가 발생했습니다!");
			}
		})
			}
		})
		/*댓글 등록*/
		$(document).on('click','.datgle_btn',function(){
			if(sessionid!=null){
				var content=ConvertSystemSourcetoHtml($('.datgle').val());
				if(content.trim()!=''&&content!=null){
					$.ajax({
						url:'/commentinsert',
						type:'post',
						data:{'content':content,'writer':sessionid,'seq':curseq},
						success:function(result){
						
							$('.datgle').val("");
							commentlist(result);
							$('body').animate({scrollTop:lastcomment_top.top},1000);
							toggle_effect(lastcomment);
						}
					})
				}else{
					alert_call(false,"내용을 입력해주세요!");
				}
			}else{
				alert_call(false,"로그인 후 이용해주세요!");
			}
		})
		/* 글 수정 기능*/
	$(document).on('click','.board_update_btn',function(){	
		if($('.input_title').val().length==0||$('.input_title').val()==""||$('.input_content').val().length==0||$('.input_content').val()==""){
			alert_call(false,"제목이나 내용에 빈 값이 있습니다!");
		}else{
		var content=$('.input_content').val();
		var title=$('.input_title').val();
		$('.input_title').val(ConvertSystemSourcetoHtml(title));
		$('.input_content').val(ConvertSystemSourcetoHtml(content));

		var form = new FormData(document.getElementById('board_insert_form'));
		var file_seq=$('#input_seq').val();
		$.ajax({
			url:'/boardupdate',
			type:'post',
			data:form,
			async: false,
		    cache: false,
		    contentType: false,
		    processData: false,
			success:function(){
				if(update_file_list.length>0){
					$.ajax({
						url:'fileupdate',
						type:'post',
						data:{'list':update_file_list,'seq':file_seq},
						 traditional : true,
						success:function(result){

							if(result){readformcall()};
						},error:function(e){
							alert(e);
						}
					})
				}else{
					readformcall();
				}

			},
			error:function(e){
				alert("글수정 도중 문제가 발생했습니다!");
			}
		})
		}
	});
	
		/* 글자수 제한*/
	$(document).on('keyup','.input_content',function(){
	  if($(this).val().length > 2000) {
		   $(this).val($(this).val().substring(0, 2000));
		 }
	})
	$(document).on('keyup','.datgle',function(){
	  if($(this).val().length > 100) {
		   $(this).val($(this).val().substring(0, 100));
		 }
	})
	/* 글 삭제*/
	$(document).on('click','.delete_btn',function(){
		$.ajax({
			url:'/securitycheck',
			type:'post',
			data:{'sessionid':sessionid,'seq':curseq},
			success:function(result){
				if(result){
					$.ajax({
						url:'/boarddelete',
						type:'post',
						data:{'seq':curseq},
						datatype:'json',
						success:function(){
							alert_call(true,"삭제완료!");
							setTimeout(function(){
								window.location.href="/board";
							},1000)
							
						},
						error:function(e){
							alert("삭제 도중 문제가 발생했습니다!");
						}
					})
				}else{
					alert_call(false,"권한이 없습니다.");
				}
			}
			});
	
	})
	//파일 업로드 제한
	$(document).on('change','#img_file',function(){
	if(this.files.length>0){
		 var sum=0
	
		 for(var i=0;i<this.files.length;i++){
				fileName=this.files[i].name;
				
				  if (!(/\.(gif|jpg|jpeg|tiff|png)$/i).test(fileName)) {              
					    alert_call(false,'이미지 파일만 업로드할 수 있습니다.');   
					    $(this).val("");
				 }
					 
					  sum+=this.files[i].size;
					  console.log(sum);
					  if(sum>10485760){
						  alert_call(false,'파일업로드 제한은 10메가입니다!');   
						    $(this).val("");
					  }
				  }
	}
	
	})
});

</script>
<body>
<h1 class="tag">고객센터</h1>
	

		<div class="board_content">

		
		</div>
		<div class="board_btn_div">
		<span class="paging_span"></span>
		<button class="board_write_btn">글쓰기</button>
		</div>
			<div class="board_info" >
			<h1 style="margin-bottom:0">전화 문의</h1>
		<h1 style="color: tomato">. . . . . . . .</h1>
			<h4>010-1234-****</h4>
			<h4>평일 AM 9:00 ~ PM 6:00</h4>
			<h4>공휴일 제외</h4>
		</div>
		<div class="board_info2" >
			<h1 style="margin-bottom:0">게시판 문의</h1>
		<h1 style="color: tomato">. . . . . . . .</h1>
			<h4>24시간 연중무휴</h4>
			<h4>최대한 빠른 시간내에 </h4>
			<h4>답변 드리도록 노력하겠습니다.</h4>
		</div>
</body>
</html>