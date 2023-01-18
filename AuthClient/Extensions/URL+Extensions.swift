import Foundation

extension URL {
  func getQueryParam(value: String) -> String? {
      guard let comps = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = comps.queryItems else { return nil }
      return queryItems.filter ({ $0.name == value }).first?.value
  }
}
