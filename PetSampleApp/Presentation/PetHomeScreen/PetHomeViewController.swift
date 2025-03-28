//
//  PetHomeViewController.swift
//  PetSampleApp
//
//  Created by Alin Stanusescu on 27.03.2025.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI

class PetHomeViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let tableView = UITableView()
    private let viewModel = PetHomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableHeader()
        bindTableView()
        bindErrors()
        viewModel.fetchAnimals()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(PetHomeTableViewCell.self, forCellReuseIdentifier: "PetCell")
    }

    private func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        headerView.backgroundColor = UIColor(hex: "3d2d8e")

        let headerLabel = UILabel(frame: headerView.bounds)
        headerLabel.text = "home_screen_title".localized
        headerLabel.textColor = .white
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textAlignment = .center

        headerView.addSubview(headerLabel)
        tableView.tableHeaderView = headerView
    }

    private func bindTableView() {
        viewModel.animals
            .bind(to: tableView.rx.items(cellIdentifier: "PetCell", cellType: PetHomeTableViewCell.self)) { row, animal, cell in
                cell.configure(with: animal)
            }
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(Animal.self)
              .subscribe(onNext: { [weak self] animal in
                  let detailView = PetDetailView(animal: animal)

                  let hostingController = UIHostingController(rootView: NavigationView { detailView })
                  hostingController.modalPresentationStyle = .automatic
                  self?.present(hostingController, animated: true)
              })
              .disposed(by: disposeBag)
    }

    private func bindErrors() {
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: "error".localized, message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
