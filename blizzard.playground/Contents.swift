//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport
import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

func jsonFormater(_ arr : [[String : Any]]){
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: arr, options: [.prettyPrinted, .sortedKeys])
        let p = playgroundSharedDataDirectory.appendingPathComponent("finalJsonData2.json")
//        FileManager.default.createFile(atPath: p, contents: jsonData, attributes: nil)
        try jsonData.write(to: p)
    } catch {
        print(error)
    }
}


func snowDataAdder2(_ dic : [[String : [[String : Any]]]]) -> [Any] {
    for month in dic {
        for days in month.values {
            var reDay : [String : Any] = [:]
            
            for day in days {
                for i in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                    let observation = (day["observations"] as! [[String : Any]])[i]
                    if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: i - 1]?["hour"] as! Int?) ?? -1 {
                        reDay["percipitation\(observation["hour"]!)"] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["percipitation\(observation["hour"]!)"] as! NSNumber).decimalValue
                        reDay["temp\(observation["hour"]!)"] = ((observation["temp"] as! Int) + (reDay["temp\(observation["hour"]!)"] as! Int)) / 2
                        reDay["windGust\(observation["hour"]!)"] = max(observation["windGust"] as! Int, reDay["windGust\(observation["hour"]!)"] as! Int)
                        reDay["windSpeed\(observation["hour"]!)"] = ((observation["windSpeed"] as! Int) + (reDay["windSpeed\(observation["hour"]!)"] as! Int)) / 2
                    } else {
                        reDay["percipitation\(observation["hour"]!)"] = (observation["percipitation"] as! NSNumber).decimalValue
//                        print((observation["percipitation"] as! NSNumber).decimalValue)
                        reDay["temp\(observation["hour"]!)"] = observation["temp"] as! Int
                        reDay["windGust\(observation["hour"]!)"] = observation["windGust"] as! Int
                        reDay["windSpeed\(observation["hour"]!)"] = observation["windSpeed"] as! Int
                    }
                }
            }
        }
    }
    return []
}

if let path = Bundle.main.path(forResource: "thirdRunResults", ofType: "json") {
    do {
        let dat = try Data(contentsOf: URL(fileURLWithPath: path))
        let snowData = try JSONSerialization.jsonObject(with: dat, options: JSONSerialization.ReadingOptions()) as! [String : [[String : [[String : Any]]]]]

//        let datesData = snowDataAdder2((snowData.first?.value)!)
        let dic = (snowData.first?.value)!
        var finalDic : [[String : Any]] = []
        for mo in 0...dic.count - 1 {
            let month = dic[mo]
            for days in month.values {
//                print(days.count)
                for i in 0...days.count - 1 {
                    if !(((days[i]["weekday"] as! Int) == 0) || ((days[i]["weekday"] as! Int)) == 6) {
                        switch i {
                        case 0:
                            if mo != 0 {
                                var reDay : [String : Any] = [:]
                                for o in 0...0 {
                                    let day = days[i - o]
                                    var tod = "am"
                                    if o == 0 {
                                        reDay["weekday"] = day["weekday"]
                                        reDay["date"] = day["date"]
                                        reDay["result"] = "school"
                                    }
                                    for h in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                                        let observation = (day["observations"] as! [[String : Any]])[h]
                                        //                        print(i)
                                        if ((((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1) == 11) && ((observation["hour"] as! Int) == 12) {
                                            tod = "pm"
                                        }
                                        if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1 {
                                            reDay["\(o)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["\(o)percipitation\(observation["hour"]!)" + tod] as! NSNumber).decimalValue
                                            reDay["\(o)temp\(observation["hour"]!)" + tod] = ((observation["temp"] as! Int) + (reDay["\(o)temp\(observation["hour"]!)" + tod] as! Int)) / 2
                                            reDay["\(o)windGust\(observation["hour"]!)" + tod] = max(observation["windGust"] as! Int, reDay["\(o)windGust\(observation["hour"]!)" + tod] as! Int)
                                            reDay["\(o)windSpeed\(observation["hour"]!)" + tod] = ((observation["windSpeed"] as! Int) + (reDay["\(o)windSpeed\(observation["hour"]!)" + tod] as! Int)) / 2
                                        } else {
                                            reDay["\(o)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue
                                            //                            print((observation["percipitation"] as! NSNumber).decimalValue)
                                            reDay["\(o)temp\(observation["hour"]!)" + tod] = observation["temp"] as! Int
                                            reDay["\(o)windGust\(observation["hour"]!)" + tod] = observation["windGust"] as! Int
                                            reDay["\(o)windSpeed\(observation["hour"]!)" + tod] = observation["windSpeed"] as! Int
                                        }
                                    }
                                }
                                let oldMonth = dic[mo - 1]
                                for oldDays in oldMonth.values {
                                    for ind in 1...2 {
                                        let day = oldDays[oldDays.count - ind]
                                        var tod = "am"
                                        for h in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                                            let observation = (day["observations"] as! [[String : Any]])[h]
                                            //                        print(i)
                                            if ((((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1) == 11) && ((observation["hour"] as! Int) == 12) {
                                                tod = "pm"
                                            }
                                            if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1 {
                                                
                                                reDay["\(ind)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["\(ind)percipitation\(observation["hour"]!)" + tod] as! NSNumber).decimalValue
                                                reDay["\(ind)temp\(observation["hour"]!)" + tod] = ((observation["temp"] as! Int) + (reDay["\(ind)temp\(observation["hour"]!)" + tod] as! Int)) / 2
                                                reDay["\(ind)windGust\(observation["hour"]!)" + tod] = max(observation["windGust"] as! Int, reDay["\(ind)windGust\(observation["hour"]!)" + tod] as! Int)
                                                reDay["\(ind)windSpeed\(observation["hour"]!)" + tod] = ((observation["windSpeed"] as! Int) + (reDay["\(ind)windSpeed\(observation["hour"]!)" + tod] as! Int)) / 2
                                            } else {
                                                reDay["\(ind)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue
                                                //                            print((observation["percipitation"] as! NSNumber).decimalValue)
                                                reDay["\(ind)temp\(observation["hour"]!)" + tod] = observation["temp"] as! Int
                                                reDay["\(ind)windGust\(observation["hour"]!)" + tod] = observation["windGust"] as! Int
                                                reDay["\(ind)windSpeed\(observation["hour"]!)" + tod] = observation["windSpeed"] as! Int
                                            }
                                        }
                                    }
                                    
                                }
                                finalDic.append(reDay)
                            }
                        case 1:
                            if mo != 0 {
                                var reDay : [String : Any] = [:]
                                for o in 0...1 {
                                    let day = days[i - o]
                                    var tod = "am"
                                    if o == 0 {
                                        reDay["weekday"] = day["weekday"]
                                        reDay["date"] = day["date"]
                                        reDay["result"] = "school"
                                    }
                                    for h in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                                        let observation = (day["observations"] as! [[String : Any]])[h]
                                        //                        print(i)
                                        if ((((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1) == 11) && ((observation["hour"] as! Int) == 12) {
                                            tod = "pm"
                                        }
                                        if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1 {
                                            reDay["\(o)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["\(o)percipitation\(observation["hour"]!)" + tod] as! NSNumber).decimalValue
                                            reDay["\(o)temp\(observation["hour"]!)" + tod] = ((observation["temp"] as! Int) + (reDay["\(o)temp\(observation["hour"]!)" + tod] as! Int)) / 2
                                            reDay["\(o)windGust\(observation["hour"]!)" + tod] = max(observation["windGust"] as! Int, reDay["\(o)windGust\(observation["hour"]!)" + tod] as! Int)
                                            reDay["\(o)windSpeed\(observation["hour"]!)" + tod] = ((observation["windSpeed"] as! Int) + (reDay["\(o)windSpeed\(observation["hour"]!)" + tod] as! Int)) / 2
                                        } else {
                                            reDay["\(o)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue
                                            //                            print((observation["percipitation"] as! NSNumber).decimalValue)
                                            reDay["\(o)temp\(observation["hour"]!)" + tod] = observation["temp"] as! Int
                                            reDay["\(o)windGust\(observation["hour"]!)" + tod] = observation["windGust"] as! Int
                                            reDay["\(o)windSpeed\(observation["hour"]!)" + tod] = observation["windSpeed"] as! Int
                                        }
                                    }
                                }
                                let oldMonth = dic[mo - 1]
                                for oldDays in oldMonth.values {
                                    for ind in 1...1 {
                                        let day = oldDays[oldDays.count - ind]
                                        var tod = "am"
                                        for h in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                                            let observation = (day["observations"] as! [[String : Any]])[h]
                                            //                        print(i)
                                            if ((((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1) == 11) && ((observation["hour"] as! Int) == 12) {
                                                tod = "pm"
                                            }
                                            if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1 {
                                                
                                                reDay["\(ind)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["\(ind)percipitation\(observation["hour"]!)" + tod] as! NSNumber).decimalValue
                                                reDay["\(ind)temp\(observation["hour"]!)" + tod] = ((observation["temp"] as! Int) + (reDay["\(ind)temp\(observation["hour"]!)" + tod] as! Int)) / 2
                                                reDay["\(ind)windGust\(observation["hour"]!)" + tod] = max(observation["windGust"] as! Int, reDay["\(ind)windGust\(observation["hour"]!)" + tod] as! Int)
                                                reDay["\(ind)windSpeed\(observation["hour"]!)" + tod] = ((observation["windSpeed"] as! Int) + (reDay["\(ind)windSpeed\(observation["hour"]!)" + tod] as! Int)) / 2
                                            } else {
                                                reDay["\(ind)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue
                                                //                            print((observation["percipitation"] as! NSNumber).decimalValue)
                                                reDay["\(ind)temp\(observation["hour"]!)" + tod] = observation["temp"] as! Int
                                                reDay["\(ind)windGust\(observation["hour"]!)" + tod] = observation["windGust"] as! Int
                                                reDay["\(ind)windSpeed\(observation["hour"]!)" + tod] = observation["windSpeed"] as! Int
                                            }
                                        }
                                    }
                                    
                                }
                                finalDic.append(reDay)
                            }
                        case 2 ... Int.max :
                            var reDay : [String : Any] = [:]
                            for o in 0...2 {
                                let day = days[i - o]
                                if o == 0 {
                                    reDay["weekday"] = day["weekday"]
                                    reDay["date"] = day["date"]
                                    reDay["result"] = "school"
                                }
                                var tod = "am"
                                for h in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                                    let observation = (day["observations"] as! [[String : Any]])[h]
                                    //                        print(i)
                                    if ((((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1) == 11) && ((observation["hour"] as! Int) == 12) {
                                        tod = "pm"
                                    }
                                    if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: h - 1]?["hour"] as! Int?) ?? -1 {
                                        
                                        reDay["\(o)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["\(o)percipitation\(observation["hour"]!)" + tod] as! NSNumber).decimalValue
                                        reDay["\(o)temp\(observation["hour"]!)" + tod] = ((observation["temp"] as! Int) + (reDay["\(o)temp\(observation["hour"]!)" + tod] as! Int)) / 2
                                        reDay["\(o)windGust\(observation["hour"]!)" + tod] = max(observation["windGust"] as! Int, reDay["\(o)windGust\(observation["hour"]!)" + tod] as! Int)
                                        reDay["\(o)windSpeed\(observation["hour"]!)" + tod] = ((observation["windSpeed"] as! Int) + (reDay["\(o)windSpeed\(observation["hour"]!)" + tod] as! Int)) / 2
                                    } else {
                                        reDay["\(o)percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue
                                        //                            print((observation["percipitation"] as! NSNumber).decimalValue)
                                        reDay["\(o)temp\(observation["hour"]!)" + tod] = observation["temp"] as! Int
                                        reDay["\(o)windGust\(observation["hour"]!)" + tod] = observation["windGust"] as! Int
                                        reDay["\(o)windSpeed\(observation["hour"]!)" + tod] = observation["windSpeed"] as! Int
                                    }
                                }
                            }
                            finalDic.append(reDay)
                        //                        print(reDay.keys.count)
                        default:
                            fatalError()
                            break
                        }
                    }
                    
                }
                /*for day in days {
                    
                    var reDay : [String : Any] = [:]
//                    print(days.firstIndex(where: { (e) -> Bool in
//                        if e["date"] as! String == day["date"] as! String {
//                            return true
//                        }
//                        return false
//                    }))
                    var tod = "am"
                    for i in 0...(day["observations"] as! [[String : Any]]).count - 1 {
                        let observation = (day["observations"] as! [[String : Any]])[i]
//                        print(i)
                        if ((((day["observations"] as! [[String : Any]])[safe: i - 1]?["hour"] as! Int?) ?? -1) == 11) && ((observation["hour"] as! Int) == 12) {
                            tod = "pm"
                        }
                        if (observation["hour"] as! Int) == ((day["observations"] as! [[String : Any]])[safe: i - 1]?["hour"] as! Int?) ?? -1 {
                            reDay["percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue + (reDay["percipitation\(observation["hour"]!)" + tod] as! NSNumber).decimalValue
                            reDay["temp\(observation["hour"]!)" + tod] = ((observation["temp"] as! Int) + (reDay["temp\(observation["hour"]!)" + tod] as! Int)) / 2
                            reDay["windGust\(observation["hour"]!)" + tod] = max(observation["windGust"] as! Int, reDay["windGust\(observation["hour"]!)" + tod] as! Int)
                            reDay["windSpeed\(observation["hour"]!)" + tod] = ((observation["windSpeed"] as! Int) + (reDay["windSpeed\(observation["hour"]!)" + tod] as! Int)) / 2
                        } else {
                            reDay["percipitation\(observation["hour"]!)" + tod] = (observation["percipitation"] as! NSNumber).decimalValue
//                            print((observation["percipitation"] as! NSNumber).decimalValue)
                            reDay["temp\(observation["hour"]!)" + tod] = observation["temp"] as! Int
                            reDay["windGust\(observation["hour"]!)" + tod] = observation["windGust"] as! Int
                            reDay["windSpeed\(observation["hour"]!)" + tod] = observation["windSpeed"] as! Int
                        }
                    }
                    print(reDay.keys.count)
                    
                }*/
            }
        }
        print(finalDic.count)
        jsonFormater(finalDic)
//        jsonFormater(datesData)
        //        for day in arr {
        //            print(day)
        //            print((day as! Dictionary)["highTemp"]!)
        //            break
        //        }
    } catch {
        print(error)
    }
}
