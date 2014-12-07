# Next

## Features

## Bug fixes

## Refactor

# 0.4

Dec 07,2014

## Features

* Added embed link
* Added custom form layout

## Bug fixes

* Check if the key-id has an associated email address [#33](https://github.com/encrypt-to/encrypt.to/issues/33)
* Ignore revoked keys [#34](https://github.com/encrypt-to/encrypt.to/issues/34)

## Refactor

* Improve form validation

# 0.3

Aug 15,2014

## Features

* Added mysql for production
* Added message count to landing page

## Bug fixes

* Ignore expired keys [#18](https://github.com/encrypt-to/encrypt.to/issues/18)
* Api now case insensitive 

## Refactor

* Update openpgpjs to v0.7.1

# 0.2.2

Apr 04,2014

## Features

* Encrypt files upto 1 mb without web worker
* User can select a key id [#19](https://github.com/encrypt-to/encrypt.to/issues/19)

## Bug fixes

* Update to OpenPGP.js v0.5.1 including critical security fixes
* Check public key validation on sign up page [#21](https://github.com/encrypt-to/encrypt.to/issues/21)

## Refactor

* Show fingerprint instead of key id in form [#20](https://github.com/encrypt-to/encrypt.to/issues/20)

# 0.2.1

Feb 06, 2014

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
