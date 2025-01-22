//
//  HPImageLoader.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 17.12.2024.
//

import Foundation

final class HPImageLoader {
    static let shared = HPImageLoader()
    private let imageDataCache = NSCache<NSString, NSData>()
    private var runningTasks = [UUID: URLSessionDataTask]()
    
    private init() {}
    
    @discardableResult
    public func fetchImage(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> UUID? {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return nil
        }
        
        let uuid = UUID()
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            defer { self?.runningTasks.removeValue(forKey: uuid) }
            
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
        
        runningTasks[uuid] = task
        return uuid
    }
    
    public func cancelLoad(_ uuid: UUID) {
        runningTasks[uuid]?.cancel()
        runningTasks.removeValue(forKey: uuid)
    }
}
