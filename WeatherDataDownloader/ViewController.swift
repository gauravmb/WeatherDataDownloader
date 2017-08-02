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
        
//        let regions = ["England","Wales","UK","Scotland"]
        let regions = ["Wales"]
//        let weathers = ["Tmax","Tmin","Tmean","Sunshine","Rainfall"]
        let weathers = ["Tmin"]

        WeatherDataDownloader.sharedInstance.downloadWeatherData(regions: regions, weatherParameter: weathers, completionHandler: { (downloadedFilePathArray) in
            
//            print(downloadedFilePathArray)
            
            do{
                let text2 = try String(contentsOf: URL(fileURLWithPath: downloadedFilePathArray[0].replacingOccurrences(of: "file://", with: "")), encoding: String.Encoding.utf8)
                let arrayOfStrings:[String] = text2.components(separatedBy: "\n")
//                print(arrayOfStrings)
                var isDataStarted = false
                var dataRows=[String]()
                var finalRows=[String]()
                for row in arrayOfStrings
                {
                    if row == ""
                    {
                        isDataStarted=true
                        continue
                    }
                    if isDataStarted
                    {
                        var rowValue=row
                        for index in 1 ..< row.characters.count/14
                        {
                            rowValue.insert(",", at: rowValue.index(rowValue.startIndex, offsetBy: (index*14)+index))
                        }
                        dataRows.append(rowValue)
                    }
                }
                
                var columeHeader=dataRows[0]
                dataRows.remove(at: 0)
                columeHeader = columeHeader.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                columeHeader = columeHeader.replacingOccurrences(of: "Year", with: "", options: NSString.CompareOptions.literal, range: nil)
                let columeArray:[String] = columeHeader.components(separatedBy: ",")
                
                for dataRow in dataRows
                {
                    var index=0
                    let valueArray:[String] = dataRow.components(separatedBy: ",")
                    
                    for value in valueArray
                    {
                        var trimmedValue = value.trimmingCharacters(in: .whitespaces)
                        trimmedValue = trimmedValue.condenseWhitespace()
                        var year = "NA"
                        var value = "NA"
                        if(trimmedValue.components(separatedBy: " ").count == 2)
                        {
                            year = trimmedValue.components(separatedBy: " ")[1]
                            value = trimmedValue.components(separatedBy: " ")[0]
                        }
                        
                        let finalRow = String(format:"England,Max temp,%@,%@,%@",year,columeArray[index],value)
                        finalRows.append(finalRow)
                        index+=1
                    }
                }
                print(finalRows)

                
                
            }
            catch(let error)
            {
                print(error.localizedDescription)
            }
            
        } , failureHandler: { () in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

