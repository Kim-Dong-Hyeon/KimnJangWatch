//
//  TestNotificationViewController.swift
//  KimnJangWatch
//
//  Created by 김동현 on 8/13/24.
//

import UIKit
import SnapKit

class TestNotificationViewController: UIViewController {
  
  private let triggerButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("5초 후 알림 생성", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    self.triggerButton.addTarget(self, action: #selector(triggerNotification), for: .touchUpInside)
  }
  
  private func configureUI() {
    view.backgroundColor = .white
    view.addSubview(triggerButton)
    
    triggerButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
  
  @objc private func triggerNotification() {
    let date = Date().addingTimeInterval(5) // 5초 후 알림 트리거
    NotificationManager.shared.scheduleNotification(at: date, with: "test 알림입니다")
    
    let alert = UIAlertController(title: "알림 예약됨", message: "알림이 5초 뒤에 울립니다.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
