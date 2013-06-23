amazonS3  = require("awssum-amazon-s3")
urlencode = require("urlencode")
express   = require("express")
cors      = require("cors")

s3 = new amazonS3.S3
  accessKeyId: process.env.AWS_ACCESS_KEY
  secretAccessKey: process.env.AWS_SECRET_KEY
  region: amazonS3.US_EAST_1

app = express()
app.use express.bodyParser()
app.use app.router

app.get "/:bucket", cors(), (req, res) ->
  s3.ListObjects {BucketName: req.params.bucket}, (err, data) ->
    return res.jsonp(400, {error: err}) if err
    out = []
    for file in data.Body.ListBucketResult.Contents
      out.push
        filename: file.Key
        encodedFilename: urlencode(file.Key)
        url: "http://#{req.params.bucket}.s3.amazonaws.com/#{urlencode(file.Key)}"

    res.jsonp(out)

module.exports = app