package com.hotel.book;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hotel.room.RoomDAO;
import com.hotel.room.RoomVO;

@Controller
public class BookController {
	@Autowired
	BookDAO bd;
	@Autowired
	BookVO bv;
	@Autowired
	RoomVO rv;
	@Autowired
	RoomDAO rd;
	

	@Transactional
	@RequestMapping(value="/bookinsert" ,method=RequestMethod.POST)
	public String bookinsert(HttpServletRequest req) {
		bv.setBook_checkin(req.getParameter("checkin"));
		bv.setBook_checkout(req.getParameter("checkout"));
		bv.setBook_pay(req.getParameter("pay"));
		bv.setBook_person(req.getParameter("person"));
		bv.setBook_type(req.getParameter("room"));
		bv.setStay(req.getParameter("stay"));
		int stay=Integer.parseInt(req.getParameter("stay"));
		int needrooms=Integer.parseInt(req.getParameter("needrooms"));
		
		int max=0;
		if(bv.getBook_type().equals("room1")) {
			 max=31;
		}else if(bv.getBook_type().equals("room2")) {
			 max=62;
		}else {
			max=93;
		}
		
		
		bd.bookinsert(bv);	
		
		rv.setRoom_date(bv.getBook_checkin());
		rv.setRoom_type(bv.getBook_type());
		rv=rd.roomcheck(rv);
		
		int seq=rv.getRoom_seq();
		rv.setRoom_rem(rv.getRoom_rem()-needrooms);
		
		for(int i=0;i<stay;i++) {
			if(seq+i<=max) {
				rv.setRoom_seq(seq+i);
			}else {
				rv.setRoom_seq(seq+i-31);
			}
			rd.roomupdate(rv);
		}
		
		return "booking";
	}
	
	@RequestMapping(value="/mybookselect" ,method=RequestMethod.POST)
	public @ResponseBody List<BookVO> mybookselect(HttpServletRequest req) {
		String id=req.getParameter("id");
		return bd.mybookselect(id);
	}
	
	@Transactional
	@RequestMapping(value="/mybookdelete" ,method=RequestMethod.POST)
	public @ResponseBody boolean mybookdelete(HttpServletRequest req) {
		int rooms;
		int max;
		String type=req.getParameter("type");
		String checkin=req.getParameter("checkin");
		int pay=Integer.parseInt(req.getParameter("pay"));
		int stay=Integer.parseInt(req.getParameter("stay"));
		pay=pay/stay;
		
		if(type.equals("room1")) {
			rooms=pay/10;
		}else if(type.equals("room2")) {
			rooms=pay/19;
		}else {
			rooms=pay/36;
		}
		rv.setRoom_type(type);
		rv.setRoom_date(checkin);
		
		rv=rd.roomcheck(rv);
		
		int roomseq=rv.getRoom_seq();
		
		if(type.equals("room1")) {
			 max=31;
		}else if(type.equals("room2")) {
			 max=62;
		}else {
			max=93;
		}
		
		rv.setRoom_rem(rv.getRoom_rem()+rooms);
		for(int i=0;i<stay;i++) {			
			if(roomseq+i<=max) {
				rv.setRoom_seq(roomseq+i);
			}else {
				rv.setRoom_seq(roomseq+i-31);
			}
			rv.setRoom_seq(roomseq+i);
			rd.roomupdate(rv);
			
		}
		
		bd.mybookdelete(req.getParameter("seq"));
		
		return true;
	}
}
