(function ($) {
  var ready = $.fn.ready;
  $.fn.ready = function (fn) {
    if (this.context === undefined) {
      // The $().ready(fn) case.
      ready(fn);
    } else if (this.selector) {
      ready($.proxy(function(){
        $(this.selector, this.context).each(fn);
      }, this));
    } else {
      ready($.proxy(function(){
        $(this).each(fn);
      }, this));
    }
  }
})(jQuery);

jQuery.externalScript = function(url, options) {
  options = $.extend(options || {}, {
    dataType: "script",
    cache: true,
    url: url
  });
  return jQuery.ajax(options);
};

function valid(msg) {
	$('#invalid').hide();
	$('#valid').text(msg);
	$('#valid').show();
	$("#submit_button").removeAttr('disabled');
}

function invalid(msg) {
	$('#valid').hide();
	$('#invalid').text(msg);
	$('#invalid').show();
	$("#submit_button").attr('disabled','disabled');
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
        $("#submit").prop('disabled', false);
			} else {
				invalid("Email does not belong to the public key. Try again!");
        $("#submit").prop('disabled', true);
			}
		}
		catch(err) {
			invalid("Sorry the public key is invalid. Try again!");
      $("#submit").prop('disabled', true);
		}	
	}	
}

$(function(){
  var cryptoObj = window.crypto || window.msCrypto; // for IE 11
  if (window.msCrypto) {
      window.crypto = window.msCrypto;
  }
	if (cryptoObj && cryptoObj.getRandomValues) {
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
	$('#user_username').bind('input propertychange', function() {
		$('.check_username').text(this.value);
	});
	
	
  $.externalScript('https://js.stripe.com/v1/').done(function(script, textStatus) {
      Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
      var subscription = {
        setupForm: function() {
          return $('.card_form').submit(function() {
            //$('input[type=submit]').prop('disabled', true);
            if ($('#card_number').length) {
              subscription.processCard();
              return false;
            } else {
              return true;
            }
          });
        },
        processCard: function() {
          var card;
          card = {
            name: $('#user_name').val(),
            number: $('#card_number').val(),
            cvc: $('#card_code').val(),
            expMonth: $('#card_month').val(),
            expYear: $('#card_year').val()
          };
          return Stripe.createToken(card, subscription.handleStripeResponse);
        },
        handleStripeResponse: function(status, response) {
          if (status === 200) {
            $('#user_stripe_token').val(response.id);
						$('.card_form')[0].submit()
          } else {
            $('#stripe_error').text(response.error.message).show();
            return $('input[type=submit]').prop('disabled', false);
          }
        }
      };
      return subscription.setupForm();
  });
});
