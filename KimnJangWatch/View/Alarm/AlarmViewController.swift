//
//  AlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//
//편집시 rxDataSources사용 하기

import UIKit

import RxSwift
import RxCocoa

class AlarmViewController: UIViewController {
  
  private var alarmView = AlarmView(frame: .zero)
  private let disposeBag = DisposeBag()
  private let alarmViewModel = AlarmViewModel()
  private var time = String()
  
  override func loadView() {
    alarmView = AlarmView(frame: UIScreen.main.bounds)
    self.view = alarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    alarmView.alarmList.delegate = self
    view.backgroundColor = .systemBackground
    alarmView.alarmList.register(AlarmListCell.self,
                                 forCellReuseIdentifier: AlarmListCell.identifier)
    initNavigation()
    bind()
  }
  
  //ViewModel transForm input, output으로 설정해야함
  func compareTimes(_ time1: String, _ time2: String) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    guard let date1 = dateFormatter.date(from: time1),
          let date2 = dateFormatter.date(from: time2) else {
      return false
    }
    
    return date1 < date2
  }
  
  //navigationBar 랑 viewModel q분리하면 깔끔해질것 같은뎨>
  private func bind() {
    alarmView.alarmList.rx.itemSelected
      .subscribe(onNext: { indexPath in
        if let cell = self.alarmView.alarmList.cellForRow(at: indexPath) as? AlarmListCell {
          self.time = cell.timeLabel.text ?? "00:00"
          self.showModal(time: self.time)
        }
      }).disposed(by: disposeBag)
    
    alarmViewModel.savedTimes
      .debug()
      .observe(on: MainScheduler.instance)
      .map { dictionary -> [(time: String, days: [String])] in
        let sortedKeys = dictionary.keys.sorted { self.compareTimes($0, $1) }
        return sortedKeys.map { time in
          (time: time, days: dictionary[time] ?? [])
        }
      }
      .bind(to: alarmView.alarmList.rx.items(cellIdentifier: AlarmListCell.identifier, cellType: AlarmListCell.self)) { _, item, cell in
        cell.configure(time: item.time, days: item.days)
      }
      .disposed(by: disposeBag)
    
    guard let right = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
    right.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.showModal(time: self.time)
    }.disposed(by: disposeBag)
    
    guard let left = navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
    left.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.edit()
    }.disposed(by: disposeBag)
  }
  
  private func initNavigation() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.title = "알람"
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.rightBarButtonItem = getRightBarButton()
    navigationItem.leftBarButtonItem = getLeftBarButton()
  }
  
  private func getRightBarButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setImage(UIImage(systemName: "plus"), for: .normal)
    button.tintColor = UIColor.dangn
    return UIBarButtonItem(customView: button)
  }
  
  private func getLeftBarButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("편집", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    return UIBarButtonItem(customView: button)
  }
  
  private func showModal(time: String) {
    let addAlarmVC = AddAlarmViewController(time: time)
    addAlarmVC.alarmViewModel = self.alarmViewModel
    let modal = UINavigationController(rootViewController: addAlarmVC)
    present(modal, animated: true, completion: nil)
  }
  
  private func edit() {
    let shouldBeEdited = !alarmView.alarmList.isEditing
    alarmView.alarmList.setEditing(shouldBeEdited, animated: true)
    let newTitle = shouldBeEdited ? "완료" : "편집"
    (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(newTitle, for: .normal)
  }
}

extension AlarmViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
      guard let self = self else { return }
      // 삭제할 시간을 찾기 위해 인덱스를 이용해 키를 가져옴
      if let cell = tableView.cellForRow(at: indexPath) as? AlarmListCell {
        // 셀의 timeLabel.text를 이용해 삭제할 시간 값을 가져옴
        let time = cell.timeLabel.text ?? ""
        // ViewModel을 통해 해당 시간을 삭제
        self.alarmViewModel.removeTime(time: time)
      }
      completionHandler(true)  // 삭제 완료 후 콜백 호출
    }
    
    // 액션을 포함하는 UISwipeActionsConfiguration을 반환
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    configuration.performsFirstActionWithFullSwipe = true  // 전체 스와이프시 자동으로 삭제 실행
    return configuration
  }
}
