package com.saibank.dataaccess;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import com.saibank.constants.BankConstants;
import com.saibank.dataObj.Customer;
import com.saibank.exception.DatabaseException;

public class CustomerDataAccess {

	public boolean insertCustomer(Customer customer) throws DatabaseException{
		boolean register = false;
		Connection connection = null;
		try {
			Class.forName(BankConstants.DB_DRIVER);
			connection = DriverManager.getConnection(BankConstants.DB_URL,
					BankConstants.DB_USERNAME, BankConstants.DB_PASSWORD);
			String query = "insert into customer(first_name, last_name, email, password, date_of_birth, phone) values(?,?,?,?,?,?)";
			PreparedStatement pstatement = connection.prepareStatement(query);
			pstatement.setString(1, customer.getFirstName());
			pstatement.setString(2, customer.getLastName());
			pstatement.setString(3, customer.getEmail());
			pstatement.setString(4, customer.getPassword());
			pstatement.setString(5, customer.getDateOfBirth());
			pstatement.setString(6, customer.getPhone());
			
			int count = pstatement.executeUpdate();
			if(count == 1){
				register = true;
			}
		} catch (Throwable exp) {
			DatabaseException de = new DatabaseException(exp);
			throw de;
		} finally {
			try {
				connection.close();
			} catch (Exception e) {

			}
		}
		return register;
	}
	
	public boolean checkCustomerLoginDetails(Customer customer) throws DatabaseException{
		boolean details = false;
		Connection connection = null;
		try {
			Class.forName(BankConstants.DB_DRIVER);
			connection = DriverManager.getConnection(BankConstants.DB_URL,
					BankConstants.DB_USERNAME, BankConstants.DB_PASSWORD);
			String query = "select * from customer where email = ? and password = ?";
			PreparedStatement pstatement = connection.prepareStatement(query);
			pstatement.setString(1, customer.getEmail());
			pstatement.setString(2, customer.getPassword());
			
			ResultSet rs = pstatement.executeQuery();
			if(rs.next()){
				details = true;
			}
		} catch (Throwable exp) {
			DatabaseException de = new DatabaseException(exp);
			throw de;
		} finally {
			try {
				connection.close();
			} catch (Exception e) {

			}
		}
		return details;
	}
	
	public static void main(String[] args) {
		try {
			CustomerDataAccess cda = new CustomerDataAccess();
			//Customer customer = new Customer("sai", "ram", "srk.mamidala@gmail.com", "sai123", "23/01/1995", "7046994107");
			Customer customer1 = new Customer("srk.mamidala@gmail.com","sai1234");
			//boolean result = cda.insertCustomer(customer);
			boolean result1 = cda.checkCustomerLoginDetails(customer1);
			//System.out.println(result);
			System.out.println(result1);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
