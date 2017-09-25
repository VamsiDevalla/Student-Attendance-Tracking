package com.saibank.util;

import java.io.IOException;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.saibank.dataObj.Customer;

public class JsonGenerator {

	public static void main(String[] args) {
		Customer customer = new Customer("sai", "ram", "sd;lfkj@;sdljfa.com", "wertyu", "qqwert", "879879789");
		 ObjectMapper mapper = new ObjectMapper();
		 try {
			mapper.writeValue(System.out, customer);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
