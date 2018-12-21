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
        // create a foodstuff item
        let fs: FoodStuff = FoodStuff(amount: 20, description: "banane")
        
        // manage the date
        let dayOnly = DateFormatterController().currentDayInSeconds()

        // create a daily sum item
        let dailySum = DailySummary(listOfFoodStuff: [fs], timestamp: dayOnly.timeIntervalSince1970 )
        
        
        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
        
        // Create an unique index on timestamp
        // because I expect only one daily summery.
        
        let indexOptions = IndexOptions(name: "timestamp", unique: true)
        let model = IndexModel(keys: [dailySum.timestamp] , options: indexOptions)
        try! collection.createIndex(model)

        // Create daily sum if it not already exist
        let result:InsertOneResult
        do {
            try result = collection.insertOne(dailySum)!
            print(result.insertedId ?? "")
        } catch let error as MongoError {
            print("mongodb error message: \(error) ")
            print("ok the item already exist! Nothing to do :-)")
        } catch {
            print("Ups something went wrong!")
        }
//        let result = try! collection.insertOne(dailySum)
//        print(result.insertedId ?? "") // prints `100`
        
        let query: Document = ["timestamp": dayOnly.timeIntervalSince1970]
        let documents = try! collection.find(query)
        for d in documents {
            print(d)
        }
    }
    
    func update(desc: String, amount: Int) -> String {
        return "not implemented yet"
    }
}
