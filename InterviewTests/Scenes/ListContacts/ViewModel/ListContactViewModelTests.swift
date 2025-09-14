import XCTest
@testable import Interview

@MainActor
final class ListContactViewModelTests: XCTestCase {
    private var sut: ListContactsViewModel!

    override func setUp() {
        sut = ListContactsViewModel(ListContactServiceFake())
    }
    
    func testLoadImage() async throws {
        let image = try await sut.loadImage("https://picsum.photos/id/238/200/")
        XCTAssertNotNil(image)
    }

    func testFetchContacts() async throws {
        let contacts = try await sut.loadContacts()
        XCTAssertNotNil(contacts)
    }

    func testIsLegacyCorrectValue() async throws {
        XCTAssertTrue(sut.isLegacy(id: 10))
        XCTAssertTrue(sut.isLegacy(id: 11))
        XCTAssertTrue(sut.isLegacy(id: 12))
        XCTAssertTrue(sut.isLegacy(id: 13))
    }

    func testIsLegacyInCorrectValue() async throws {
        XCTAssertFalse(sut.isLegacy(id: 55))
        XCTAssertFalse(sut.isLegacy(id: 9))
        XCTAssertFalse(sut.isLegacy(id: -100))
        XCTAssertFalse(sut.isLegacy(id: 0))
    }
    
    func testLoadImageWithError() async throws {
        do{
            sut = ListContactsViewModel(ListContactServiceFakeError())
            let _ = try await sut.loadImage("https://picsum.photos/id/238/200/")
            XCTFail("Expected an ErrorState.serverError")
        }catch{}
    }

    func testFetchContactsWithError() async throws {
        do{
            sut = ListContactsViewModel(ListContactServiceFakeError())
            let _ = try await sut.loadContacts()
            XCTFail("Expected an ErrorState.serverError")
        }catch{}
    }
    
    func testLoadImageWithNoConnectionError() async throws {
        do{
            sut = ListContactsViewModel(ListContactServiceNoConnection())
            let _ = try await sut.loadImage("https://picsum.photos/id/238/200/")
            XCTFail("Expected an ErrorState.serverError")
        }catch{}
    }

    func testFetchContactsWithNoConnectionError() async throws {
        do{
            sut = ListContactsViewModel(ListContactServiceNoConnection())
            let _ = try await sut.loadContacts()
            XCTFail("Expected an ErrorState.serverError")
        }catch{}
    }

    
    func testLoadImageWithBadURl() async throws {
        do{
            sut = ListContactsViewModel(ListContactServiceBadURl())
            let _ = try await sut.loadImage("https://asdaapicsum.photos/id/238/200/")
            XCTFail("Expected an ErrorState.serverError")
        }catch{}
    }

    func testFetchContactsWithURl() async throws {
        do{
            sut = ListContactsViewModel(ListContactServiceBadURl())
            let _ = try await sut.loadContacts()
            XCTFail("Expected an ErrorState.serverError")
        }catch{}
    }

    override func tearDown() {
        sut = nil
    }
    
}
