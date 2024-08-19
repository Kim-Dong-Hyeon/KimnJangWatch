//
//  AddAlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/13/24.
// //hour, minutem time, dayArray등 Model로 파일 분리? DateFormatter를 ViewModel로 묶어서 재활용하기?

import UIKit

import RxSwift
import RxCocoa

class AddAlarmViewController: UIViewController {
  
  private var addAlarmView = AddAlarmView(frame: .zero)
  private let disposeBag = DisposeBag()
  var alarmViewModel = AlarmViewModel()
  private let hour: Int
  private let minute: Int
  private var time: String
  private var dayArray: [Int] = []
  
  init(time: String) {
    hour = Int(time.prefix(2)) ?? 0
    minute = Int(time.suffix(2)) ?? 0
    self.time = time
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    addAlarmView = AddAlarmView(frame: UIScreen.main.bounds)
    self.view = addAlarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    addAlarmView.timeSetList.register(TimeSetCell.self,
                                      forCellReuseIdentifier: TimeSetCell.identifier)
    addAlarmView.timeSetList.dataSource = self
    addAlarmView.timeSetList.delegate = self
    configureUI()
    bind()
  }
  
  private func configureUI() {
    navigationItem.title = "알람 편집"
    navigationItem.rightBarButtonItem = saveButton()
    navigationItem.leftBarButtonItem = cancelButton()
    
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.hour = hour
    dateComponents.minute = minute
    
    if let time = calendar.date(from: dateComponents) {
      addAlarmView.timeView.date = time
    }
  }
  
  private func bind() {
    guard let right = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
    guard let left = navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
    
    addAlarmView.timeSetList.rx.itemSelected
      .subscribe(onNext: { indexPath in
        if self.addAlarmView.timeSetList.cellForRow(at: indexPath) is TimeSetCell {
          if indexPath.row == 0 {
            self.navigationController?.pushViewController(DayTableViewController(time: self.time), animated: true)
          } else if indexPath.row == 2 {
            self.navigationController?.pushViewController(AlarmSongViewController(), animated: true)
          }
        }
      }).disposed(by: disposeBag)
    
    right.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      let selectedDate = self.addAlarmView.timeView.date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      let time = dateFormatter.string(from: selectedDate)
      if let savedDayArray = UserDefaults.standard.dictionary(forKey: "times") as? [String: [Int]] {
        dayArray = savedDayArray[time] ?? []
        self.alarmViewModel.addTime(day: dayArray, time: time)
      }
      self.dismiss(animated: true, completion: nil)
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

extension AddAlarmViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: TimeSetCell.identifier,
      for: indexPath) as? TimeSetCell else { return UITableViewCell() }
    cell.configureCell(indexPath: indexPath.row)
    return cell
  }
}
