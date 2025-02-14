//
//  CityViewController.swift
//  CityWeather
//
//  Created by 김정호 on 2/13/25.
//

import UIKit

final class CityViewController: BaseViewController {
    
    // MARK: - properties
    private let cityView = CityView()
    private let viewModel = CityViewModel()
    
    // MARK: - life cycles
    override func loadView() {
        view = cityView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.willAppearView.value = ()
    }
    
    // MARK: - methods
    override func configureStyle() {
        cityView.tableView.separatorStyle = .none
    }
    
    override func configureDelegate() {
        cityView.tableView.delegate = self
        cityView.tableView.dataSource = self
        cityView.tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
    }
    
    override func configureAddTarget() {
        cityView.refreshBarButtonItem.target = self
        cityView.refreshBarButtonItem.action = #selector(tappedRefreshBarButtonItem)
        
        cityView.searchBarButtonItem.target = self
        cityView.searchBarButtonItem.action = #selector(tappedSearchBarButtonItem)
    }
    
    override func bind() {
        viewModel.output.region.lazyBind { [weak self] region in
            guard let region else { return }
            self?.configureNavigation(title: "\(region.koCountryName), \(region.koCityName)")
        }
        
        viewModel.output.weather.lazyBind { [weak self] _ in
            self?.cityView.bindDate(date: Date())
            self?.cityView.tableView.reloadData()
        }
        
        viewModel.output.iconImage.lazyBind { [weak self] _ in
            self?.cityView.tableView.reloadData()
        }
        
        viewModel.output.photoImage.lazyBind { [weak self] _ in
            self?.cityView.tableView.reloadData()
        }
        
        viewModel.output.citySearchView.lazyBind { [weak self] _ in
            self?.navigationController?.pushViewController(CitySearchViewController(), animated: true)
        }
    }
    
    private func configureNavigation(title: String) {
        navigationItem.title = title
        navigationItem.rightBarButtonItems = [cityView.searchBarButtonItem, cityView.refreshBarButtonItem]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc
    private func tappedRefreshBarButtonItem() {
        viewModel.input.tappedRefreshBarButtonItem.value = ()
    }
    
    @objc
    private func tappedSearchBarButtonItem() {
        viewModel.input.tappedSearchBarButtonItem.value = ()
    }
}

// MARK: - extensions
extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as? CityCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.bindIcon(weather: viewModel.output.weather.value, data: viewModel.output.iconImage.value)
        case 5:
            cell.bindPhoto(data: viewModel.output.photoImage.value)
        default:
            cell.bindWeather(weather: viewModel.output.weather.value, index: indexPath.row)
        }
        
        return cell
    }
}
