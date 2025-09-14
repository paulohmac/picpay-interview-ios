import XCTest
@testable import Interview

final class ListContactServiceTests: XCTestCase {
    private var sut: ListContactService!
    private var session: URLSession!
    override func setUp() {
        sut = ListContactService()
    }
    
    func testFetchContacts() async throws {
        let contacts = try await sut.fetchContacts()
        XCTAssertEqual(contacts?.count, 13)
    }

    func testLoadImage() async throws {
        let image = try await sut.loadImage("https://picsum.photos/id/238/200/")
        XCTAssertNotNil(image)
    }

    func testLoadImageWrongUrl() async throws {
        do{
            let _ = try await sut.loadImage("https:///200/")
            XCTFail("Error not thrown when loading image with wrong url")
       } catch { }
    }

    override func tearDown() {
        session = nil
        MockURLProtocol.error = nil
        sut = nil
    }
}


var mockData: Data? {
    """
    [{
      "id": 2,
      "name": "Beyonce",
      "photoURL": "https://api.adorable.io/avatars/285/a2.png"
    }]
    """.data(using: .utf8)
}
