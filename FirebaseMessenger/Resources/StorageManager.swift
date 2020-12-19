//
//  StorageManager.swift
//  FirebaseMessenger
//
//  Created by Muhammed Emin Aydın on 15.12.2020.
//

import Foundation
import FirebaseStorage

final class StorageManeger {
    static let shared = StorageManeger()
    
    private let storage = Storage.storage().reference()
    
    typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    
    /// Upload picture to firebase storage and returns completion with url string to download
    /// - Parameters:
    ///   - data: Profile picture data
    ///   - fileName: Profile picture filename
    ///   - completion: Upload picture to databese
    public func uploadProfilePicture(with data: Data,
                                     fileName: String,
                                     completion: @escaping UploadPictureCompletion) {
        
        storage.child("images/\(fileName)").putData(data, metadata: nil) { (metadata, error) in
            guard error == nil else{
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { (url, error) in
                guard let url = url else {
                    print("Failed to get download url")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    
    public func donwloadUrl(for path: String, completion: @escaping ((Result<URL, Error>) -> Void)) {
        let reference = storage.child(path)
        reference.downloadURL { (url, error) in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        }
    }
    
}
