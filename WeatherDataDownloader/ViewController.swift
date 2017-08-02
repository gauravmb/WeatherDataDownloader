//
//  ViewController.swift
//  WeatherDataDownloader
//
//  Created by Gaurav Bhatia on 01/08/17.
//  Copyright © 2017 Gaurav Bhatia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regions = ["England","Wales","UK","Scotland"]
//        let regions = ["Wales"]
        let weathers = ["Tmax","Tmin","Tmean","Sunshine","Rainfall"]
//        let weathers = ["Tmin","Tmax"]

        WeatherDataDownloader.sharedInstance.downloadWeatherData(regions: regions, weatherParameter: weathers, completionHandler: { (downloadedFilePathArray,regionArray,weatherArray) in
            
            for index in 0 ..< downloadedFilePathArray.count
            {
                let rows:[String]? = WeatherDataFileParser.sharedInstance.parseDataAtPath(filePath: downloadedFilePathArray[index], region: regionArray[index], weatherType: weatherArray[index])
                print(rows ?? "No row parsed")
            }
            
//            print(downloadedFilePathArray)
            

            
        } , failureHandler: { () in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



