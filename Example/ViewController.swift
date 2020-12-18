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
        
        let op2 = BlockOperation {
            print("op 2 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 2 block finish")
        }
        
        let op3 = BlockOperation {
            print("op 3 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 3 block finish")
        }
        
        let op4 = BlockOperation {
            print("op 4 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 4 block finish")
        }
        
        
        let op5 = BlockOperation {
            print("op 5 block start")
            Thread.sleep(forTimeInterval: 5)
            print("op 5 block finish")
        }
        
        let op6 = BlockOperation {
            print("op 6 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op 6 block finish")
        }
        
        let op7 = BlockOperation {
            print("op 7 block start")
            Thread.sleep(forTimeInterval: 3)
            print("op 7 block finish")
        }
        
        let op8 = BlockOperation {
            print("op 8 block start")
            Thread.sleep(forTimeInterval: 11)
            print("op 8 block finish")
        }
        
        let op9 = BlockOperation {
            print("op 9 block start")
            Thread.sleep(forTimeInterval: 2)
            print("op 9 block finish")
        }
        
        let op10 = BlockOperation {
            print("op 10 block start")
             Thread.sleep(forTimeInterval: 2)
            print("op 10 block finish")

        }
        
        AwaitOperationQueue(name: "AwaitOperationQueue",
            .sync(op1),
            .sync(op2),
            .sync(op3),
            .sync(op4),
            .async(.init(10, [op5, op6, op7, op8, op9])),
            .sync(op10)
        ).finish {
            print("finish 1")
        }.finish {
            print("finish 2")
        }.finish {
            print("finish 3")
        }.excute()
    }


}

