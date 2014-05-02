function IsEmail(email) {
  var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  if(!regex.test(email)) {
     return false;
  }else{
     return true;
  }
}

$(function(){
	$("#lead_email").focus();
	
	$('#submit').click(function(){
		var email = $('#lead_email').val();
		if(IsEmail(email)==false){
			alert("Please enter a valid email address!")
		  return false;
		}
	});
});