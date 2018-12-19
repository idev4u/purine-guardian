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
        let client = try! req.make(MongoClient.self)
        mongodb_example(client: client)
        print("hello")
        return "Hello, world!"
    }


    func mongodb_example(client: MongoClient ){
        let doc2: FoodStuff = FoodStuff(amount: 20, description: "banane")
//        let collection = try collection("myCollection", withType: FoodStuff.self)
        let collection = try! client.db("myDB").collection("myCollection", withType: FoodStuff.self)
//        let doc: Document = ["_id": 100, "a": 1, "b": 2, "c": 3]
        let result = try! collection.insertOne(doc2)
        print(result?.insertedId ?? "") // prints `100`
    }
}
