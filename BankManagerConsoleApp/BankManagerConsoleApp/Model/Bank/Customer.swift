//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by 쿼카, 두기 on 2022/04/28.
//

enum Task: CaseIterable {
    case deposit
    case loan
}

struct Customer {
    let number: Int
    let task: Task
}
