//
//  TestTableViewController.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/2/11.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TestTableViewController: UIViewController {

  @IBOutlet weak var tableVC: UITableView!


  /// ---> must keyin self
  let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>> (
    configureCell: { (_, tv, indexPath, element) in
      let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
      cell.textLabel?.text = "\(element) @row: \(indexPath.row)"
      return cell
    },
    titleForHeaderInSection: { dataSource, sectionIndex in
      return dataSource[sectionIndex].model
    }
  )
 /// <----

  let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

      let ds = self.dataSource
      let items = Observable.just([
        SectionModel(model: "First section",
                     items: [1.0, 2.0, 3.0]),
        SectionModel(model: "Second section",
                     items: [1.0, 2.0, 3.0]),
        SectionModel(model: "Third section",
                     items: [1.0, 2.0, 3.0])
        ])

      items
        .bind(to: tableVC.rx.items(dataSource: ds))
        .disposed(by: disposeBag)

      tableVC.rx
        .itemSelected
        .map { indexPath in
          return (indexPath, ds[indexPath])
        }
        .subscribe(onNext: { [unowned self] in
          self.tableVC.deselectRow(at: $0.0, animated: true)
          self.presentAlert(info: $0)
        })
        .disposed(by: disposeBag)

      tableVC.rx
        .setDelegate(self)
        .disposed(by: disposeBag)
  }



  func presentAlert(info: (IndexPath, Double)) {
    let alert = UIAlertController(title: "\(info.0)", message: "\(info.1)", preferredStyle: .alert)
    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }

}

extension TestTableViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .none
  }
}

extension TestTableViewController {
  static var `default`: Double {
    return 5.0
  }
}




/** 奇怪的用法
func testFF() {
  var testInstance: TestInstance = .default
  testInstance = .aaaaa
}

open class TestInstance {
  public static let `default` = TestInstance(name: "DEFAULT!")
  public static let aaaaa = TestInstance(name: "TODetj")
  public init(name: String) {
    let catchName = "I test the default and with it name: \(name)"
    print(catchName)
  }
}
*/

