//
//  JsonCodable.swift
//
//

import Foundation

func printLog<T>(message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
}

public protocol JsonCodable: Codable {
    static func dateFormatter() -> DateFormatter?
}

extension Array : JsonCodable {
}

extension Array where Element : JsonCodable {
    func jsonArrayString(_ outputFormatter: JSONEncoder.OutputFormatting = []) -> String {
        return Element.encode(outputFormatter, dateFormatter: Element.dateFormatter(), value: self).string()!
    }
    
    
    init?(data: Data) {
        guard let s = data.decode([Element].self) else { return nil }
        self = s
    }
    
    init?(string: String) {
        guard let s = string.data()?.decode([Element].self) else { return nil }
        self = s
    }
    
    init?(json: [Dictionary<String, Any?>]) {
        guard let s = json.data()?.decode([Element].self) else { return nil }
        self = s
    }
    
}


public extension JsonCodable {
    public static func dateFormatter() -> DateFormatter? {
        return nil
    }
    
    init?(json: Dictionary<String, Any?>) {
        guard let s = json.data()?.decode(Self.self) else { return nil }
        self = s
    }
    
    
    static func arrayFrom(json: [Dictionary<String, Any?>]) -> [Self]? {
        return json.data()?.decode([Self].self)
    }
    
    
    init?(data: Data) {
        guard let s = data.decode(Self.self) else { return nil }
        self = s
    }
    
    
    static func arrayFrom( data: Data) -> [Self]? {
        return data.decode([Self].self)
    }
    
    
    init?(string: String) {
        guard let s = string.data()?.decode(Self.self) else { return nil }
        self = s
    }
    
    static func arrayFrom(string: String) -> [Self]? {
        return string.data()?.decode([Self].self)
    }
    
    func data(_ outputFormatter: JSONEncoder.OutputFormatting = [], dateFormatter : DateFormatter? = nil) -> Data {
        return Self.encode(outputFormatter, dateFormatter: dateFormatter, value: self)
    }
    
    func jsonString(_ outputFormatter: JSONEncoder.OutputFormatting = [], dateFormatter : DateFormatter? = nil) -> String {
        return data([.prettyPrinted], dateFormatter: dateFormatter).string()!
    }
    
    static func encode<T>(_ outputFormatter: JSONEncoder.OutputFormatting = [], dateFormatter : DateFormatter? = nil, value: T) -> Data where T : Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatter
        
        if let dateFormatter = Self.dateFormatter() {
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
        }
        
        return try! encoder.encode(value)
    }
}

extension JSONEncoder {
    func outputFormat(_ formatter: JSONEncoder.OutputFormatting) -> Self {
        outputFormatting = formatter
        return self
    }
}

extension Data {
    func string() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    func json() -> [String: Any?]? {
        do {
            
            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as! [String: Any?]
            return json
        }
        catch {
            
            return nil
        }
    }
    
    func jsonArray() -> [[String: Any?]]? {
        do {
            
            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments) as! [[String: Any?]]
            return json
        }
        catch {
            
            printLog(message: error.localizedDescription)
            printLog(message: error.localizedDescription)
            return nil
        }
    }
    
    
    func decode<T>(_ type: [T].Type) -> [T]? where T : JsonCodable {
        return Data.decode(type, from: self)
    }
    
    
    func decode<T>(_ type: T.Type) -> T? where T : JsonCodable {
        return Data.decode(type, from: self)
    }
    
    static func decode<T>(_ type: T.Type, from data: Data) -> T? where T : JsonCodable {
        let decoder = JSONDecoder()
        
        if let dateFormatter = T.dateFormatter() {
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }
        
        do {
            return try decoder.decode(type, from: data)
        }
        catch {
            printLog(message: error)
        }
        
        return nil
    }
}

extension Data {
    init?(obj: Any, options: JSONSerialization.WritingOptions = []) {
        var data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: obj, options:options)
            
        } catch {
            printLog(message: error.localizedDescription)
            
            return nil
        }
        
        self = data
    }
}

extension Dictionary {
    func data(_ options: JSONSerialization.WritingOptions = []) -> Data? {
        return Data(obj: self, options: options)
    }
    
    func string() -> String? {
        return data(.prettyPrinted)?.string()
    }
}



extension Array where Element == [String: Any?] {
    func data(_ options: JSONSerialization.WritingOptions = []) -> Data? {
        return Data(obj: self, options: options)
    }
    
    func string() -> String? {
        return data(.prettyPrinted)?.string()
    }
}

extension String {
    func data() -> Data? {
        return data(using: .utf8)
    }
    
    func json() -> [String: Any?]? {
        return data()?.json()
    }
    
    func jsonArray() -> [[String: Any?]]? {
        return data()?.jsonArray()
    }
}

