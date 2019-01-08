import Vapor
import MongoSwift

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    /// Endpoints
    // info
    router.get { req in
        return "this is the purine-guradin api"
    }
    
    // create
    router.post("/purine/dailysummary/") { req -> HTTPStatus in
        let client = try! req.make(MongoClient.self)
        insertNewItem(client: client)
        return HTTPStatus.ok
    }
    // update
    router.put(FoodStuff.self, at: "/purine/dailysummary/") { req, payloadFoodStuff -> HTTPStatus in
        let client = try! req.make(MongoClient.self)
        addFoodStuff(client: client, amount: payloadFoodStuff.amount!, description: payloadFoodStuff.description!)
        return HTTPStatus.ok
    }
    
    // delete
    router.delete("/purine/dailysummary/", Int.parameter) { req -> HTTPResponse in
        let index = try req.parameters.next(Int.self)
        let client = try! req.make(MongoClient.self)
        removeFoodstuffAtIndex(client: client, index: index)
        return HTTPResponse(status: .ok, body: "delete item for index \(index)")
    }
    
    // read
    router.get("/purine/dailysummary/") { req -> [DailySummary] in
        let client = try! req.make(MongoClient.self)
        return getCurrentDialySummary(client: client)
    }
    
    /// DailySummaery Model Interaction
    /*
     this has to be moved in a Daily Summary Controller
     */
    
    func insertNewItem(client: MongoClient ){
        
        // manage the date
        let dayOnly = DateFormatterController().currentDayInSeconds()
        
        // create a daily sum item
        let dailySum = DailySummary(listOfFoodStuff: [], timestamp: dayOnly.timeIntervalSince1970 )
        
        let collection = try! client.db("myDB").collection("myCollection", withType: DailySummary.self)
               
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
    
    func addFoodStuff(client :MongoClient, amount:Int, description : String){
        var dailyItem = getObjectFromDb(client: client)
        dailyItem.listOfFoodStuff.append(FoodStuff(amount: amount, description: description))
        print("this meal was add \(dailyItem.listOfFoodStuff.debugDescription)")
        updateObjectInDb(collectionObject: dailyItem, client: client)
    }
    
    func removeFoodstuffAtIndex(client :MongoClient, index:Int){
        var dailyItem = getObjectFromDb(client: client)
        print("this meal was removed \(dailyItem.listOfFoodStuff[index])")
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
    
    /// Mongo actions
    /*
     this has to be moved in a DataStore Controller
     */
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
