import Foundation

func loadJSON(name: String) -> Data {
    guard let resourceURL = Bundle.module.url(forResource: name, withExtension: "json"),
          let data = try? Data(contentsOf: resourceURL) else {
        fatalError("Can't load JSON file")
    }
    return data
}
