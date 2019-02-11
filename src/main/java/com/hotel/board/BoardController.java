package com.hotel.board;



import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.mysql.cj.util.StringUtils;

/**
 * Handles requests for the application home page.
 */
@Controller
public class BoardController {
	
	@Autowired
	BoardVO bv;
	@Autowired
	BoardDAO bd;
	
	
	@RequestMapping(value = "/board", method = RequestMethod.GET)
	public String board(Model model) {
		model.addAttribute("list",bd.selcetlist(0));
		model.addAttribute("count",bd.boardCount());
		return "board";
	}
	@RequestMapping(value = "/boardpaging", method = RequestMethod.POST)
	public @ResponseBody List<BoardVO> boardpaging(Model model,HttpServletRequest req) {

		int i=Integer.parseInt(req.getParameter("i"));
		model.addAttribute("count",bd.boardCount());
		return bd.selcetlist((i-1)*10);
	}
	@RequestMapping(value = "/boardwriteform", method = RequestMethod.POST)
	public String boardwriteform() {
		return "boardwrite";
	}
	@RequestMapping(value = "/boardreadform", method = RequestMethod.POST)
	public String boardreadform() {
		return "boardread";
	}
	@Transactional
	@RequestMapping(value = "/boardinsert", method = RequestMethod.POST)
	public @ResponseBody List<BoardVO> submit(MultipartHttpServletRequest req) throws IllegalStateException, IOException
 {	 		
	
		List<MultipartFile> mf = req.getFiles("file[]");
		String id=req.getParameter("writer");
	
		if(mf.get(0).getSize()>0) {	
			bv.setFilepath(bd.uploadfiles(mf,id));
		}else {
			bv.setFilepath(null);
		}

		String title=req.getParameter("title");
		String content=req.getParameter("content");
		String writer=req.getParameter("writer");
		bv.setTitle(title);
		bv.setContent(content);
		bv.setWriter(writer);
		bv.setSecurity(req.getParameter("lock"));
		bd.boardinsert(bv);
		return bd.selcetlist(0);
	}
	@Transactional
	@RequestMapping(value = "/boardread", method = RequestMethod.POST)
	public  @ResponseBody BoardVO boardread(HttpServletRequest req) {
		bv.setSeq(Integer.parseInt(req.getParameter("seq")));
		return bd.selectread(bv);
	}
	
	@RequestMapping(value="/fileread", method = RequestMethod.POST)
		public @ResponseBody List<String> readfile(HttpServletRequest req){

		return bd.fileread(req.getParameter("path"));
	}
	@Transactional
	@RequestMapping(value="/fileupdate", method = RequestMethod.POST)
	public @ResponseBody boolean fileupdate(HttpServletRequest req){

		String[] list=req.getParameterValues("list");
		bv.setSeq(Integer.parseInt(req.getParameter("seq")));
		bv=bd.selectread(bv);

		bd.updatefile(list,bv.getFilepath());

		return true;
}
	@Transactional
	@RequestMapping(value = "/securitycheck", method = RequestMethod.POST)
	public  @ResponseBody boolean securitycheck(HttpServletRequest req) {
		String id=req.getParameter("sessionid");
		String seq=req.getParameter("seq");

		if(id.equals("admin")) {
			return true;
		}
		bv.setSeq(Integer.parseInt(seq));
		bv.setWriter(id);

		if(bd.securitycheck(bv)==null) {
			return false;
		}else {
			return true;
		}
	}
	@Transactional
	@RequestMapping(value = "/boardupdate", method = RequestMethod.POST)
	public String boardupdate(MultipartHttpServletRequest req) throws IllegalStateException, IOException {	
		List<MultipartFile> mf = req.getFiles("file[]");
		bv.setSeq(Integer.parseInt(req.getParameter("seq")));
		if(mf.get(0).getSize()>0) {
			bv=bd.selectread(bv);
			bd.addfiles(mf, bv.getFilepath());
		}
		String title=req.getParameter("title");
		String content=req.getParameter("content");
		
		
		bv.setTitle(title);
		bv.setContent(content);	
		bd.boardupdate(bv);
		return "board";
	}
	@Transactional
	@RequestMapping(value = "/boarddelete", method = RequestMethod.POST)
	public String boarddelete(HttpServletRequest req) {
		bv.setSeq(Integer.parseInt(req.getParameter("seq")));
		bv=bd.selectread(bv);
		if(!StringUtils.isNullOrEmpty(bv.getFilepath())) {
			bd.filedelete(bv.getFilepath());
		}
		
		bd.boarddelete(bv);
		
		return "board";
	}
	
}
