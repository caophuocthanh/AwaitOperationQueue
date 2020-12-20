//
//  ViewController.swift
//  Example
//
//  Created by Cao Phuoc Thanh on 12/18/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import AsyncOperator

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let op1 = BlockOperation {
            print("op 1 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 1 block finish")
        }
        op1.name = "op1"
        
        let op2 = BlockOperation {
            print("op 2 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 2 block finish")
        }
        op2.name = "op2"
        
        let op3 = BlockOperation {
            print("op 3 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 3 block finish")
        }
        op3.name = "op3"
        
        let op4 = BlockOperation {
            print("op 4 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 4 block finish")
        }
        op4.name = "op4"
        
        let op5 = BlockOperation {
            print("op 5 block start")
            Thread.sleep(forTimeInterval: 5)
            print("op 5 block finish")
        }
        op5.name = "op5"
        
        let op6 = BlockOperation {
            print("op 6 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 6 block finish")
        }
        op6.name = "op6"
        
        let op7 = BlockOperation {
            print("op 7 block start")
            Thread.sleep(forTimeInterval: 3)
            print("op 7 block finish")
        }
        op7.name = "op7"
        
        let op8 = BlockOperation {
            print("op 8 block start")
            Thread.sleep(forTimeInterval: 11)
            print("op 8 block finish")
        }
        op8.name = "op8"
        
        let op9 = BlockOperation {
            print("op 9 block start")
            Thread.sleep(forTimeInterval: 2)
            print("op 9 block finish")
        }
        op9.name = "op9"
        
        let op10 = BlockOperation {
            print("op 10 block start")
            Thread.sleep(forTimeInterval: 2)
            print("op 10 block finish")
            
        }
        op10.name = "op10"
        
        let run = AwaitOperationQueue(
            name: "AwaitOperationQueue",
            .qos(.userInteractive),
            .sync(op1),
            .sync(op2),
            .sync(op3),
            .sync(op4),
            .async(.init(
                name: "ops_group",
                maxConcurrent: 10,
                operators:[
                    op5,
                    op6,
                    op7,
                    op8,
                    op9
                ]){ group in
                    print("Group \(group.name ?? "") all done.")
                }),
            .sync(op10)
        )
        
        run.completed {
            print("finish 1")
        }.completed {
            print("finish 2")
        }.completed {
            print("finish 3")
        }.excute()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            print("cancel")
            run.cancel()
        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 14) {
//            print("cancel")
//            run.isSuspended = false
//        }
    }
    
    
}

