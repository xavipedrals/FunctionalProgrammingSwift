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

struct MySet<T> {
    let contains: (T) -> Bool
}

//Adding init in a struct extension you don't lose the default struct init
extension MySet where T: Comparable {
    init(withRangeFrom lower: T, through upper: T) {
        contains = { x in
            (x >= lower) && (x <= upper)
        }
    }
}

extension MySet where T: Equatable {
    init(_ elements: T ...) {
        contains = { x in
            elements.contains(x)
        }
    }
}

extension MySet: CustomStringConvertible where T == Int {
    var description: String {
        return [Int](-10 ... 10).filter{ x in
            contains(x)}.description
    }
}

//extensions in the same file as the definition come for free, in different files same module small cost, different files different modules compiler + runtime small cost
extension MySet {
    func union(_ otherSet: MySet) -> MySet {
        return self || otherSet
    }
    
    func intersection(_ otherSet: MySet) -> MySet {
        return self && otherSet
    }
    
    var complement: MySet{
        return MySet{ x in !self.contains(x) }
    }
}

extension MySet {
    static func ||(first: MySet, second: MySet) -> MySet {
        return MySet{ x in first.contains(x) || second.contains(x) }
    }
    
    static func &&(first: MySet, second: MySet) -> MySet {
        return MySet{ x in first.contains(x) && second.contains(x) }
    }
    
    static prefix func !(set: MySet) -> MySet {
        return MySet{ x in !set.contains(x) }
    }
}

extension MySet where T: Equatable {
    static func +(first: MySet, second: MySet) -> MySet {
        return first || second
    }
    
    static func -(first: MySet, second: MySet) -> MySet {
        return first && !second
    }
    
    static func +(set: MySet, element: T) -> MySet {
        return set + MySet(element)
    }
    
    static func -(set: MySet, element: T) -> MySet {
        return set - MySet(element)
    }
}

extension MySet where T: Equatable {
    func minus(_ setToBeRemoved: MySet) -> MySet {
        return self - setToBeRemoved
    }
    
    func symmetricDifference(with otherSet: MySet) -> MySet {
        return union(otherSet) - intersection(otherSet)
    }
    
    func add(_ element: T) -> MySet {
        return self + element
    }
    
    func remove(_ element: T) -> MySet {
        return self - element
    }
}

let evenNumbers = MySet<Int>(contains: {x in x % 2 == 0})

evenNumbers.contains(4353453452)
evenNumbers.contains(-53453)

let emptySet = MySet<Int>{ _ in false }
let universalSet = MySet<Int>{ _ in true }

let threeThroughSeven = MySet<Int>(withRangeFrom: 3, through: 7)
let primes = MySet<Int>(2,3,5)

threeThroughSeven.union(primes)
threeThroughSeven.intersection(primes)
threeThroughSeven.complement

threeThroughSeven.add(9).remove(9).add(9)

//If you have a RandomNumber generator for ints you have a random number generator for doubles, strings and whatever you want, you only need a map function

//: ---

//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
