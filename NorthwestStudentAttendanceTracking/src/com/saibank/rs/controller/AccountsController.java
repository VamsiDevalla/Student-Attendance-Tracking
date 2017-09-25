package com.saibank.rs.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Scope;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.saibank.dataObj.AccountDetail;

@RestController
@Scope("request")
public class AccountsController
{
	
	
	@RequestMapping(value = "/getAllAccounts") 
	public @ResponseBody List<AccountDetail> getAllAccounts(Model model)
	{
		AccountDetail accountDetail1 = new AccountDetail("Checking Account", "139393490");
		AccountDetail accountDetail2 = new AccountDetail("Savings Account", "93939");
		
		List<AccountDetail> list = new ArrayList<AccountDetail>();
		list.add(accountDetail1);
		list.add(accountDetail2);
		
		return list;
	}
	

	

	
}
