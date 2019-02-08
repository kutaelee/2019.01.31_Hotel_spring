package com.hotel.comment;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class CommentController {
	@Autowired
	CommentDAO cd;
	@Autowired
	CommentVO cv;
	
	@Transactional
	@RequestMapping(value="/commentinsert",method=RequestMethod.POST)
	public @ResponseBody List<CommentVO> commentinsert(HttpServletRequest req) {
		cv.setParent_seq(req.getParameter("seq"));
		cv.setWriter(req.getParameter("writer"));
		cv.setContent(req.getParameter("content"));
		cd.commentinsert(cv);
		List<CommentVO> list=cd.commentlist(cv);

		return list;
	}
	@RequestMapping(value="/commentlist",method=RequestMethod.POST)
	public @ResponseBody List<CommentVO> commentlist(HttpServletRequest req) {
		cv.setParent_seq(req.getParameter("seq"));
		List<CommentVO> list=cd.commentlist(cv);
			
		return list;
	}
}
