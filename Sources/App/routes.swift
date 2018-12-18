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
        mongodb_example()
        print("hello")
        return "Hello, world!"
    }


    func mongodb_example(){
        // initialize global state
        MongoSwift.initialize()
        
        let client = try! MongoClient(connectionString: "mongodb://localhost:27017")
        let db = try! client.db("myDB")
        let collection = try! db.createCollection("myCollection")
        
        // free all resources
        MongoSwift.cleanup()
        
        let doc: Document = ["_id": 100, "a": 1, "b": 2, "c": 3]
        let result = try! collection.insertOne(doc)
        print(result?.insertedId ?? "") // prints `100`
    }
}
