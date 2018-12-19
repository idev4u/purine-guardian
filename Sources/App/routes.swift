import Vapor
import MongoSwift

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req -> String in
        let collection = try! req.make(MongoCollection<Document>.self)
        mongodb_example(collection: collection)
        print("hello")
        return "Hello, world!"
    }


    func mongodb_example(collection: MongoCollection<Document> ){
       
        let doc: Document = ["_id": 100, "a": 1, "b": 2, "c": 3]
        let result = try! collection.insertOne(doc)
        print(result?.insertedId ?? "") // prints `100`
    }
}
