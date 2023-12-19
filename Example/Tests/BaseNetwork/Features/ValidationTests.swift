//
//  ValidationTests.swift
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@testable import Cloudinary
import Foundation
import XCTest

class StatusCodeValidationTestCase: BaseTestCase {
    func testThatValidationForRequestWithAcceptableStatusCodeResponseSucceeds() {
        // Given
        let urlString = "https://httpbin.org/status/200"

        let expectation1 = self.expectation(description: "request should return 200 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(statusCode: 200..<300)
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }
        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithUnacceptableStatusCodeResponseFails() {
        // Given
        let urlString = "https://httpbin.org/status/404"

        let expectation1 = self.expectation(description: "request should return 404 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(statusCode: [200])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError, let statusCode = error.responseCode {
                XCTAssertTrue(error.isUnacceptableStatusCode)
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Error should not be nil, should be an CLDNError, and should have an associated statusCode.")
            }
        }
    }

    func testThatValidationForRequestWithNoAcceptableStatusCodesFails() {
        // Given
        let urlString = "https://httpbin.org/status/201"

        let expectation1 = self.expectation(description: "request should return 201 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(statusCode: [])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError, let statusCode = error.responseCode {
                XCTAssertTrue(error.isUnacceptableStatusCode)
                XCTAssertEqual(statusCode, 201)
            } else {
                XCTFail("Error should not be nil, should be an CLDNError, and should have an associated statusCode.")
            }
        }
    }
}

// MARK: -

class ContentTypeValidationTestCase: BaseTestCase {
    func testThatValidationForRequestWithAcceptableContentTypeResponseSucceeds() {
        // Given
        let urlString = "https://httpbin.org/ip"

        let expectation1 = self.expectation(description: "request should succeed and return ip")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(contentType: ["application/json"])
            .validate(contentType: ["application/json; charset=utf-8"])
            .validate(contentType: ["application/json; q=0.8; charset=utf-8"])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithAcceptableWildcardContentTypeResponseSucceeds() {
        // Given
        let urlString = "https://httpbin.org/ip"

        let expectation1 = self.expectation(description: "request should succeed and return ip")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(contentType: ["*/*"])
            .validate(contentType: ["application/*"])
            .validate(contentType: ["*/json"])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithUnacceptableContentTypeResponseFails() {
        // Given
        let urlString = "https://httpbin.org/"

        let expectation1 = self.expectation(description: "request should succeed and return html")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(contentType: ["application/octet-stream"])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError {
                XCTAssertTrue(error.isUnacceptableContentType)
                XCTAssertEqual(error.responseContentType, "text/html")
                XCTAssertEqual(error.acceptableContentTypes?.first, "application/octet-stream")
            } else {
                XCTFail("error should not be nil")
            }
        }
    }

    func testThatValidationForRequestWithNoAcceptableContentTypeResponseFails() {
        // Given
        let urlString = "https://httpbin.org/"

        let expectation1 = self.expectation(description: "request should succeed and return html")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(contentType: [])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError {
                XCTAssertTrue(error.isUnacceptableContentType)
                XCTAssertEqual(error.responseContentType, "text/html")
                XCTAssertTrue(error.acceptableContentTypes?.isEmpty ?? false)
            } else {
                XCTFail("error should not be nil")
            }
        }
    }

    func skipped_testThatValidationForRequestWithNoAcceptableContentTypeResponseSucceedsWhenNoDataIsReturned() {
        // Given
        let urlString = "https://mockbin.org/"

        let expectation1 = self.expectation(description: "request should succeed and return no data")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(contentType: [])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithAcceptableWildcardContentTypeResponseSucceedsWhenResponseIsNil() {
        // Given
        class MockManager: CLDNSessionManager {
            override func request(_ urlRequest: CLDNURLRequestConvertible) -> CLDNDataRequest {
                do {
                    let originalRequest = try urlRequest.CLDN_AsURLRequest()
                    let originalTask = CLDNDataRequest.Requestable(urlRequest: originalRequest)

                    let task = try originalTask.CLDN_Task(session: session, adapter: adapter, queue: queue)
                    let request = MockDataRequest(session: session, requestTask: .data(originalTask, task))

                    delegate[task] = request

                    if startRequestsImmediately { request.resume() }

                    return request
                } catch {
                    let request = CLDNDataRequest(session: session, requestTask: .data(nil, nil), error: error)
                    if startRequestsImmediately { request.resume() }
                    return request
                }
            }
        }

        class MockDataRequest: CLDNDataRequest {
            override var response: HTTPURLResponse? {
                return MockHTTPURLResponse(
                    url: request!.url!,
                    statusCode: 204,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                )
            }
        }

        class MockHTTPURLResponse: HTTPURLResponse {
            override var mimeType: String? { return nil }
        }

        let manager: CLDNSessionManager = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.ephemeral
                configuration.httpAdditionalHeaders = CLDNSessionManager.defaultHTTPHeaders

                return configuration
            }()

            return MockManager(configuration: configuration)
        }()

        let urlString = "https://httpbin.org/delete"

        let expectation1 = self.expectation(description: "request should be stubbed and return 204 status code")

        var requestResponse: CLDNDefaultDataResponse?

        // When
        manager.request(urlString, method: .delete)
            .validate(contentType: ["*/*"])
            .response { resp in
                requestResponse = resp
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestResponse?.response)
        XCTAssertNotNil(requestResponse?.data)
        XCTAssertNil(requestResponse?.error)

        XCTAssertEqual(requestResponse?.response?.statusCode, 204)
        XCTAssertNil(requestResponse?.response?.mimeType)
    }
}

// MARK: -

class MultipleValidationTestCase: BaseTestCase {
    func testThatValidationForRequestWithAcceptableStatusCodeAndContentTypeResponseSucceeds() {
        // Given
        let urlString = "https://httpbin.org/ip"

        let expectation1 = self.expectation(description: "request should succeed and return ip")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithUnacceptableStatusCodeAndContentTypeResponseFailsWithStatusCodeError() {
        // Given
        let urlString = "https://httpbin.org/"

        let expectation1 = self.expectation(description: "request should succeed and return status code 200")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(statusCode: 400..<600)
            .validate(contentType: ["application/octet-stream"])
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError {
                XCTAssertTrue(error.isUnacceptableStatusCode)
                XCTAssertEqual(error.responseCode, 200)
            } else {
                XCTFail("error should not be nil")
            }
        }
    }

    func testThatValidationForRequestWithUnacceptableStatusCodeAndContentTypeResponseFailsWithContentTypeError() {
        // Given
        let urlString = "https://httpbin.org/"

        let expectation1 = self.expectation(description: "request should succeed and return html")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(contentType: ["application/octet-stream"])
            .validate(statusCode: 400..<600)
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError {
                XCTAssertTrue(error.isUnacceptableContentType)
                XCTAssertEqual(error.responseContentType, "text/html")
                XCTAssertEqual(error.acceptableContentTypes?.first, "application/octet-stream")
            } else {
                XCTFail("error should not be nil")
            }
        }
    }
}

// MARK: -

class AutomaticValidationTestCase: BaseTestCase {
    func testThatValidationForRequestWithAcceptableStatusCodeAndContentTypeResponseSucceeds() {

        // Given
        let url = URL(string: "https://httpbin.org/ip")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let expectation1 = self.expectation(description: "request should succeed and return ip")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlRequest).validate().response { resp in
            requestError = resp.error
            expectation1.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithUnacceptableStatusCodeResponseFails() {
        // Given
        let urlString = "https://httpbin.org/status/404"

        let expectation1 = self.expectation(description: "request should return 404 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate()
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError, let statusCode = error.responseCode {
                XCTAssertTrue(error.isUnacceptableStatusCode)
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("error should not be nil")
            }
        }
    }

    func testThatValidationForRequestWithAcceptableWildcardContentTypeResponseSucceeds() {
        // Given
        let url = URL(string: "https://httpbin.org/ip")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/*", forHTTPHeaderField: "Accept")

        let expectation1 = self.expectation(description: "request should succeed and return ip")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlRequest).validate().response { resp in
            requestError = resp.error
            expectation1.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithAcceptableComplexContentTypeResponseSucceeds() {
        // Given
        let url = URL(string: "https://httpbin.org/")!
        var urlRequest = URLRequest(url: url)

        let headerValue = "text/xml, application/xml, application/xhtml+xml, text/html;q=0.9, text/plain;q=0.8,*/*;q=0.5"
        urlRequest.setValue(headerValue, forHTTPHeaderField: "Accept")

        let expectation1 = self.expectation(description: "request should succeed and return xml")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlRequest).validate().response { resp in
            requestError = resp.error
            expectation1.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationForRequestWithUnacceptableContentTypeResponseFails() {
        // Given
        let url = URL(string: "https://httpbin.org/")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")

        let expectation1 = self.expectation(description: "request should succeed and return html")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlRequest).validate().response { resp in
            requestError = resp.error
            expectation1.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(requestError)

        for error in [requestError] {
            if let error = error as? CLDNError {
                XCTAssertTrue(error.isUnacceptableContentType)
                XCTAssertEqual(error.responseContentType, "text/html")
                XCTAssertEqual(error.acceptableContentTypes?.first, "application/json")
            } else {
                XCTFail("error should not be nil")
            }
        }
    }
}

// MARK: -

private enum ValidationError: Error {
    case missingData, missingFile, fileReadFailed
}

extension CLDNDataRequest {
    func validateDataExists() -> Self {
        return validate { request, response, data in
            guard data != nil else { return .failure(ValidationError.missingData) }
            return .success
        }
    }

    func validate(with error: Error) -> Self {
        return validate { _, _, _ in .failure(error) }
    }
}

// MARK: -

class CustomValidationTestCase: BaseTestCase {
    func testThatCustomValidationClosureHasAccessToServerResponseData() {
        // Given
        let urlString = "https://httpbin.org/get"

        let expectation1 = self.expectation(description: "request should return 200 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate { request, response, data in
                guard data != nil else { return .failure(ValidationError.missingData) }
                return .success
            }
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }


        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatCustomValidationCanThrowCustomError() {
        // Given
        let urlString = "https://httpbin.org/get"

        let expectation1 = self.expectation(description: "request should return 200 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate { _, _, _ in .failure(ValidationError.missingData) }
            .validate { _, _, _ in .failure(ValidationError.missingFile) } // should be ignored
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }


        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertEqual(requestError as? ValidationError, ValidationError.missingData)
    }

    func testThatValidationExtensionHasAccessToServerResponseData() {
        // Given
        let urlString = "https://httpbin.org/get"

        let expectation1 = self.expectation(description: "request should return 200 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validateDataExists()
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(requestError)
    }

    func testThatValidationExtensionCanThrowCustomError() {
        // Given
        let urlString = "https://httpbin.org/get"

        let expectation1 = self.expectation(description: "request should return 200 status code")

        var requestError: Error?

        // When
        CLDNSessionManager.default.request(urlString)
            .validate(with: ValidationError.missingData)
            .validate(with: ValidationError.missingFile) // should be ignored
            .response { resp in
                requestError = resp.error
                expectation1.fulfill()
            }

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertEqual(requestError as? ValidationError, ValidationError.missingData)
    }
}
