//
//  AsyncOperator.swift
//  AsyncOperator
//
//  Created by Cao Phuoc Thanh on 12/18/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import Foundation

public class AwaitOperationQueue {
    
    public struct AsyncQueue {
        // required
        var maxConcurrent: Int
        var operators: [Operation]
        // optionals
        public var name: String?
        var completed: ((AsyncQueue) -> Void)?
        public init(name: String? = nil, maxConcurrent: Int, operators: [Operation], completed: ((AsyncQueue) -> Void)? = nil) {
            self.maxConcurrent = maxConcurrent
            self.operators = operators
            
            self.name = name
            self.completed = completed
            
        }
    }
    
    public enum Queue {
        case qos(DispatchQoS)
        case sync(Operation)
        case async(AwaitOperationQueue.AsyncQueue)
        case finish(FinishCalback)
    }
    
    public typealias FinishCalback = () -> Void
    
    private var queue: DispatchQueue
    private var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    private var finishCalbacks : [FinishCalback] = []
    
    private var queues: [Queue] = []
    
    private let start = CFAbsoluteTimeGetCurrent()
    
    private var name: String
    
    var label: String {
        return "\(self.name)_AwaitOperationQueue"
    }
    
    public init(name: String,_ queues: Queue...) {
        //print("[🌦🌦] AwaitOperationQueue init")
        self.name = name
        self.queues = queues
        self.queue = DispatchQueue(label: "\(self.name)_AwaitOperationQueue", qos: .userInteractive, attributes: [], autoreleaseFrequency: .workItem, target: nil)
    }
    
    public func excute() {
        print("[🌦][queue:\(self.name)] excute")
        self.queue.async {
            var ops: [Operation] = []
            for queue in self.queues {
                switch queue {
                case .qos(let value):
                    self.queue = DispatchQueue(label: self.label, qos: value, attributes: [], autoreleaseFrequency: .workItem, target: nil)
                case .finish(let value):
                    self.finishCalbacks.append(value)
                case .sync(let syncOperation):
                    ops.append(syncOperation)
                case .async(let group):
                    let asyncOperation = BlockOperation {
                        var _ops: [Operation] = []
                        let _startGroup = CFAbsoluteTimeGetCurrent()
                        let _operationQueue = OperationQueue()
                        _operationQueue.maxConcurrentOperationCount = group.maxConcurrent
                        for op in group.operators {
                            _ops.append(op)
                        }
                        _operationQueue.addOperations(_ops, waitUntilFinished: true)
                        print("[🌦][queue:\(self.name)][group:\(group.name ?? "nil")] finish in \(CFAbsoluteTimeGetCurrent() - _startGroup) s")
                        group.completed?(group)
                    }
                    ops.append(asyncOperation)
                    break
                }
            }
            self.operationQueue.addOperations(ops, waitUntilFinished: true)
            self.finishCalbacks.forEach { calback in
                calback()
            }
            print("[🌦][queue:\(self.name)] finish in \(CFAbsoluteTimeGetCurrent() - self.start) s")
        }
    }
    
    @discardableResult
    public func finish(_ calback: @escaping FinishCalback) -> AwaitOperationQueue {
        self.finishCalbacks.append(calback)
        return self
    }
    
    deinit {
        print("[🌦][queue:\(self.name)] deinit")
    }
}



