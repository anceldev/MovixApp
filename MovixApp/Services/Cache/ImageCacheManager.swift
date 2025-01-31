//
//  ImageCacheManager.swift
//  MovixApp
//
//  Created by Ancel Dev account on 24/1/25.
//

import Foundation
import SwiftUI

@MainActor
class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let memoryCache: MemoryImageCache
    private let diskCache: DiskCacheImage
    
    private init() {
        self.memoryCache = MemoryImageCache()
        do {
            self.diskCache = try DiskCacheImage()
        } catch {
            fatalError("Cache in disk cannot be initialized: \(error.localizedDescription)")
        }
    }
    
    func getImage(forKey key: String) async throws -> UIImage? {
        if let image = try await memoryCache.getImage(forKey: key) {
            return image
        }
        
        if let image = try await diskCache.getImage(forKey: key) {
            try await memoryCache.saveImage(image, forKey: key)
            return image
        }
        return nil
    }
    func saveImage(_ image: UIImage, forKey key: String) async throws {
        try await memoryCache.saveImage(image, forKey: key)
        try await diskCache.saveImage(image, forKey: key)
    }
    func clearCache() async throws {
        try await memoryCache.clearCache()
        try await diskCache.clearCache()
    }
}
