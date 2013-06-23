# CORS Bucket List

CORS Bucket List is a little node.js webservice for fetching S3 bucket contents as JSON.

## Development Setup

To run an instance of this service for use with your own AWS account:

    cp .env.sample .env # then add your S3 credentials
    npm install
    foreman start

Then open [localhost:5000/some-bucket](http://localhost:5000/some-bucket) in your browser,
were `some-bucket` is the name of a bucket on your S3 account. You should see the contents of your bucket
in a format like this:

```json
[
  {
    "filename": "app.json",
    "encodedFilename": "app.json",
    "url": "http://loafer.s3.amazonaws.com/app.json"
  },{
    "filename": "index.html",
    "encodedFilename": "index.html",
    "url": "http://loafer.s3.amazonaws.com/index.html"
  }
]
```

## Deploying to Heroku

Assuming you've got a `.env` file set up to run locally:

    heroku create my-bucket-list
    git push heroku master
    heroku plugins:install git://github.com/ddollar/heroku-config.git
    heroku config:push -a my-bucket-list