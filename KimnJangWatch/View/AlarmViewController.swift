//
//  AlarmViewController.swift
//  KimnJangWatch
//
//  Created by 김윤홍 on 8/12/24.
//
//rootViewController 수정해야함 TabBarController로 반드시 반드시

import UIKit

import RxSwift
import RxCocoa

class AlarmViewController: UIViewController {
  
  private var alarmView = AlarmView(frame: .zero)
  private let disposeBag = DisposeBag()
  private let alarmViewModel = AlarmViewModel()
  
  override func loadView() {
    alarmView = AlarmView(frame: UIScreen.main.bounds)
    self.view = alarmView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    alarmView.alarmList.register(AlarmListCell.self,
                                 forCellReuseIdentifier: AlarmListCell.identifier)
    initNavigation()
    bind()
  }
  
  private func bind() {
    alarmView.alarmList.rx.itemSelected
      .subscribe(onNext: { indexPath in
        if let _ = self.alarmView.alarmList.cellForRow(at: indexPath) as? AlarmListCell {
          self.showModal()
        }
      }).disposed(by: disposeBag)
    
    alarmViewModel.ids
      .bind(to: alarmView.alarmList.rx
        .items(cellIdentifier: AlarmListCell.identifier,
               cellType: AlarmListCell.self)) { index, alarm, cell in
        cell.timeLabel.text = "12:10"
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
    button.setTitle("+", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    
    button.rx.tap.bind { [weak self] in
      self?.showModal()
    }.disposed(by: disposeBag)
    return UIBarButtonItem(customView: button)
  }
  
  private func getLeftBarButton() -> UIBarButtonItem {
    let button = UIButton()
    button.setTitle("편집", for: .normal)
    button.setTitleColor(UIColor.dangn, for: .normal)
    
    button.rx.tap.bind { [weak self] in
      self?.edit()
    }.disposed(by: disposeBag)
    return UIBarButtonItem(customView: button)
  }
  
  func showModal() {
    let modal = UINavigationController(rootViewController: AddAlarmViewController())
    present(modal, animated: true, completion: nil)
  }
  
  func edit() {
    print("편집화면 구현하기")
  }
}

//struct PreView: PreviewProvider {
//  static var previews: some View {
//    AlarmViewController().toPreview()
//  }
//}
//
//#if DEBUG
//extension UIViewController {
//  private struct Preview: UIViewControllerRepresentable {
//    let viewController: UIViewController
//    func makeUIViewController(context: Context) -> UIViewController {
//      return viewController
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    }
//  }
//  func toPreview() -> some View {
//    Preview(viewController: self)
//  }
//}
//#endif
