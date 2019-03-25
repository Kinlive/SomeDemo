//
//  MusicListViewController.swift
//  DemoRxSwift
//
//  Created by Kinlive on 2019/3/5.
//  Copyright © 2019 Kinlive. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyJSON

class MusicListViewController: UIViewController, UITableViewDelegate {

  let tableView: UITableView! = {
    let tv = UITableView()
    tv.register(MusicCell.self, forCellReuseIdentifier: "Cell")
    return tv
  }()

  let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,JSON>>(
    configureCell: { (_, tv, indexPath, element) in
      let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
      cell.textLabel?.text = element["name"].string
      return cell
  }, titleForHeaderInSection: { (dataSource, sectionIndex) in
    return dataSource.sectionModels[sectionIndex].model
  })

  let disposeBag = DisposeBag()

  let rxChannels = BehaviorRelay<[SectionModel<String,JSON>]>(value: [SectionModel(model: "", items: [])])


  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()

    tableView.rx
      .setDelegate(self)
      .disposed(by: disposeBag)

    tableView.rx
      .itemSelected
      .subscribe { [unowned self] event in
        let channelId = self.rxChannels.value[0].items[event.element!.row]["channel_id"].string ?? ""
        RequestManager.shared.request(type: .playlist(channelId), head: "song", completion: { (json) in
          guard
            let ujson = json,
            let title = ujson.array?[0]["title"],
            let albumtitle = ujson.array?[0]["albumtitle"]
          else { return }
          print("print json: \(String(describing: ujson.array))")

          self.showAlert(title: title.string, message: albumtitle.string)
        })
        self.tableView.deselectRow(at: event.element!, animated: true)

//        MusicProvider.request(Player.playlist(channelId), completion: { (result) in
//          do {
//            switch result {
//            case .success(let response):
//              let json = try JSON(data: response.data)["song"]
//              print("print json: \(json.array)")
//            case .failure(let err):
//              print("failure : \(err)")
//            }
//          } catch let e {
//            print("Catch error :\(e.localizedDescription)")
//          }
//        })

    }.disposed(by: disposeBag)

    // 餵給tableView.items是複數用陣列裝
    rxChannels
      .bind(to: self.tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    // Do any additional setup after loading the view.
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    RequestManager.shared.request(type: .channels, head: "channels") {
      guard let json = $0 else { return }
      self.rxChannels.accept([SectionModel(model: "SectionName", items: json.array ?? [])])
    }

//    MusicProvider.request(.channels) { [unowned self] (result) in
//      do {
//        switch result {
//        case .success(let response):
//          let json = try JSON(data: response.data)["channels"]
//          self.rxChannels.accept([SectionModel(model: "channels", items: json.array ?? [])])
//        case .failure(let error):
//          print("On request with error: \(error)")
//        }
//      } catch let e {
//        print("Moya transfer data error: \(e.localizedDescription)")
//      }
//    }

  }

  func showAlert(title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }

  func setupUI() {
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
    let leading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
    let trailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
    let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
    NSLayoutConstraint.activate([top, leading, trailing, bottom])

  }

}


class MusicCell: UITableViewCell {



}
