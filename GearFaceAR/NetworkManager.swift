//
//  NetworkManager.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 11/20/20.
//

import Foundation
import ARGearRenderer

let API_HOST = "https://apis.argear.io/api/v3/"
let API_KEY = "2f7b45e1314ef1d07abb3959"
let API_SECRET_KEY = "2986ecc1ee2ffadc6927a382674d8ab40d44c79da45aab8cc9326590295448f5"
let API_AUTH_KEY = "U2FsdGVkX1+1i2drSO5bSf2oLmSL/ktq+NUuMA1lWEcvAw0/maN3uxJJVtjTsoEp"

class NetworkManager {

    static let shared = NetworkManager()
    
    var argSession: ARGSession?
    
    init() {
    }
    
    func connectAPI() {
        
        let urlString = API_HOST + API_KEY
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                }
            }
        }
        task.resume()
    }

    func downloadItem(url: String?, title: String?, type: String?) {
        
        let authCallback : ARGAuthCallback = {(url: String?, code: ARGStatusCode) in
            if (code.rawValue == ARGStatusCode.SUCCESS.rawValue) {
                let downloadUrl = URL(string: url!)!
                let task = URLSession.shared.downloadTask(with: downloadUrl) { (url, response, error) in

                    if let error = error {
                        print("error: \(error)")
                    } else {
                        if let _ = response as? HTTPURLResponse {
                        }

                        var cachesDirectory: URL? = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
                        cachesDirectory?.appendPathComponent((response?.suggestedFilename)!)

                        if let targetPath = url, let caches = cachesDirectory {

                            let fileManager = FileManager.default
                            do {
                                try fileManager.copyItem(at: targetPath, to: caches)
                            } catch _ {
                            }

                            if let session = self.argSession, let contents = session.contents {

                                var itemType: ARGContentItemType = .sticker
                                if let typeString = type {
                                    if typeString == "filter" {
                                        itemType = .filter
                                    }
                                }
                                contents.setItemWith(itemType, withItemFilePath: caches.absoluteString, withItemID: caches.deletingPathExtension().lastPathComponent) { (success, msg) in
                                    if (success) {
                                        NSLog("success");
                                    } else {
                                        NSLog("fail");
                                    }
                                }
                            }
                        }
                    }
                }
                task.resume()
            } else {
                
            }
        }

        if let session = self.argSession, let auth = session.auth {
            auth.requestSignedUrl(withUrl: url ?? "", itemTitle: title ?? "", itemType: type ?? "", completion: authCallback)
        }
    }
}
