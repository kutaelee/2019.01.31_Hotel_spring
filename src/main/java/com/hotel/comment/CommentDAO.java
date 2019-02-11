package com.hotel.comment;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
	public void commentupdate(CommentVO cv) {
		sqlssion.update(namespace+".commentupdate",cv);
	}
	public CommentVO commentselect(CommentVO cv) {
		return sqlssion.selectOne(namespace+".commentselect",cv);
	}
	@Transactional
	public void commentdelete(CommentVO cv) {
		sqlssion.delete(namespace+".commentdelete",cv);
	}
}
