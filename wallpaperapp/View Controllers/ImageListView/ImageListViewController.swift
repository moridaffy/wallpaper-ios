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
  private let model = ImageListViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupConstraints()
    setupTableView()
    setupReactive()
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
    tableView.register(ImageCellView.self, forCellReuseIdentifier: "ImageCell")
  }
  
  private func setupReactive() {
    model.imageUrl.asObservable()
      .bind(to: tableView.rx.items) { tableView, _, url in
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as? ImageCellView {
          cell.setup(model: ImageCellViewModel(imageUrl: url))
          return cell
        } else {
          fatalError("🔥 Can't dequeue cell with ID: TaskListCell")
        }
      }.disposed(by: disposeBag)
  }
}

extension ImageListViewController {
  @objc private func pullToRefresh() {
    APIManager.loadImages(search: nil) { [weak self] (imageUrl, error) in
      self?.refresher?.endRefreshing()
      if let imageUrl = imageUrl {
        self?.model.imageUrl.value = imageUrl
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
