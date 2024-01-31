//
//  SearchViewController.swift
//  SeSAC-Mission-Media
//
//  Created by 원태영 on 1/31/24.
//

import UIKit
import SnapKit

enum SearchTVCollection {
  
  case search(query: String)
  case detail
  case recommend
  case cast
}

final class SearchViewController: BaseViewController {
  
  // MARK: - UI
  private lazy var searchBar = UISearchBar().configured {
    $0.placeholder = "TV 프로그램 이름을 검색하세요"
    $0.barTintColor = .clear
    $0.barStyle = .black
    $0.tintColor = .label
    $0.searchTextField.textColor = .label
    $0.autocorrectionType = .no
    $0.autocapitalizationType = .none
    $0.spellCheckingType = .no
    $0.delegate = self
  }
  
  private lazy var resultTableView = UITableView().configured {
    $0.delegate = self
    $0.dataSource = self
    $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
  }
  
  // MARK: - Property
  private var tvList: [TV] = [] {
    didSet {
      resultTableView.reloadData()
    }
  }
  
  
  // MARK: - Life Cycle
  override func setHierarchy() {
    view.addSubviews(searchBar, resultTableView)
  }
  
  override func setAttribute() {
    
  }
  
  override func setConstraint() {
    searchBar.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(44)
    }
    
    resultTableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    
    RouterManager.shared.callTVRequest(collection: .search(query: text)) { models in
      self.tvList = models
      
      searchBar.text?.removeAll()
    }
  }
}

extension SearchViewController: TableControllable {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tvList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
    let data = tvList[indexPath.row]
    
    cell.setData(data: data)
    
    return cell
  }
}