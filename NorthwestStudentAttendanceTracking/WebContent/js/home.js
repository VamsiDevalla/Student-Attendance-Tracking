function initializeHome(){
		
   $.get("accounts.html", function(data, status){
		$("#contentId").html(data);
		setAccountData();
   });

   $("#accountsId").click(function(){
       $.get("accounts.html", function(data, status){
    	   $("#contentId").html(data);
    	   setAccountData();
       });
   });
   
   $("#transfersId").click(function(){
	       $.get("transfers.html", function(data, status){
	    	   $("#contentId").html(data);
	       });
   });

   $("#messagesId").click(function(){
       $.get("messages.html", function(data, status){
    	   $("#contentId").html(data);
       });
   });   

}
   
