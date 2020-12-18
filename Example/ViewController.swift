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
            print("op1 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op1 block finish")
        }
        
        let op2 = BlockOperation {
            print("op2 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op2 block finish")
        }
        
        let op3 = BlockOperation {
            print("op3 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op3 block finish")
        }
        
        let op4 = BlockOperation {
            print("op4 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op4 block finish")
        }
        
        
        let op5 = BlockOperation {
            print("op5 block start")
            Thread.sleep(forTimeInterval: 5)
            print("op5 block finish")
        }
        
        let op6 = BlockOperation {
            print("op6 block start")
            Thread.sleep(forTimeInterval: 1)
            print("op6 block finish")
        }
        
        let op7 = BlockOperation {
            print("op7 block start")
            Thread.sleep(forTimeInterval: 3)
            print("op7 block finish")
        }
        
        let op8 = BlockOperation {
            print("op8 block start")
            Thread.sleep(forTimeInterval: 11)
            print("op8 block finish")
        }
        
        let op9 = BlockOperation {
            print("op9 block start")
            Thread.sleep(forTimeInterval: 2)
            print("op9 block finish")
        }
        
        let op10 = BlockOperation {
            print("op10 block start")
             Thread.sleep(forTimeInterval: 2)
            print("op10 block finish")

        }
        
        let opque = AwaitOperationQueue(
            .sync(op1),
            .sync(op2),
            .sync(op3),
            .sync(op4),
            .async(.init(10, [op5, op6, op7, op8, op9])),
            .sync(op10)
        )
        
        opque.finish {
            print("finish 1")
        }.finish {
            print("finish 2")
        }.finish {
            print("finish 3")
        }
        
        opque.excute()
    }


}
