//
//  HPAPICacheManager.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 10.12.2024.
//

import Foundation

final class HPAPICacheManager {
    
    private var cacheDictionary: [HPEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setupCache()
    }
    
    public func cachedResponse(for endpoint: HPEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: HPEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    private func setupCache() {
        HPEndpoint.allCases.forEach { endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
