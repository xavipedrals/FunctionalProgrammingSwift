//: ### MoreList
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

indirect enum List<A> {
    case empty
    case cons(head: A, tail: List)
}

extension List: CustomStringConvertible  {
    var description: String {
        switch self {
        case .empty:
            return "( )"
        case let .cons(head, tail):
            return "(\(head)" + tail.description + ")"
        }
    }
}

extension List {
    private init(_ xs: [A]) {
        if xs.isEmpty {self = List.empty}
        else {
            var xs = xs
            let first = xs.removeFirst()
            self = List.cons(head: first, tail: List(xs))
        }
    }
    
    init(_ xs: A...){
        self.init(xs)
    }
}

extension List {
    var head: A {
        guard case .cons(let head, _) = self  else {
            fatalError("The list is empty.")
        }
        return head
    }
    var tail: List {
        guard case .cons(_, let tail) = self else {
            fatalError("The list is empty.")
        }
        return tail
    }
    
    func append(_ element: A) -> List {
        return List.cons(head: element, tail: self)
    }
}

extension List {
    func foldLeft<B>(_ initialValue: B, _ f: @escaping(B, A) -> B) -> B {
        guard case let .cons(head, tail) = self else {return initialValue}
        return tail.foldLeft(f(initialValue, head), f)
    }
    
    func reversed() -> List {
        return foldLeft(List.empty){ (reversedList, element) in
            List.cons(head: element, tail: reversedList)
        }
    }
    
    func foldRight<B>(_ initialValue: B, _ f: @escaping(A, B) -> B) -> B {
        return reversed().foldLeft(initialValue){(b,a) in f(a,b)}
    }
}

extension List {
    func map<B>(_ f: @escaping (A) -> B) -> List<B> {
        return foldRight(List<B>.empty){(element, mappedList) in
            List<B>.cons(head: f(element), tail: mappedList)}
    }
    func filter(_ f: @escaping (A) -> Bool) -> List {
        return foldRight(List.empty){(element, filteredList) in
            f(element) ? List.cons(head: element, tail: filteredList) : filteredList}
    }
}

extension List {
    func append(_ otherList: List) -> List {
        return foldRight(otherList){(a,b) in List.cons(head: a, tail: b)}
    }
    func join<B>() -> List<B> where A == List<B> {
        return foldRight(List<B>.empty, {(a,b) in a.append(b)})
    }
    func flatMap<B>(_ f: @escaping (A) -> List<B> ) -> List<B> {
        return map(f).join()
    }
}



let emptyList = List<Int>.empty
let six = List.cons(head: 6, tail: emptyList)
let oneTwoThree
    = List.cons(head: 1,
                tail: List.cons(head: 2,
                                tail: List.cons(head: 3,
                                                tail: emptyList)))

let anotherEmptyList = List<Int>()
let five = List(5)
let sevenEightNine = List(7, 8, 9)

sevenEightNine.head
sevenEightNine.tail
sevenEightNine.append(6)

sevenEightNine.foldLeft(0, +)
sevenEightNine.foldLeft(0){(accumulator, element) in
    accumulator + element
}
sevenEightNine.foldLeft(emptyList){(accumulator, element)
    in accumulator.append(element + 1)
}

sevenEightNine.reversed()

sevenEightNine.foldRight(0, +)

sevenEightNine.foldRight(emptyList){(element, accumulator)
    in accumulator.append(element + 1)
}

sevenEightNine
    .map{x in x + 1}
sevenEightNine
    .filter{x in x % 2 == 1}

let lists = List.cons(head: oneTwoThree,
                      tail: List.cons(head: sevenEightNine,
                                      tail: List.empty))

let listsA = oneTwoThree.append(sevenEightNine)


lists.join()

let flatMapDoubleTwoThreFour
    = oneTwoThree.flatMap{x in List.cons(head: x,
                                          tail: List.cons(head: x,
                                                          tail: List<Int>.empty))}

flatMapDoubleTwoThreFour
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
