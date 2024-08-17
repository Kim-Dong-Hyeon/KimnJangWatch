//
//  AddAlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/13/24.
//

import UIKit

import RxSwift
import RxCocoa

class AddAlarmViewController: UIViewController {
  
  private var addAlarmView = AddAlarmView(frame: .zero)
  private let disposeBag = DisposeBag()
  var alarmViewModel = AlarmViewModel()
  
  override func loadView() {
    addAlarmView = AddAlarmView(frame: UIScreen.main.bounds)
    self.view = addAlarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    initNavigation()
    bind()
  }
  
  private func initNavigation() {
    navigationItem.title = "알람 편집"
    navigationItem.rightBarButtonItem = saveButton()
    navigationItem.leftBarButtonItem = cancelButton()
  }
  
  private func bind() {
    guard let right = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
    guard let left = navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
    
    right.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      let selectedDate = self.addAlarmView.timeView.date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      let time = dateFormatter.string(from: selectedDate)
      self.alarmViewModel.addTime(time)
      self.dismiss(animated: true)
    }.disposed(by: disposeBag)
    
    left.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.dismiss(animated: true)
    }.disposed(by: disposeBag)
  }
  
  private func saveButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("저장", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    return UIBarButtonItem(customView: button)
  }
  
  private func cancelButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    return UIBarButtonItem(customView: button)
  }
}
