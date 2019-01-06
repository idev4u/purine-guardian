import Vapor
import MongoSwift

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.post("/purine/dailysummary/") { req -> HTTPStatus in
        let client = try! req.make(MongoClient.self)
        insertNewItem(client: client)
        return HTTPStatus.ok
    }
    
    router.put(FoodStuff.self, at: "/purine/dailysummary/") { req, payloadFoodStuff -> HTTPStatus in
        let client = try! req.make(MongoClient.self)
        
        print("\(payloadFoodStuff)")
        addFoodStuff(client: client, amount: payloadFoodStuff.amount!, description: payloadFoodStuff.description!)
        return HTTPStatus.ok
    }
    
    router.delete("/purine/dailysummary/", Int.parameter) { req -> HTTPResponse in
        let index = try req.parameters.next(Int.self)
        let client = try! req.make(MongoClient.self)
        removeFoodstuffAtIndex(client: client, index: index)
//        return "delte item for index \(index)"
        
        return HTTPResponse(status: .ok, body: "delte item for index \(index)")
    }
    
    router.get("/purine/dailysummary/") { req -> String in
         let client = try! req.make(MongoClient.self)
       
        return  "\(getCurrentDialySummary(client: client))"
    }
    


    func insertNewItem(client: MongoClient ){
        // create a foodstuff item
//        let fs: FoodStuff = FoodStuff(amount: 20, description: "banane")
        
        // manage the date
        let dayOnly = DateFormatterController().currentDayInSeconds()

        // create a daily sum item
        let dailySum = DailySummary(listOfFoodStuff: [], timestamp: dayOnly.timeIntervalSince1970 )
        
        
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
        
//        let query: Document = ["timestamp": dayOnly.timeIntervalSince1970]
//        print("how many are exist? \(try! collection.count(query))")
    }
    
    
    // DailySummaery Interaction
    func addFoodStuff(client :MongoClient, amount:Int, description : String){
        var dailyItem = getObjectFromDb(client: client)
        dailyItem.listOfFoodStuff.append(FoodStuff(amount: amount, description: description))
        updateObjectInDb(collectionObject: dailyItem, client: client)
        
    }
    
    func removeFoodstuffAtIndex(client :MongoClient, index:Int){
        var dailyItem = getObjectFromDb(client: client)
        dailyItem.listOfFoodStuff.remove(at: index)
        updateObjectInDb(collectionObject: dailyItem, client: client)
    }
    
    func getCurrentDialySummary(client :MongoClient) -> [DailySummary] {
        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
        let documents = try! collection.find(["timestamp": DateFormatterController().currentDayInSeconds().timeIntervalSince1970])
        var listOfDailySummary = [DailySummary]()
        for d in documents {
            print(d)
            listOfDailySummary.append(d)
        }
        return listOfDailySummary
    }
    
    //Mongo actions
    func updateObjectInDb(collectionObject :DailySummary, client: MongoClient) {
        let query: Document = ["timestamp": DateFormatterController().currentDayInSeconds().timeIntervalSince1970]
        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
        try! collection.findOneAndReplace(filter: query, replacement: collectionObject)
        
    }
    
    func getObjectFromDb(client: MongoClient) ->DailySummary {
        let query: Document = ["timestamp": DateFormatterController().currentDayInSeconds().timeIntervalSince1970]
        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
        let documents = try! collection.find(query)
        //      Get the first element from the iterator documents
        return documents.next()!
    }
}
