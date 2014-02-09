function encrypt() {
	var message_body_input = $('#message_body_input').val();
	$("#message_body_input").attr("disabled", "disabled");
	if (message_body_input.indexOf("-----BEGIN PGP MESSAGE-----") !== -1 && message_body_input.indexOf("-----END PGP MESSAGE-----") !== -1) {
		// validate form
	} else {
		// encrypt message
		publicKeys = openpgp.key.readArmored($('#pubkey').text()).keys[0];
		var validatePublicKeys = JSON.stringify(publicKeys).replace(/,/g,'\n');
		$('#check-pubkey').text(validatePublicKeys);

   	var message = document.getElementById("message_body_input");
		
   	var plaintext = message.value;
   	var ciphertext = openpgp.encryptMessage([publicKeys],plaintext);
		console.log(openpgp);
		var result = openpgp.message.readArmored(ciphertext);
		var validateMessage = JSON.stringify(result).replace(/,/g,'\n');
		$('#check-message').text(validateMessage);

   	message.value = ciphertext;	
		var message_body = document.getElementById("message_body");
		message_body.value = ciphertext;
	}
}

function file() {
	
	// encrypt file		
	var file = $("#message_file_input").get(0).files[0];
	
	if (file.size > 1048576) {
		alert("Sorry file size > 1 MB!");
		$("#message_file_input").val("");
		return
	}
	
	$("#message_file_input").hide();
	$("#encrypting").text("Encrypting...");
	$("#encrypting").show();
	
  var reader = new FileReader();
  reader.onload = function(e) {
  	var msg = openpgp.message.fromBinary(e.target.result);
		publicKeys = openpgp.key.readArmored($('#pubkey').text()).keys[0];
		msg = msg.encrypt([publicKeys]);
		var armored = openpgp.armor.encode(openpgp.enums.armor.message, msg.packets.write());
		var message_file = document.getElementById("message_file");
		message_file.value = armored;
		var message_filename = document.getElementById("message_filename");
		message_filename.value = file.name + ".gpg"
		$("#encrypting").text(file.name + ".gpg encrypted.");
		$('#remove').show();
  }
  reader.readAsBinaryString(file);
	
}

$(function(){
	// focus body on load
   $("#message_body").focus();
   
	if (window.crypto && window.crypto.getRandomValues) {
	    // ready
		 } else {
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
	 
   // file input
   $('#message_file_input').on('change', function() {
			file();
   });
	 
   // remove attachment
   $('#remove').on('click', function() {
			$('#message_file_input').val("");
			$('#message_file_input').show();
			$('#message_file').val("");
			$('#message_filename').val("");
			$('#encrypting').val("");
			$('#encrypting').hide();
			$('#remove').hide();
   });
	 
   // receiver update
   $('#message_receiver').on('change', function() {
			$('#message_to').val(this.value);
   });

   $('#encrypt').on("click",function(e){
	   encrypt();
		 $('#send').text('Send');
		 $('#send').show();
		 $('#encrypt').hide();
   });

   // validate form on submit
   $.validate({
	   validateOnBlur : false,
	   errorMessagePosition : 'top',
	   scrollToTopOnError : false,
	   form : '#new_message',
    	onValidate : function() {       	
			encrypt();
    	},
		onSuccess : function() {
			encrypt();
     	},
   	});
});