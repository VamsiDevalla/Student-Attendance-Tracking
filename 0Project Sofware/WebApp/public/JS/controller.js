
function randomCode(){
    document.querySelector('#text').value=Math.floor(Math.random()*(999-100+1)+100);
}
        


function generateBarCode(){
  var url;
  var n=document.querySelector('input[type="Number"]').value;
  for(var i=0;i<n;i++){
    var nric = document.querySelector('#text').value;
    var st="";
    st += nric;
    var run = $('#ram').val();
    url = 'https://api.qrserver.com/v1/create-qr-code/?data=' + st + run + '&amp;size=50x50';
    $('#barcode').attr('src', url);
    $('#uri').val("https://api.qrserver.com/v1/create-qr-code/?data='" + st + run + "'&amp");
  }
   $('#qruri').attr('href', url).attr("target", "_blank")[0].click();
   
}

