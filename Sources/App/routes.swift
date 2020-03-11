import Crypto
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // public routes
    let userController = UserController()
    
    // basic / password auth protected routes
    let basic = router.grouped(User.basicAuthMiddleware(using: BCryptDigest()))
    basic.post("login", use: userController.login)
    
    // bearer / token auth protected routes
    let bearer = router.grouped(User.tokenAuthMiddleware(), User.guardAuthMiddleware())
    
    // Customers
    bearer.get("customers", use: CustomerController().index)
    bearer.get("customers", "mail", use: CustomerController().mail)
    bearer.get("customers", Int.parameter, "billings", use: CustomerController().billing)
    bearer.get("customers", Int.parameter, "invoices", use: CustomerController().invoice)
    
    // Invoices
    bearer.get("invoices", use: InvoiceController().index)
    bearer.get("invoices", Invoice.parameter, use: InvoiceController().single)
}
