//: ### GenericSet
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

struct MySet<A> {
    let contains: (A) -> Bool
}

extension MySet where A: Comparable {
    init(withRangeFrom lower: A, to upper: A) {
        contains = {x in
            (x >= lower) && (x <= upper)
        }
    }
}

extension MySet where A: Equatable {
    
    init(_ elements: A ...) {
        contains = {x in
            elements.contains(x)
        }
    }
}

extension MySet {
    static func ||(first: MySet, second: MySet ) -> MySet {
        return MySet{x in first.contains(x) || second.contains(x)}
    }
    static func &&(first: MySet, second: MySet ) -> MySet {
        return MySet{x in first.contains(x) && second.contains(x)}
    }
    
    static prefix func !(set: MySet) -> MySet {
        return MySet{x in !set.contains(x)}
    }
}

extension MySet  {
    static func -(first: MySet, second: MySet ) -> MySet {
        return first && !second
    }
    static func +(first: MySet, second: MySet ) -> MySet {
        return first || second
    }
}

extension MySet where A: Equatable {
    static func -(set: MySet, element: A ) -> MySet {
        return set - MySet(element)
    }
    static func +(set: MySet, element: A ) -> MySet {
        return set + MySet(element)
    }
}

extension MySet {
    func union(_ otherSet: MySet) -> MySet {
        return self || otherSet
    }
    
    func intersection(_ otherSet: MySet) -> MySet {
        return self && otherSet
    }
    var complement:  MySet {
        return !self
    }
}
extension MySet {
    func minus(_ setToBeRemoved:  MySet) -> MySet {
        return self.intersection(setToBeRemoved.complement)
    }
    
    func symmetricDifference(with otherSet: MySet) -> MySet {
        return self.union(otherSet).minus(self.intersection(otherSet))
    }
}

extension MySet where A: Equatable {
    
    func add(_ element: A) -> MySet {
        return MySet{x in
            self.contains(x) || x == element
        }
    }
    
    func remove(_ element: A) -> MySet {
        return MySet{ x in
            self.contains(x) && x != element
        }
    }
}

extension MySet: CustomStringConvertible where A == Int {
    var description: String {
        return [Int](-10 ... 10).filter{x in contains(x)}.description
    }
}

let evens = MySet<Int>(){x in
    x % 2 == 0
}

evens.contains(40024)
evens.contains(603)

let emptySet = MySet<Int>{_ in false}
let universalSet = MySet<Int>{_ in true}

let twoThroughSeven = MySet(withRangeFrom: 2, to: 7)
let primes = MySet(2, 3, 5, 7)

twoThroughSeven.union(primes)
twoThroughSeven.intersection(primes)
twoThroughSeven.complement

twoThroughSeven.minus(primes)
twoThroughSeven.symmetricDifference(with: primes)
twoThroughSeven.add(0)
twoThroughSeven.remove(0)
twoThroughSeven.add(0)
twoThroughSeven.remove(0)

extension MySet {
    func filter(_ f: @escaping (A) -> Bool) -> MySet {
        return self.intersection(MySet(contains: f))
    }
}

let twoThreeFour = MySet("two", "three", "four")
let three = twoThreeFour.filter{word in word.count > 4}
three.contains("two")
three.contains("three")
three.contains("four")
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
