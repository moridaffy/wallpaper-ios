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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.backgroundColor = (SettingsManager.shared.themeMode.value == .normal) ? UIColor.white : UIColor.black
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !SettingsManager.shared.demoMode {
      pullToRefresh()
    }
  }
  
  func setup(title: String?, model: ImageListViewModel = ImageListViewModel()) {
    self.model = model
    if let title = title {
      self.title = title
    }
  }
  
  private func setupUI() {
    let tableView = UITableView(frame: view.frame, style: .plain)
    view.addSubview(tableView)
    self.tableView = tableView
    
    if model.category == nil {
      let searchButton = UIButton()
      searchButton.setImage(#imageLiteral(resourceName: "icon_search").withRenderingMode(.alwaysTemplate), for: .normal)
      searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
      navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
    }
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
    
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.register(ImageTableCellView.self, forCellReuseIdentifier: "ImageTableCell")
  }
  
  private func setupReactive() {
    model.images.asObservable()
      .bind(to: tableView.rx.items) { (tableView, _, model) in
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableCell") as? ImageTableCellView {
          cell.setup(model: ImageTableCellViewModel(image: model))
          return cell
        } else {
          fatalError("🔥 Can't dequeue cell with ID: ImageTableCell")
        }
      }.disposed(by: disposeBag)
    
    tableView.rx.modelSelected(WallpaperImage.self)
      .subscribe { [weak self] (event) in
        if let image = event.element {
          let imageDetailedViewController = ImageDetailedViewController()
          imageDetailedViewController.setup(model: ImageDetailedViewModel(image: image))
          self?.present(imageDetailedViewController.embedInNavigationController(), animated: true, completion: nil)
        }
      }.disposed(by: disposeBag)
  }
}

extension ImageListViewController {
  @objc private func pullToRefresh() {
    let search = model.category?.searchString ?? model.category?.type.rawValue
    APIManager.loadImages(search: search) { response, error in
      self.refresher?.endRefreshing()
      if let response = response {
        self.model.setupContent(response: response, append: false)
      } else {
        print("🔥 Failed to load images: \(error?.localizedDescription ?? "unknown error")")
      }
    }
  }
  
  @objc private func searchButtonTapped() {
    let alert = UIAlertController(title: NSLocalizedString("Search", comment: ""),
                                  message: NSLocalizedString("Please, enter search request and hit \"Go\" button", comment: ""),
                                  preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.placeholder = NSLocalizedString("Cars", comment: "")
      textField.keyboardType = .asciiCapable
    }
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("Go", comment: ""), style: .default) { (_) in
      guard let searchText = alert.textFields?.first?.text, !searchText.isEmpty else { return }
      let imageListViewController = ImageListViewController()
      let searchCategory =  WallpaperCategory(type: .search, searchString: searchText)
      imageListViewController.setup(title: NSLocalizedString("Search", comment: ""), model: ImageListViewModel(category: searchCategory))
      self.navigationController?.pushViewController(imageListViewController, animated: true)
    })
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (_) in
      alert.dismiss(animated: true, completion: nil)
    })
    present(alert, animated: true, completion: nil)
  }
}

extension ImageListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height / 4
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == model.images.value.count - 1 {
      let indicator = UIActivityIndicatorView()
      indicator.startAnimating()
      tableView.tableFooterView = indicator
      APIManager.loadImages(search: model.category?.type.rawValue, page: model.page + 1) { (response, error) in
        self.tableView.tableFooterView = nil
        guard let response = response else {
          print("🔥 Failed to load images: \(error?.localizedDescription ?? "unknown error")")
          return
        }
        self.model.page += 1
        self.model.setupContent(response: response, append: true)
      }
    }
  }
}
