function encrypt() {
	var message_body_input = $('#message_body_input').val();
	$("#message_body_input").attr("disabled", "disabled");
	if (message_body_input.indexOf("-----BEGIN PGP MESSAGE-----") !== -1 && message_body_input.indexOf("-----END PGP MESSAGE-----") !== -1) {
		// validate form
	} else {
		// let's encrypt
		openpgp.init();
   		var publicKeys = openpgp.read_publicKey($('#pubkey').text());
		for (var i = 0; i < publicKeys.length; i++) {
			$('#check-pubkey').text(publicKeys[i].toString());
		}				
   		var message = document.getElementById("message_body_input");
		
   		var plaintext = message.value;
   		var ciphertext = openpgp.write_encrypted_message(publicKeys,plaintext);
		var result = openpgp.read_message(ciphertext);
		for (var i = 0; i < result.length; i++) {
			$('#check-message').text(result[i].toString());
		}	
   		message.value = ciphertext;	
		var message_body = document.getElementById("message_body");
		message_body.value = ciphertext;
	
	}
}

$(function(){
	// focus body on load
   $("#message_body").focus();
   
	if (window.crypto.getRandomValues) {
	    // ready
		 } else {
	    //alert("Error: Browser not supported\nReason: We need a cryptographically secure PRNG to be implemented (i.e. the window.crypto method)\nSolution: Use Chrome >= 11, Safari >= 3.1 or Firefox >= 21");   
	  	$('.marker_browser').show();
			$('#send').hide();
		}

   // advanced mode
   $('#advanced').change(function(){
       if($(this).is(':checked')){
       		$('#pubkey').show();
		   		$('#check-pubkey').show();
		   		$('#check-message').show();
		   		$('.hidden').show();
		   		$('#send').hide();
          $('#encrypt').show();		   
       } else {
          $('#pubkey').hide();
		   		$('#check-pubkey').hide();
		   		$('#check-message').hide();
		   		$('.hidden').hide();
		   		$('#send').show();
          $('#encrypt').hide();
       }
   });


   $('#encrypt').on("click",function(e){
	   encrypt();
	   $('#send').show();
       $('#encrypt').hide();
   });

   // validate form on submit
   $.validate({
	   validateOnBlur : false, // disable validation when input looses focus
	   errorMessagePosition : 'top', // Instead of 'element' which is default
	   scrollToTopOnError : false, // Set this property to true if you have a long form
	   form : '#new_message',
    	onValidate : function() {       	
			encrypt();
    	},
		onSuccess : function() {
			encrypt();
     	},
   	});
});