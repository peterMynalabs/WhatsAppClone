
import Foundation
import UIKit

protocol CountrySelectorDelegate: class {
    func pressedOnRow(country: String)
}

class CountrySelectorViewController: VC {
    
    var mainView = UIView()
    var listOfCountries = Country().getListOfCountryNames()
    var searchController: UISearchController?
    
    weak var countrySelectorDelegate: CountrySelectorDelegate?
    
    override func loadView() {
        mainView.frame = UIScreen.main.bounds
        view = mainView
        mainView.backgroundColor = .white
        title = "Your Country"
        mainView.addSubview(tableView)
        definesPresentationContext = true
        
        tableView.snp.makeConstraints({ (make) -> Void in
            make.top.equalTo(mainView)
            make.left.equalTo(mainView)
            make.width.equalTo(mainView)
            make.height.equalTo(mainView)
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        listOfCountries.sort()
        setupSearchController()
    }
    
    var searchableCountrySelectorViewController: SearchableCountrySelectorViewController = {
        var tableView = SearchableCountrySelectorViewController()
        return tableView
    }()
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor =  UIColor(rgb: 0xF6F6F6)
        return tableView
    }()
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: searchableCountrySelectorViewController)
        searchableCountrySelectorViewController.searchableCountrySelectorDelegate = self
        searchableCountrySelectorViewController.listOfCountries = listOfCountries
        searchController!.searchResultsUpdater = self
        searchController!.obscuresBackgroundDuringPresentation = false
        searchController!.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
    }
}

extension CountrySelectorViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text != "" {
            searchableCountrySelectorViewController.listOfCountries = Array(Country().getListOfCountryNames()).filter({$0.contains(text)})
            searchableCountrySelectorViewController.tableView.reloadData()
            searchController.obscuresBackgroundDuringPresentation = false
            searchableCountrySelectorViewController.tableView.isUserInteractionEnabled = true
            
        } else {
            searchController.obscuresBackgroundDuringPresentation = true
            searchableCountrySelectorViewController.listOfCountries = Country().getListOfCountryNames().sorted()
            searchableCountrySelectorViewController.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text =  listOfCountries[indexPath.row]
        cell.detailTextLabel!.text = "+" + Country().getCountryPhoneCode(from: listOfCountries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(Country().getCountryPhoneCode(from: listOfCountries[indexPath.row]))
        countrySelectorDelegate?.pressedOnRow(country: Country().getCountryPhoneCode(from: listOfCountries[indexPath.row]))
        navigationController?.popViewController(animated: true)
    }
}

extension CountrySelectorViewController: SearchableCountrySelectorDelegate {
    func pressedCell(country: String) {
        countrySelectorDelegate?.pressedOnRow(country: Country().getCountryPhoneCode(from: country))
        navigationController?.popToRootViewController(animated: true)
    }
}
