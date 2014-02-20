function valid(msg) {
	$('#invalid').hide();
	$('#valid').text(msg);
	$('#valid').show();
	$("#submit").removeAttr('disabled');
}

function invalid(msg) {
	$('#valid').hide();
	$('#invalid').text(msg);
	$('#invalid').show();
	$("#submit").attr('disabled','disabled');
}

function validateEmail($email) {
  var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
  if( !emailReg.test( $email ) ) {
    return false;
  } else {
    return true;
  }
}

function check() {
	var user_public_key = $('#user_public_key').val();
	if (user_public_key !== "" && user_public_key.indexOf("BEGIN PGP PUBLIC KEY BLOCK") !== -1 && user_public_key.indexOf("END PGP PUBLIC KEY BLOCK") !== -1) {
		// validate public key
		try {
			publicKeys = openpgp.key.readArmored(user_public_key);
			var publicEmails = ""
			for (var k=0; k < publicKeys.keys.length; k++) {				
				for (var u=0; u < publicKeys.keys[k].users.length; u++) {					
					publicEmails += publicKeys.keys[k].users[u].userId.userid;
				}
			}
			var email = $('#user_email').val();
			if (email !== "" && validateEmail($('#user_email').val()) && publicEmails.indexOf(email) !== -1) {
				valid("Public key is valid.");
			} else {
				invalid("Email does not belong to the public key. Try again!");
			}
		}
		catch(err) {
			invalid("Sorry the public key is invalid. Try again!");
		}	
	}	
}

$(function(){
	$("#submin").prop('disabled', false);
	if (window.crypto && window.crypto.getRandomValues) {
		$('#user_public_key').bind('input propertychange', function() {
			check();
		});
		$('#user_email').bind('input propertychange', function() {
			check();
		});
	} else {
		$('.marker_browser').show();
		$('#send').hide();
	}
});
