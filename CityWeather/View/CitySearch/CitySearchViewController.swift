//
//  CitySearchViewController.swift
//  CityWeather
//
//  Created by 김정호 on 2/14/25.
//

import UIKit

final class CitySearchViewController: BaseViewController {
    
    // MARK: - properties
    private let citySearchView = CitySearchView()
    private let viewModel = CitySearchViewModel()
    
    // MARK: - life cycles
    override func loadView() {
        view = citySearchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.input.didLoadView.value = ()
    }
    
    // MARK: - methods
    override func configureStyle() {
        configureNavigation()
        citySearchView.tableView.separatorStyle = .none
    }
    
    override func configureDelegate() {
        citySearchView.searchBar.delegate = self
        citySearchView.tableView.delegate = self
        citySearchView.tableView.dataSource = self
        citySearchView.tableView.register(CitySearchCell.self, forCellReuseIdentifier: CitySearchCell.identifier)
    }
    
    override func bind() {
        viewModel.output.weathers.lazyBind { [weak self] weathers in
            self?.citySearchView.hasData(hasData: !weathers.isEmpty)
        }
        
        viewModel.output.iconImages.lazyBind { [weak self] _ in
            self?.citySearchView.tableView.reloadData()
        }
        
        viewModel.output.cityView.lazyBind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = "도시 검색"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
    }
}

// MARK: - extensions
extension CitySearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.searchBarSearchButtonClicked.value = searchBar.text
    }
}

extension CitySearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            if !viewModel.output.isLoadingLast.value {
                viewModel.input.didScrollScrollView.value = ()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didSelectRowAt.value = indexPath
    }
}

extension CitySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.weathers.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitySearchCell.identifier, for: indexPath) as? CitySearchCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.bind(region: viewModel.output.regions.value[indexPath.row],
                  weather: viewModel.output.weathers.value[indexPath.row],
                  iconImage: viewModel.output.iconImages.value[indexPath.row])
        
        return cell
    }
}
