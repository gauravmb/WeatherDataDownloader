//
//  WeatherDataDownloader.swift
//  WeatherDataDownloader
//
//  Created by Gaurav Bhatia on 01/08/17.
//  Copyright © 2017 Gaurav Bhatia. All rights reserved.
//

import Foundation

class WeatherDataDownloader {
    static let sharedInstance = WeatherDataDownloader()
    
    func downloadWeatherData(regions:[String],weatherParameter:[String], completionHandler:@escaping(_ downloadedFilePaths:[String],_ region:[String],_ weatherType:[String] ) -> (), failureHandler:@escaping ()->()) {
        
        var downloadedFilePathArray = [String]()
        var region = [String]()
        var weather = [String]()

        var requestCompleted = 0
        let totalRequest = regions.count*weatherParameter.count
        let region_codes = regions
        let weather_params = weatherParameter
        
        for region_code in region_codes {
            var documentURL:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
            documentURL = documentURL.appendingPathComponent(region_code)
            do
            {
                        if(FileManager.default.fileExists(atPath: documentURL.absoluteString.replacingOccurrences(of: "file://", with: "")))
                        {
                            do
                            {
                                try FileManager.default.removeItem(at: documentURL)
                            }
                            catch
                            {
        
                            }
        
                        }
                try FileManager.default.createDirectory(at: documentURL, withIntermediateDirectories: false, attributes: nil)
            }
            catch
            {
                return
            }
            for weather_param in weather_params {
                let downloadURLString = String(format: "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/%@/ranked/%@.txt",weather_param,region_code)
                let downloadURL = URL(string:downloadURLString)
                
                let appendPath = String(format: "/%@.txt",weather_param)
                let destinationUrl = documentURL.appendingPathComponent(appendPath)
                
                DownloadManager.sharedInstance.downloadFileAtURL(downloadURL: downloadURL!, downloadPath: destinationUrl, completionHandler: { (downloadPath) in
                    print("DownloadPath:%@",downloadPath)
                    downloadedFilePathArray.append(downloadPath)
                    region.append(region_code)
                    weather.append(weather_param)

                    requestCompleted=requestCompleted+1
                    if(requestCompleted==totalRequest)
                    {
                        completionHandler(downloadedFilePathArray,region,weather)
                    }
                }, failureHandler: { (error) in
                    print("Error:%@",error.localizedDescription)
                    requestCompleted=requestCompleted+1
                    if(requestCompleted==totalRequest)
                    {
                        failureHandler()
                    }
                })
                
                
            }
        }
        
    }
    
}
