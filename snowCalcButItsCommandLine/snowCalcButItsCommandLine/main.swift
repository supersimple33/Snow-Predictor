//
//  main.swift
//  snowCalcButItsCommandLine
//
//  Created by Addison Hanrattie on 2/11/19.
//  Copyright © 2019 Catherine Hanrattie. All rights reserved.
//

import Foundation
import CoreML

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

let neuralNets : [MLModel] = [blizzard1().model, blizzard2().model]

print("please choose a model to use from 0 to \(neuralNets.count - 1) or press ? for more info")

var noEscape = true
while noEscape {
    let userInput = readLine() ?? "" // is it safe to convert to ""
    if userInput == "?" {
        for i in 0...neuralNets.count - 1 {
            let network = neuralNets[i]
            print(network.modelDescription, i, "\n", "\n")
        }
    } else if let network = neuralNets[safe: Int(userInput) ?? -1] {
        print("You have chosen #\(userInput)")
        print("This model takes the following inputs ", network.modelDescription.inputDescriptionsByName)
        print("please enter your dicitonary of data below in the formate from above")
        let dataString = readLine() ?? ""
        do {
            print("Serializing JSON")
            let dataArray = try JSONSerialization.jsonObject(with: dataString.data(using: .utf8)!, options: []) as! [String : Double]// it would be cool in the future to have it create its own types/dictionaries
            print("JSON Serialized")
            print("Creating Feature Provider")
            let features = try MLDictionaryFeatureProvider(dictionary: dataArray)
            print("Feature Provider Created")
            print("Predicting")
            print(try network.prediction(from: features).featureValue(for: "resultProbability") ?? "No Val")
        } catch {
            print(error)
            print("make sure you conformed to the expected dictionary")
        }
    } else {
        print("Input \(userInput) invalid")
    }
}

//.featureValue(for: "resultProbability") ?? "No Val"
