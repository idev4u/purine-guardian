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
        let fs: FoodStuff = FoodStuff(amount: 20, description: "banane")
        print(Date().timeIntervalSince1970)
        let dailySum = DailySummary(listOfFoodStuff: [fs], timestamp: Date().timeIntervalSince1970)
//        dailySum.listOfFoodStuff[0] = fs
//        let collection = try! client.db("myDB").collection("myCollection", withType: FoodStuff.self)

        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
        let result = try! collection.insertOne(dailySum)
        print(result?.insertedId ?? "") // prints `100`
    }
}
