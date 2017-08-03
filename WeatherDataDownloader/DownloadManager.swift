//
//  DownloadManager.swift
//  WeatherDataDownloader
//
//  Created by Gaurav Bhatia on 01/08/17.
//  Copyright © 2017 Gaurav Bhatia. All rights reserved.
//

import Foundation
class DownloadManager {

    static let sharedInstance = DownloadManager()
    
    func downloadFileAtURL(downloadURL:URL, downloadPath:URL, completionHandler:@escaping (_ donwloadPath : String) -> (), failureHandler:@escaping (_ error:Error)->())  {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:downloadURL)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
//                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do
                {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: downloadPath)
                }
                catch (let writeError)
                {
//                    print("Error creating a file \(downloadPath) : \(writeError)")
                    failureHandler(writeError)
                }
                completionHandler(downloadPath.absoluteString)
            }
            else
            {
//                print("Error description: %@", error?.localizedDescription ?? "Failed to copy");
                failureHandler(error!)

            }
        }
        task.resume()
        
    }
}
    
    
    
