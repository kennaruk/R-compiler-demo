var express = require('express');
var router = express.Router();
const bodyParser = require('body-parser');
const { spawn } = require("child_process");
const fs = require('fs');

router.use(bodyParser.json());

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index.ejs', { title: 'Express' });
});

router.post('/rCompile', (req, res, next) => {
  const rScript = req.body.rScript;
  const filePath = `/tmp/${new Date().toISOString()}.R`;
  let outData = '';

  fs.writeFile(filePath, rScript, (err) => {
    if(err) {
      console.log('err:', err);
      res.json({
        err: err
      });
    }

    const rexecute = spawn("Rscript", [
      filePath
    ]);

    rexecute.stdout.on("data", data => {
      console.log(`stdout: ${data}`);
      var str =  data.toString('utf8')
      outData += str;
    });
  
    rexecute.stderr.on("data", data => {
      console.log(`stderr: ${data}`);
      var str =  data.toString('utf8')
      outData = str;
    });
  
    rexecute.on("close", code => {
      res.json({
        err: false,
        data: outData
      });
      console.log(`child process exited with code ${code}`);
    });

  });

});
module.exports = router;
