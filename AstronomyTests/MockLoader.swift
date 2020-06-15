//
//  MockLoader.swift
//  AstronomyTests
//
//  Created by Marissa Gonzales on 6/15/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

@testable import Astronomy

class MockLoader: NetworkDataLoader {

    var url: URL?
    var request: URLRequest?
    var data: Data?
    var error: Error?

    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        self.request = request
        DispatchQueue.global(qos: .background).async {
            completion(self.data, self.error)
        }
    }

    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        self.url = url
        DispatchQueue.global(qos: .background).async {
            completion(self.data, self.error)
        }
    }
}

