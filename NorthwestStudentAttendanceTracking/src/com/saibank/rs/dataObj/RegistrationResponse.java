package com.saibank.rs.dataObj;

public class RegistrationResponse {

	private String result;
	private String failedReason;
	public RegistrationResponse() {
		// TODO Auto-generated constructor stub
	}
	
	public RegistrationResponse(String result, String failedReason) {
		super();
		this.result = result;
		this.failedReason = failedReason;
	}
	

	public RegistrationResponse(String result) {
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
