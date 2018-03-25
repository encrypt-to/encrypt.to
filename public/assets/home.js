function validateKeyId($keyid) {
  var keyid = /[0][x].*/;
  if (!keyid.test( $keyid)) {
    return false;
  } else {
    return true;
  }
}

function validateEmail($email) {
  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,8})?$/;
  if (!emailReg.test($email)) {
    return false;
  } else {
    return true;
  }
}

function checkEmailAndKeyId() {
	if ($("#key").val() != "" && (validateEmail($("#key").val()) || validateKeyId($("#key").val()))) {
		return true;
	} else {
		return false;
	}	
}

$(function(){
  //$("#key").focus();
	//$("#try").prop('disabled', true);
	// validate input
	$('#key').bind('input propertychange', function() {
		if (checkEmailAndKeyId()) {
			$("#try").removeAttr('disabled');
		} else {
			$("#try").prop('disabled', true);
		}
	});
	// bind button
	$('#try').bind('click', function() {
		if ($("#key").val()==="") {
			alert("Please enter an email or key-id (0x...) if the public key is stored on a public key server!");
		} else {
			window.location.href = '/' + $("#key").val();	
		}
	});
	// bind enter
	$('#key').keydown(function(e) {
		if (e.keyCode == 13 && checkEmailAndKeyId()) {
	  	window.location.href = '/' + $("#key").val();
	  }
	});
});