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
  
  private func bind() {
    
    alarmView.alarmList.rx.itemSelected
      .subscribe(onNext: { indexPath in
        if let cell = self.alarmView.alarmList.cellForRow(at: indexPath) as? AlarmListCell {
          self.time = cell.timeLabel.text ?? "00:00"
          self.showModal(time: self.time)
        }
      }).disposed(by: disposeBag)
    
//    alarmView.alarmList.rx.itemDeleted
//      .subscribe(onNext: { [weak self] indexPath in
//        guard let self = self else { return }
//        
//        var time = self.alarmViewModel.savedTimes.value()
//        time.remove(at: indexPath.row)
//        self.alarmViewModel.savedTimes.onNext(time)
//      })
    
    alarmViewModel.savedTimes
      .debug()
      .observe(on: MainScheduler.instance)
      .bind(to: alarmView.alarmList.rx
        .items(cellIdentifier: AlarmListCell.identifier,
               cellType: AlarmListCell.self)) { _, time, cell in
        cell.timeLabel.text = time
      }.disposed(by: disposeBag)
    
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
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    print("delte모드\(indexPath)")
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    print("나와라 제발\(indexPath)")
    if editingStyle == .delete {
      print("삭제")
//      var currentTimes = alarmViewModel.savedTimes.value
//      currentTimes.remove(at: indexPath.row)
//      alarmViewModel.savedTimes.accept(currentTimes)
    }
  }
}
