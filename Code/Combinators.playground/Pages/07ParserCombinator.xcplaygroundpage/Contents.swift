//: ### Parser Combinator
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

struct Parser<T> {
    let parse: (String) -> ParserResult<T>
}
extension Parser {
    func followed<U>(by otherParser: Parser<U>) -> Parser<(T,U)> {
        return Parser<(T,U)>{string in
            switch self.parse(string) {
            case .failure(let message):
                return .failure(message)
            case .success(let value, let remain):
                switch otherParser.parse(remain) {
                case .failure(let message):
                    return .failure(message)
                case .success(let innerValue, let innerRemain):
                    return .success((value, innerValue),innerRemain)
                }
            }
        }
    }
    func or(_ otherParser: Parser) -> Parser {
        return Parser{string in
            switch self.parse(string) {
            case .success(let value, let remain):
                return .success(value, remain)
            case .failure(let message):
                switch otherParser.parse(string) {
                case .success(let value, let remain):
                    return .success(value, remain)
                case .failure(let message2):
                    return .failure(message + " and " + message2)
                }
            }
        }
    }
}


//:

func characterParser(for characterToMatch: Character) -> Parser<Character> {
    return Parser<Character>{string in
        guard let firstChar = string.first else {
            return .failure("String is empty")
        }
        if firstChar == characterToMatch {
            return .success(characterToMatch, String(string.dropFirst()))
        } else { return .failure("\(firstChar) from \(string) is not \(characterToMatch)")}
    }
}

let parserA = characterParser(for: "A")

parserA.parse("ABC")
parserA.parse("ZBC")
parserA.parse("")

let parserB = characterParser(for: "B")
let parserAThenB = parserA.followed(by: parserB)

parserAThenB.parse("ABC")
parserAThenB.parse("ZBC")
parserAThenB.parse("AZC")
parserAThenB.parse("")

let parserAOrB = parserA.or(parserB)

parserAOrB.parse("ABC")
parserAOrB.parse("ZBC")
parserAOrB.parse("BZC")
parserAOrB.parse("")



//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
