/*:
 > # IMPORTANT: To use `RxSwiftExtPlayground.playground`, please:
 
 1. Make sure you have [Carthage](https://github.com/Carthage/Carthage) installed
 1. Fetch Carthage dependencies from shell: `carthage bootstrap --platform ios`
 1. Build scheme `RxSwiftExtPlayground` scheme for a simulator target
 1. Choose `View > Show Debug Area`
 */

//: [Previous](@previous)

import RxSwift
import RxSwiftExt

example("takeUntil(Completable)") {
    struct Connection {}
    let terminationSignal = PublishSubject<Void>()
    let connection = Observable<Connection>.create { sub in
        print("connecting...")
        delay(1) {
            print("connected")
            sub.onNext(Connection())
        }
        return Disposables.create { print("closing connection") }
    }
    // close the connection on a signal
    .takeUntil(terminationSignal)
    .debug("connection")
    .share()
    
    var heartbeatFailsIn = 3
    func sendHeartbeat(connection: Connection) -> Single<Bool> {
        print("sending keepalive ❤️")
        heartbeatFailsIn -= 1
        return .just(heartbeatFailsIn > 0)
    }
    
    // when we get a connection we ping it at an interval to make sure it's still open
    _ = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
        .withLatestFrom(connection)
        .flatMapLatest(sendHeartbeat)
        // until the connection completes or errors out
        .takeUntil(completed: connection)
    
    // if heartbeat is unsuccessful we send a termination signal to the connection
    .filterMap({$0 ? .ignore : .map(()) })
    .do(onNext: { print("Heartbeat failed 💔") } )
    // send the termination signal
    .multicast(terminationSignal)
    .connect()
}

//: [Next](@next)
