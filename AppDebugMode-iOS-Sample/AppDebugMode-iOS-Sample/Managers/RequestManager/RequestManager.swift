//
//  RequestManager.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Foundation
import Combine
import GoodNetworking
import Alamofire
import AppDebugMode


import SwiftUI


final class RequestManager: RequestManagerType {

    enum ApiServer: String {

        case base

        var rawValue: String {
#if DEBUG
            return AppDebugModeProvider.shared.getSelectedServer(for: Constants.ServersCollections.sampleBackend).url
#else
            return Constants.ProdServer.url
#endif
        }

    }

    private let session: NetworkSession

    init(baseServer: ApiServer) {
        let configuration = URLSessionConfiguration.default
        setupInterceptor()
//        configuration.protocolClasses = [MockURLProtocol.self]
        session = NetworkSession(
            baseUrl: baseServer.rawValue,
            configuration: .init(
                urlSessionConfiguration: configuration,
                interceptor: nil,
                serverTrustManager: nil,
                eventMonitors: [LoggingEventMonitor(logger: OSLogLogger())]
            )
        )
    }

    func fetchCars(id: Int) -> AnyPublisher<CarResponse, AFError> {
        return session.request(endpoint: Endpoint.cars(id))
            .goodify()
            .eraseToAnyPublisher()
    }

    func fetchProducts(id: Int) -> AnyPublisher<ProductResponse, AFError> {
        return session.request(endpoint: Endpoint.products(id))
            .goodify()
            .eraseToAnyPublisher()
    }

}

// MARK: - MockURLProtocol

final class MockURLProtocol: URLProtocol {

    func getRequest(request: URLRequest) async -> URLRequest {
        if #available(iOS 17.0, *) {
            let provider = InterceptionProvider()
            return await provider.intercept(requestTo: request)
        } else {
            return request
        }
    }

    override func stopLoading() {}

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override func startLoading() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        Task {
            do {
                let newRequest = await getRequest(request: request)
                let task = session.dataTask(with: newRequest)
                task.resume()
            } catch {
                let task = session.dataTask(with: request)
                task.resume()
            }
        }
    }

}

// MARK: URLSessionDataDelegate

extension MockURLProtocol: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        guard let client = self.client else { return }
        if         
            let response = dataTask.response,
            let httpResponse = response as? HTTPURLResponse
        {
            let modifiedResponse = HTTPURLResponse(url: httpResponse.url!,
                                                   statusCode: 400, // Change the status code as needed
                                                   httpVersion: "HTTP/1.1",
                                                   headerFields: httpResponse.allHeaderFields as! [String: String])

            client.urlProtocol(self, didReceive: modifiedResponse!, cacheStoragePolicy: .notAllowed)
        } else {
            print("Parsing Error")
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }



}
