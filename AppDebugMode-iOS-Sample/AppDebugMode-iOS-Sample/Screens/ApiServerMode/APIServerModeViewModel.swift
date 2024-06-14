//
//  APIServerModeViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Combine
import Alamofire
#if DEBUG
import AppDebugMode
#endif
import Factory

@MainActor
final class APIServerModeViewModel: ObservableObject {

    // MARK: - Factory

    @Injected(\.requestManager) private var requestManager
    @Injected(\.urlProvider) private var urlProvider

    // MARK: - Enums
    
    enum CarFetchingState {
        
        case idle
        case loading
        case success(CarResponse)
        case error(AFError)
        
    }
    
    enum LargeFetchingState {

        case idle
        case loading
        case success(LargeObjectResponse)
        case error(AFError)

    }

    enum ProductFetchingState {
        
        case idle
        case loading
        case success(ProductResponse)
        case error(AFError)
        
    }
     
    // MARK: - Variables - Computed
    
    var selectedServerName: String = ""
    var selectedServerURL: String = ""

    // MARK: - Combine
    
    @Published var largeResult: LargeFetchingState = .idle
    @Published var carResult: CarFetchingState = .idle
    @Published var productResult: ProductFetchingState = .idle

    // MARK: - Initializer
    
    init() {
        Task {
            self.selectedServerName = await Container.shared.urlProvider.resolve().resolveBaseUrl() ?? ""
        }
    }
    
}

extension APIServerModeViewModel {
    
    func fetchSimpleResponse() async {
        #if DEBUG
        await selectedServerName == Constants.devServer.name ? fetchProduct() : fetchCar()
        #else
        await selectedServerName == Constants.prodServer.name ? fetchProduct() : fetchCar()
        #endif
    }
    
    func fetchLargeObject() async {
        do {
            largeResult = .success(try await requestManager.fetchLargeObject())
        } catch {
            if let error = error as? AFError {
                largeResult = .error(error)
            }
        }
    }

    // MARK: - Helpers

    private func fetchCar() async {
        do {
            carResult = .success(try await requestManager.fetchCars(id: Int.random(in: 1...10)))
        } catch {
            if let error = error as? AFError {
                carResult = .error(error)
            }
        }
    }
    
    private func fetchProduct() async {
        do {
            productResult = .success(try await requestManager.fetchProducts(id: Int.random(in: 1...10)))
        } catch {
            if let error = error as? AFError {
                productResult = .error(error)
            }
        }
    }
    
}
