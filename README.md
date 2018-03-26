# Encrypt.to

Send encrypted PGP messages via https://encrypt.to/

[![Build Status](https://secure.travis-ci.org/encrypt-to/encrypt.to.png)](https://travis-ci.org/encrypt-to/encrypt.to)

### How does it work?

When your public key is added to a public keyserver open the link: `https://encrypt.to/{your-email}` or `https://encrypt.to/{your-key-id}`.

### Security audit tool

Start the [code audit now](http://encrypt-to.github.io "code audit now") with the [Security audit tool](https://github.com/encrypt-to/encrypt-to.github.io "Security audit tool").

### Updates

Read [Diaspora](https://diasp.eu/u/info "Status") or [Twitter](https://twitter.com/encrypt_to "Status") for updates.

### Browser Compatibility

	* Desktop: Chrome >= 37, Firefox >= 34, Opera >= 24, Safari >= 7.1
	* Mobile: Chrome >= 64, Android >= 62, Opera >= 37, Safari >= iOS 8

### I don't like Ruby

The secure contact form is available for [PHP](https://github.com/encrypt-to/secure.contactform.php "PHP") and [Perl](https://github.com/encrypt-to/secure.contactform.perl "Perl").

### Ready for Heroku

Easily deployable on Heroku [https://github.com/encrypt-to/secure.contactform.ruby](https://github.com/encrypt-to/secure.contactform.ruby).

### Changelog

[Changelog](https://github.com/encrypt-to/encrypt.to/blob/master/Changelog.md "Changelog")


### I don't have a public/private keypair

Everyone can and should have a public and private key. There are many free tools for key management like [GPGTools](https://gpgtools.org/ "GPGTools") for Mac, [Seahorse](https://projects.gnome.org/seahorse/index.html "Seahorse") for Linux or [Gpg4win](http://www.gpg4win.org/ "Gpg4win") for Windows.

### My public key is stored on a public key server

No signup needed!

	Open the link: https://encrypt.to/{your-email} or https://encrypt.to/{your-key-id}

### My public key should be private!

You can use our private key server by uploading your public key on [Encrypt.to](https://encrypt.to/users/sign_up "Encrypt.to").

#### How to export your public key

##### GPGTools

Select the key you want to export by clicking on the corresponding key on your list, and then clicking the right mouse button and on [Export] in the popup menu. Choose a file to export your key to, e.g. my-key.asc. 

##### Seahorse

Open the "My personal keys" tab and select the key you want to export by clicking on the corresponding key on your list, and then clicking on the [Export] of the main menu. Choose a file to export your key to, e.g. my-key.asc. A popup window will let you know whether the operation was successful.

##### Gpg4win

Select the key you want to export by clicking on the corresponding key on your list, and then clicking on the [Export] icon of the main GPA menu. Choose a file to export your key to, e.g. my-key.asc. A popup window will let you know whether the operation was successful. Then click on [OK].

##### Command line

	gpg -a --output my-key.asc --export {your-key-id}

#### How to import your public key at Encrypt.to

Open the file e.g. my-key.asc with a text editor, which will show your public key as a series of blocks containing text and numbers.

Highlight the whole key portion from

	-----BEGIN PGP PUBLIC KEY BLOCK-----
	to
	-----END PGP PUBLIC KEY BLOCK-----

and copy it using the copy function on your toolbar or a keyboard shortcut such as CMD+C or Ctrl+C. This saves your key on the clipboard until you are ready to paste it, as described next.

Open [Encrypt.to](https://encrypt.to/users/sign_up "Encrypt.to") in your browser and paste your public key into the input field such as CMD+V or Ctrl+V. Fill the form and click on "Create an account".

### MIT License

[LICENSE](https://github.com/encrypt-to/encrypt.to/blob/master/LICENSE "LICENSE")
