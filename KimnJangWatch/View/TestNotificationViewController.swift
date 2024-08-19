//
//  TestNotificationViewController.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/13/24.
//

import UIKit

import SnapKit

/// 사용자 인터페이스와 상호작용하며, ViewModel과 통신하여 알림 관련 작업을 수행합니다.
class TestNotificationViewController: UIViewController {
  
  private let viewModel = TestNotificationViewModel()
  
  private let triggerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("5초 후 알림 생성", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    return button
  }()
  
  private let pauseButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("일시정지", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    button.isEnabled = false
    return button
  }()
  
  private let resumeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("재개", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    button.isEnabled = false
    return button
  }()
  
  private let showNotificationsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("예약된 알림 목록 보기", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    return button
  }()
  
  private let removeNotificationsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("모든 알림 삭제", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    setupActions()
  }
  
  /// UI를 구성하는 메서드입니다. 버튼들을 화면에 배치합니다.
  private func configureUI() {
    view.backgroundColor = .white
    view.addSubview(triggerButton)
    view.addSubview(pauseButton)
    view.addSubview(resumeButton)
    view.addSubview(showNotificationsButton)
    view.addSubview(removeNotificationsButton)
    
    triggerButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-60)
    }
    
    pauseButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(triggerButton.snp.bottom).offset(20)
    }
    
    resumeButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(pauseButton.snp.bottom).offset(20)
    }
    
    showNotificationsButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(resumeButton.snp.bottom).offset(20)
    }
    
    removeNotificationsButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(showNotificationsButton.snp.bottom).offset(20)
    }
  }
  
  /// 버튼에 액션을 연결하는 메서드입니다.
  private func setupActions() {
    triggerButton.addTarget(self, action: #selector(triggerNotification), for: .touchUpInside)
    pauseButton.addTarget(self, action: #selector(pauseNotification), for: .touchUpInside)
    resumeButton.addTarget(self, action: #selector(resumeNotification), for: .touchUpInside)
    showNotificationsButton
      .addTarget(self, action: #selector(showPendingNotifications), for: .touchUpInside)
    removeNotificationsButton
      .addTarget(self, action: #selector(removeAllNotifications), for: .touchUpInside)
  }
  
  /// 5초 후 알림을 예약하는 메서드입니다. 알림이 예약되면 일시정지 버튼이 활성화됩니다.
  @objc private func triggerNotification() {
    viewModel.triggerNotification { identifier in
      self.pauseButton.isEnabled = true
      let alert = UIAlertController(
        title: "알림 예약됨",
        message: "알림이 5초 뒤에 울립니다.",
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  /// 예약된 알림을 일시정지하는 메서드입니다. 일시정지 후 재개 버튼이 활성화됩니다.
  @objc private func pauseNotification() {
    if let _ = viewModel.pauseNotification() {
      resumeButton.isEnabled = true
      pauseButton.isEnabled = false
    }
  }
  
  /// 일시정지된 알림을 재개하는 메서드입니다. 재개 후 일시정지 버튼이 다시 활성화됩니다.
  @objc private func resumeNotification() {
    if let _ = viewModel.resumeNotification() {
      resumeButton.isEnabled = false
      pauseButton.isEnabled = true
    }
  }
  
  /// 예약된 알림 목록을 표시하는 메서드입니다.
  @objc private func showPendingNotifications() {
    viewModel.showPendingNotifications { requests in
      let alertMessage = requests.map {
        "ID: \($0.identifier), Body: \($0.content.body)"
      }.joined(separator: "\n")
      
      let alert = UIAlertController(
        title: "알림 목록",
        message: alertMessage,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      DispatchQueue.main.async {
        self.present(alert, animated: true, completion: nil)
      }
    }
  }
  
  /// 모든 예약된 알림을 삭제하는 메서드입니다.
  @objc private func removeAllNotifications() {
    viewModel.removeAllNotifications {
      let alert = UIAlertController(
        title: "알림 삭제",
        message: "모든 예약된 알림이 삭제되었습니다.",
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}
