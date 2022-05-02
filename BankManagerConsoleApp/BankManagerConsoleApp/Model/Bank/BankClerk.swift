//
//  BankClerk.swift
//  BankManagerConsoleApp
//
//  Created by 쿼카, 두기 on 2022/04/29.
//
import Foundation

struct BankClerk {
    private enum Constant {
        static let (depositStartText, loanStartText) = ("번 고객 예금 업무 시작", "번 고객 대출 업무 시작")
        static let (depositEndText, loanEndText) = ("번 고객 예금 업무 완료", "번 고객 대출 업무 완료")
        static let depositWorkTime = 0.7
        static let loanWorkTime = 1.1
    }
    
    func depositWork(customer: Customer) {
        print("\(customer.number) \(Constant.depositStartText)")
        Thread.sleep(forTimeInterval: Constant.depositWorkTime)
        print("\(customer.number) \(Constant.depositEndText)")
    }
    
    }
}

