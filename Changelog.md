# Head

## Features

* Show link to public key
* [Security Audit Tool](http://encrypt-to.github.io/)

## Bug fixes

* Default use newest key [#18](https://github.com/encrypt-to/encrypt.to/issues/18)

## Refactor

* Added test specs and travic ci
* Checking for prng support [#17](https://github.com/encrypt-to/encrypt.to/issues/17)
* Disable asset pipeline to audit js files [#25](https://github.com/encrypt-to/encrypt.to/issues/25)

# 0.2.0

Dec 23, 2013

## Features

* User registration for non-public key server
* Sign in and upload public key
* Advanced mode [#5](https://github.com/encrypt-to/encrypt.to/issues/5) [#6](https://github.com/encrypt-to/encrypt.to/issues/6)
* Spam protection, max. 2 messages in 5 minutes [#12](https://github.com/encrypt-to/encrypt.to/issues/12)

## Bug fixes

* Avoid possible command injection [#3](https://github.com/encrypt-to/encrypt.to/issues/3) 
* Better handling when JS is disabled [#1](https://github.com/encrypt-to/encrypt.to/issues/1)
* Check if body is encrypted [#10](https://github.com/encrypt-to/encrypt.to/issues/10)
* Support key-id with email selector [#7](https://github.com/encrypt-to/encrypt.to/issues/17)

# 0.1.0

Dec 09, 2013

## Features

* Initial version of Encrypt.to
* Send encrypted PGP messages to users with JS client side encryption
* Load keys from public sks key server https://sks-keyservers.net/
