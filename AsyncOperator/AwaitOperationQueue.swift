//
//  AsyncOperator.swift
//  AsyncOperator
//
//  Created by Cao Phuoc Thanh on 12/18/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import Foundation


public class AwaitOperationQueue {
    
    public struct Async {
        var maxConcurrent: Int
        var operators: [Operation]
        public init(_ maxConcurrent: Int, _ operators: [Operation]) {
            self.maxConcurrent = maxConcurrent
            self.operators = operators
        }
    }
    
    public enum Queue {
        case qos(DispatchQoS)
        case sync(Operation)
        case async(AwaitOperationQueue.Async)
        case finish(FinishCalback)
    }
    
    public typealias FinishCalback = () -> Void
    
    private var queue: DispatchQueue = DispatchQueue(label: "AsyncOperator", qos: .userInteractive, attributes: [], autoreleaseFrequency: .workItem, target: nil)
    private var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    private var finishCalbacks : [FinishCalback] = []
    
    private var queues: [Queue] = []

    public init(_ queues: Queue...) {
        self.queues = queues
    }
    
    public func excute() {
        self.queue.async {
            var ops: [Operation] = []
            for queue in self.queues {
                switch queue {
                case .qos(let value):
                    self.queue = DispatchQueue(label: "AsyncOperator", qos: value, attributes: [], autoreleaseFrequency: .workItem, target: nil)
                case .finish(let value):
                    self.finishCalbacks.append(value)
                case .sync(let syncOperation):
                    ops.append(syncOperation)
                case .async(let group):
                    let asyncOperation = BlockOperation {
                        var _ops: [Operation] = []
                        let operationQueue = OperationQueue()
                        operationQueue.maxConcurrentOperationCount = group.maxConcurrent
                        for op in group.operators {
                            _ops.append(op)
                        }
                        operationQueue.addOperations(_ops, waitUntilFinished: true)
                    }
                    ops.append(asyncOperation)
                    break
                }
            }
            self.operationQueue.addOperations(ops, waitUntilFinished: true)
            self.finishCalbacks.forEach { $0() }
        }
    }
    
    @discardableResult
    public func finish(_ calback: @escaping FinishCalback) -> AwaitOperationQueue {
        self.finishCalbacks.append(calback)
        return self
    }
    
    deinit {
        print("deinit")
    }
}



