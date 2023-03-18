import Foundation

public protocol RouterProtocol {
    func routeEndpoint(_ endpoint: inout Endpoint, environment: BaseEnvironmentType)
}

final public class Router: RouterProtocol {
    public init() { }
    
    public func routeEndpoint(_ endpoint: inout Endpoint, environment: BaseEnvironmentType) {
        var url = URL(string: environment.url)!
        url.appendPathComponent(endpoint.path)
        endpoint.path = url.absoluteString
    }
}
