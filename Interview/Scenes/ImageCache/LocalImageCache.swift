import Foundation
import UIKit

@MainActor
class LocalImageCache {
    private let shared = NSCache<NSString, UIImage>()
    func getImage(_ url: String) -> UIImage?{
        return shared.object(forKey: url as NSString)
    }
}
