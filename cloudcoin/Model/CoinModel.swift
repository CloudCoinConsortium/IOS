//
//  CoinModel.swift
//  cloudcoin
//
//  Created by Moumita China on 25/11/21.
//

import Foundation

class CoinModel: Codable {
    var cloudcoin: [CoinModelData]? = []
    
    init() {
    }
    init(cloudcoin: [CoinModelData]) {
        self.cloudcoin = cloudcoin
    }
}
class CoinModelData: Codable {
    var nn: String?
    var sn: String?
    var an: [String]?
    var pan: [String]?
    var ed: String?
    var pown: String?
    var aoid: [String]?
    
    private enum CodingKeys: CodingKey {
        case nn, sn, an, pan, ed, pown, aoid
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        nn = try? container.stringTransform(key: .nn)
        sn = try? container.decode(String.self, forKey: .sn)
        an = try? container.decodeArray(String.self, forKey: .an)
        pan = try? container.decode([String].self, forKey: .pan)
        ed = try? container.decode(String.self, forKey: .ed)
        pown = try? container.decode(String.self, forKey: .pown)
        aoid = try? container.decode([String].self, forKey: .aoid)
    }
    
    init(nn: String, sn: String, an: [String], pan: [String]?=nil, ed: String, pown: String, aoid: [String]) {
        self.nn = nn
        self.sn = sn
        self.an = an
        self.pan = pan
        self.ed = ed
        self.pown = pown
        self.aoid = aoid
    }
}
fileprivate struct DummyCodable: Codable {}

extension KeyedDecodingContainerProtocol{
    public func stringTransform(key : Self.Key)throws -> String?{
        do{
            if let value = try self.decodeIfPresent(Int?.self, forKey: key) ?? -1{
                if value == -1{
                   return nil
                }else{
                    return String(value)
                }
            }
            if let value = try self.decodeIfPresent(String?.self, forKey: key) ?? nil{
                return value
            }
            else{
                return nil
            }
        }catch{
            return nil
        }
    }
    public func intTransform(key : Self.Key)throws -> Int?{
        do{
            if let value = try self.decodeIfPresent(Int?.self, forKey: key) ?? nil{
                return value
            }
            if let value = try self.decodeIfPresent(String?.self, forKey: key) ?? ""{
                if !value.isEmpty{
                    return Int(value)
                }else{
                    return nil
                }
            }
            else{
                return nil
            }
        }catch{
            return nil
        }
    }
    public func decodeArray<T>(_ type: T.Type, forKey key: Self.Key) throws -> [T] where T : Decodable {
        var unkeyedContainer = try self.nestedUnkeyedContainer(forKey: key)
        return try unkeyedContainer.decodeArray(type)
    }
}
extension UnkeyedDecodingContainer {
    
    public mutating func decodeArray<T>(_ type: T.Type) throws -> [T] where T : Decodable {
        
        var array = [T]()
        while !self.isAtEnd {
            do {
                let item = try self.decode(T.self)
                array.append(item)
            } catch let error {
                print("error: \(error)")
                array.append("" as! T)
                // hack to increment currentIndex
                _ = try self.decode(DummyCodable.self)
            }
        }
        return array
    }
}
