//: ### Favorites
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

let words = ["a", "cat", "is", "very", "smart"]
let empty = [String]()

func numberOfLetters(_ string: String) -> Int {
    return string.count
}

func charactersIn(_ string: String) -> [Character] {
    return Array(string)
}

func containsA(_ string: String) -> Bool {
    return string.contains("a")
}
//: ---



func myMap(_ input: [String],
           transform:(String) -> Int) -> [Int] {
    var result = [Int]()
    for element in input {
        result.append(transform(element))
    }
    return result
}
func myMap<Input, Output>(_ input: [Input],
                          transform:(Input) -> Output) -> [Output] {
    var result = [Output]()
    for element in input {
        result.append(transform(element))
    }
    return result
}

extension Sequence {                                 // Array<Output>
    func myMap<Output>(transform:(Element) -> Output) -> [Output] {
        var result = [Output]()
        for element in self {
            result.append(transform(element))
        }
        return result
    }
    
    func myFilter(condition: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        for element in self where condition(element) {
            result.append(element)
        }
        return result
    }
    
    func myReduce<Output>(_ initialValue: Output,
                          transform: (Output, Element) -> Output) -> Output {
        var accumulator = initialValue
        for element in self {
            accumulator = transform(accumulator, element)
        }
        return accumulator
    }
    
    func myFlatMap<Output>(transform:(Element) -> [Output]) -> [Output] {
        var result = [Output]()
        for element in self {
            result.append(contentsOf: transform(element))
        }
        return result
    }
    
    func myCompactMap<Output>(transform:(Element) -> Output?) -> [Output] {
        var result = [Output]()
        for element in self {
            if let value = transform(element) {
                result.append(value)
            }
        }
        return result
    }
}

extension Optional {                       // Optional<Output>
    func myMap<Output>(transform: (Wrapped) -> Output) -> Output? {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return .some(transform(value))
        }
    }
    func myflatMap<Output>(transform: (Wrapped) -> Output?) -> Output? {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return transform(value)
        }
    }
}

myMap(words, transform: {string
    in string.count})

words
    .myMap{$0.count}

//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
