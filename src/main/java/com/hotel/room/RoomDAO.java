package com.hotel.room;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Service;

@Service
public class RoomDAO {
	private static final String namespace="com.hotel.room.RoomMapper";
	
	@Inject
	private SqlSession sqlssion;
	
	public void roomset(RoomVO rv) {
		System.out.println("roomset");
		sqlssion.selectOne(namespace+".roomset",rv);
	}
	public RoomVO roomcheck(RoomVO rv) {
		return sqlssion.selectOne(namespace+".roomcheck",rv);
	}
	public RoomVO stayroomcheck(RoomVO rv) {
		return sqlssion.selectOne(namespace+".stayroomcheck",rv);
	}
	public void roomupdate(RoomVO rv) {
		sqlssion.update(namespace+".roomupdate",rv);

	}
	public List<RoomVO> remainingrooms(String room_type){
		return sqlssion.selectList(namespace+".remainingrooms",room_type);
	}
	public void roomchange(RoomVO rv) {
		sqlssion.selectList(namespace+".roomchange",rv);
	}
}
