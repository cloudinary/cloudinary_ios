//
//  ParameterEncodingTests.swift
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

class ParameterEncodingTestCase: BaseTestCase {
    let urlRequest = URLRequest(url: URL(string: "https://example.com/")!)

    internal func checkParamsEncodedCorrectly(params: [String: Any], encoding: CLDNURLEncoding = CLDNURLEncoding.default) throws {
        var request = urlRequest
        request.httpMethod = CLDNHTTPMethod.post.rawValue

        let encodedURLRequest = try encoding.CLDN_Encode(request, with: params)

        XCTAssertNotNil(encodedURLRequest.httpBody, "HTTPBody should not be nil")

        let queryParams = params.map({
            encoding.queryComponents(fromKey: $0, value: $1)
        }).reduce([], +)

        if let httpBody = encodedURLRequest.httpBody, let decodedHTTPBody = String(data: httpBody, encoding: .utf8) {
            for query in queryParams {
                XCTAssert(decodedHTTPBody.contains("\(query.0)=\(query.1)"))
            }
        } else {
            XCTFail("decoded http body should not be nil")
        }
    }
}

// MARK: -

class URLParameterEncodingTestCase: ParameterEncodingTestCase {

    // MARK: Properties

    let encoding = CLDNURLEncoding.default

    // MARK: Tests - Parameter Types

    func testURLParameterEncodeNilParameters() {
        do {
            // Given, When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: nil)

            // Then
            XCTAssertNil(urlRequest.url?.query)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeEmptyDictionaryParameter() {
        do {
            // Given
            let parameters: [String: Any] = [:]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertNil(urlRequest.url?.query)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeOneStringKeyStringValueParameter() {
        do {
            // Given
            let parameters = ["foo": "bar"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=bar")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeOneStringKeyStringValueParameterAppendedToQuery() {
        do {
            // Given
            var mutableURLRequest = self.urlRequest
            var urlComponents = URLComponents(url: mutableURLRequest.url!, resolvingAgainstBaseURL: false)!
            urlComponents.query = "baz=qux"
            mutableURLRequest.url = urlComponents.url

            let parameters = ["foo": "bar"]

            // When
            let urlRequest = try encoding.CLDN_Encode(mutableURLRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "baz=qux&foo=bar")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeTwoStringKeyStringValueParameters() {
        do {
            // Given
            let parameters = ["foo": "bar", "baz": "qux"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "baz=qux&foo=bar")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyNSNumberIntegerValueParameter() {
        do {
            // Given
            let parameters = ["foo": NSNumber(value: 25)]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=25")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyNSNumberBoolValueParameter() {
        do {
            // Given
            let parameters = ["foo": NSNumber(value: false)]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=0")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyIntegerValueParameter() {
        do {
            // Given
            let parameters = ["foo": 1]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyDoubleValueParameter() {
        do {
            // Given
            let parameters = ["foo": 1.1]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=1.1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyBoolValueParameter() {
        do {
            // Given
            let parameters = ["foo": true]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyArrayValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["a", 1, true]]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%5B%5D=a&foo%5B%5D=1&foo%5B%5D=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyArrayValueParameterWithoutBrackets() {
        do {
            // Given
            let encoding = CLDNURLEncoding(arrayEncoding: .noBrackets)
            let parameters = ["foo": ["a", 1, true]]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=a&foo=1&foo=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyDictionaryValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["bar": 1]]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%5Bbar%5D=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyNestedDictionaryValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["bar": ["baz": 1]]]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%5Bbar%5D%5Bbaz%5D=1")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyNestedDictionaryArrayValueParameter() {
        do {
            // Given
            let parameters = ["foo": ["bar": ["baz": ["a", 1, true]]]]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            let expectedQuery = "foo%5Bbar%5D%5Bbaz%5D%5B%5D=a&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1&foo%5Bbar%5D%5Bbaz%5D%5B%5D=1"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyNestedDictionaryArrayValueParameterWithoutBrackets() {
        do {
            // Given
            let encoding = CLDNURLEncoding(arrayEncoding: .noBrackets)
            let parameters = ["foo": ["bar": ["baz": ["a", 1, true]]]]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            let expectedQuery = "foo%5Bbar%5D%5Bbaz%5D=a&foo%5Bbar%5D%5Bbaz%5D=1&foo%5Bbar%5D%5Bbaz%5D=1"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterLiteralBoolEncodingWorksAndDoesNotAffectNumbers() {
        do {
            // Given
            let encoding = CLDNURLEncoding(boolEncoding: .literal)
            let parameters: [String: Any] = [
                // Must still encode to numbers
                "a": 1,
                "b": 0,
                "c": 1.0,
                "d": 0.0,
                "e": NSNumber(value: 1),
                "f": NSNumber(value: 0),
                "g": NSNumber(value: 1.0),
                "h": NSNumber(value: 0.0),

                // Must encode to literals
                "i": true,
                "j": false,
                "k": NSNumber(value: true),
                "l": NSNumber(value: false)
            ]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "a=1&b=0&c=1&d=0&e=1&f=0&g=1&h=0&i=true&j=false&k=true&l=false")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: Tests - All Reserved / Unreserved / Illegal Characters According to RFC 3986

    func testThatReservedCharactersArePercentEscapedMinusQuestionMarkAndForwardSlash() {
        do {
            // Given
            let generalDelimiters = ":#[]@"
            let subDelimiters = "!$&'()*+,;="
            let parameters = ["reserved": "\(generalDelimiters)\(subDelimiters)"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            let expectedQuery = "reserved=%3A%23%5B%5D%40%21%24%26%27%28%29%2A%2B%2C%3B%3D"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatReservedCharactersQuestionMarkAndForwardSlashAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["reserved": "?/"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "reserved=?/")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatUnreservedNumericCharactersAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["numbers": "0123456789"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "numbers=0123456789")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatUnreservedLowercaseCharactersAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["lowercase": "abcdefghijklmnopqrstuvwxyz"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "lowercase=abcdefghijklmnopqrstuvwxyz")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatUnreservedUppercaseCharactersAreNotPercentEscaped() {
        do {
            // Given
            let parameters = ["uppercase": "ABCDEFGHIJKLMNOPQRSTUVWXYZ"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "uppercase=ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatIllegalASCIICharactersArePercentEscaped() {
        do {
            // Given
            let parameters = ["illegal": " \"#%<>[]\\^`{}|"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            let expectedQuery = "illegal=%20%22%23%25%3C%3E%5B%5D%5C%5E%60%7B%7D%7C"
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: Tests - Special Character Queries

    func testURLParameterEncodeStringWithAmpersandKeyStringWithAmpersandValueParameter() {
        do {
            // Given
            let parameters = ["foo&bar": "baz&qux", "foobar": "bazqux"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo%26bar=baz%26qux&foobar=bazqux")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringWithQuestionMarkKeyStringWithQuestionMarkValueParameter() {
        do {
            // Given
            let parameters = ["?foo?": "?bar?"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "?foo?=?bar?")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringWithSlashKeyStringWithQuestionMarkValueParameter() {
        do {
            // Given
            let parameters = ["foo": "/bar/baz/qux"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "foo=/bar/baz/qux")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringWithSpaceKeyStringWithSpaceValueParameter() {
        do {
            // Given
            let parameters = [" foo ": " bar "]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "%20foo%20=%20bar%20")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringWithPlusKeyStringWithPlusValueParameter() {
        do {
            // Given
            let parameters = ["+foo+": "+bar+"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "%2Bfoo%2B=%2Bbar%2B")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyPercentEncodedStringValueParameter() {
        do {
            // Given
            let parameters = ["percent": "%25"]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "percent=%2525")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringKeyNonLatinStringValueParameter() {
        do {
            // Given
            let parameters = [
                "french": "français",
                "japanese": "日本語",
                "arabic": "العربية",
                "emoji": "😃"
            ]

            // When
            let urlRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            let expectedParameterValues = [
                "arabic=%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9",
                "emoji=%F0%9F%98%83",
                "french=fran%C3%A7ais",
                "japanese=%E6%97%A5%E6%9C%AC%E8%AA%9E"
            ]

            let expectedQuery = expectedParameterValues.joined(separator: "&")
            XCTAssertEqual(urlRequest.url?.query, expectedQuery)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringForRequestWithPrecomposedQuery() {
        do {
            // Given
            let url = URL(string: "https://example.com/movies?hd=[1]")!
            let parameters = ["page": "0"]

            // When
            let urlRequest = try encoding.CLDN_Encode(URLRequest(url: url), with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "hd=%5B1%5D&page=0")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringWithPlusKeyStringWithPlusValueParameterForRequestWithPrecomposedQuery() {
        do {
            // Given
            let url = URL(string: "https://example.com/movie?hd=[1]")!
            let parameters = ["+foo+": "+bar+"]

            // When
            let urlRequest = try encoding.CLDN_Encode(URLRequest(url: url), with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "hd=%5B1%5D&%2Bfoo%2B=%2Bbar%2B")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testURLParameterEncodeStringWithThousandsOfChineseCharacters() {
        do {
            // Given
            let repeatedCount = 2_000
            let url = URL(string: "https://example.com/movies")!
            let parameters = ["chinese": String(repeating: "一二三四五六七八九十", count: repeatedCount)]

            // When
            let urlRequest = try encoding.CLDN_Encode(URLRequest(url: url), with: parameters)

            // Then
            var expected = "chinese="

            for _ in 0..<repeatedCount {
                expected += "%E4%B8%80%E4%BA%8C%E4%B8%89%E5%9B%9B%E4%BA%94%E5%85%AD%E4%B8%83%E5%85%AB%E4%B9%9D%E5%8D%81"
            }

            XCTAssertEqual(urlRequest.url?.query, expected)
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    // MARK: Tests - Varying HTTP Methods

    func testThatURLParameterEncodingEncodesGETParametersInURL() {
        do {
            // Given
            var mutableURLRequest = self.urlRequest
            mutableURLRequest.httpMethod = CLDNHTTPMethod.get.rawValue
            let parameters = ["foo": 1, "bar": 2]

            // When
            let urlRequest = try encoding.CLDN_Encode(mutableURLRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "bar=2&foo=1")
            XCTAssertNil(urlRequest.value(forHTTPHeaderField: "Content-Type"), "Content-Type should be nil")
            XCTAssertNil(urlRequest.httpBody, "HTTPBody should be nil")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatURLParameterEncodingEncodesPOSTParametersInHTTPBody() {
        do {
            // Given
            var mutableURLRequest = self.urlRequest
            mutableURLRequest.httpMethod = CLDNHTTPMethod.post.rawValue
            let parameters = ["foo": 1, "bar": 2]

            // When
            let urlRequest = try encoding.CLDN_Encode(mutableURLRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded; charset=utf-8")
            XCTAssertNotNil(urlRequest.httpBody, "HTTPBody should not be nil")

            if let httpBody = urlRequest.httpBody, let decodedHTTPBody = String(data: httpBody, encoding: .utf8) {
                XCTAssertEqual(decodedHTTPBody, "bar=2&foo=1")
            } else {
                XCTFail("decoded http body should not be nil")
            }
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testThatURLEncodedInURLParameterEncodingEncodesPOSTParametersInURL() {
        do {
            // Given
            var mutableURLRequest = self.urlRequest
            mutableURLRequest.httpMethod = CLDNHTTPMethod.post.rawValue
            let parameters = ["foo": 1, "bar": 2]

            // When
            let urlRequest = try CLDNURLEncoding.queryString.CLDN_Encode(mutableURLRequest, with: parameters)

            // Then
            XCTAssertEqual(urlRequest.url?.query, "bar=2&foo=1")
            XCTAssertNil(urlRequest.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertNil(urlRequest.httpBody, "HTTPBody should be nil")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
}

// MARK: -

class JSONParameterEncodingTestCase: ParameterEncodingTestCase {
    // MARK: Properties

    let encoding = CLDNJSONEncoding.default

    // MARK: Tests

    func testJSONParameterEncodeNilParameters() {
        do {
            // Given, When
            let URLRequest = try encoding.CLDN_Encode(self.urlRequest, with: nil)

            // Then
            XCTAssertNil(URLRequest.url?.query, "query should be nil")
            XCTAssertNil(URLRequest.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertNil(URLRequest.httpBody, "HTTPBody should be nil")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testJSONParameterEncodeComplexParameters() {
        do {
            // Given
            let parameters: [String: Any] = [
                "foo": "bar",
                "baz": ["a", 1, true],
                "qux": [
                    "a": 1,
                    "b": [2, 2],
                    "c": [3, 3, 3]
                ]
            ]

            // When
            let URLRequest = try encoding.CLDN_Encode(self.urlRequest, with: parameters)

            // Then
            XCTAssertNil(URLRequest.url?.query)
            XCTAssertNotNil(URLRequest.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertEqual(URLRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertNotNil(URLRequest.httpBody)

            if let httpBody = URLRequest.httpBody {
                do {
                    let json = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)

                    if let json = json as? NSObject {
                        XCTAssertEqual(json, parameters as NSObject)
                    } else {
                        XCTFail("json should be an NSObject")
                    }
                } catch {
                    XCTFail("json should not be nil")
                }
            }
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testJSONParameterEncodeArray() {
        do {
            // Given
            let array: [String] = ["foo", "bar", "baz"]

            // When
            let URLRequest = try encoding.encode(self.urlRequest, withJSONObject: array)

            // Then
            XCTAssertNil(URLRequest.url?.query)
            XCTAssertNotNil(URLRequest.value(forHTTPHeaderField: "Content-Type"))
            XCTAssertEqual(URLRequest.value(forHTTPHeaderField: "Content-Type"), "application/json")
            XCTAssertNotNil(URLRequest.httpBody)

            if let httpBody = URLRequest.httpBody {
                do {
                    let json = try JSONSerialization.jsonObject(with: httpBody, options: .allowFragments)

                    if let json = json as? NSObject {
                        XCTAssertEqual(json, array as NSObject)
                    } else {
                        XCTFail("json should be an NSObject")
                    }
                } catch {
                    XCTFail("json should not be nil")
                }
            }
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }

    func testJSONParameterEncodeParametersRetainsCustomContentType() {
        do {
            // Given
            var mutableURLRequest = URLRequest(url: URL(string: "https://example.com/")!)
            mutableURLRequest.setValue("application/custom-json-type+json", forHTTPHeaderField: "Content-Type")

            let parameters = ["foo": "bar"]

            // When
            let urlRequest = try encoding.CLDN_Encode(mutableURLRequest, with: parameters)

            // Then
            XCTAssertNil(urlRequest.url?.query)
            XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Content-Type"), "application/custom-json-type+json")
        } catch {
            XCTFail("Test encountered unexpected error: \(error)")
        }
    }
}

// MARK: -

class UploaderEncodingTestCase: ParameterEncodingTestCase {
    func testUploadFolderDecouplingSimplifiedToRequest() throws {
        let uploadRequestParams = CLDUploadRequestParams()
        uploadRequestParams.setPublicIdPrefix("public_id_prefix")
        uploadRequestParams.setAssetFolder("asset_folder")
        uploadRequestParams.setDisplayName("display_name")
        uploadRequestParams.setUseFilenameAsDisplayName(true)
        uploadRequestParams.setFolder("folder/test")
        try checkParamsEncodedCorrectly(params: uploadRequestParams.params)
    }

    func testRenameFolderDecouplingSimplifiedToRequest() throws {
        var renameRequestParams = CLDRenameRequestParams(params: ["asset_folder": "asset_folder" as AnyObject, "display_name": "display_name"  as AnyObject, "public_id_prefix": "public_id_prefix"  as AnyObject])
        try checkParamsEncodedCorrectly(params: renameRequestParams.params)
    }

    func testExplicityFolderDecouplingSimplifiedToRequest() throws {
        let explicitRequestParams = CLDExplicitRequestParams()
        explicitRequestParams.setPublicIdPrefix("public_id_prefix")
        explicitRequestParams.setAssetFolder("asset_folder")
        explicitRequestParams.setDisplayName("display_name")
        explicitRequestParams.setUseFilenameAsDisplayName(true)
        explicitRequestParams.setFolder("folder/test")
        try checkParamsEncodedCorrectly(params: explicitRequestParams.params)
    }
}
