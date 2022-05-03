//
//  Task.swift
//  BankManagerConsoleApp
//
//  Created by 쿼카, 두기 on 2022/05/03.
//

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
}
