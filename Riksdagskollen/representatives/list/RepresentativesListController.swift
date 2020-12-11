//
//  RepresentativesListController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-12-07.
//

import UIKit
import Sheeeeeeeeet


class RepresentativesListController: UITableViewController, UIActionSheetDelegate {

    
    private var optionsButton: UIBarButtonItem!
    private var optionsMenu: ActionSheet!
    private var model: RepresentativesListModel!
    private var currentPartyFilter: Set<String>!

    override func viewDidLoad() {
        super.viewDidLoad()
        model = RepresentativesListModel(onDataChange: {self.tableView.reloadData()})
        currentPartyFilter = model.filteredParties
        setupTableview()

        optionsMenu = buildActionSheetMenu()
        optionsButton = parent!.navigationItem.rightBarButtonItems![1]
        optionsButton.target = self
        optionsButton.action = #selector(showOptionsMenu(sender:))
        
    }
    
    @objc func showOptionsMenu(sender: AnyObject){
        buildActionSheetMenu().present(in: self, from: view)
    }
    
    
    private func buildActionSheetMenu() -> ActionSheet {
        var items = [MenuItem]()
        items.append(MenuItem(title: "Filtrera efter parti", subtitle: nil, value: nil, image: UIImage(named: "filter"), isEnabled: true, tapBehavior: .dismiss))
        items.append(SectionMargin())
        items.append(SectionTitle(title: "Sortering"))
        items.append(SingleSelectItem(title: "Stigande", subtitle: nil, isSelected: model.currentSortOrderOption == .ascending, group: "sortorder", value: RepresentativesSortOrderOption.ascending, image: UIImage(systemName: "arrow.up"), tapBehavior: .dismiss))
        items.append(SingleSelectItem(title: "Fallande", subtitle: nil, isSelected:  model.currentSortOrderOption == .descending, group: "sortorder", value: RepresentativesSortOrderOption.descending, image: UIImage(systemName: "arrow.down"), tapBehavior: .dismiss))
        items.append(SectionMargin())
        items.append(SingleSelectItem(title: "Sortera efter förnamn", subtitle: nil, isSelected: model.currentSortingOption == .firstName, group: "sorting", value: RepresentativesSortingOption.firstName, image: nil, tapBehavior: .dismiss))
        items.append(SingleSelectItem(title: "Sortera efter efternamn", subtitle: nil, isSelected: model.currentSortingOption  == .lastName, group: "sorting", value: RepresentativesSortingOption.lastName, image: nil, tapBehavior: .dismiss))
        items.append(SingleSelectItem(title: "Sortera efter ålder", subtitle: nil, isSelected: model.currentSortingOption  == .age, group: "sorting", value: RepresentativesSortingOption.age, image: nil, tapBehavior: .dismiss))
        items.append(SingleSelectItem(title: "Sortera efter valkrets", subtitle: nil, isSelected: model.currentSortingOption  == .district, group: "sorting", value: RepresentativesSortingOption.district, image: nil, tapBehavior: .dismiss))
        items.append(SectionMargin())
        items.append(OkButton(title: "Avbryt"))

        let menu = Menu(title: "Visningsalternativ", items: items)
        return menu.toActionSheet{ sheet, item in
            self.menuItemPressed(sheet: sheet, item: item)
        }
    }
    
    
    private func buildFilterActionSheet() -> ActionSheet {
        var items = [MenuItem]()
        items.append(MultiSelectToggleItem(title: "Partier", state: model.isAllPartiesSelected ? .deselectAll : .selectAll, group: "parties", selectAllTitle: "Markera alla", deselectAllTitle: "Avmarkera alla"))
        items[0].tapBehavior = .none
        
        for party in CurrentParties.values {
            let image = party.logo.resizeImage(targetSize: CGSize(width: 30, height: 30))
            items.append(MultiSelectItem(title: party.name, subtitle: nil, isSelected: model.filteredParties.contains(party.id), group: "parties", value: party.id, image: image))
        }
        items.append(OkButton(title: "Tillämpa"))
        items.append(CancelButton(title: "Avbryt"))
        
        let menu = Menu(title: "Filtrera efter parti", items: items)
        return menu.toActionSheet{ sheet, item in
            self.handleFilterSheetAction(sheet: sheet, item: item)
        }
    }
    
    func handleFilterSheetAction(sheet: ActionSheet, item: MenuItem) {
        if let partySelect = item as? MultiSelectItem {
            if partySelect.isSelected {
                currentPartyFilter.insert(partySelect.value as! String)
            } else {
                currentPartyFilter.remove(partySelect.value as! String)
            }
        } else if let _ = item as? OkButton{
            self.model.updateFilter(filteredParties: currentPartyFilter)
        } else if let multiToggleItem = item as? MultiSelectToggleItem {
            if multiToggleItem.state == .selectAll {
                currentPartyFilter.removeAll()
            } else {
                currentPartyFilter = Set(CurrentParties.values.map({$0.id}))
            }
        } else {
            currentPartyFilter = model.filteredParties
            sheet.dismiss()
        }
    }
    
    
    func menuItemPressed(sheet: ActionSheet, item: MenuItem){
        if let singleSelectItem = item as? SingleSelectItem {
            if singleSelectItem.group == "sortorder" {
                model.currentSortOrderOption = (singleSelectItem.value as! RepresentativesSortOrderOption)
            } else {
                model.currentSortingOption = (singleSelectItem.value as! RepresentativesSortingOption)
            }
        } else {
            buildFilterActionSheet().present(in: self, from: view)
        }
    }
    
    
    
    func setupTableview () {
        tableView.register(RepresentativeTableViewCell.nib(), forCellReuseIdentifier: RepresentativeTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorStyle = .none
    }
    
    func onRepresentativesDownloaded(_ representatives: [Representative]) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.currentRepresentatives.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepresentativeTableViewCell.identifier, for: indexPath) as! RepresentativeTableViewCell
        cell.configure(with: model.currentRepresentatives[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RepresentativeDetailsController()
        vc.representative = model.currentRepresentatives[indexPath.row]
        show(vc, sender: nil)
    }

}
