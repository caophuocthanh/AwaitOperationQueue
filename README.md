# AwaitOperationQueue

### Code:
```swift

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
        
        AwaitOperationQueue(
            name: "AwaitOperationQueue",
            .qos(.userInteractive),
            .sync(op1),
            .sync(op2),
            .sync(op3),
            .sync(op4),
            .async(.init(
                name: "ops:[5,6,7,8,9]",
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
        ).finish {
            print("finish 1")
        }.finish {
            print("finish 2")
        }.finish {
            print("finish 3")
        }.excute()
    }

```

### Result

```
[🌦][queue:AwaitOperationQueue] excute
op 1 block start
op 1 block finish
op 2 block start
op 2 block finish
op 3 block start
op 3 block finish
op 4 block start
op 4 block finish
op 5 block start
op 7 block start
op 6 block start
op 8 block start
op 9 block start
op 6 block finish
op 9 block finish
op 7 block finish
op 5 block finish
op 8 block finish
[🌦][queue:AwaitOperationQueue][group:ops:[5,6,7,8,9]] finish in 11.001109957695007 s
Group ops:[5,6,7,8,9] all done.
op 10 block start
op 10 block finish
finish 1
finish 2
finish 3
[🌦][queue:AwaitOperationQueue] finish in 17.016005992889404 s
[🌦][queue:AwaitOperationQueue] deinit

```

## Contact
- Email: caophuocthanh@gmail.com
- Site: https://onebuffer.com
- Linkedin: https://www.linkedin.com/in/caophuocthanh/
