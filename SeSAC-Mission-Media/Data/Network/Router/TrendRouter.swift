//
//  TrendRouter.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/30/24.
//

import Alamofire
import Foundation

enum TrendRouter: Router {
  
  case trendTV(timeWindow: TimeWindow)
  
  var method: HTTPMethod {
    switch self {
      case .trendTV:
        return .get
    }
  }
  
  var baseURL: String {
    return "https://api.themoviedb.org/3/trending"
  }
  
  var path: String {
    switch self {
      case .trendTV(let timeWindow):
        return "/tv/\(timeWindow.rawValue)"
    }
  }
  
  var headers: HTTPHeaders {
    return [APIKey.TMDB.authorization.key: APIKey.TMDB.authorization.value]
  }
  
  /// 이후에는 case 별로 파라미터를 가변으로 받아서 처리할 수 있는 방법으로 수정
  var parameters: Parameters? {
    let language: Constant.Parameter = .language(iso: .kor)
    
    return [language.key: language.value]
  }
}

extension TrendRouter {
  enum TimeWindow: String {
    case week
    case day
  }
}
