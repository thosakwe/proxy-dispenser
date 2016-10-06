var privateKey = process.argv[2];
var queryString = process.argv[3];
var crypto = require('crypto');
var hash = crypto.createHmac('sha512', privateKey);
hash.update(queryString);
var value = hash.digest('hex');
console.log(value);
process.exit(0);