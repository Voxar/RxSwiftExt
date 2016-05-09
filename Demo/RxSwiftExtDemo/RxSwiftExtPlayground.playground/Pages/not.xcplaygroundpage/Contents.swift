/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Build `RxSwift+Ext` scheme for a simulator target
 1. Build `RxSwiftExtDemo` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxSwift_Ext

/*:
 ## not

 The `not` operator applies a the boolean not (!) to a `Bool`
 */
example("boolean not - example 1") {

    _ = Observable.just(false)
        .not()
        .subscribeNext { result in
            assert(result)
        }
}

//: [Next](@next)
