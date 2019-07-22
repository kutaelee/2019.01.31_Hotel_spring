package com.hotel.room;

import org.springframework.stereotype.Component;

@Component
public class RoomVO {
	private int room_seq;
	private String room_type;
	private String room_date;
	private int room_rem;
	public int getRoom_seq() {
		return room_seq;
	}
	public void setRoom_seq(int room_seq) {
		this.room_seq = room_seq;
	}
	public String getRoom_type() {
		return room_type;
	}
	public void setRoom_type(String room_type) {
		this.room_type = room_type;
	}
	public String getRoom_date() {
		return room_date;
	}
	public void setRoom_date(String room_date) {
		this.room_date = room_date;
	}
	public int getRoom_rem() {
		return room_rem;
	}
	public void setRoom_rem(int room_rem) {
		this.room_rem = room_rem;
	}
	@Override
	public String toString() {
		return "RoomVO [room_seq=" + room_seq + ", room_type=" + room_type + ", room_date=" + room_date + ", room_rem="
				+ room_rem + "]";
	}

	
}
