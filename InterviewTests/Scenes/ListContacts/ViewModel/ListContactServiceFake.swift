import UIKit
@testable import Interview

final class ListContactServiceFake: ListContactServiceProtocol{
    
    func fetchContacts() async throws -> [Contact]? {
        return [Contact]()
    }
    
    func loadImage(_ url: String) async throws -> UIImage? {
        return UIImage()
    }
}

final class ListContactServiceFakeError: ListContactServiceProtocol{
   
    func fetchContacts() async throws -> [Contact]? {
        throw ErrorState.serverError
    }
    
    func loadImage(_ url: String) async throws -> UIImage? {
        throw ErrorState.serverError
    }
}

final class ListContactServiceNoConnection: ListContactServiceProtocol{
   
    func fetchContacts() async throws -> [Contact]? {
        throw URLError(.notConnectedToInternet)
    }
    
    func loadImage(_ url: String) async throws -> UIImage? {
        throw URLError(.notConnectedToInternet)
    }
}

final class ListContactServiceBadURl: ListContactServiceProtocol{
   
    func fetchContacts() async throws -> [Contact]? {
        throw URLError(.badURL)
    }
    
    func loadImage(_ url: String) async throws -> UIImage? {
        throw URLError(.badURL)
    }
}
