BucketList  = require("bucket-list")
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
    for filename in files

      # Skip files that don't match the given pattern
      continue if req.query.pattern && !minimatch(filename, req.query.pattern)

      # url encode everything but slashes
      filenameEncoded = encodeURIComponent(filename).replace("%2F", "/")

      out.push
        url: "http://#{req.params.bucket}.s3.amazonaws.com/#{filenameEncoded}"
        vanityUrl: "http://#{req.params.bucket}/#{filenameEncoded}"

    res.jsonp(out)

module.exports = app



