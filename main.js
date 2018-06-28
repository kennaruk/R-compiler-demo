var AWS = require('aws-sdk');
const s3 = new AWS.S3({apiVersion: '2006-03-01'});
const conv = require('binstring');

var params = {
    Body: conv('hello', {in: 'binary'}), 
    Bucket: "r-compiler", 
    Key: new Date().toISOString()+".R"
   };
   s3.putObject(params, function(err, data) {
     if (err) console.log(err, err.stack); // an error occurred
     else     console.log(data);        
   });