//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private lazy var bankView = BankView(frame: view.bounds)
    private var bank = Bank()
    
    var timer = Timer()
    var isPlay = false
    var counter = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = bankView
        setButtons()
        bankView.timerLabel.text = String(counter)
    }
    
    private func setButtons() {
        bankView.addCustomerButton.addTarget(self, action: #selector(touchAddCustomerButton), for: .touchUpInside)
        bankView.resetButton.addTarget(self, action: #selector(touchResetButton), for: .touchUpInside)
    }
    
    @objc private func touchAddCustomerButton() {
        bank.delegate = self
        bank.newOpen()
  
    }
    
    func startTimer() {
        if isPlay {
            return
        }
        isPlay = true
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        counter += 0.01
        bankView.timerLabel.text = String(format: "%.2f", counter)
    }
    
    @objc private func touchResetButton() {
        bank.resetWork()
    }
}

extension ViewController: BankDelegate {
    func addCustomer(customer: Customer) {
        var customerLabel: UILabel {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.preferredFont(forTextStyle: .title3)
            label.text = "\(customer.number) - \(customer.task.title)"
            return label
        }
        bankView.waitingStackView.addArrangedSubview(customerLabel)
    }
    
    func sendTaskingCustomer(customer: Customer) {
        DispatchQueue.main.async {
            self.startTimer()
            self.bankView.waitingStackView.arrangedSubviews.forEach {
                let label = $0 as? UILabel
                if label?.text == "\(customer.number) - \(customer.task.title)" {
                    $0.removeFromSuperview()
                    self.bankView.taskingStackView.addArrangedSubview($0)
                }
            }
        }
    }
    
    func sendEndCustomer(customer: Customer) {
        DispatchQueue.main.async {
            self.bankView.taskingStackView.arrangedSubviews.forEach({
                let label = $0 as? UILabel
                if label?.text == "\(customer.number) - \(customer.task.title)" {
                    $0.removeFromSuperview()
                }
            })
        }
    }
    func sendFinishWork() {
        isPlay = false
        timer.invalidate()
    }
}
