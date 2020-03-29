//
//  CLDNRequest.swift
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

import Foundation

/// A type that can inspect and optionally adapt a `URLRequest` in some manner if necessary.
internal protocol CLDNRequestAdapter {
    /// Inspects and adapts the specified `URLRequest` in some manner if necessary and returns the result.
    ///
    /// - parameter urlRequest: The URL request to adapt.
    ///
    /// - throws: An `Error` if the adaptation encounters an error.
    ///
    /// - returns: The adapted `URLRequest`.
    func CLDN_Adapt(_ urlRequest: URLRequest) throws -> URLRequest
}

// MARK: -

/// A closure executed when the `CLDNRequestRetrier` determines whether a `CLDNRequest` should be retried or not.
internal typealias CLDNRequestRetryCompletion = (_ shouldRetry: Bool, _ timeDelay: TimeInterval) -> Void

/// A type that determines whether a request should be retried after being executed by the specified session manager
/// and encountering an error.
internal protocol CLDNRequestRetrier {
    /// Determines whether the `CLDNRequest` should be retried by calling the `completion` closure.
    ///
    /// This operation is fully asynchronous. Any amount of time can be taken to determine whether the request needs
    /// to be retried. The one requirement is that the completion closure is called to ensure the request is properly
    /// cleaned up after.
    ///
    /// - parameter manager:    The session manager the request was executed on.
    /// - parameter request:    The request that failed due to the encountered error.
    /// - parameter error:      The error encountered when executing the request.
    /// - parameter completion: The completion closure to be executed when retry decision has been determined.
    func CLDN_Should(_ manager: CLDNSessionManager, retry request: CLDNRequest, with error: Error, completion: @escaping CLDNRequestRetryCompletion)
}

// MARK: -

protocol CLDNTaskConvertible {
    func CLDN_Task(session: URLSession, adapter: CLDNRequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask
}

/// A dictionary of headers to apply to a `URLRequest`.
internal typealias CLDNHTTPHeaders = [String: String]

// MARK: -

/// Responsible for sending a request and receiving the response and associated data from the server, as well as
/// managing its underlying `URLSessionTask`.
internal class CLDNRequest {

    // MARK: Helper Types

    /// A closure executed when monitoring upload or download progress of a request.
    internal typealias ProgressHandler = (Progress) -> Void

    enum RequestTask {
        case data(CLDNTaskConvertible?, URLSessionTask?)
        case upload(CLDNTaskConvertible?, URLSessionTask?)
    }

    // MARK: Properties

    /// The delegate for the underlying task.
    internal var delegate: CLDNTaskDelegate {
        get {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            return taskDelegate
        }
        set {
            taskDelegateLock.lock() ; defer { taskDelegateLock.unlock() }
            taskDelegate = newValue
        }
    }

    /// The underlying task.
    internal var task: URLSessionTask? { return delegate.task }

    /// The session belonging to the underlying task.
    internal let session: URLSession

    /// The request sent or to be sent to the server.
    internal var request: URLRequest? { return task?.originalRequest }

    /// The response received from the server, if any.
    internal var response: HTTPURLResponse? { return task?.response as? HTTPURLResponse }

    /// The number of times the request has been retried.
    internal var retryCount: UInt = 0

    let originalTask: CLDNTaskConvertible?

    var startTime: CFAbsoluteTime?
    var endTime: CFAbsoluteTime?

    var validations: [() -> Void] = []

    private var taskDelegate: CLDNTaskDelegate
    private var taskDelegateLock = NSLock()

    // MARK: Lifecycle

    init(session: URLSession, requestTask: RequestTask, error: Error? = nil) {
        self.session = session

        switch requestTask {
        case .data(let originalTask, let task):
            taskDelegate = CLDNDataTaskDelegate(task: task)
            self.originalTask = originalTask
        case .upload(let originalTask, let task):
            taskDelegate = CLDNUploadTaskDelegate(task: task)
            self.originalTask = originalTask
        }

        delegate.error = error
        delegate.queue.addOperation { self.endTime = CFAbsoluteTimeGetCurrent() }
    }

    // MARK: Authentication

    /// Associates an HTTP Basic credential with the request.
    ///
    /// - parameter user:        The user.
    /// - parameter password:    The password.
    /// - parameter persistence: The URL credential persistence. `.ForSession` by default.
    ///
    /// - returns: The request.
    @discardableResult
    internal func authenticate(
        user: String,
        password: String,
        persistence: URLCredential.Persistence = .forSession)
        -> Self
    {
        let credential = URLCredential(user: user, password: password, persistence: persistence)
        return authenticate(usingCredential: credential)
    }

    /// Associates a specified credential with the request.
    ///
    /// - parameter credential: The credential.
    ///
    /// - returns: The request.
    @discardableResult
    internal func authenticate(usingCredential credential: URLCredential) -> Self {
        delegate.credential = credential
        return self
    }

    /// Returns a base64 encoded basic authentication credential as an authorization header tuple.
    ///
    /// - parameter user:     The user.
    /// - parameter password: The password.
    ///
    /// - returns: A tuple with Authorization header and credential value if encoding succeeds, `nil` otherwise.
    internal class func authorizationHeader(user: String, password: String) -> (key: String, value: String)? {
        guard let data = "\(user):\(password)".data(using: .utf8) else { return nil }

        let credential = data.base64EncodedString(options: [])

        return (key: "Authorization", value: "Basic \(credential)")
    }

    // MARK: State

    /// Resumes the request.
    internal func resume() {
        guard let task = task else { delegate.queue.isSuspended = false ; return }

        if startTime == nil { startTime = CFAbsoluteTimeGetCurrent() }

        task.resume()

//        NotificationCenter.default.post(
//            name: Notification.Name.Task.DidResume,
//            object: self,
//            userInfo: [Notification.Key.Task: task]
//        )
    }

    /// Suspends the request.
    internal func suspend() {
        guard let task = task else { return }

        task.suspend()
    }

    /// Cancels the request.
    internal func cancel() {
        guard let task = task else { return }

        task.cancel()
    }
}

// MARK: - CustomStringConvertible

extension CLDNRequest: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes the HTTP method and URL, as
    /// well as the response status code if a response has been received.
    internal var description: String {
        var components: [String] = []

        if let HTTPMethod = request?.httpMethod {
            components.append(HTTPMethod)
        }

        if let urlString = request?.url?.absoluteString {
            components.append(urlString)
        }

        if let response = response {
            components.append("(\(response.statusCode))")
        }

        return components.joined(separator: " ")
    }
}

// MARK: - CustomDebugStringConvertible

extension CLDNRequest: CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, in the form of a cURL command.
    internal var debugDescription: String {
        return cURLRepresentation()
    }

    func cURLRepresentation() -> String {
        var components = ["$ curl -v"]

        guard let request = self.request,
              let url = request.url,
              let host = url.host
        else {
            return "$ curl command could not be created"
        }

        if let httpMethod = request.httpMethod, httpMethod != "GET" {
            components.append("-X \(httpMethod)")
        }

        if let credentialStorage = self.session.configuration.urlCredentialStorage {
            let protectionSpace = URLProtectionSpace(
                host: host,
                port: url.port ?? 0,
                protocol: url.scheme,
                realm: host,
                authenticationMethod: NSURLAuthenticationMethodHTTPBasic
            )

            if let credentials = credentialStorage.credentials(for: protectionSpace)?.values {
                for credential in credentials {
                    guard let user = credential.user, let password = credential.password else { continue }
                    components.append("-u \(user):\(password)")
                }
            } else {
                if let credential = delegate.credential, let user = credential.user, let password = credential.password {
                    components.append("-u \(user):\(password)")
                }
            }
        }

        if session.configuration.httpShouldSetCookies {
            if
                let cookieStorage = session.configuration.httpCookieStorage,
                let cookies = cookieStorage.cookies(for: url), !cookies.isEmpty
            {
                let string = cookies.reduce("") { $0 + "\($1.name)=\($1.value);" }

            #if swift(>=3.2)
                components.append("-b \"\(string[..<string.index(before: string.endIndex)])\"")
            #else
                components.append("-b \"\(string.substring(to: string.characters.index(before: string.endIndex)))\"")
            #endif
            }
        }

        var headers: [AnyHashable: Any] = [:]

        session.configuration.httpAdditionalHeaders?.filter {  $0.0 != AnyHashable("Cookie") }
                                                    .forEach { headers[$0.0] = $0.1 }

        request.allHTTPHeaderFields?.filter { $0.0 != "Cookie" }
                                    .forEach { headers[$0.0] = $0.1 }

        components += headers.map {
            let escapedValue = String(describing: $0.value).replacingOccurrences(of: "\"", with: "\\\"")

            return "-H \"\($0.key): \(escapedValue)\""
        }

        if let httpBodyData = request.httpBody, let httpBody = String(data: httpBodyData, encoding: .utf8) {
            var escapedBody = httpBody.replacingOccurrences(of: "\\\"", with: "\\\\\"")
            escapedBody = escapedBody.replacingOccurrences(of: "\"", with: "\\\"")

            components.append("-d \"\(escapedBody)\"")
        }

        components.append("\"\(url.absoluteString)\"")

        return components.joined(separator: " \\\n\t")
    }
}

// MARK: -

/// Specific type of `CLDNRequest` that manages an underlying `URLSessionDataTask`.
internal class CLDNDataRequest: CLDNRequest {

    // MARK: Helper Types

    struct Requestable: CLDNTaskConvertible {
        let urlRequest: URLRequest

        func CLDN_Task(session: URLSession, adapter: CLDNRequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
            do {
                let urlRequest = try self.urlRequest.adapt(using: adapter)
                return queue.sync { session.dataTask(with: urlRequest) }
            } catch {
                throw AdaptError(error: error)
            }
        }
    }

    // MARK: Properties

    /// The request sent or to be sent to the server.
    internal override var request: URLRequest? {
        if let request = super.request { return request }
        if let requestable = originalTask as? Requestable { return requestable.urlRequest }

        return nil
    }

    /// The progress of fetching the response data from the server for the request.
    internal var progress: Progress { return dataDelegate.progress }

    var dataDelegate: CLDNDataTaskDelegate { return delegate as! CLDNDataTaskDelegate }

    // MARK: Stream

    /// Sets a closure to be called periodically during the lifecycle of the request as data is read from the server.
    ///
    /// This closure returns the bytes most recently received from the server, not including data from previous calls.
    /// If this closure is set, data will only be available within this closure, and will not be saved elsewhere. It is
    /// also important to note that the server data in any `Response` object will be `nil`.
    ///
    /// - parameter closure: The code to be executed periodically during the lifecycle of the request.
    ///
    /// - returns: The request.
    @discardableResult
    internal func stream(closure: ((Data) -> Void)? = nil) -> Self {
        dataDelegate.dataStream = closure
        return self
    }

    // MARK: Progress

    /// Sets a closure to be called periodically during the lifecycle of the `CLDNRequest` as data is read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is read from the server.
    ///
    /// - returns: The request.
    @discardableResult
    internal func downloadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
        dataDelegate.progressHandler = (closure, queue)
        return self
    }
}

// MARK: -

/// Specific type of `CLDNRequest` that manages an underlying `URLSessionUploadTask`.
internal class CLDNUploadRequest: CLDNDataRequest {

    // MARK: Helper Types

    enum Uploadable: CLDNTaskConvertible {
        case data(Data, URLRequest)
        case file(URL, URLRequest)
        case stream(InputStream, URLRequest)

        func CLDN_Task(session: URLSession, adapter: CLDNRequestAdapter?, queue: DispatchQueue) throws -> URLSessionTask {
            do {
                let task: URLSessionTask

                switch self {
                case let .data(data, urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.sync { session.uploadTask(with: urlRequest, from: data) }
                case let .file(url, urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.sync { session.uploadTask(with: urlRequest, fromFile: url) }
                case let .stream(_, urlRequest):
                    let urlRequest = try urlRequest.adapt(using: adapter)
                    task = queue.sync { session.uploadTask(withStreamedRequest: urlRequest) }
                }

                return task
            } catch {
                throw AdaptError(error: error)
            }
        }
    }

    // MARK: Properties

    /// The request sent or to be sent to the server.
    internal override var request: URLRequest? {
        if let request = super.request { return request }

        guard let uploadable = originalTask as? Uploadable else { return nil }

        switch uploadable {
        case .data(_, let urlRequest), .file(_, let urlRequest), .stream(_, let urlRequest):
            return urlRequest
        }
    }

    /// The progress of uploading the payload to the server for the upload request.
    internal var uploadProgress: Progress { return uploadDelegate.uploadProgress }

    var uploadDelegate: CLDNUploadTaskDelegate { return delegate as! CLDNUploadTaskDelegate }

    // MARK: Upload Progress

    /// Sets a closure to be called periodically during the lifecycle of the `CLDNUploadRequest` as data is sent to
    /// the server.
    ///
    /// After the data is sent to the server, the `progress(queue:closure:)` APIs can be used to monitor the progress
    /// of data being read from the server.
    ///
    /// - parameter queue:   The dispatch queue to execute the closure on.
    /// - parameter closure: The code to be executed periodically as data is sent to the server.
    ///
    /// - returns: The request.
    @discardableResult
    internal func uploadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
        uploadDelegate.uploadProgressHandler = (closure, queue)
        return self
    }
}
