//: ### Warmup
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

import Foundation

let s1 = "Annabelle, my dog, is not the smartest animal in Ohio."
let s2 = "Madam, in Eden, I'm Adam."
//: ---
func lowercased(_ string: Substring) -> String {
    return string.lowercased()
}
func caseInsensitive(_ string1: Substring, string2: Substring) -> Bool {
    return string1.lowercased() < string2.lowercased()
}

func outPunctuation(_ char: Character) -> Bool {
    guard let unicodeScalar = char.unicodeScalars.first else {return false}
    return !CharacterSet.punctuationCharacters.contains(unicodeScalar)
}

func outWhitespace(_ char: Character) -> Bool {
    guard let unicodeScalar = char.unicodeScalars.first else {return false}
    return !CharacterSet.whitespacesAndNewlines.contains(unicodeScalar)
}
//: ---

s1.split(separator: " ")

s1.split(separator: " ").sorted()

s1.lowercased().split(separator:" ").sorted()

s1
    .split(separator:" ")
    .map{word in word.lowercased()}
    .sorted()


s1
    .split(separator:" ")
    .map{$0.lowercased()}
    .sorted()

s1
    .split(separator:" ")
    .map(lowercased)
    .sorted()



s1.split(separator: " ")
    .sorted{$0.lowercased() < $1.lowercased()}


s1.split(separator:" ").sorted{(string1, string2) in
    string1.lowercased() < string2.lowercased()
}

s1
    .split(separator:" ")
    .sorted(by: caseInsensitive)



s1.filter{(_ char: Character) -> Bool in
    guard let unicodeScalar
        = char.unicodeScalars.first else {return false}
    return !CharacterSet.punctuationCharacters
        .contains(unicodeScalar)
    }
    .split(separator:" ")
    .sorted(by: caseInsensitive)



s1
    .filter(outPunctuation)
    .split(separator:" ")
    .sorted(by: caseInsensitive)

let s3 = s2
    .filter(outPunctuation)
    .filter(outWhitespace)
    .lowercased()


zip(s3, s3.reversed())

zip(s3, s3.reversed())
    .map{$0}

zip(s3, s3.reversed())
    .map{$0 == $1}

zip(s3, s3.reversed())
    .map{(first, second) in first == second}

zip(s3, s3.reversed())
    .map(==)

zip(s3, s3.reversed())
    .map(==)
    .reduce(true){$0 && $1}

zip(s3, s3.reversed())
    .map(==)
    .reduce(true){(accumulator, element) in accumulator && element}


zip(s3, s3.reversed())
    .reduce(true){(result, tuple) in
        let (first, second) = tuple
        return result && (first == second)
}

//func remainder(of string: String) -> Substring? {
//    if let firstSpace = string.index(of: " ") {
//        return string[firstSpace...]
//    } else {
//        return nil
//    }
//}

func remainder(of string: String) -> Substring? {
    return string.index(of: " ").map{string[$0...]}
}

remainder(of: s1)
remainder(of: s3)


let spellOutFormatter = NumberFormatter()
spellOutFormatter.numberStyle = .spellOut


func next(_ number: Int) -> Int? {
    return spellOutFormatter.string(for: number)?.count
}

//func stableFrom(_ int: Int) -> Int? {
//    guard let nextInt = next(int),
//        nextInt != int else  {
//            return int
//    }
//    return stableFrom(nextInt)
//}

//func stableFrom(_ int: Int) -> Int? {
//    return next(int).map{$0 == int ? $0 : stableFrom($0) }
//}

//func stableFrom(_ int: Int) -> Int? {
//    return next(int).map{nextInt in
//        if nextInt == int {
//            return nextInt
//        }
//        else {
//            return stableFrom(nextInt)
//        }
//    }
//}

//func stableFrom(_ int: Int) -> Int? {
//    return next(int).flatMap{nextInt in
//        if nextInt == int {
//            return nextInt
//        }
//        else {
//            return stableFrom(nextInt)
//        }
//    }
//}

func stableFrom(_ int: Int) -> Int? {
    return next(int).flatMap{$0 == int ? $0 : stableFrom($0) }
}


stableFrom(1000)

//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
