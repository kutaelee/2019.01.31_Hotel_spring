package com.hotel.common;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.TimeZone;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
 
@Aspect
@Component
public class LoggerAspect {
	static final Logger logger = LoggerFactory.getLogger(LoggerAspect.class);

     
   @Before("execution(* com.springbook.board.*.submit(..))")
   public void before(JoinPoint joinPoint) {
	   HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		logger.info("REQUEST URI : {}", request.getRequestURI());
	   
   }

   
}
