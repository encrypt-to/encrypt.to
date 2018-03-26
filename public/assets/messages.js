function encrypt() {
	return {
		then: function(callback) {
			var message_body_input = $('#message_body_input').val();
			$("#message_body_input").attr("disabled", "disabled");
			if (message_body_input.indexOf("-----BEGIN PGP MESSAGE-----") !== -1 && message_body_input.indexOf("-----END PGP MESSAGE-----") !== -1) {
				callback(true);	
			} else {
				// encrypt message
        var keystatus = {0:"invalid", 1:"expired", 2:"revoked", 3:"valid", 4:"no_self_cert"};
        var pubkey = $('#pubkey').text();
        var readArmored = openpgp.key.readArmored(pubkey);
        var verifyPrimaryKey = readArmored.keys[0].verifyPrimaryKey();
        verifyPrimaryKey.then(function(value) {
          if (value != 3) {
            alert("Sorry, the primary key is " + keystatus[verifyPrimaryKey]);
          }
        });
        var verifySubKey = readArmored.keys[0].subKeys[0].verify(readArmored.keys[0].primaryKey);
        verifySubKey.then(function(value) {
          if (value != 3) {
            alert("Sorry, the primary key is " + keystatus[verifySubKey]);
          }
        });
        var validatePublicKeys = JSON.stringify(readArmored.keys[0]).replace(/,/g,'\n');
        $('#check-pubkey').text(validatePublicKeys);
				var message = document.getElementById("message_body_input");
        var options = {
          data: message.value,
          publicKeys: readArmored.keys
        };
        openpgp.encrypt(options).then(function(ciphertext) {
        	var result = openpgp.message.readArmored(ciphertext.data);
        	var validateMessage = JSON.stringify(result).replace(/,/g,'\n');
					$('#check-message').text(validateMessage);
					message.value = ciphertext.data;	
					var message_body = document.getElementById("message_body");
					message_body.value = ciphertext.data;
					callback(true);
				});
			}	
		}
	};
}

function file() {	
	// encrypt file		
	var file = $("#message_file_input").get(0).files[0];
	
	if (file.size > 26214400) {
		alert("Sorry file size > 25 MB!");
		$("#message_file_input").val("");
		return
	}
	
	$("#message_file_input").hide();
	$("#encrypting").text("Encrypting...");
	$("#encrypting").show();
	
  var reader = new FileReader();
	reader.onload = function(e) {
    bytes = new Uint8Array(e.target.result);
		publicKeys = openpgp.key.readArmored($('#pubkey').text()).keys;
    var options = {
        data: bytes,
        publicKeys: publicKeys,
        filename: file.name
    };
    openpgp.encrypt(options).then(function(ciphertext) {
    		var message_file = document.getElementById("message_file");
    		message_file.value = window.btoa(ciphertext.data);
    		var message_filename = document.getElementById("message_filename");
    		message_filename.value = file.name + ".gpg"
    		$("#encrypting").text(file.name + ".gpg encrypted.");
        $('#remove').show();
    });

	}
	reader.readAsArrayBuffer(file);
  
}

function fingerprint(key) {
	var fpr = key.primaryKey.getFingerprint().toUpperCase();
	return "Fingerprint: " + fpr.slice(0, 4) + ' ' + fpr.slice(4, 8) + ' ' + fpr.slice(8, 12) + ' ' + fpr.slice(12, 16) + ' ' + fpr.slice(16, 20) + ' ' + fpr.slice(20, 24) + ' ' + fpr.slice(24, 28) + ' ' + fpr.slice(28, 32) + ' ' + fpr.slice(32, 36) + ' ' + fpr.slice(36);
}

function validateEmail($email) {
	var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,8})?$/;
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
  var unixTS = Math.round(+new Date()/1000);
  var workerPath = "/assets/openpgp.worker_v303.min.js?" + unixTS;
	openpgp.initWorker({path: workerPath});
	
	// focus body on load
	$("#message_body_input").focus();
	 
	// show fingerprint
	var fp = fingerprint(openpgp.key.readArmored($('#pubkey').text()).keys[0]);
	$("#fingerprint").text(fp);
  
  var cryptoObj = window.crypto || window.msCrypto; // for IE 11
  if (window.msCrypto) {
      window.crypto = window.msCrypto;
  }
	if (cryptoObj && cryptoObj.getRandomValues) {
		// ready
	} else {
		$('.marker_browser').show();
		$('#send').hide();
	}

	// advanced mode
	$('#advanced').change(function(){
		if($(this).is(':checked')){
			$('#advanced_mode').show();
			$('#send').hide();
			$('#encrypt').show();		   
		} else {
			$('#advanced_mode').hide();
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
			$('#send').text($('#send_button').val());
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