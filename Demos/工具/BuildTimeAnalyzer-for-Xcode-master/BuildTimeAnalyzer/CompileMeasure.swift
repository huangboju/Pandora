//
//  CompileMeasure.swift
//  BuildTimeAnalyzer
//

import Foundation

struct CompileMeasure {
    
    var time: Double
    var path: String
    var code: String
    var filename: String
    var references: Int

    private var locationArray: [Int]

    var fileAndLine: String {
        return "\(filename):\(locationArray[0])"
    }

    var fileInfo: String {
        return "\(fileAndLine):\(locationArray[1])"
    }
    
    var location: Int {
        return locationArray[0]
    }
    
    var timeString: String {
        return String(format: "%.1fms", time)
    }
    
    init?(time: Double, rawPath: String, code: String, references: Int) {
        let untrimmedFilename = rawPath.characters.split(separator: "/").map(String.init).last
        
        guard let filepath = rawPath.characters.split(separator: ":").map(String.init).first,
            let filename = untrimmedFilename?.characters.split(separator: ":").map(String.init).first else { return nil }
        
        let locationString = String(rawPath.substring(from: filepath.endIndex).characters.dropFirst())
        let locations = locationString.characters.split(separator: ":").flatMap{ Int(String.init($0)) }
        guard locations.count == 2 else { return nil }
        
        self.time = time
        self.code = code
        self.path = filepath
        self.filename = filename
        self.locationArray = locations
        self.references = references
    }

    init?(rawPath: String, time: Double) {
        let untrimmedFilename = rawPath.characters.split(separator: "/").map(String.init).last

        guard let filepath = rawPath.characters.split(separator: ":").map(String.init).first,
            let filename = untrimmedFilename?.characters.split(separator: ":").map(String.init).first else { return nil }

        self.time = time
        self.code = ""
        self.path = filepath
        self.filename = filename
        self.locationArray = [1,1]
        self.references = 1
    }

    subscript(column: Int) -> String {
        switch column {
        case 0:
            return timeString
        case 1:
            return fileInfo
        case 2:
            return "\(references)"
        default:
            return code
        }
    }
}
