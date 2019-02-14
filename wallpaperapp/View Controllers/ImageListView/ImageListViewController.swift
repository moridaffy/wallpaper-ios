//
//  ImageListViewController.swift
//  wallpaperapp
//
//  Created by Максим Скрябин on 13/02/2019.
//  Copyright © 2019 MSKR. All rights reserved.
//

import RxSwift
import RxDataSources
import SnapKit

class ImageListViewController: UIViewController {
  
  private weak var tableView: UITableView!
  private var refresher: UIRefreshControl?
  
  private let disposeBag = DisposeBag()
  private var model: ImageListViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupConstraints()
    setupTableView()
    setupReactive()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // TODO: uncomment to enable automatic image loading
//    pullToRefresh()
  }
  
  func setup(model: ImageListViewModel = ImageListViewModel()) {
    self.model = model
  }
  
  private func setupUI() {
    let tableView = UITableView(frame: view.frame, style: .plain)
    view.addSubview(tableView)
    self.tableView = tableView
  }
  
  private func setupConstraints() {
    tableView.snp.makeConstraints { (make) in
      make.center.size.equalTo(view)
    }
  }
  
  private func setupTableView() {
    let refresher = UIRefreshControl()
    refresher.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    tableView.refreshControl = refresher
    self.refresher = refresher
    
    tableView.delegate = self
    tableView.register(ImageTableCellView.self, forCellReuseIdentifier: "ImageTableCell")
  }
  
  private func setupReactive() {
    model.images.asObservable()
      .bind(to: tableView.rx.items) { (tableView, _, model) in
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell") as? ImageTableCellView {
          cell.setup(model: ImageTableCellViewModel(imageUrl: model.previewUrl))
          return cell
        } else {
          fatalError("🔥 Can't dequeue cell with ID: ImageTableCell")
        }
      }.disposed(by: disposeBag)
  }
}

extension ImageListViewController {
  @objc private func pullToRefresh() {
    APIManager.loadImages(search: model.category?.type.rawValue) { [weak self] (response, error) in
      self?.refresher?.endRefreshing()
      if let response = response {
        self?.model.setupContent(response: response)
      } else {
        print("🔥 Failed to load images: \(error?.localizedDescription)")
      }
    }
  }
}

extension ImageListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height / 4
  }
}
