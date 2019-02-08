package com.hotel.navi;

import java.io.PrintWriter;
import java.io.StringWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.hotel.common.LoggerAspect;

@ControllerAdvice
public class GlobalExceptionHandler extends RuntimeException {
	static final Logger logger = LoggerFactory.getLogger(LoggerAspect.class);
  // 모든 예외 처리
  @ExceptionHandler(Exception.class)
  public void handlerException(HttpServletRequest request, HttpServletResponse response,
                  Exception e) throws Exception{
	    StringWriter error = new StringWriter();
	    // 1. 로깅
	  e.printStackTrace(new PrintWriter(error));
	    request.setAttribute("error", "서버에서 에러가 났습니다! 죄송합니다!");
	    logger.error("REQUEST URI : {}", error);
 
    if(e.getClass().getName().equals("org.springframework.web.servlet.NoHandlerFoundException"));
    {
    	request.setAttribute("error", "요청하신 페이지를 찾을수 없습니다!");   	
    
    }
    // 2. 에러페이지
    // 컨트롤러가 아니기 때문에 뷰 페이지의 full path를 작성해야 함
    request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
  }
  
  
}

