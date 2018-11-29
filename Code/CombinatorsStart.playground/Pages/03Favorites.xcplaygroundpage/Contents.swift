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

//func myMap(_ input: [String], transform: (String) -> Int) -> [Int] {
//    var result = [Int]()
//    for element in input {
//        result.append(transform(element))
//    }
//    return result
//}

//Generics tip: go from concrete to abstract
func myMap<Input, Output>(_ input: [Input], transform: (Input) -> Output) -> [Output] {
    var result = [Output]()
    for element in input {
        result.append(transform(element))
    }
    return result
}

extension Sequence {
    //This is how Swift map function is implemented
    func myMap<Output>(_ transform: (Element) -> Output) -> [Output] {
        var result = [Output]()
        for element in self {
            result.append(transform(element))
        }
        return result
    }
    
    func myFilter(_ condition: (Element) -> Bool) -> [Element] {
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
    
    func myMapUsingReduce<Output>(_ transform: (Element) -> Output) -> [Output] {
        return reduce([Output](), { (accumulator, element) in
            accumulator + [transform(element)]
        })
    }
    
    func myFlatMap<Output>(_ transform: (Element) -> [Output]) -> [Output] {
        var result = [Output]()
        for element in self {
            result.append(contentsOf: transform(element))
        }
        return result
    }
    
    func myCompactMap<Output>(_ transform: (Element) -> Output?) -> [Output] {
        var result = [Output]()
        for element in self {
            if let newValue = transform(element) {
                result.append(newValue)
            }
        }
        return result
    }
}

extension Optional {
    func myMap<Output>(_ transform: (Wrapped) -> Output) -> Output? {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return .some(transform(value))
        }
    }
    
    //flatmap transform return and func return are always the same type
    func myFlatMap<Output>(_ transform: (Wrapped) -> Output?) -> Output? {
        switch self {
        case .none:
            return .none
        case .some(let value):
            return transform(value)
        }
    }
}

myMap(words, transform: numberOfLetters)

words.myMap(numberOfLetters)

words.myMapUsingReduce(numberOfLetters)

words.myFilter(containsA)

words.myReduce(0) { (accumulator, word)  in
    accumulator + word.count
}

//: ---


//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
