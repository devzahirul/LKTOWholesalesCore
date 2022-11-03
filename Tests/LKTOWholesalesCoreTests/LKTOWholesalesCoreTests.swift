import XCTest
@testable import LKTOWholesalesCore




class MockNetworkRequestHandler: LKTONetworkRequestable {
    func handle(request: URLRequest, completion: @escaping (Result<Data, LKTOError>) -> Void) {
        
        if let data = readLocalFile(forName: "category") {
            
            print("Success: \(String(data: data, encoding: .utf8))")
            
            completion(.success(data))
        } else {
            
            completion(.success("This is just a test".data(using: .utf8)!))
        }
    }
}


class TestPlatForm: Platform {
  
    let mockNetworkRequestHandler = MockNetworkRequestHandler()
    func getNetwork() -> LKTOWholesalesCore.LKTONetwork {
        LKTONetwork(.test, requestHandler: mockNetworkRequestHandler)
    }
    
    static let shared = TestPlatForm()
    static func getShared() -> Platform {
        return shared
    }
}


class LKNToNetworkTest: XCTestCase {
    
    func test_create_init_network() {
        XCTAssertNotNil(TestPlatForm.getShared().getNetwork())
        XCTAssertEqual(TestPlatForm.getShared().getNetwork().environment.baseURL, TestPlatForm.shared.baseURL)
    }
    
    
    func test_createRequest_get_without_any_params() {
        
        
        
        let lktoNetworkRequest = TestPlatForm.getShared().getNetwork().createRequest(for: Endpoints.category)
       // XCTAssertNil(lktoNetworkRequest.endpoint.createURLRequest(for: lktoNetworkRequest.parent?.environment ?? .test)?.url?.absoluteString)
        
        
      //  let expectation = expectation(description: "")
        
        
        lktoNetworkRequest.resume { serializer in
            var categories: LKTOListResponse<CategoryModel>? = serializer.decode()
            XCTAssertNotNil(categories)
            
          //  expectation.fulfill()
         
        }
       // waitForExpectations(timeout: 2)
    }
    
}




private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            print("JSON DATA: \(String(data: jsonData, encoding: .utf8))")
            return jsonData
        }
    } catch {
        print("JSON file error")
        print(error)
    }
    
    return nil
}

