# purine

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