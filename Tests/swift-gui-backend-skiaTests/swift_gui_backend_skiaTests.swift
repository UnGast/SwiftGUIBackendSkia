import XCTest
@testable import swift_gui_backend_skia

final class swift_gui_backend_skiaTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_gui_backend_skia().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
