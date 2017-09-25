package com.saibank.dataObj;

public class AccountDetail
{
	private String accountName;
	private String accountNumber;
	public AccountDetail(String accountName, String accountNumber)
	{
		super();
		this.accountName = accountName;
		this.accountNumber = accountNumber;
	}
	public String getAccountName()
	{
		return accountName;
	}
	public void setAccountName(String accountName)
	{
		this.accountName = accountName;
	}
	public String getAccountNumber()
	{
		return accountNumber;
	}
	public void setAccountNumber(String accountNumber)
	{
		this.accountNumber = accountNumber;
	}
	
	
}
