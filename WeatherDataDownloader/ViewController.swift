//
//  ViewController.swift
//  WeatherDataDownloader
//
//  Created by Gaurav Bhatia on 01/08/17.
//  Copyright © 2017 Gaurav Bhatia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regions = ["England","Wales","UK","Scotland"]
//        let regions = ["Wales"]
        let weathers = ["Tmax","Tmin","Tmean","Sunshine","Rainfall"]
//        let weathers = ["Tmin","Tmax"]
        var finalWeatherRows = [String]()
        

        statusLabel.text=String(format:"Downloading data for %@ for Weather %@",regions,weathers)
        
        WeatherDataDownloader.sharedInstance.downloadWeatherData(regions: regions, weatherParameter: weathers, completionHandler: { (downloadedFilePathArray,regionArray,weatherArray) in
            
            self.statusLabel.text=String(format:"Downloaded %d files \n Prasing in Progress",downloadedFilePathArray.count)

            
            for index in 0 ..< downloadedFilePathArray.count
            {
                let rows:[String]? = WeatherDataFileParser.sharedInstance.parseDataAtPath(filePath: downloadedFilePathArray[index], region: regionArray[index], weatherType: weatherArray[index])
                finalWeatherRows += rows!
            }
            
            let fileName = "Weather.csv"
            var documentURL:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
            documentURL=documentURL.appendingPathComponent(fileName)
            var csvText = "Region,Weather,Year,Month,Value\n"

            for finalWeatherRow in finalWeatherRows
            {
                csvText.append(String(format:"%@\n",finalWeatherRow))
            }
            
            print(csvText)
            do {
                
                try csvText.write(to: documentURL, atomically: true, encoding: String.Encoding.utf8)
                
            self.statusLabel.text=String(format:"Parsing weather data completed, %@ in available via Itunes File Sharing",fileName,fileName)
                
            }
            catch
            {
                print("Failed to create file")
                print("\(error)")
            }
            
            
        } , failureHandler: { () in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



