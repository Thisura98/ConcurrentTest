//
//  main.swift
//  concurrenttest
//
//  Created by Thisura Dodangoda on 2022-01-21.
//

import Foundation

class Animal{
    var age: Int
    var name: String
    init(){
        age = 0
        name = ""
    }
    init(_ age: Int, _ name: String){
        self.age = age
        self.name = name
    }
}

extension Thread{
    func number() -> Int{
        return Int(pthread_mach_thread_np(pthread_self()))
    }
}

let start = Date()
var animal = Animal()

print("Main Thread", Thread.main.number())

func threadSafetyForClass1() {
    let queue = DispatchQueue(label: "threadSafety1", attributes: [.concurrent])
    queue.async {
        for age in 1...30 {
            let beforeValue = animal.age
            let newValue = age
            let t = Date().timeIntervalSince(start)
            sleep(arc4random_uniform(2))
            animal = Animal(age, "name\(newValue)")
            // animal.age = newValue
            // animal.name = "name\(newValue)"
            print(t, Thread.current.number(), "1", "\(beforeValue) => \(newValue)", separator: ",")
        }
    }
}

func threadSafetyForClass2() {
    let queue = DispatchQueue(label: "threadSafety2", attributes: [.concurrent])
    queue.async {
        for age in 31...60 {
            let beforeValue = animal.age
            let newValue = age
            let t = Date().timeIntervalSince(start)
            sleep(arc4random_uniform(2))
            animal = Animal(age, "name\(newValue)")
            print(t, Thread.current.number(), "2", "\(beforeValue) => \(newValue)", separator: ",")
        }
    }
}

threadSafetyForClass1()
threadSafetyForClass2()


RunLoop.main.run()
