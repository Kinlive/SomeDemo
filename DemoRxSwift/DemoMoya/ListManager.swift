//
//  ListManager.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/5.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import Moya
import Result
import SwiftyJSON

//let MusicProvider = MoyaProvider<Player>.init(plugins: [PlugIn()])

class PlugIn: PluginType {

  func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {

    print(result)
    switch result {
    case .success(let response):
      print(response.data)
    case .failure(let error):
      print(error.localizedDescription)
    }
    return result
  }

}

enum Player {

  case channels
  case playlist(String)
}

extension Player: TargetType {

  var baseURL: URL {
    switch self {
    case .channels:
      return URL(string: "https://www.douban.com")!
    case .playlist:
      return URL(string: "https://douban.fm")!
    }
  }

  var path: String {
    switch self {
    case .channels:
      return "/j/app/radio/channels"
    case .playlist:
      return "/j/mine/playlist"
    }
  }

  var method: Moya.Method {
    return .get
  }

  var sampleData: Data {
    return "{}".data(using: String.Encoding.utf8)!
  }

  var task: Task {
    switch self {
    case .playlist(let channel):
      var params: [String: Any] = [:]
      params["channel"] = channel
      params["type"] = "n"
      params["from"] = "mainsite"
      return .requestParameters(parameters: params, encoding: URLEncoding.default)
    default:
      return .requestPlain
    }
  }

  var validate: Bool {
    return false
  }

  var headers: [String : String]? {
    return nil
  }


}


enum TypeB {
  case testA
  case testB
}

class RequestManager {

  static let shared = RequestManager()

  let provider = MoyaProvider<Player>.init(plugins: [PlugIn()])


  open func request(type: Player, head: String, completion: @escaping (JSON?) -> Void) {

    provider.request(type) {
      do {
        switch $0 {
        case .success(let response):
          let json = try JSON.init(data: response.data)["\(head)"]
          completion(json)
        case .failure(let err):
          print("Request failure: \(err.localizedDescription)")
          completion(nil)
        }
      } catch let e {
        print("Catch error when json transfer:\(e.localizedDescription)")
        completion(nil)
      }
    }
  }


  open func requestTest<T>(type: T, head: String) -> String where T: TargetType {



    if case let newType = type as? Player {

      return "Type player"
    } else if case let nType = type as? TypeB {
      return "Type TypeBB"
    } else {
      return "none type"
    }
  }
}

