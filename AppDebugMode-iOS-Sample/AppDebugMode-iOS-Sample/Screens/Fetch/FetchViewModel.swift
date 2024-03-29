//
//  HomeViewModel.swift
//  AppDebugMode-iOS-Sample
//
//  Created by Lukas Kubaliak on 14/09/2023.
//

import Combine
import Alamofire
#if DEBUG
import AppDebugMode
#endif

final class FetchViewModel {
    
    // MARK: - TypeAliases
    
    typealias DI = WithRequestManager
    
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
    
    // MARK: - Constants
    
    private let di: DI
    private let coordinator: Coordinator<AppStep>
    
    // MARK: - Variables - Computed
    
    var selectedServerName: String {
        #if DEBUG
        return AppDebugModeProvider.shared.getSelectedServer(for: Constants.ServersCollections.sampleBackend).name
        #else
        return Constants.ProdServer.name
        #endif
    }
    
    var selectedServerURL: String {
        #if DEBUG
        return AppDebugModeProvider.shared.getSelectedServer(for: Constants.ServersCollections.sampleBackend).url
        #else
        return Constants.ProdServer.url
        #endif
    }
    
    // MARK: - Combine
    
    var largeResult = CurrentValueSubject<LargeFetchingState, Never>(.idle)
    var carResult = CurrentValueSubject<CarFetchingState, Never>(.idle)
    var productResult = CurrentValueSubject<ProductFetchingState, Never>(.idle)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(di: DI, coordinator: Coordinator<AppStep>) {
        self.coordinator = coordinator
        self.di = di
    }
    
}

// MARK: - Public

extension FetchViewModel {
    
    func fetchResponse() {
        #if DEBUG
        selectedServerName == Constants.Servers.dev.name ? fetchProduct() : fetchCar()
        #else
        selectedServerName == Constants.DevServer.name ? fetchProduct() : fetchCar()
        #endif
    }
    
    func fetchLarge() {
        di.requestManager.fetchLarge()
            .map { LargeFetchingState.success($0) }
            .catch { Just(.error($0)) }
            .prepend(.loading)
            .sink { [weak self] result in self?.largeResult.send(result) }
            .store(in: &cancellables)
    }

    func fetchCar() {
        di.requestManager.fetchCars(id: Int.random(in: 1...10))
            .map { CarFetchingState.success($0) }
            .catch { Just(.error($0)) }
            .prepend(.loading)
            .sink { [weak self] result in self?.carResult.send(result) }
            .store(in: &cancellables)
    }
    
    func fetchProduct() {
        di.requestManager.fetchProducts(id: Int.random(in: 1...10))
            .map { ProductFetchingState.success($0) }
            .catch { Just(.error($0)) }
            .prepend(.loading)
            .sink { [weak self] result in self?.productResult.send(result) }
            .store(in: &cancellables)
    }
    
}
