//
//  DisplayViewController.swift
//  nekofiles
//
//  Created by samara on 2/24/24.
//

import UIKit

class DisplayViewController: UITableViewController {

	let tableData = [
		["Appearence"],
		["Collection View"]
	]
	
	var sectionTitles = [
		"",
		"Tint Color"
	]

	let collectionData = ["Default", "Berry", "Dr Pepper", "Cool Blue", "Fuchsia", "Purplish"]
	let collectionDataColors = ["848ef9", "ff7a83", "711f25", "4161F1", "FF00FF", "D7B4F3"]
	
	init() { super.init(style: .insetGrouped) }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Display"

		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "CollectionCell")
	}
	
	func updateAppearance(with style: UIUserInterfaceStyle) {
		view.window?.overrideUserInterfaceStyle = style
		Preferences.preferredInterfaceStyle = style.rawValue
	}
}

extension DisplayViewController {
	override func numberOfSections(in tableView: UITableView) -> Int { return sectionTitles.count }
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableData[section].count }
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { return sectionTitles[section] }
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return sectionTitles[section].isEmpty ? 5 : 40 }
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let title = sectionTitles[section]
		let headerView = InsetGroupedSectionHeader(title: title)
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let reuseIdentifier = "Cell"
		let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
		cell.selectionStyle = .none
		let cellText = tableData[indexPath.section][indexPath.row]
		switch cellText {
		case "Appearence":
			cell.textLabel?.text = "Appearance"
			let segmentedControl = UISegmentedControl(items: UIUserInterfaceStyle.allCases.map { $0.description })
			segmentedControl.selectedSegmentIndex = UIUserInterfaceStyle.allCases.firstIndex { $0.rawValue == Preferences.preferredInterfaceStyle } ?? 0
			segmentedControl.addTarget(self, action: #selector(appearanceSegmentedControlChanged(_:)), for: .valueChanged)
			cell.accessoryView = segmentedControl

		case "Collection View":
			let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionTableViewCell
			cell.setData(collectionData: collectionData, colors: collectionDataColors)
			cell.backgroundColor = .clear
			return cell
		default:
			break
		}
		return cell
	}
	
	@objc private func appearanceSegmentedControlChanged(_ sender: UISegmentedControl) {
		let selectedStyle = UIUserInterfaceStyle.allCases[sender.selectedSegmentIndex]
		updateAppearance(with: selectedStyle)
	}
}

extension UIUserInterfaceStyle: CaseIterable {
	public static var allCases: [UIUserInterfaceStyle] = [.unspecified, .dark, .light]
	var description: String {
		switch self {
		case .unspecified:
			return "System"
		case .light:
			return "Light"
		case .dark:
			return "Dark"
		@unknown default:
			return "Unknown Mode"
		}
	}
}