package com.hotel.member;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

@Service
public class MemberDAO {
	private static final String namespace="com.hotel.member.MemberMapper";
	@Inject
	private SqlSession sqlssion;
	
	public MemberVO memberlogin(MemberVO vo) {
		return sqlssion.selectOne(namespace+".memberlogin",vo);
	}
	public MemberVO idcheck(String id) {
		return sqlssion.selectOne(namespace+".idcheck",id);
	}
	public void memberjoin(MemberVO mv) {
		sqlssion.insert(namespace+".memberjoin",mv);
	}
	public MemberVO emailcheck(String email) {
		return sqlssion.selectOne(namespace+".emailcheck",email);
	}
}
