package com.hotel.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MemberController {
	@Autowired
	MemberVO mv;
	@Autowired
	MemberDAO md;
	@Autowired
	BCryptPasswordEncoder passwordEncoder;

	@RequestMapping(value="sessioncheck",method=RequestMethod.POST)
	public @ResponseBody String sessioncheck(HttpServletRequest req) {
		HttpSession session=req.getSession(true);
		if(session.getAttribute("userid")==null) {
			return "logout";
			
		}else {
			return session.getAttribute("userid").toString();
		}
	
	}
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String login(HttpServletRequest req) {
		HttpSession session = req.getSession();
		
		if(session.getAttribute("userid")!=null)
		{
			return "logout";
		}else {
			return "login";
		}
	}
	@RequestMapping(value="/memberlogin",method=RequestMethod.POST)
	public @ResponseBody String  memberlogin(HttpServletRequest req){
		String id=req.getParameter("id");
		String pw=req.getParameter("password")+"Gyutae_hotel";	

		MemberVO mv=new MemberVO();
		mv.setId(id);
		mv=md.memberlogin(mv);
		if(!ObjectUtils.isEmpty(mv)) {
			if(passwordEncoder.matches(pw, mv.getPassword())) {
				HttpSession session=req.getSession();
				session.setAttribute("userid",id);		
				return id;
			}else {
				return null;
			}
		}
		return null;

		
	}
	@RequestMapping(value="/memberlogout",method=RequestMethod.GET)
	public String memberlogout(HttpServletRequest req) {
		HttpSession session=req.getSession(false);
		if(session!=null) {
			session.invalidate();
		}
		return "logout";
	}
	@RequestMapping(value="/join",method=RequestMethod.GET)
	public String join() {
		return "join";
	}
	
	@RequestMapping(value="/idcheck",method=RequestMethod.POST)
	public @ResponseBody boolean idcheck(HttpServletRequest req){
		String id=req.getParameter("id");
	
		if(md.idcheck(id)!=null) {
			return false;
		}else {
			return true;
		}
		
	}
	@Transactional
	@RequestMapping(value="/memberjoin",method=RequestMethod.POST)
	public @ResponseBody boolean memberjoin(HttpServletRequest req){
		String id=req.getParameter("id");
		String email=req.getParameter("email");
		MemberVO mv=new MemberVO();
	
		if(!ObjectUtils.isEmpty(md.idcheck(id))&&!ObjectUtils.isEmpty(md.emailcheck(email))) {
			return false;
			
		}else {
			String pw=req.getParameter("password")+"Gyutae_hotel";	
			String encodepw = passwordEncoder.encode(pw);
			mv.setId(id);
			mv.setEmail(email);
			mv.setPassword(encodepw);
			md.memberjoin(mv);
			HttpSession session=req.getSession(false);
			session.setAttribute("userid", id);
			return true;
		}
	}
	@RequestMapping(value="/emailcheck",method=RequestMethod.POST)
	public @ResponseBody boolean emailcheck(HttpServletRequest req){
		String email=req.getParameter("email");
		mv=md.emailcheck(email);
		if(ObjectUtils.isEmpty(mv)) {
			return true;//사용해도좋음
		}else {
			return false;//이미있는이메일
		}
		
	}
	@RequestMapping(value="/helpid",method=RequestMethod.POST)
	public @ResponseBody String helpid(HttpServletRequest req){
		String email=req.getParameter("email");
		mv=md.emailcheck(email);

		if(!ObjectUtils.isEmpty(mv)) {
		
			return mv.getId();//이메일과 일치하는 아이디
		}else {
			return null;//사용해도좋음
	
		}
		
	}
}
