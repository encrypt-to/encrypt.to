$(function(){
   $("#message_body").focus();
   $.validate({
     form : '#new_message',
    onValidate : function() {       	
		var message_body_input = $('#message_body_input').val();
		$("#message_body_input").attr("disabled", "disabled");
		if (message_body_input.indexOf("-----BEGIN PGP MESSAGE-----") !== -1 && message_body_input.indexOf("-----END PGP MESSAGE-----") !== -1) {
			// encryption done
		} else {
			// let's encrypt
			openpgp.init();
       		var publicKeys = openpgp.read_publicKey($('#pubkey').text());
     
       		var message = document.getElementById("message_body_input");
			
       		var plaintext = message.value;
       		var ciphertext = openpgp.write_encrypted_message(publicKeys,plaintext);

       		message.value = ciphertext;	
			var message_body = document.getElementById("message_body");
			message_body.value = ciphertext;
		
		}
    },
	onSuccess : function() {
		var message_body_input = $('#message_body_input').val();
		$("#message_body_input").attr("disabled", "disabled");
		if (message_body_input.indexOf("-----BEGIN PGP MESSAGE-----") !== -1 && message_body_input.indexOf("-----END PGP MESSAGE-----") !== -1) {
			// encryption done
		} else {
			// let's encrypt
			openpgp.init();
       		var publicKeys = openpgp.read_publicKey($('#pubkey').text());
     
       		var message = document.getElementById("message_body_input");
			
       		var plaintext = message.value;
       		var ciphertext = openpgp.write_encrypted_message(publicKeys,plaintext);

       		message.value = ciphertext;	
			var message_body = document.getElementById("message_body");
			message_body.value = ciphertext;
		
		}
     },
   });

});