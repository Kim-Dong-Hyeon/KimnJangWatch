//
//  AddAlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/13/24.
// //hour, minutem time, dayArray등 Model로 파일 분리? DateFormatter를 ViewModel로 묶어서 재활용하기?

import UIKit
import CoreData

import RxSwift
import RxCocoa

class AddAlarmViewController: UIViewController {
  
  private var addAlarmView = AddAlarmView(frame: .zero)
  private let disposeBag = DisposeBag()
  var alarmViewModel = AlarmViewModel()
  private let hour: Int
  private let minute: Int
  private var time: String
  let dataManager = DataManager()
  var onSave: (() -> Void)?
  
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
  
  // 시간과 분을 입력받아 오늘 날짜의 Date 객체를 생성하는 메서드
  private func createDate(hour: String, minute: String) -> Date {
    let calendar = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.hour = Int(hour)
    dateComponents.minute = Int(minute)
    dateComponents.year = calendar.component(.year, from: Date())
    dateComponents.month = calendar.component(.month, from: Date())
    dateComponents.day = calendar.component(.day, from: Date())
    
    // 오늘 날짜의 시간으로 Date 생성
    var date = calendar.date(from: dateComponents) ?? Date()
    
    // 현재 시간보다 이전 시간이라면, 다음날로 설정
    if date < Date() {
      date = calendar.date(byAdding: .day, value: 1, to: date)!
    }
    
    return date
  }
  
  private func bind() {
    guard let right = navigationItem.rightBarButtonItem?.customView as? UIButton else { return }
    guard let left = navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
    
    // 반복 및 사운드 페이지로 이동하는 부분을 확인합니다.
    addAlarmView.timeSetList.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let self = self else { return }
        
        if indexPath.row == 0 {
          // 반복 설정 페이지로 이동
          let dayTableViewController = DayTableViewController(time: self.time)
          self.navigationController?.pushViewController(dayTableViewController, animated: true)
        } else if indexPath.row == 2 {
          // 사운드 설정 페이지로 이동
          let alarmSongViewController = AlarmSongViewController()
          self.navigationController?.pushViewController(alarmSongViewController, animated: true)
        }
      }).disposed(by: disposeBag)
    
    // 알람 저장 버튼과 취소 버튼의 동작을 설정합니다.
    right.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.saveAlarm()
    }.disposed(by: disposeBag)
    
    left.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.dismiss(animated: true, completion: nil)
    }.disposed(by: disposeBag)
  }
  
  // 알람 저장 로직을 함수로 분리
  private func saveAlarm() {
    let selectedDate = addAlarmView.timeView.date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let time = dateFormatter.string(from: selectedDate)
    
    if let labelCell = addAlarmView.timeSetList.cellForRow(at: IndexPath(row: 1, section: 0)) as? TimeSetCell,
       let switchCell = addAlarmView.timeSetList.cellForRow(at: IndexPath(row: 3, section: 0)) as? TimeSetCell {
      let message = labelCell.getMessage()
      let repeatAlarm = switchCell.getRepeat()
      
      let newAlarmID = UUID().uuidString
      let alarmDate = self.createDate(hour: String(time.prefix(2)), minute: String(time.suffix(2)))
      
      NotificationManager.shared.scheduleNotification(
        at: alarmDate,
        with: message,
        identifier: newAlarmID,
        repeats: dataManager.readUserDefault(key: "day") ?? [],
        snooze: repeatAlarm
      )
      
      dataManager.createTime(
        id: UUID(),
        hour: String(time.prefix(2)),
        minute: String(time.suffix(2)),
        repeatDays: dataManager.readUserDefault(key: "day") ?? [],
        message: message,
        isOn: true,
        repeatAlarm: repeatAlarm
      )
    }
    
    self.onSave?()
    self.dismiss(animated: true, completion: nil)
  }
  
  private func saveButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("저장", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    dataManager.deleteUserDefault(key: "day")
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
