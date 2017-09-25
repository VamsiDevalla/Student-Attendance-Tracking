package com.saibank.rs.controller;

import org.springframework.context.annotation.Scope;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.saibank.dataObj.Customer;
import com.saibank.dataaccess.CustomerDataAccess;
import com.saibank.exception.DatabaseException;
import com.saibank.rs.dataObj.LoginResponse;
import com.saibank.rs.dataObj.RegistrationResponse;

@RestController
@Scope("request")
public class CustomerRegistrationController
{
	@RequestMapping(value = "/register") 
	public @ResponseBody RegistrationResponse register(@RequestBody Customer registration)
	{
		RegistrationResponse rr = null;
		CustomerDataAccess rd = new CustomerDataAccess();
		try {
			boolean result = rd.insertCustomer(registration);
			if(result == true){
				rr = new RegistrationResponse("Registration Successful");
			}
			else{
				rr = new RegistrationResponse("Registration Failed", "Registration database returned false");
			}
		} catch (Throwable e) {
			rr = new RegistrationResponse("Registration Failed", "Unexpected exception happened. check log.");
			e.printStackTrace();
		}
		return rr;
	}
	
	@RequestMapping(value = "/logins") 
	public @ResponseBody LoginResponse login(@RequestBody Customer login)
	{
		System.out.println(login);
		LoginResponse loginDetails = null;
		CustomerDataAccess rd = new CustomerDataAccess();
		try {
			boolean result = rd.checkCustomerLoginDetails(login);
			if(result == true){
				loginDetails = new LoginResponse("Login Successful");
			}
			else{
				loginDetails = new LoginResponse("Login Failed", "Login database returned false");
			}
		} catch (Throwable e) {
			loginDetails = new LoginResponse("Login Failed", "Unexpected exception happened. check log.");
			e.printStackTrace();
		}
		return loginDetails;
	}

}
