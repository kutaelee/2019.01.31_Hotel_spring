package com.hotel.book;

import org.springframework.stereotype.Component;

@Component
public class BookVO {
	private String book_seq;
	private String book_type;
	private String book_person;
	private String book_date;
	private String book_pay;
	private String book_deposit;
	private String book_account;
	private String book_checkin;
	private String book_checkout;
	private String stay;
	

	public String getStay() {
		return stay;
	}
	public void setStay(String stay) {
		this.stay = stay;
	}
	public String getBook_checkin() {
		return book_checkin;
	}
	public void setBook_checkin(String book_checkin) {
		this.book_checkin = book_checkin;
	}
	public String getBook_checkout() {
		return book_checkout;
	}
	public void setBook_checkout(String book_checkout) {
		this.book_checkout = book_checkout;
	}
	public String getBook_account() {
		return book_account;
	}
	public void setBook_account(String book_account) {
		this.book_account = book_account;
	}
	public String getBook_seq() {
		return book_seq;
	}
	public void setBook_seq(String book_seq) {
		this.book_seq = book_seq;
	}
	public String getBook_type() {
		return book_type;
	}
	public void setBook_type(String book_type) {
		this.book_type = book_type;
	}
	public String getBook_person() {
		return book_person;
	}
	public void setBook_person(String book_person) {
		this.book_person = book_person;
	}
	public String getBook_date() {
		return book_date;
	}
	public void setBook_date(String book_date) {
		this.book_date = book_date;
	}
	public String getBook_pay() {
		return book_pay;
	}
	public void setBook_pay(String book_pay) {
		this.book_pay = book_pay;
	}
	public String getBook_deposit() {
		return book_deposit;
	}
	public void setBook_deposit(String book_deposit) {
		this.book_deposit = book_deposit;
	}
	@Override
	public String toString() {
		return "BookVO [book_seq=" + book_seq + ", book_type=" + book_type + ", book_person=" + book_person
				+ ", book_date=" + book_date + ", book_pay=" + book_pay + ", book_deposit=" + book_deposit + "]";
	}
	
	
}
