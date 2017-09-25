package com.saibank.rs.dataObj;

public class LoginResponse {

	private String result;
	private String failedReason;
	public LoginResponse() {
		// TODO Auto-generated constructor stub
	}
	
	public LoginResponse(String result, String failedReason) {
		super();
		this.result = result;
		this.failedReason = failedReason;
	}
	

	public LoginResponse(String result) {
		super();
		this.result = result;
	}

	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}

	public String getFailedReason() {
		return failedReason;
	}

	public void setFailedReason(String failedReason) {
		this.failedReason = failedReason;
	}
	
}
