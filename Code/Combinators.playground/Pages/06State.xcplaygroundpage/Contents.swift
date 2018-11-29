//: ### State
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

struct State<S, A> {
    let run: (S) -> (A, S)
}

extension State {
    static func pure(_ a: A) -> State<S, A> {
        return State<S, A>{s in (a, s)}
    }
    func map<B>(_ f: @escaping (A) -> B) -> State<S, B> {
        return State<S, B>{s in
            let (nextA, nextS) = self.run(s)
            return (f(nextA), nextS)
        }
    }
    func flatMap<B>(_ f: @escaping  (A) -> State<S, B>)
        -> State<S, B> {
            return State<S,B>{s in
                let (nextA, nextState) = self.run(s)
                return f(nextA).run(nextState)
            }
    }
    func derivedMap<B>(_ f: @escaping (A) -> B) -> State<S, B> {
        return flatMap{a in State<S,B>.pure(f(a))}
    }
    
}

typealias Rand<A>  = State<RNG, A>

let randomIntGenerator: Rand<Int> = State(run: {rng in rng.nextInt()})

let (n1, rng1) = randomIntGenerator.run(initialRNG)
n1
let (n2, rng2) = randomIntGenerator.run(rng1)
n2

let randomBoolGenerator = randomIntGenerator.map{int in int % 2 == 1}

let (b1, brng1) = randomBoolGenerator.run(initialRNG)
b1
let (b2, brng2) = randomBoolGenerator.run(brng1)
b2

let randomDoubleGenerator = randomIntGenerator.map{int in Double(int)/Double(max)}

max
let (d1, drng1) = randomDoubleGenerator.run(initialRNG)
d1
let (d2, drng2) = randomDoubleGenerator.run(drng1)
d2

//: ---

extension State where S == RNG, A == Int {
    func nextLessThan(_ upperLimit: Int) -> State<RNG, Int> {
        return flatMap{int in
            guard int < upperLimit else {
                print(int)
                return self.nextLessThan(upperLimit)
            }
            return State<RNG, Int>.pure(int)
        }
    }
}

let lessThan1000: Rand<Int> = randomIntGenerator.nextLessThan(1000)

let (nextLessThan1000, ltrng1) = lessThan1000.run(initialRNG)
nextLessThan1000

extension State {
    func next(_ n: Int, accumulator: [A] = [A]()) -> State<S, [A]> {
        return flatMap{a in
            guard n > 0 else { return State<S, [A]>.pure(accumulator)
            }
            return self.next(n - 1, accumulator: accumulator + [a] )
        }
    }
}


let next100 = randomIntGenerator.next(100)

let (result100, nextRNG) = next100.run(initialRNG)
result100

//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
