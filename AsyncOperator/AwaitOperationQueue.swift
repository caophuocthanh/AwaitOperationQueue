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
        fileprivate var maxConcurrent: Int
        public var operators: [Operation]
        // optionals
        public var name: String?
        fileprivate var completed: ((AsyncQueue) -> Void)?
        public init(name: String? = nil, maxConcurrent: Int, operators: [Operation], completed: ((AsyncQueue) -> Void)? = nil) {
            self.maxConcurrent = maxConcurrent
            self.operators = operators
            
            self.name = name
            self.completed = completed
            
        }
    }
    
    fileprivate var isCancel: Bool = false
    
    public enum Queue {
        case qos(DispatchQoS)
        case sync(Operation)
        case async(AwaitOperationQueue.AsyncQueue)
        case queueCompleted(AwaitOperationQueue.OperationCompletedCalback)
        case canceled(AwaitOperationQueue.Calback)
        case completed(AwaitOperationQueue.Calback)
    }
    
    public typealias Calback = () -> Void
    public typealias OperationCompletedCalback = (Queue) -> Void
    
    private var queue: DispatchQueue
    private var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        return operationQueue
    }()
    
    private var completedCalbacks : [Calback] = []
    private var canceledCalbacks : [Calback] = []
    private var operationCompletedCalback : [OperationCompletedCalback] = []
    
    private var queues: [Queue] = []
    
    private var groupOperationQueue: [OperationQueue] = []
    
    private let start = CFAbsoluteTimeGetCurrent()
    
    private var observations: [NSKeyValueObservation] = []
    
    private var name: String
    
    public var operations: [Queue] = []
    
    var label: String {
        return "\(self.name)_AwaitOperationQueue"
    }
    
    @available(iOS 13.0, *)
    public var progress: Progress {
        return self.operationQueue.progress
    }
    
    public init(name: String,_ queues: Queue...) {
        self.name = name
        self.queues = queues
        self.queue = DispatchQueue(label: "\(self.name)_AwaitOperationQueue", qos: .userInteractive, attributes: [], autoreleaseFrequency: .workItem, target: nil)
        //print("[🌦][queue:\(self.name)]  init")
    }
    
    public var isSuspended: Bool {
        get { self.queue.sync(flags: .barrier) { return self.operationQueue.isSuspended } }
        set { self.queue.sync(flags: .barrier) { self.operationQueue.isSuspended = newValue } }
    }
    
    public func suppend() {
        self.queue.sync(flags: .barrier) {
            self.operationQueue.isSuspended = true
        }
    }
    
    public func cancel() {
        self.queue.sync(flags: .barrier) {
            self.isCancel = true
            self.groupOperationQueue.forEach {
                $0.cancelAllOperations()
                $0.operations.forEach { $0.cancel() }
            }
            self.operationQueue.cancelAllOperations()
            self.operationQueue.operations.forEach { $0.cancel() }
            //print("[🌦][queue:\(self.name)] queue cancel:", self.isCancel)
        }
    }
    
    public func excute() {
        self.queue.async {
            
            let observation = self.operationQueue.observe(\.operationCount, options: [.old, .new]) { object, change in
                guard self.operations.count > 0, let oldValue = change.oldValue, oldValue != 0, let newValue = change.newValue else { return }
                let index = self.operations.count - newValue - 1
                let queue = self.operations[index]
                ////print("[🌦][queue:\(self.name)] operation done:", queue)
                self.operationCompletedCalback.forEach { $0(queue) }
            }
            self.observations.append(observation)
            //print("[🌦][queue:\(self.name)] excute")
            
            var ops: [Operation] = []
            for queue in self.queues {
                switch queue {
                case .queueCompleted(let value):
                    self.operationCompletedCalback.append(value)
                case .qos(let value):
                    self.queue = DispatchQueue(label: self.label, qos: value, attributes: [], autoreleaseFrequency: .workItem, target: nil)
                case .canceled(let value):
                    self.canceledCalbacks.append(value)
                case .completed(let value):
                    self.completedCalbacks.append(value)
                case .sync(let op):
                    guard self.isCancel == false else { break }
                    self.operations.append(queue)
                    ops.append(op)
                case .async(let group):
                    guard self.isCancel == false else { break }
                    self.operations.append(queue)
                    let asyncOperation = BlockOperation {
                        var _ops: [Operation] = []
                        let _startGroup = CFAbsoluteTimeGetCurrent()
                        let _operationQueue = OperationQueue()
                        let groupObservation = _operationQueue.observe(\.operationCount, options: [.old, .new]) { object, change in
                            //print("[🌦][queue:\(self.name)][group:\(group.name ?? "")] operations.count changed:", change.newValue ?? "")
                            //                            guard let oldValue = change.oldValue, oldValue != 0, let newValue = change.newValue else { return }
                            //                            let index = group.operators.count - newValue - 1
                            //                            let op = group.operators[index]
                            //                            //print("[🌦][queue:\(self.name)][group:\(group.name ?? "")] operation done:", op.name ?? "")
                            //                            self.operationCompletedCalback.forEach { $0(op)}
                        }
                        self.observations.append(groupObservation)
                        _operationQueue.maxConcurrentOperationCount = group.maxConcurrent
                        for op in group.operators {
                            _ops.append(op)
                        }
                        self.groupOperationQueue.append(_operationQueue)
                        _operationQueue.addOperations(_ops, waitUntilFinished: true)
                        //print("[🌦][queue:\(self.name)][group:\(group.name ?? "nil")] complete in \(CFAbsoluteTimeGetCurrent() - _startGroup) s, cancel:", self.isCancel)
                        group.completed?(group)
                    }
                    ops.append(asyncOperation)
                    break
                }
            }
            
            self.operationQueue.addOperations(ops, waitUntilFinished: true)
            
            if self.isCancel == true {
                var isCompleted: Bool = true
                self.queues.forEach {
                    switch $0 {
                    case .sync(let op):
                        print("[🌦][queue:\(self.name)][operation:\(op.name ?? "unknown")] complete check task done:", (op.isFinished == true && op.isCancelled == false))
                        if (op.isFinished == true && op.isCancelled == false) == false { isCompleted = false }
                    case .async(let group):
                        group.operators.forEach { op in
                           print("[🌦][queue:\(self.name)][group:\(group.name ?? "")][operation:\(op.name ?? "unknown")] complete check task done:", (op.isFinished == true && op.isCancelled == false))
                            if (op.isFinished == true && op.isCancelled == false) == false { isCompleted = false }
                        }
                    default: break
                    }
                }
                //print("[🌦][queue:\(self.name)] cancel after \(CFAbsoluteTimeGetCurrent() - self.start) s, cancel:", self.isCancel)
                if isCompleted {
                    self.completedCalbacks.forEach { calback in
                        calback()
                    }
                } else {
                    self.canceledCalbacks.forEach { calback in
                        calback()
                    }
                }
            } else {
                self.completedCalbacks.forEach { calback in
                    calback()
                }
                //print("[🌦][queue:\(self.name)] complete in \(CFAbsoluteTimeGetCurrent() - self.start) s, cancel:", self.isCancel)
            }
            self.operations = []
            self.observations = []
        }
    }
    
    @discardableResult
    public func canceled(_ calback: @escaping Calback) -> AwaitOperationQueue {
        self.canceledCalbacks.append(calback)
        return self
    }
    
    @discardableResult
    public func completed(_ calback: @escaping Calback) -> AwaitOperationQueue {
        self.completedCalbacks.append(calback)
        return self
    }
    
    deinit {
        //print("[🌦][queue:\(self.name)] deinit")
    }
}



