//
//  MockEndpoint.swift
//  Testios
//
//  Created by Chad Garrett on 2021/12/08.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation

/// Service to mock fetching an object from an endpoint
final class MockEndpoint<T> {

    /// Mocks fetching data from an endpoint with a default delay of 2 seconds
    /// - Parameters:
    ///   - object: The object to be returned from the mock endpoint, results with an error if not provided
    ///   - delay: Fake delay to mimic a network request
    ///   - result: Outcome of the mock endpoint
    internal func fetchData(_ object: T?, delay: TimeInterval = 2, _ onCompletion: @escaping (Result<T, AppError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            if let object = object {
                onCompletion(.success(object))
            } else {
                onCompletion(.failure(.apiError))
            }
        }
    }
}
