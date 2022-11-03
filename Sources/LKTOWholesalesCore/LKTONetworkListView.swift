//
//  SwiftUIView.swift
//  
//
//  Created by Lynkto_2 on 10/28/22.
//

import SwiftUI



enum LKTOResoure<T> {
   
    
    case loading
    case succes(T)
    case failure(LKTOError)
    
    var data: T? {
        switch self {
        case .succes(let t): return t
        default: return nil
        }
    }
    
    var error: LKTOError? {
        switch self {
        case .failure(let t): return t
        default: return nil
        }
    }
    
}



@available(iOS 13.0, *)
public class LKTONetworkListHandlerViewModel<Model: Decodable>: ObservableObject {
    public var lktonetworkRequest: LKTONetworkRequest
    
    @Published  var resource: LKTOResoure<LKTOListResponse<Model>> = .loading
    
    public init(_ lktonetworkRequest: LKTONetworkRequest) {
        self.lktonetworkRequest = lktonetworkRequest
    }
    
    public func refreshUI() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    public func fetch() {
        self.lktonetworkRequest.resume { result in
            switch result {
            case .success(let serialize):
                let response: LKTOListResponse<Model>? = serialize.decode()
                DispatchQueue.main.async {
                self.resource = .succes(response!)
                }
                
                self.refreshUI()
                
            case .failure(let failure):
                self.resource = .failure(failure)
                self.refreshUI()
            }
        }
        
    }
    
    public func onAppear(isRefresh: Bool) {
        fetch()
    }
    
}


@available(iOS 13.0, *)
public class LKTONetworkNonListHandlerViewModel<Model: Decodable>: ObservableObject {
    public var lktonetworkRequest: LKTONetworkRequest
    
    @Published  var resource: LKTOResoure<LKTODictionaryResponse<Model>> = .loading
    
    public init(_ lktonetworkRequest: LKTONetworkRequest) {
        self.lktonetworkRequest = lktonetworkRequest
    }
    
    public func refreshUI() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    public func fetch() {
        self.lktonetworkRequest.resume { result in
            switch result {
            case .success(let serialize):
                let response: LKTODictionaryResponse<Model>? = serialize.decode()
                DispatchQueue.main.async {
                  
                        self.resource = .succes(response!)
                   
                }
                self.refreshUI()
                
            case .failure(let failure):
                self.resource = .failure(failure)
                self.refreshUI()
            }
        }
        
    }
    
    public func onAppear(isRefresh: Bool) {
        fetch()
    }
    
}

// Button with network action
@available(iOS 14.0.0, *)
public struct LKTONetworkButtonView<Label: View, Model: Decodable>: View {
    public var title: String = "NEXT"
    public let requestViewModel: LKTONetworkNonListHandlerViewModel<Model>
    public let label: (_ title: String) -> Label
    public let getParams: () -> [String: String]?
    public let onResponse: (Model)-> Void
    @State var showLoader = false
    
    public init(title: String, requestViewModel: LKTONetworkNonListHandlerViewModel<Model>, @ViewBuilder label: @escaping (_ title: String) -> Label, getParams: @escaping() -> [String: String]?, onResponse: @escaping(Model) ->Void) {
        self.title = title
        self.requestViewModel = requestViewModel
        self.label = label
        self.getParams = getParams
        self.onResponse = onResponse
    }
    
    public var body: some View {
        VStack {
            if showLoader {
                ProgressView()
            } else {
                Button {
                    showLoader = true
                    // action
                    requestViewModel.lktonetworkRequest.forceRefresh = true
                    requestViewModel.lktonetworkRequest.endpoint.params = getParams()
                    requestViewModel.onAppear(isRefresh: false)
                    
                } label: {
                    
                    label(title)
                }
            }
        }.onReceive(requestViewModel.objectWillChange) { _ in
            showLoader = false
            if let data = requestViewModel.resource.data {
                onResponse(data.data)
                return
            }
            if let error = requestViewModel.resource.error {
                print(error)
            }
            
        }
        
    }
}


@available(iOS 14.0.0, *)
public struct LKTONetworkDetailsView<Model: Decodable , Content: View>: View {
    public let viewModel: LKTONetworkNonListHandlerViewModel<Model>
    public let content: (_ items: Model) -> Content
    public let callOnAppear: Bool
    public init(viewModel: LKTONetworkNonListHandlerViewModel<Model>, callonAppear: Bool = true, content: @escaping (_: Model) -> Content) {
        self.viewModel = viewModel
        self.content = content
        self.callOnAppear = callonAppear
    }
    
     @State public var refresh = false
    
    public var body: some View {
        Group {
            if refresh || !refresh {
                 if viewModel.resource.data != nil {
                     content(viewModel.resource.data!.data)
                 } else if viewModel.resource.error != nil {
                    Text("\(viewModel.resource.error?.localizedDescription ?? "Error")")
                 } else {
                     ProgressView()
                 }
            }
        }
        .onReceive(viewModel.objectWillChange, perform: { _ in
            refresh.toggle()
        })
        .onAppear(perform: {
            if callOnAppear {
             viewModel.onAppear(isRefresh: false)
            }
        })
    }
}

@available(iOS 14.0.0, *)
public struct LKTONetworkListView<Model: Decodable & Identifiable, Content: View>: View {
    public let viewModel: LKTONetworkListHandlerViewModel<Model>
    public let content: (_ items: [Model]) -> Content
    
    public init(viewModel: LKTONetworkListHandlerViewModel<Model>, content: @escaping (_: [Model]) -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
    
     @State public var refresh = false
    
    public var body: some View {
        Group {
            if refresh || !refresh {
                 if viewModel.resource.data != nil {
                    content(viewModel.resource.data?.data ?? [])
                 } else if viewModel.resource.error != nil {
                    Text("\(viewModel.resource.error?.localizedDescription ?? "Error")")
                 } else {
                     ProgressView()
                 }
            }
        }
        .onReceive(viewModel.objectWillChange, perform: { _ in
            refresh.toggle()
        })
        .onAppear(perform: {
            viewModel.onAppear(isRefresh: false)
        })
    }
}




