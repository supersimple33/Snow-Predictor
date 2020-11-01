import Foundation
import CreateML
import PlaygroundSupport

if let path = Bundle.main.url(forResource: "finalJsonData", withExtension: "json") {
    do {
        var table = try MLDataTable(contentsOf: path)
        table.removeColumn(named: "date")
        print(table.dropMissing().playgroundDescription)
        let split = table.dropMissing().randomSplit(by: 1.0)
        let c = try MLLogisticRegressionClassifier(trainingData: split.0, targetColumn: "result")
        
        print("eval")
        c.evaluation(on: split.1)
        c.evaluation(on: split.1)
        let p = playgroundSharedDataDirectory.appendingPathComponent("blizzard2.mlmodel")
        try c.write(to: p, metadata: MLModelMetadata(author: "Addison Hanrattie", shortDescription: "This is the second version of my model that takes in hourly data only from one season", license: "This model may not be shared, used or recreated at all", version: "2.0", additional: nil))
    } catch {
        print(error)
    }
}

//        var classifier = try MLClassifier(trainingData: split.0, targetColumn: "result")
//        var boostedcClassifier = try MLBoostedTreeClassifier.init(trainingData: split.0, targetColumn: "result", featureColumns: nil, parameters: MLBoostedTreeClassifier.ModelParameters(validationData: nil, maxDepth: 8, maxIterations: 25, minLossReduction: 0, minChildWeight: 0.1, randomSeed: 42, stepSize: 0.3, earlyStoppingRounds: nil, rowSubsample: 1.0, columnSubsample: 1.0))

/*NOTES:


*/
