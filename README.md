# AwaitOperationQueue

### Code:
```swift

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

```

### Result

```
op1 block start
op1 block finish
op2 block start
op2 block finish
op3 block start
op3 block finish
op4 block start
op4 block finish
op5 block start
op6 block start
op7 block start
op8 block start
op9 block start
op6 block finish
op9 block finish
op7 block finish
op5 block finish
op8 block finish
op10 block start
op10 block finish
finish 1
finish 2
finish 3
deinit

```
