import Foundation
import UIKit
@MainActor
class ListContactService: ListContactServiceProtocol {

    func fetchContacts() async throws -> [Contact]? {
        guard let url = URL(string: Constants.apiURL) else {
            throw ErrorState.serverError
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorState.serverError
        }

        let posts = try JSONDecoder().decode([Contact].self, from: data)
        return posts
    }
    
    func loadImage(_ url: String) async throws -> UIImage? {
        guard let url = URL(string: url) else {
            throw ErrorState.serverError
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ErrorState.serverError
        }

        guard let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

protocol ListContactServiceProtocol: Sendable{
    func fetchContacts() async throws -> [Contact]?
    func loadImage(_ url: String) async throws -> UIImage?
}
