import Foundation
import UIKit
@MainActor
struct ListContactsViewModel: ListContactsViewModelProtocol  {
    private let service: ListContactServiceProtocol?
    private let imageCache: LocalImageCache? = LocalImageCache()

    init(_ service: ListContactServiceProtocol){
        self.service = service
    }

    func loadContacts() async throws -> [Contact]?{
        var contacts: [Contact]?
        try await contacts = service?.fetchContacts()
        return contacts
    }
    
    func loadImage(_ url: String) async throws -> UIImage? {
        var image: UIImage?
        if let cachedImage = imageCache?.getImage(url) {
            image = cachedImage
        } else{
            image = try await service?.loadImage(url)
        }
        return image
    }
    
    nonisolated func isLegacy(id: Int) -> Bool{
        return [10, 11, 12, 13].contains(id)
    }
}

protocol ListContactsViewModelProtocol: Sendable{
    func loadContacts() async throws -> [Contact]?
    func loadImage(_ url: String) async throws -> UIImage?
    func isLegacy(id: Int) -> Bool
}
