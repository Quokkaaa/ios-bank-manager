//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by 쿼카, 두기 on 2022/04/28.
import Foundation

struct Bank {
    enum Task: CaseIterable {
        case deposit
        case loan
        
        var clerkCount: Int {
            switch self {
            case .deposit:
                return 2
            case .loan:
                return 1
            }
        }
        
        var title: String {
            switch self {
            case .deposit:
                return "예금"
            case .loan:
                return "대출"
            }
        }
    }
    private enum Constant {
        static let empty = ""
    }
    private var customerQueue = Queue<Customer>()
    private var totalCustomerCount = Int.zero
    private var workingTime = Constant.empty
    
    private let depositSemaphore = DispatchSemaphore(value: Task.deposit.clerkCount)
    private let loanSemaphore = DispatchSemaphore(value: Task.loan.clerkCount)
    
    weak var delegate: BankDelegate?
    
    private mutating func receiveCustomer() {
        for _ in 1...10 {
            guard let task = Task.allCases.randomElement() else {
                return
            }
            totalCustomerCount += 1
            let customer = Customer(number: totalCustomerCount, task: task)
            customerQueue.enqueue(newElement: customer)
            delegate?.addCustomer(customer: customer)
        }
    }
    
    private mutating func sendCustomerToClerk() {
        let group = DispatchGroup()
        let workQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        while !customerQueue.isEmpty {
            guard let customer = customerQueue.dequeue() else {
                return
            }
            matchToClerk(customer: customer, group: group, queue: workQueue)
        }
        group.notify(queue: workQueue) {
            print("끝났다!")
        }
    }
    
    private func matchToClerk(customer: Customer, group: DispatchGroup, queue: DispatchQueue) {
        switch customer.task {
        case .deposit:
            queue.async(group: group) {
                depositSemaphore.wait()
                delegate?.sendTaskingCustomer(customer: customer)
                BankClerk.startDepositWork(customer: customer)
                delegate?.sendEndCustomer(customer: customer)
                depositSemaphore.signal()
            }
        case .loan:
            queue.async(group: group) {
                loanSemaphore.wait()
                delegate?.sendTaskingCustomer(customer: customer)
                BankClerk.startLoanWork(customer: customer)
                delegate?.sendEndCustomer(customer: customer)
                loanSemaphore.signal()
            }
        }
    }
    
    func timeCheck(_ block: () -> Void) -> String {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let durationTime = CFAbsoluteTimeGetCurrent() - startTime
        return String(format: "%.2f", durationTime)
    }

    mutating func newOpen() {
        receiveCustomer()
        sendCustomerToClerk()
    }
    
    mutating func resetWork() {
        customerQueue.clear()
        totalCustomerCount = Int.zero
        workingTime = Constant.empty
    }
}

protocol BankDelegate: AnyObject {
    func addCustomer(customer: Customer)
    func sendTaskingCustomer(customer: Customer)
    func sendEndCustomer(customer: Customer)
//    func sendNoCustomer()
}
