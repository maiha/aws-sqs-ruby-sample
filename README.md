# aws-sqs-ruby-sample

## requirements
* docker
* make
* SQS: QUEUE_URL (This should already exist.)
* IAM: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION (access key for the queue)

## setup

```console
$ cp .env.sample .env
$ vi .env
```

Fill up `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`, `QUEUE_URL`.

## run

Run `make` first that will build docker image for ruby and sqs gem.

```console
$ make
Docker image[ruby-aws-sqs:2.7.2-1.3.4] not found. Creating...
make -C docker
docker build -t ruby-aws-sqs:2.7.2-1.3.4 .
Sending build context to Docker daemon  4.096kB
Step 1/5 : FROM ruby:2.7.2-alpine3.12
...

$ make

```

Then, try `info`, `send` and `recv`.

```console
$ make send
$ make info

$ make recv
$ make info
```
