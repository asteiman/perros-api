import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // public routes
    let userController = UserController()
    router.post("users", use: userController.create)
    
    // Customers
    router.get("customers", use: CustomerController().index)
    router.get("customers", "mail", use: CustomerController().mail)
    router.get("customers", Int.parameter, "billings", use: CustomerController().billing)
    router.get("customers", Int.parameter, "invoices", use: CustomerController().invoice)
    
    // Invoices
    router.get("invoices", use: InvoiceController().index)
    router.get("invoices", Invoice.parameter, use: InvoiceController().single)
    
    // basic / password auth protected routes
    let basic = router.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
    basic.post("login", use: userController.login)
    
    // bearer / token auth protected routes
    let bearer = router.grouped(User.tokenAuthMiddleware())
    let todoController = TodoController()
    bearer.get("todos", use: todoController.index)
    bearer.post("todos", use: todoController.create)
    bearer.delete("todos", Todo.parameter, use: todoController.delete)
}
