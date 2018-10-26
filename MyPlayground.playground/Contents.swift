
import Foundation
import UIKit

print("Hello World")
class BaseClass{
    private init(){}
    func test(){
        print(#function + "in ")
    }
}

class DerivedClass: BaseClass{
    override init() {
        
    }
    override func test() {
        print(#function )
    }
}

let base:BaseClass = DerivedClass()

base.test()
