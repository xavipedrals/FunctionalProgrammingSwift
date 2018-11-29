//: ### State
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

//state monad
struct State<S, A> {
    let run: (S) -> (A, S)
}

extension State {
    func map<B>(_ transform: @escaping (A) -> B) -> State<S, B> {
        return State<S, B>(run: { s in
            let (nextA, nextS) = self.run(s)
            return (transform(nextA), nextS)
        })
    }
    
    func flatMap<B>(_ transform: @escaping (A) -> State<S, B>) -> State<S, B> {
        return State<S, B>{ s in
            let (nextA, nextS) = self.run(s)
            return transform(nextA).run(nextS)
        }
    }
    
    static func pure(_ a: A) -> State<S, A> {
        return State<S, A>{ s in (a,s) }
    }
}

typealias Rand<A> = State<RNG, A>

let randomIntGenerator: Rand<Int> = State{ rng in rng.nextInt() }

let (n1, rng1) = randomIntGenerator.run(initialRNG)
n1

let (n2, rng2) = randomIntGenerator.run(rng1)
n2

let randomBoolGenerator: Rand<Bool> = randomIntGenerator.map{ int in int % 2 == 1 }

let (b1, brng1) = randomBoolGenerator.run(initialRNG)
b1

let (b2, brng2) = randomBoolGenerator.run(brng1)
b2

let randomDoubleGenerator: Rand<Double> = randomIntGenerator.map{ int in Double(int) / Double(max) }

let (d1, drng1) = randomDoubleGenerator.run(initialRNG)
d1

let (d2, drng2) = randomDoubleGenerator.run(drng1)
d2

extension State where S == RNG, A == Int {
    func nextLessThan(_ upperLimit: Int) -> State<RNG, Int> {
        return flatMap{ int in
            guard int < upperLimit else {
                print(int)
                return self.nextLessThan(upperLimit)
            }
            return State<RNG, Int>.pure(int)
        }
    }
}

let lessThan200: Rand<Int> = randomIntGenerator.nextLessThan(200)

let (nl200, nrng1) = lessThan200.run(initialRNG)
nl200

extension State {
    func next(_ n: Int, accumulator:[A] = [A]()) -> State<S, [A]> {
        return flatMap({ a in
            guard n > 0 else { return State<S, [A]>.pure(accumulator) }
            return self.next(n - 1, accumulator: accumulator + [a])
        })
    }
}

let next42 = randomIntGenerator.next(42)
let (n42, rng42) = next42.run(initialRNG)

n42
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
