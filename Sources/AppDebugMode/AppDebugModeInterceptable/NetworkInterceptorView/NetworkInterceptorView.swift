//
//  NetworkInterceptorView.swift
//  AppDebugModeInterceptable-iOS
//
//  Created by Filip Šašala on 21/02/2024.
//
#if canImport(GoodNetworking_Shared)

import Alamofire
import AsyncQueue
import GoodNetworking_Shared
import Observation
import SwiftUI

// MARK: - Provider

@available(iOS 17.0, *)
public actor InterceptionProvider {

    private let interceptionQueue = ActorQueue<InterceptionProvider>()
    private weak var interceptorViewModel: NetworkInterceptorViewModel?

    internal init() {
        interceptionQueue.adoptExecutionContext(of: self)
    }

    nonisolated public func intercept(requestTo endpoint: Endpoint) async -> Endpoint {
        guard interceptorEnabled else { return endpoint }

        return await interceptionQueue.enqueueAndWait { actor in
            guard let interceptorViewModel = actor.interceptorViewModel else { preconditionFailure() }
            
            while true {
                guard !interceptorViewModel.isIntercepting else {
                    try? await Task.sleep(nanoseconds: UInt64(1e9)) // prevent actor reentrancy issues (?)
                    continue
                }
                return await interceptorViewModel.startInterception(of: endpoint)
            }
        }
    }

    func bind(viewModel: NetworkInterceptorViewModel) {
        self.interceptorViewModel = viewModel
    }

}

// MARK: - ViewModel

@available(iOS 17.0, *)
@Observable public final class NetworkInterceptorViewModel {

    enum State: Equatable {

        case idle
        case autocontinue(Endpoint, in: TimeInterval)
        case editing(Endpoint)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.autocontinue, .autocontinue), (.editing, .editing):
                return true

            default:
                return false
            }
        }

    }

    var state: State = .idle

    var isIntercepting: Bool {
        return if case .idle = state { false } else { true }
    }

    var isEditing: Bool {
        get {
            return if case let .editing(_) = self.state { true } else { false }
        }
        set {
            guard let endpoint else { return }
            self.state = newValue ? .editing(endpoint) : .autocontinue(endpoint, in: 1)
        }
    }

    var timeLeft: TimeInterval {
        get {
            switch state {
            case .autocontinue(_, let seconds):
                return seconds

            case .idle:
                return 0

            case .editing:
                return .infinity
            }
        }
        set {
            switch state {
            case .autocontinue(let endpoint, let seconds):
                self.state = .autocontinue(endpoint, in: newValue)

            default:
                break
            }
        }
    }

    var endpoint: Endpoint? {
        switch state {
        case .idle:
            return nil

        case .autocontinue(let endpoint, _):
            return endpoint

        case .editing(let endpoint):
            return endpoint
        }
    }

    public init(endpoint: Endpoint? = nil) {
        Task {
            await withInterceptionProvider { provider in
                await provider.bind(viewModel: self)
                if let endpoint { await provider.intercept(requestTo: endpoint) }
            }
        }
    }

    func startInterception(of endpoint: Endpoint) async -> Endpoint {
        self.state = .autocontinue(endpoint, in: interceptorAutocontinueDelay)

        while timeLeft > 0 {
            try? await Task.sleep(nanoseconds: UInt64(1e9)) // 1 second
            timeLeft -= 1
        }

        if let updatedEndpoint = self.endpoint {
            self.state = .idle
            return updatedEndpoint
        } else {
            self.state = .idle
            return endpoint
        }
    }

    func updateEndpoint(_ newValue: Endpoint) {
        switch self.state {
        case .idle:
            Task { await withInterceptionProvider { provider in await provider.intercept(requestTo: newValue) }}

        case .autocontinue(_, let seconds):
            self.state = .autocontinue(newValue, in: seconds)

        case .editing:
            self.state = .editing(newValue)
        }
    }

}

// MARK: - View

@available(iOS 17.0, *)
public struct NetworkInterceptorView: View {

    @Namespace private var animation
    @Bindable var viewModel: NetworkInterceptorViewModel

    public init(viewModel: NetworkInterceptorViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        dynamicIslandView {
            if let endpoint = viewModel.endpoint {
                dynamicIslandInterceptingView(endpoint: endpoint)
                    .transition(.opacity)
            } else {
                Text("👀")
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring)
        .ignoresSafeArea()
        .statusBarHidden(viewModel.isIntercepting)
        .sheet(
            isPresented: $viewModel.isEditing,
            content: {
                if let endpoint = viewModel.endpoint {
                    NetworkInterceptorEditingFormView(
                        endpoint: Binding(
                            get: { MutableEndpoint(endpoint) },
                            set: { viewModel.updateEndpoint($0) }
                        ),
                        isEditing: $viewModel.isEditing
                    )
                } else {
                    Text("No endpoint available for intercepting")
                }
            }
        )
    }

    func dynamicIslandInterceptingView(endpoint: Endpoint) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Image(systemName: "automatic.brakesignal")
                    ProgressView(
                        value: Float(min(viewModel.timeLeft, .greatestFiniteMagnitude)),
                        total: Float(interceptorAutocontinueDelay)
                    )
                    .progressViewStyle(.automatic)
                    .frame(maxWidth: 60)
                }
                .foregroundStyle(.tint)

                Spacer()

                Button(action: {
                    viewModel.isEditing.toggle()
                }, label: {
                    Text("Edit")
                })
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Color.white.frame(height: 1 / UIScreen.main.nativeScale)

            endpointView(endpoint: endpoint)
                .padding(.horizontal)
                .padding(.vertical, 8)
        }
    }

    func endpointView(endpoint: Endpoint) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // HTTP Method and path
            Label(
                title: {
                    Group {
                        Text("\(endpoint.method.rawValue) ")
                            .foregroundStyle(endpoint.method.color)
                            .bold()

                        +

                        Text("\(endpoint.path)")
                    }
                    .lineLimit(1)
                },
                icon: { Image(systemName: "flag.checkered") }
            )

            // Top 4 headers
            Label(
                title: {
                    Text("\(endpoint.headers?.fancyDescription ?? "No headers")")
                        .lineLimit(4)
                        .monospaced()
                },
                icon: { Image(systemName: "apple.terminal.fill") }
            )


        }
        .foregroundStyle(.white)
    }

    func dynamicIslandView(@ViewBuilder content: @escaping () -> some View) -> some View {
        GeometryReader { proxy in
            let maximumExpandedInterceptingIslandWidth: CGFloat = 350
            let maximumExpandedInterceptingIslandHeight: CGFloat = 250

            let dynamicIslandSize = CGRect(
                x: (proxy.size.width / 2) - (125.66 / 2),
                y: 11.3333,
                width: 125.66,
                height: 37
            )
            let interceptingIslandSize = CGRect(
                x: viewModel.isIntercepting ? (proxy.size.width / 2) - (maximumExpandedInterceptingIslandWidth / 2) : dynamicIslandSize.width,
                y: dynamicIslandSize.minY,
                width: viewModel.isIntercepting ? maximumExpandedInterceptingIslandWidth : dynamicIslandSize.width,
                height: viewModel.isIntercepting ? maximumExpandedInterceptingIslandHeight : dynamicIslandSize.height
            )

            ZStack {
                RoundedRectangle(cornerRadius: 18.5, style: .circular)
                content()
            }
            .frame(
                minWidth: dynamicIslandSize.width,
                maxWidth: interceptingIslandSize.width,
                minHeight: dynamicIslandSize.height,
                maxHeight: interceptingIslandSize.height
            )
            .padding(.horizontal, interceptingIslandSize.minX)
            .padding(.vertical, interceptingIslandSize.minY)
            .fixedSize(horizontal: false, vertical: true)
            .background { dynamicIslandWindowSizeInterceptor() }
            .onAppear { print("IS KURWA INTERCEPTING OR NOT: \(viewModel.isIntercepting) STATE \(viewModel.state)") }
        }
    }

    func dynamicIslandWindowSizeInterceptor() -> some View {
        GeometryReader { dynamicIslandProxy in
            Color.clear.onChange(of: viewModel.state, initial: true) {
                if viewModel.isEditing {
                    InterceptorWindow.interceptorBounds = UIScreen.main.bounds
                } else {
                    InterceptorWindow.interceptorBounds = dynamicIslandProxy.frame(in: .global)
                }
            }
        }
    }

}

// MARK: - Edit form

@available(iOS 17.0, *)
struct NetworkInterceptorEditingFormView: View {

    @Binding var endpoint: MutableEndpoint
    @Binding var isEditing: Bool

    @ViewBuilder var body: some View {
        NavigationStack {
            content
                .navigationTitle("Edit request")
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var content: some View {
        Form {
            Section("Path") {
                TextField("Path", text: $endpoint.path)
            }

            Section("Method") {
                TextField("Path", text: Binding(
                    get: { endpoint.method.rawValue },
                    set: { endpoint.method = HTTPMethod(rawValue: $0) }
                ))
            }

            Section("Headers") {
                let headers = endpoint.headers?.dictionary.sorted(by: { $0.key < $1.key }) ?? []
                ForEach(headers, id: \.key) { header in
                    HStack {
                        Text(header.key)
                        TextField("Value", text: Binding(
                            get: { header.value },
                            set: { newValue in endpoint.headers?.update(name: header.key, value: newValue) }
                        ))
                    }
                }
            }

            Button(action: {
                isEditing.toggle()
            }, label: {
                Text("Close and send")
            })
        }
    }

}

// MARK: - Extensions

struct MutableEndpoint: Endpoint {

    private let originalEndpoint: Endpoint

    init(_ endpoint: Endpoint) {
        self.originalEndpoint = endpoint
        self.path = endpoint.path
        self.method = endpoint.method
        self.headers = endpoint.headers
        self.encoding = endpoint.encoding
        self.parameters = endpoint.parameters
    }

    var path: String
    var method: HTTPMethod
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding
    var parameters: EndpointParameters?

    func url(on baseUrl: String) throws -> URL {
        return try baseUrl.asURL().appendingPathComponent(path)
    }

}

extension Alamofire.HTTPMethod {

    var color: Color {
        switch self {
        case .get:
            Color.green

        case .post:
            Color.orange

        case .put, .patch:
            Color.yellow

        case .delete:
            Color.red

        default:
            Color.white
        }
    }

}

extension Alamofire.HTTPHeaders {

    var fancyDescription: String {
        self.dictionary
            .sorted(by: { $0.key < $1.key })
            .map { key, value in "\(key): \(String(value[..<String.Index(utf16Offset: value.count > 20 ? 20 : value.count - 1, in: value)]))" }
            .joined(separator: "\n")
    }

}

// MARK: - Previews

@available(iOS 17.0, *)
struct NetworkInterceptorView_Previews: PreviewProvider {

    static var previews: some View {
        NetworkInterceptorView(
            viewModel: NetworkInterceptorViewModel(
                endpoint: TestEndpoint.test
            )
        )
    }

}

enum TestEndpoint: Endpoint {

    case test

    var path: String {
        "/users?query=123672839109IUJHNSIDA87ZH"
    }

    var method: Alamofire.HTTPMethod {
        .post
    }

    var headers: Alamofire.HTTPHeaders? {
        [
            "Auth": "jajajajajajajjajajajaquery=123672839109IUJHNSIDA87ZH",
            "X-Custom": "something went wrong",
            "X-Country": "de_DE",
            "X-Country-2": "de_DE",
            "X-Country-3": "de_DE",
            "X-Country-4": "de_DE",
            "X-Country-5": "de_DE",
            "X-Country-6": "de_DE"
        ]
    }

    var encoding: Alamofire.ParameterEncoding {
        JSONEncoding.default
    }

    var parameters: GoodNetworking_Shared.EndpointParameters? {
        nil
    }

    func url(on baseUrl: String) throws -> URL {
        fatalError()
    }


}
#endif
