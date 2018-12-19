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
        insertNewItem(client: client)
        print("hello")
        return "Hello, world!"
    }


    func insertNewItem(client: MongoClient ){
        let fs: FoodStuff = FoodStuff(amount: 20, description: "banane")
        print(Date().timeIntervalSince1970)
        let dailySum = DailySummary(listOfFoodStuff: [fs], timestamp: Date().timeIntervalSince1970)
        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
        let result = try! collection.insertOne(dailySum)
        print(result?.insertedId ?? "") // prints `100`
        
        let query: Document = ["timestamp": 1545229259.108623]
        let documents = try! collection.find(query)
        for d in documents {
            print(d)
        }
    }
    
    func update(desc: String, amount: Int) -> String {
        return "not implemented yet"
    }
}
