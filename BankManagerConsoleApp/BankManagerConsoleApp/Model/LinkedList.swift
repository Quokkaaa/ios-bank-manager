//  LinkedList.swift
//  BankManagerConsoleApp
//   Created by 쿼카, 두기 on 2022/04/26

import Foundation

final class LinkedList<Element> {
    private var head: Node<Element>?
    private var tail: Node<Element>?
    
    func append(data: Element) {
        let newNode = Node(date: data)
        if head == nil {
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            tail = newNode
        }
    }
}
