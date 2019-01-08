import Vapor
import MongoSwift

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Register Mongo Client
    let client = try! MongoClient(connectionString: "mongodb://localhost:27017")
    let db = try! client.db("myDB")
    let collection:MongoCollection<Document>
    do {
        collection = try db.createCollection("myCollection")
    } catch {
        collection = try db.collection("myCollection")
    }
    // Create an unique index on timestamp
    // because I expect only one daily 
    let indexOptions = IndexOptions(name: "timestamp", unique: true)
    let model = IndexModel(keys: [ "timestamp": 1] , options: indexOptions)
    do {
        try collection.createIndex(model)
    } catch {
        print("Index already exist!")
    }
    services.register(client)
    

}
// make mongo collection service ready
extension MongoClient: Service {
}
