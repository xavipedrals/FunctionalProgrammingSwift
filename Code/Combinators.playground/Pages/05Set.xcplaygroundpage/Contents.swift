//: ### Set
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

let smallOdds: Set = [1, 3, 5, 7, 9]
let smallTriples: Set = [3, 6, 9]

smallOdds.contains(3)
smallOdds.contains(4)

smallOdds.union(smallTriples)
smallOdds.intersection(smallTriples)
smallOdds.subtracting(smallTriples)
smallOdds.symmetricDifference(smallTriples)
//: ---
struct IntSet {
    let contains: (Int) -> Bool
}

extension IntSet {
    init(withRangeFrom lower: Int, to upper: Int) {
        contains = {x in
            (x >= lower) && (x <= upper)
        }
    }
    
    init(_ elements: Int ...) {
        contains = {x in
            elements.contains(x)
        }
    }
}

extension IntSet {
    static func ||(first: IntSet, second: IntSet ) -> IntSet {
        return IntSet{x in first.contains(x) || second.contains(x)}
    }
    static func &&(first: IntSet, second: IntSet ) -> IntSet {
        return IntSet{x in first.contains(x) && second.contains(x)}
    }
    
    static prefix func !(set: IntSet) -> IntSet {
        return IntSet{x in !set.contains(x)}
    }
}

extension IntSet {
    static func -(first: IntSet, second: IntSet ) -> IntSet {
        return first && !second
    }
    static func +(first: IntSet, second: IntSet ) -> IntSet {
        return first || second
    }
    static func -(set: IntSet, element: Int ) -> IntSet {
        return set - IntSet(element)
    }
    static func +(set: IntSet, element: Int ) -> IntSet {
        return set + IntSet(element)
    }
}

extension IntSet {
    func union(_ otherSet: IntSet) -> IntSet {
        return self || otherSet
    }
    
    func intersection(_ otherSet: IntSet) -> IntSet {
        return self && otherSet
    }
    var complement:  IntSet {
        return !self
    }
}
extension IntSet {
    func minus(_ setToBeRemoved:  IntSet) -> IntSet {
        return self.intersection(setToBeRemoved.complement)
    }
    
    func symmetricDifference(with otherSet: IntSet) -> IntSet {
        return self.union(otherSet).minus(self.intersection(otherSet))
    }
    
    func add(_ element: Int) -> IntSet {
        return IntSet{x in
            self.contains(x) || x == element
        }
    }
    
    func remove(_ element: Int) -> IntSet {
        return IntSet{ x in
            self.contains(x) && x != element
        }
    }
}

extension IntSet: CustomStringConvertible {
    var description: String {
        return [Int](-10 ... 10).filter{x in contains(x)}.description
    }
}

let evens = IntSet(){x in
    x % 2 == 0
}

evens.contains(40024)
evens.contains(603)

let emptySet = IntSet{_ in false}
let universalSet = IntSet{_ in true}

let twoThroughSeven = IntSet(withRangeFrom: 2, to: 7)
let primes = IntSet(2, 3, 5, 7)

twoThroughSeven.union(primes)
twoThroughSeven.intersection(primes)
twoThroughSeven.complement

twoThroughSeven.minus(primes)
twoThroughSeven.symmetricDifference(with: primes)
twoThroughSeven.add(0)
twoThroughSeven.remove(0)
twoThroughSeven.add(0)
twoThroughSeven.remove(0)


//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
