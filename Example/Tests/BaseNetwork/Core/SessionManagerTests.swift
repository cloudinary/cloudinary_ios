//
//  SessionManagerTests.swift
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

class SessionManagerTestCase: BaseTestCase {
    
    // MARK: Helper Types
    
    private class HTTPMethodAdapter: CLDNRequestAdapter {
        let method: CLDNHTTPMethod
        let throwsError: Bool
        
        init(method: CLDNHTTPMethod, throwsError: Bool = false) {
            self.method = method
            self.throwsError = throwsError
        }
        
        func CLDN_Adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            guard !throwsError else { throw CLDNError.invalidURL(url: "") }
            
            var urlRequest = urlRequest
            urlRequest.httpMethod = method.rawValue
            
            return urlRequest
        }
    }
    
    private class RequestHandler: CLDNRequestAdapter, CLDNRequestRetrier {
        var adaptedCount = 0
        var retryCount = 0
        var retryErrors: [Error] = []
        
        var shouldApplyAuthorizationHeader = false
        var throwsErrorOnSecondAdapt = false
        
        func CLDN_Adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            if throwsErrorOnSecondAdapt && adaptedCount == 1 {
                throwsErrorOnSecondAdapt = false
                throw CLDNError.invalidURL(url: "")
            }
            
            var urlRequest = urlRequest
            
            adaptedCount += 1
            
            if shouldApplyAuthorizationHeader && adaptedCount > 1 {
                if let header = CLDNRequest.authorizationHeader(user: "user", password: "password") {
                    urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
                }
            }
            
            return urlRequest
        }
        
        func CLDN_Should(_ manager: CLDNSessionManager, retry request: CLDNRequest, with error: Error, completion: @escaping CLDNRequestRetryCompletion) {
            retryCount += 1
            retryErrors.append(error)
            
            if retryCount < 2 {
                completion(true, 0.0)
            } else {
                completion(false, 0.0)
            }
        }
    }
    
    private class UploadHandler: CLDNRequestAdapter, CLDNRequestRetrier {
        var adaptedCount = 0
        var retryCount = 0
        var retryErrors: [Error] = []
        
        func CLDN_Adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            adaptedCount += 1
            
            if adaptedCount == 1 { throw CLDNError.invalidURL(url: "") }
            
            return urlRequest
        }
        
        func CLDN_Should(_ manager: CLDNSessionManager, retry request: CLDNRequest, with error: Error, completion: @escaping CLDNRequestRetryCompletion) {
            retryCount += 1
            retryErrors.append(error)
            
            completion(true, 0.0)
        }
    }
    
    // prevents the test from running, currently there's an issue when Travis CI runs this test
    lazy var allowManagerTest: Bool = {
        return ProcessInfo.processInfo.arguments.contains("TEST_SESSION_MANAGER")
    }()
    
    // MARK: Tests - Initialization
    
    func testInitializerWithDefaultArguments() {
        // Given, When
        let manager = CLDNSessionManager()
        
        // Then
        XCTAssertNotNil(manager.session.delegate, "session delegate should not be nil")
        XCTAssertTrue(manager.delegate === manager.session.delegate, "manager delegate should equal session delegate")
    }
    
    func testInitializerWithSpecifiedArguments() {
        // Given
        let configuration = URLSessionConfiguration.default
        let delegate = CLDNSessionDelegate()
        
        
        // When
        let manager = CLDNSessionManager(
            configuration: configuration,
            delegate: delegate)
        
        // Then
        XCTAssertNotNil(manager.session.delegate, "session delegate should not be nil")
        XCTAssertTrue(manager.delegate === manager.session.delegate, "manager delegate should equal session delegate")
    }
    
    func testThatFailableInitializerSucceedsWithDefaultArguments() {
        // Given
        let delegate = CLDNSessionDelegate()
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        }()
        
        // When
        let manager = CLDNSessionManager(session: session, delegate: delegate)
        
        // Then
        if let manager = manager {
            XCTAssertTrue(manager.delegate === manager.session.delegate, "manager delegate should equal session delegate")
        } else {
            XCTFail("manager should not be nil")
        }
    }
    
    func testThatFailableInitializerSucceedsWithSpecifiedArguments() {
        // Given
        let delegate = CLDNSessionDelegate()
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        }()
        
        // When
        let manager = CLDNSessionManager(session: session, delegate: delegate)
        
        // Then
        if let manager = manager {
            XCTAssertTrue(manager.delegate === manager.session.delegate, "manager delegate should equal session delegate")
        } else {
            XCTFail("manager should not be nil")
        }
    }
    
    func testThatFailableInitializerFailsWithWhenDelegateDoesNotEqualSessionDelegate() {
        // Given
        let delegate = CLDNSessionDelegate()
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            return URLSession(configuration: configuration, delegate: CLDNSessionDelegate(), delegateQueue: nil)
        }()
        
        // When
        let manager = CLDNSessionManager(session: session, delegate: delegate)
        
        // Then
        XCTAssertNil(manager, "manager should be nil")
    }
    
    func testThatFailableInitializerFailsWhenSessionDelegateIsNil() {
        // Given
        let delegate = CLDNSessionDelegate()
        let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        }()
        
        // When
        let manager = CLDNSessionManager(session: session, delegate: delegate)
        
        // Then
        XCTAssertNil(manager, "manager should be nil")
    }
    
    // MARK: Tests - Default HTTP Headers
    
    func testDefaultUserAgentHeader() {
        // Given, When
        let userAgent = CLDNSessionManager.defaultHTTPHeaders["User-Agent"]
        
        // Then
        let osNameVersion: String = {
            let version = ProcessInfo.processInfo.operatingSystemVersion
            let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            
            let osName: String = {
#if os(iOS)
                return "iOS"
#elseif os(watchOS)
                return "watchOS"
#elseif os(tvOS)
                return "tvOS"
#elseif os(macOS)
                return "OS X"
#elseif os(Linux)
                return "Linux"
#else
                return "Unknown"
#endif
            }()
            
            return "\(osName) \(versionString)"
        }()
        
        let cloudinaryVersion: String = {
            guard
                let afInfo = Bundle(for: CLDNSessionManager.self).infoDictionary,
                let build = afInfo["CFBundleShortVersionString"]
            else { return "Unknown" }
            
            return "Cloudinary/\(build)"
        }()
        let info = Bundle.main.infoDictionary
        let executable = info?[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        let appVersion = info?["CFBundleShortVersionString"] as? String ?? "Unknown"
        
        
        XCTAssertTrue(userAgent?.contains(cloudinaryVersion) == true)
        XCTAssertTrue(userAgent?.contains(osNameVersion) == true)
        XCTAssertTrue(userAgent?.contains("\(executable)/\(appVersion)") == true)
    }
    
    // MARK: Tests - Start Requests Immediately
    
    func testSetStartRequestsImmediatelyToFalseAndResumeRequest() {
        // Given
        let manager = CLDNSessionManager()
        manager.startRequestsImmediately = false
        
        let url = URL(string: "https://httpbin.org/")!
        let urlRequest = URLRequest(url: url)
        
        let expectation = self.expectation(description: "\(url)")
        
        var response: HTTPURLResponse?
        
        // When
        manager.request(urlRequest)
            .response { resp in
                response = resp.response
                expectation.fulfill()
            }
            .resume()
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(response, "response should not be nil")
        XCTAssertTrue(response?.statusCode == 200, "response status code should be 200")
    }
    
    // MARK: Tests - Deinitialization
    
    func testReleasingManagerWithPendingRequestDeinitializesSuccessfully() {
        // Given
        var manager: CLDNSessionManager? = CLDNSessionManager()
        manager?.startRequestsImmediately = false
        
        let url = URL(string: "https://httpbin.org/get")!
        let urlRequest = URLRequest(url: url)
        
        // When
        let request = manager?.request(urlRequest)
        manager = nil
        
        // Then
        XCTAssertTrue(request?.task?.state == .suspended, "request task state should be '.Suspended'")
        XCTAssertNil(manager, "manager should be nil")
    }
    
    func testReleasingManagerWithPendingCanceledRequestDeinitializesSuccessfully() {
        // Given
        var manager: CLDNSessionManager? = CLDNSessionManager()
        manager!.startRequestsImmediately = false
        
        let url = URL(string: "https://httpbin.org/")!
        let urlRequest = URLRequest(url: url)
        
        // When
        let request = manager!.request(urlRequest)
        request.cancel()
        manager = nil
        
        // Then
        let state = request.task?.state
        XCTAssertTrue(state == .canceling || state == .completed, "state should be .Canceling or .Completed")
        XCTAssertNil(manager, "manager should be nil")
    }
    
    // MARK: Tests - Bad Requests
    
    func skipped_testThatDataRequestWithInvalidURLStringThrowsResponseHandlerError() {
        // Given
        let sessionManager = CLDNSessionManager()
        let expectation = self.expectation(description: "CLDNRequest should fail with error")
        
        var response: CLDNDefaultDataResponse?
        
        // When
        sessionManager.request("https://httpbin.org/get/äëïöü").response { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.data?.count, 0)
        XCTAssertNotNil(response?.error)
        
        if let error = response?.error as? CLDNError {
            XCTAssertTrue(error.isInvalidURLError)
            XCTAssertEqual(error.urlConvertible as? String, "https://httpbin.org/get/äëïöü")
        } else {
            XCTFail("error should not be nil")
        }
    }
    
    func skipped_testThatUploadDataRequestWithInvalidURLStringThrowsResponseHandlerError() {
        // Given
        let sessionManager = CLDNSessionManager()
        let expectation = self.expectation(description: "Upload should fail with error")
        
        var response: CLDNDefaultDataResponse?
        
        // When
        sessionManager.upload(Data(), to: "https://httpbin.org/").response { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.data?.count, 0)
        XCTAssertNotNil(response?.error)
        
        if let error = response?.error as? CLDNError {
            XCTAssertTrue(error.isInvalidURLError)
            XCTAssertEqual(error.urlConvertible as? String, "https://httpbin.org/get/äëïöü")
        } else {
            XCTFail("error should not be nil")
        }
    }
    
    func skipped_testThatUploadFileRequestWithInvalidURLStringThrowsResponseHandlerError() {
        // Given
        let sessionManager = CLDNSessionManager()
        let expectation = self.expectation(description: "Upload should fail with error")
        
        var response: CLDNDefaultDataResponse?
        
        // When
        sessionManager.upload(URL(fileURLWithPath: "/invalid"), to: "https://httpbin.org/get/äëïöü").response { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.data?.count, 0)
        XCTAssertNotNil(response?.error)
        
        if let error = response?.error as? CLDNError {
            XCTAssertTrue(error.isInvalidURLError)
            XCTAssertEqual(error.urlConvertible as? String, "https://httpbin.org/get/äëïöü")
        } else {
            XCTFail("error should not be nil")
        }
    }
    
    func skipped_testThatUploadStreamRequestWithInvalidURLStringThrowsResponseHandlerError() {
        // Given
        let sessionManager = CLDNSessionManager()
        let expectation = self.expectation(description: "Upload should fail with error")
        
        var response: CLDNDefaultDataResponse?
        
        // When
        sessionManager.upload(InputStream(data: Data()), to: "https://httpbin.org/get/äëïöü").response { resp in
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.data?.count, 0)
        XCTAssertNotNil(response?.error)
        
        if let error = response?.error as? CLDNError {
            XCTAssertTrue(error.isInvalidURLError)
            XCTAssertEqual(error.urlConvertible as? String, "https://httpbin.org/get/äëïöü")
        } else {
            XCTFail("error should not be nil")
        }
    }
    
    // MARK: Tests - CLDNRequest Adapter
    
    func testThatSessionManagerCallsRequestAdapterWhenCreatingDataRequest() {
        // Given
        let adapter = HTTPMethodAdapter(method: .post)
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = adapter
        sessionManager.startRequestsImmediately = false
        
        // When
        let request = sessionManager.request("https://httpbin.org/get")
        
        // Then
        XCTAssertEqual(request.task?.originalRequest?.httpMethod, adapter.method.rawValue)
    }
    
    func testThatSessionManagerCallsRequestAdapterWhenCreatingUploadRequestWithData() {
        // Given
        let adapter = HTTPMethodAdapter(method: .get)
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = adapter
        sessionManager.startRequestsImmediately = false
        
        // When
        let request = sessionManager.upload("data".data(using: .utf8)!, to: "https://httpbin.org/post")
        
        // Then
        XCTAssertEqual(request.task?.originalRequest?.httpMethod, adapter.method.rawValue)
    }
    
    func testThatSessionManagerCallsRequestAdapterWhenCreatingUploadRequestWithFile() {
        // Given
        let adapter = HTTPMethodAdapter(method: .get)
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = adapter
        sessionManager.startRequestsImmediately = false
        
        // When
        let fileURL = URL(fileURLWithPath: "/path/to/some/file.txt")
        let request = sessionManager.upload(fileURL, to: "https://httpbin.org/post")
        
        // Then
        XCTAssertEqual(request.task?.originalRequest?.httpMethod, adapter.method.rawValue)
    }
    
    func testThatSessionManagerCallsRequestAdapterWhenCreatingUploadRequestWithInputStream() {
        // Given
        let adapter = HTTPMethodAdapter(method: .get)
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = adapter
        sessionManager.startRequestsImmediately = false
        
        // When
        let inputStream = InputStream(data: "data".data(using: .utf8)!)
        let request = sessionManager.upload(inputStream, to: "https://httpbin.org/post")
        
        // Then
        XCTAssertEqual(request.task?.originalRequest?.httpMethod, adapter.method.rawValue)
    }
    
    func testThatRequestAdapterErrorThrowsResponseHandlerError() {
        // Given
        let adapter = HTTPMethodAdapter(method: .post, throwsError: true)
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = adapter
        sessionManager.startRequestsImmediately = false
        
        // When
        let request = sessionManager.request("https://httpbin.org/get")
        
        // Then
        if let error = request.delegate.error as? CLDNError {
            XCTAssertTrue(error.isInvalidURLError)
            XCTAssertEqual(error.urlConvertible as? String, "")
        } else {
            XCTFail("error should not be nil")
        }
    }
    
    // MARK: Tests - CLDNRequest Retrier
    
    func testThatSessionManagerCallsRequestRetrierWhenRequestEncountersError() throws {
        
        try XCTSkipUnless(allowManagerTest, "prevents the test from running, currently there's an issue when Travis CI runs this test")
        
        // Given
        let handler = RequestHandler()
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = handler
        sessionManager.retrier = handler
        
        let expectation = self.expectation(description: "request should eventually fail")
        var response: CLDNDataResponse<Any>?
        
        // When
        let request = sessionManager.request("https://httpbin.org/basic-auth/user/password")
            .validate()
            .responseJSON { jsonResponse in
                response = jsonResponse
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(handler.adaptedCount, 2)
        XCTAssertEqual(handler.retryCount, 2)
        XCTAssertEqual(request.retryCount, 1)
        XCTAssertEqual(response?.result.isSuccess, false)
        XCTAssertTrue(sessionManager.delegate.requests.isEmpty)
    }
    
    func testThatSessionManagerCallsRequestRetrierWhenRequestInitiallyEncountersAdaptError() throws {
        
        try XCTSkipUnless(allowManagerTest, "prevents the test from running, currently there's an issue when Travis CI runs this test")
        
        // Given
        let handler = RequestHandler()
        handler.adaptedCount = 1
        handler.throwsErrorOnSecondAdapt = true
        handler.shouldApplyAuthorizationHeader = true
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = handler
        sessionManager.retrier = handler
        
        let expectation = self.expectation(description: "request should eventually fail")
        var response: CLDNDataResponse<Any>?
        
        // When
        sessionManager.request("https://httpbin.org/basic-auth/user/password")
            .validate()
            .responseJSON { jsonResponse in
                response = jsonResponse
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(handler.adaptedCount, 2, "handler.adaptedCount should be equal to 2")
        XCTAssertEqual(handler.retryCount, 1, "handler.retryCount should be equal to 1")
        XCTAssertEqual(response?.result.isSuccess, true, "response?.result.isSuccess should be equal to true")
        XCTAssertTrue(sessionManager.delegate.requests.isEmpty, "delegate.requests.isEmpty should be empty")
        
        handler.retryErrors.forEach { XCTAssertFalse($0 is AdaptError, "retry error should not be AdaptError") }
    }
    
    func testThatSessionManagerCallsRequestRetrierWhenUploadInitiallyEncountersAdaptError() throws {
        
        try XCTSkipUnless(allowManagerTest, "prevents the test from running, currently there's an issue when Travis CI runs this test")
        
        // Given
        let handler = UploadHandler()
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = handler
        sessionManager.retrier = handler
        
        let expectation = self.expectation(description: "request should eventually fail")
        var response: CLDNDataResponse<Any>?
        
        let uploadData = "upload data".data(using: .utf8, allowLossyConversion: false)!
        
        // When
        sessionManager.upload(uploadData, to: "https://httpbin.org/post")
            .validate()
            .responseJSON { jsonResponse in
                response = jsonResponse
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(handler.adaptedCount, 2)
        XCTAssertEqual(handler.retryCount, 1)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertTrue(sessionManager.delegate.requests.isEmpty)
        
        handler.retryErrors.forEach { XCTAssertFalse($0 is AdaptError) }
    }
    
    func testThatSessionManagerCallsAdapterWhenRequestIsRetried() throws {
        
        try XCTSkipUnless(allowManagerTest, "prevents the test from running, currently there's an issue when Travis CI runs this test")
        
        // Given
        let handler = RequestHandler()
        handler.shouldApplyAuthorizationHeader = true
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = handler
        sessionManager.retrier = handler
        
        let expectation = self.expectation(description: "request should eventually fail")
        var response: CLDNDataResponse<Any>?
        
        // When
        let request = sessionManager.request("https://httpbin.org/basic-auth/user/password")
            .validate()
            .responseJSON { jsonResponse in
                response = jsonResponse
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(handler.adaptedCount, 2)
        XCTAssertEqual(handler.retryCount, 1)
        XCTAssertEqual(request.retryCount, 1)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertTrue(sessionManager.delegate.requests.isEmpty)
    }
    
    func testThatRequestAdapterErrorThrowsResponseHandlerErrorWhenRequestIsRetried() throws {
        
        try XCTSkipUnless(allowManagerTest, "prevents the test from running, currently there's an issue when Travis CI runs this test")
        
        // Given
        let handler = RequestHandler()
        handler.throwsErrorOnSecondAdapt = true
        
        let sessionManager = CLDNSessionManager()
        sessionManager.adapter = handler
        sessionManager.retrier = handler
        
        let expectation = self.expectation(description: "request should eventually fail")
        var response: CLDNDataResponse<Any>?
        
        // When
        let request = sessionManager.request("https://httpbin.org/basic-auth/user/password")
            .validate()
            .responseJSON { jsonResponse in
                response = jsonResponse
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertEqual(handler.adaptedCount, 1, "handler.adaptedCount count should be equal to 0")
        XCTAssertEqual(handler.retryCount, 1, "handler.retry count should be equal to 0")
        XCTAssertEqual(request.retryCount, 0, "result.retry count should be equal to 0")
        XCTAssertEqual(response?.result.isSuccess, false, "result should succeed")
        XCTAssertTrue(sessionManager.delegate.requests.isEmpty, "delegate.requests should be empty")
        
        if let error = response?.result.error as? CLDNError {
            XCTAssertTrue(error.isInvalidURLError, "error.isInvalidURLError should be true")
            XCTAssertEqual(error.urlConvertible as? String, "", "error.urlConvertible shold be true")
        } else {
            XCTFail("error should not be nil")
        }
    }
}

// MARK: -

class SessionManagerConfigurationHeadersTestCase: BaseTestCase {
    enum ConfigurationType {
        case `default`, ephemeral, background
    }
    
    func testThatDefaultConfigurationHeadersAreSentWithRequest() {
        // Given, When, Then
        executeAuthorizationHeaderTest(for: .default)
    }
    
    func testThatEphemeralConfigurationHeadersAreSentWithRequest() {
        // Given, When, Then
        executeAuthorizationHeaderTest(for: .ephemeral)
    }
#if os(macOS)
    func testThatBackgroundConfigurationHeadersAreSentWithRequest() {
        // Given, When, Then
        executeAuthorizationHeaderTest(for: .background)
    }
#endif
    
    private func executeAuthorizationHeaderTest(for type: ConfigurationType) {
        // Given
        let manager: CLDNSessionManager = {
            let configuration: URLSessionConfiguration = {
                let configuration: URLSessionConfiguration
                
                switch type {
                case .default:
                    configuration = .default
                case .ephemeral:
                    configuration = .ephemeral
                case .background:
                    let identifier = "org.cloudinary.test.manager-configuration-tests"
                    configuration = .background(withIdentifier: identifier)
                }
                
                var headers = CLDNSessionManager.defaultHTTPHeaders
                headers["Authorization"] = "Bearer 123456"
                configuration.httpAdditionalHeaders = headers
                
                return configuration
            }()
            
            return CLDNSessionManager(configuration: configuration)
        }()
        
        let expectation = self.expectation(description: "request should complete successfully")
        
        var response: CLDNDataResponse<Any>?
        
        // When
        manager.request("https://httpbin.org/headers")
            .responseJSON { closureResponse in
                response = closureResponse
                expectation.fulfill()
            }
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        if let response = response {
            XCTAssertNotNil(response.request, "request should not be nil")
            XCTAssertNotNil(response.response, "response should not be nil")
            XCTAssertNotNil(response.data, "data should not be nil")
            XCTAssertTrue(response.result.isSuccess, "result should be a success")
            
            if
                let response = response.result.value as? [String: Any],
                let headers = response["headers"] as? [String: String],
                let authorization = headers["Authorization"]
            {
                XCTAssertEqual(authorization, "Bearer 123456", "authorization header value does not match")
            } else {
                XCTFail("failed to extract authorization header value")
            }
        } else {
            XCTFail("response should not be nil")
        }
    }
}
