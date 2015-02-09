function encrypt() {
	return {
		then: function(callback) {
			var message_body_input = $('#message_body_input').val();
			$("#message_body_input").attr("disabled", "disabled");
			if (message_body_input.indexOf("-----BEGIN PGP MESSAGE-----") !== -1 && message_body_input.indexOf("-----END PGP MESSAGE-----") !== -1) {
				callback(true);	
			} else {
				// encrypt message
				publicKeys = openpgp.key.readArmored($('#pubkey').text()).keys[0];
				var validatePublicKeys = JSON.stringify(publicKeys).replace(/,/g,'\n');
				$('#check-pubkey').text(validatePublicKeys);
				var message = document.getElementById("message_body_input");
				var plaintext = message.value;
				openpgp.encryptMessage([publicKeys],plaintext).then(function(ciphertext) {
					var result = openpgp.message.readArmored(ciphertext);
					var validateMessage = JSON.stringify(result).replace(/,/g,'\n');
					$('#check-message').text(validateMessage);
					message.value = ciphertext;	
					var message_body = document.getElementById("message_body");
					message_body.value = ciphertext;
					callback(true);	
				});
			}	
		}
	};
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
		message_file.value = window.btoa(armored);
		var message_filename = document.getElementById("message_filename");
		message_filename.value = file.name + ".gpg"
		$("#encrypting").text(file.name + ".gpg encrypted.");
		$('#remove').show();
	}
	reader.readAsBinaryString(file);
	
}

function fingerprint(key) {
	var fpr = key.primaryKey.getFingerprint().toUpperCase();
	return "Fingerprint: " + fpr.slice(0, 4) + ' ' + fpr.slice(4, 8) + ' ' + fpr.slice(8, 12) + ' ' + fpr.slice(12, 16) + ' ' + fpr.slice(16, 20) + ' ' + fpr.slice(20, 24) + ' ' + fpr.slice(24, 28) + ' ' + fpr.slice(28, 32) + ' ' + fpr.slice(32, 36) + ' ' + fpr.slice(36);
}

function validateEmail($email) {
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
	if (!emailReg.test($email)) {
		return false;
	} else {
		return true;
	}
}

$(function(){
	
	// prevent form submit by enter
	$('input,select').bind("keypress", function (e) {
		if (e.keyCode == 13) {
			return false;
		}
	});
	
	// init openpgp worker
	openpgp.initWorker('/assets/openpgp.worker.min.js');
	
	// focus body on load
	$("#message_body_input").focus();
	 
	// show fingerprint
	var fp = fingerprint(openpgp.key.readArmored($('#pubkey').text()).keys[0]);
	$("#fingerprint").text(fp);
   
	if (window.crypto && window.crypto.getRandomValues) {
		// ready
	} else {
		$('.marker_browser').show();
		$('#send').hide();
	}

	// advanced mode
	$('#advanced').change(function(){
		if($(this).is(':checked')){
			$('#change-pubkey').show();
			$('#pubkey').show();
			$('#check-pubkey').show();
			$('#check-message').show();
			$('.hidden').show();
			$('#send').hide();
			$('#encrypt').show();		   
		} else {
			$('#change-pubkey').hide();
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
	 
	// change key
	$('#message_keyid').on('change', function() {
		window.location.href = "/" + this.value;
	});
	 
	$('#encrypt').on("click",function(e){ 
		encrypt().then(function(done) {
			$('#send').text('Send');
			$('#send').show();
			$('#encrypt').hide();
		});
	});
	 
	$('#send').on("click",function(e){
		encrypt().then(function(done) {
			if (done) {
				var email = $('#message_from').val();
				// validate email
				if (email !== "" && validateEmail(email)) {
					$('#send').text($('#sending').val());
					$('#encrypt').text($('#sending').val());
					$('#new_message').submit();
				} else {
					alert($('#valid_mail').val());
					$('#send').text('Send');
				}
			} 
		});
	});
});