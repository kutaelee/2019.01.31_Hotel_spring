package com.hotel.comment;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

@Service
public class CommentDAO {
	private static final String namespace="com.hotel.comment.CommentMapper";
	
	@Inject
	private SqlSession sqlssion;
	
	public void commentinsert(CommentVO cv) {
		sqlssion.selectList(namespace+".commentinsert",cv);
	}
	public List<CommentVO> commentlist(CommentVO cv){
		return sqlssion.selectList(namespace+".commentlist",cv);
	}
}
