BucketList  = require("bucket-list")
urlencode   = require("urlencode")
express     = require("express")
cors        = require("cors")
minimatch   = require("minimatch")

app = express()
app.use app.router

app.get "/", cors(), (req, res) ->
  res.jsonp(400, {error: "Specify a bucket as the base path, e.g. /my-bucket"})

app.get "/:bucket", cors(), (req, res) ->

  bucket = BucketList.connect
    key: req.query.key || process.env.AWS_ACCESS_KEY
    secret: req.query.secret || process.env.AWS_SECRET_KEY
    bucket: req.params.bucket

  # bucketStream = bucket("folder_name")
  # bucketStream.on "data", (fileNameWithPath) ->
  #   console.log fileNameWithPath

  bucket "", (err, files) ->
    return res.jsonp(400, {error: err}) if err
    out = []
    for file in files

      # Skip files that don't match the given pattern
      continue if req.query.pattern && !minimatch(file, req.query.pattern)

      out.push
        filename: file
        filenameEncoded: urlencode(file)
        url: "https://#{req.params.bucket}.s3.amazonaws.com/#{urlencode(file)}"

    res.jsonp(out)

module.exports = app



