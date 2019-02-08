package com.hotel.book;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

@Service
public class BookDAO {
	private static final String namespace="com.hotel.book.BookMapper";
	@Inject
	private SqlSession sqlssion;
	
	public void bookinsert(BookVO bv) {
	 sqlssion.insert(namespace+".bookinsert",bv);
	}
	public List<BookVO> mybookselect(String id){
		return sqlssion.selectList(namespace+".mybookselect",id);
	}
	public void mybookdelete(String seq) {
		sqlssion.delete(namespace+".mybookdelete",seq);
	}
}
