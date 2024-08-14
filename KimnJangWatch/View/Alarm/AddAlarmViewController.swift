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
  private let alarmViewModel = AlarmViewModel()
  
  override func loadView() {
    addAlarmView = AddAlarmView(frame: UIScreen.main.bounds)
    self.view = addAlarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    initNavigation()
  }
  
  private func initNavigation() {
    navigationItem.title = "알람 편집"
    navigationItem.rightBarButtonItem = saveButton()
    navigationItem.leftBarButtonItem = cancelButton()
  }
  
  //bind부분과 UIBarButton 설정하는거 분리해주기
  private func saveButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("저장", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    
    button.rx.tap.bind { [weak self] in
      let selectedDate = self?.addAlarmView.timeView.date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH시 mm분"
      let time = dateFormatter.string(from: selectedDate!)
      var times = UserDefaults.standard.array(forKey: "times") as? [String] ?? []
      times.append(time)
      print(times)
      UserDefaults.standard.set(times, forKey: "times")
      self?.alarmViewModel.savedTimes.onNext(times)
      self?.dismiss(animated: true)}.disposed(by: disposeBag)
    return UIBarButtonItem(customView: button)
  }
  
  private func cancelButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    
    button.rx.tap.bind { [weak self] in
      self?.dismiss(animated: true)
    }.disposed(by: disposeBag)
    return UIBarButtonItem(customView: button)
  }
}
