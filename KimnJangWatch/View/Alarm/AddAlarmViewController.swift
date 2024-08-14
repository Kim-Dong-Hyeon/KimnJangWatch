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
  
  //bind? subscribe? 나중에 userDefault에 연결혀줄것을 생각하기 !
  private func saveButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("저장", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    
    button.rx.tap.bind { [weak self] in
      self?.dismiss(animated: true)
    }.disposed(by: disposeBag)
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
