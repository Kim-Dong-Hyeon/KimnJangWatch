//
//  AlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//

import UIKit

import RxSwift
import RxCocoa

class AlarmViewController: UIViewController {
  
  private var alarmView = AlarmView(frame: .zero)
  private let disposeBag = DisposeBag()
  private let alarmViewModel = AlarmViewModel()
  let dataManager = DataManager()
  
  private var timeEntities: [Time] = [] {
    didSet {
      alarmView.alarmList.reloadData()
    }
  }
  
  override func loadView() {
    alarmView = AlarmView(frame: UIScreen.main.bounds)
    self.view = alarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    initNavigation()
    fetchData()
    bindButtons()
  }
  
  private func setupView() {
    alarmView.alarmList.delegate = self
    alarmView.alarmList.dataSource = self
    view.backgroundColor = .systemBackground
    alarmView.alarmList.register(AlarmListCell.self, forCellReuseIdentifier: AlarmListCell.identifier)
  }

  private func fetchData() {
    let alarms = dataManager.readCoreData(entityType: Time.self)
    DispatchQueue.main.async { [weak self] in
      self?.timeEntities = alarms
    }
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
  
  private func bindButtons() {
    guard let rightButton = navigationItem.rightBarButtonItem?.customView as? UIButton,
          let leftButton = navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
    
    rightButton.rx.tap
      .bind { [weak self] in
        self?.showModal()
      }
      .disposed(by: disposeBag)
    
    leftButton.rx.tap
      .bind { [weak self] in
        self?.toggleEditingMode()
      }
      .disposed(by: disposeBag)
    
  }
  
  private func showModal() {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH mm"
    let currentTime = formatter.string(from: Date())
    
    let addAlarmVC = AddAlarmViewController(time: currentTime)
    addAlarmVC.alarmViewModel = self.alarmViewModel
    addAlarmVC.onSave = { [weak self] in
      self?.fetchData()
    }
    let modal = UINavigationController(rootViewController: addAlarmVC)
    present(modal, animated: true, completion: nil)
  }
  
  private func toggleEditingMode() {
    let isEditing = !alarmView.alarmList.isEditing
    alarmView.alarmList.setEditing(isEditing, animated: true)
    let newTitle = isEditing ? "완료" : "편집"
    (navigationItem.leftBarButtonItem?.customView as? UIButton)?.setTitle(newTitle, for: .normal)
  }
}

extension AlarmViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeEntities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListCell.identifier, for: indexPath) as? AlarmListCell else {
      return UITableViewCell()
    }
    
    let timeEntity = timeEntities[indexPath.row]
    cell.configure(time: "\(timeEntity.hour):\(timeEntity.minute)", days: timeEntity.repeatDays)
    cell.onOff.isOn = timeEntity.isOn
    cell.onOff.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    
    return cell
  }
  
  @objc private func switchValueChanged(_ sender: UISwitch) {
    guard let cell = sender.superview?.superview as? AlarmListCell,
          let indexPath = alarmView.alarmList.indexPath(for: cell) else { return }
    
    let timeEntity = timeEntities[indexPath.row]
    dataManager.updateAlarmStatus(id: timeEntity.id!, isOn: sender.isOn)
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (_, _, completionHandler) in
      guard let self = self else { return }
      
      let timeEntity = self.timeEntities[indexPath.row]
      self.alarmViewModel.removeTime(time: "\(timeEntity.hour):\(timeEntity.minute)")
      self.dataManager.deleteTime(id: timeEntity.id!)
      self.fetchData()
      
      completionHandler(true)
    }
    
    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
    configuration.performsFirstActionWithFullSwipe = true
    return configuration
  }
}
