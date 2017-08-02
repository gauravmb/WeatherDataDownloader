//
//  WeatherDataFileParser.swift
//  WeatherDataDownloader
//
//  Created by Gaurav Bhatia on 03/08/17.
//  Copyright © 2017 Gaurav Bhatia. All rights reserved.
//

import Foundation

class WeatherDataFileParser {
    
    static let sharedInstance = WeatherDataFileParser()
    
    func parseDataAtPath(filePath:String,region:String,weatherType:String) -> [String]? {
    
        do{
            let text2 = try String(contentsOf: URL(fileURLWithPath: filePath.replacingOccurrences(of: "file://", with: "")), encoding: String.Encoding.utf8)
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
            
            if dataRows.count>1
            {
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
                    
                    let finalRow = String(format:"%@,%@,%@,%@,%@",region,weatherType,year,columeArray[index],value)
                    finalRows.append(finalRow)
                    index+=1
                }
            }
            return finalRows
            }
            else
            {
                return ["No Rows found"]
            }
        }
        catch(let error)
        {
            return [error.localizedDescription]
        }
        
    }
}

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
