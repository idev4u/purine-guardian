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
    let collection = try! db.createCollection("myCollection")
    services.register(collection)
    

}
// make mongo collection service ready
extension MongoCollection: Service {
}
