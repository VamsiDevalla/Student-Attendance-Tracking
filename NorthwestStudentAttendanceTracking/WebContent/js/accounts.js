function setAccountData()
{
	 $.get("getAllAccounts.action", function(data, status){
				 
		 $.each(data, function(i, accountDataObj) {
			 //alert(accountDataObj);
			 $('#accountsTableId')
		     .append("<tr><td>" + accountDataObj.accountName + "</td><td>"+ accountDataObj.accountNumber +"</td></tr>");
		 });//each
    
	 });//get

}//setAccountData
