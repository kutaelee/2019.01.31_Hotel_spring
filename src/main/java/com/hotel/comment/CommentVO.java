package com.hotel.comment;

import org.springframework.stereotype.Component;

@Component
public class CommentVO {
	private String comment_seq;
	private String parent_seq;
	private String writer;
	private String reg_date;
	private String content;
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getComment_seq() {
		return comment_seq;
	}
	public void setComment_seq(String comment_seq) {
		this.comment_seq = comment_seq;
	}
	public String getParent_seq() {
		return parent_seq;
	}
	public void setParent_seq(String parant_seq) {
		this.parent_seq = parant_seq;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	@Override
	public String toString() {
		return "CommentVO [comment_seq=" + comment_seq + ", parent_seq=" + parent_seq + ", writer=" + writer
				+ ", reg_date=" + reg_date + "]";
	}

	
}
