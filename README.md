# S3 Bucket Lister

A CORS-friendly webservice for fetching S3 bucket contents as JSON(P).

## Usage

Various ways to get a file listing for bucket `loafer`:

Browser:
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