# S3 Bucket Lister

A CORS-friendly webservice for fetching S3 bucket contents as JSON(P).

## Usage

Here are a few ways to get a file listing for a bucket name "loafer":

Browser:<br>
[s3-bucket-lister.herokuapp.com/loafer](https://s3-bucket-lister.herokuapp.com/loafer)

Shell:
```sh
curl -H "Content-Type: application/json" https://s3-bucket-lister.herokuapp.com/loafer
```

jQuery:
```js
var bucket = "loafer";
$.getJSON("https://s3-bucket-lister.herokuapp.com/loafer/"+bucket, function(files) {
  console.log(files);
});
```

## AWS Credentials

If no AWS credentials are included with your request, then the app's `AWS_ACCESS_KEY` and `AWS_SECRET_KEY` environment variables are used to fulfill the request. You can override
this default by passing in your own key and secret as query parameters:

[/nether-bucket?key=AKIAJRC74QAUTBQQ5BTA&secret=yfk1aVb/s/txkA2atOJH0pmIGnEz4Pv/glqH4SUv](https://s3-bucket-lister.herokuapp.com/nether-bucket?key=AKIAJRC74QAUTBQQ5BTA&secret=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)

Amazon's [Identity and Access Management (IAM)](http://docs.aws.amazon.com/AmazonS3/latest/dev/UsingIAMPolicies.html) enables you to create multiple users within your AWS account. I recommend creating a user with *read-only* privileges to your account's buckets.

## Development Setup

To run an instance of this service for use with your own AWS account:

```sh
cp .env.sample .env # then add your S3 credentials
npm install
foreman start
```

Then open [localhost:5000/some-bucket](http://localhost:5000/some-bucket) in your browser,
where `some-bucket` is the name of a bucket on your S3 account. You should see the contents of your bucket
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

Assuming you've added your S3 credentials to `.env` per the development
instructions above, then:

```sh
heroku create my-bucket-list
git push heroku master
heroku plugins:install git://github.com/ddollar/heroku-config.git
heroku config:push -a my-bucket-list
open https://my-bucket-list.herokuapp.com/some-bucket
```

## License

MIT