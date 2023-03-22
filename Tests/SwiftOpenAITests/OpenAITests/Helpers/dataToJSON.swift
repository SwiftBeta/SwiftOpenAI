import Foundation

 extension Data {
     func toJSONString() -> String? {
         return String(data: self, encoding: .utf8)
     }
 }
