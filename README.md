# purine-guardian

## getting started

```
git clone git@github.com:idev4u/purine-guardian.git
cd purine-guardian
```

## pre
install mongodb
https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/

```sh
brew install mongodb@3.6
```

start local mongodb
```sh
cd .. && mkdir -p purine-guardian-db
mongod --dbpath ../purine-guardian-db/
```

verify local mongodb
```
mongo --host 127.0.0.1:27017
```

and the mongo driver for swift
```
brew install mongo-c-driver
```

install vapor

```
brew install vapor/tap/vapor
```

## hands on

```
vapor xcode
```

## run the app local

start
```sh
mongod --dbpath ../purine-guardian-db/
vapor build
vapor run
Running purine-guardian ...
Running default command: .build/debug/Run serve
Server starting on http://localhost:8080
```

## API

This section describes how the api for the purine-gardian works.

### create
first step create a daily resource!
```sh
$curl http://localhost:8080/purine/dailysummary -X POST -iv
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> POST /purine/dailysummary HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
HTTP/1.1 200 OK
< content-length: 0
content-length: 0
< date: Sun, 06 Jan 2019 12:02:13 GMT
date: Sun, 06 Jan 2019 12:02:13 GMT
< Connection: keep-alive
Connection: keep-alive

<
* Connection #0 to host localhost left intact
```

### update

If the a daily resource exist, it is possible to add the all the food user has eaten for the day.
```sh
$curl http://localhost:8080/purine/dailysummary/ -X PUT -H 'Content-Type: application/json' -d '{ "amount": 25,"description":"testapples" }' -iv
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> PUT /purine/dailysummary/ HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.54.0
> Accept: */*
> Content-Type: application/json
> Content-Length: 43
>
* upload completely sent off: 43 out of 43 bytes
< HTTP/1.1 200 OK
HTTP/1.1 200 OK
< content-length: 0
content-length: 0
< date: Sun, 06 Jan 2019 12:14:14 GMT
date: Sun, 06 Jan 2019 12:14:14 GMT
< Connection: keep-alive
Connection: keep-alive

<
* Connection #0 to host localhost left intact
```
### read

This provides the current status of the food the user has eaten.
```sh
$curl http://localhost:8080/purine/dailysummary/ -s | jq
```
```json
[
  {
    "listOfFoodStuff": [
      {
        "amount": 25,
        "description": "testapples"
      },
      {
        "amount": 25,
        "description": "testapples"
      },
      {
        "amount": 25,
        "description": "testapples"
      },
      {
        "amount": 25,
        "description": "testapples"
      }
    ],
    "timestamp": 1546729200
  }
]
```
### delete

This delte a meal entry from the daily summary.
```sh
$ curl http://localhost:8080/purine/dailysummary/0 -X DELETE
delete item for index 0
```
