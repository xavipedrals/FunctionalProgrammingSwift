//: ### Parser Combinator
//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)

struct Parser<T> {
    let parse: (String) -> ParserResult<T>
}

extension Parser {
    func followed<U>(by otherParser: Parser<U>) -> Parser<(T,U)> {
        return Parser<(T,U)>{ string in
            switch self.parse(string) {
            case .failure(let message):
                return .failure(message)
            case .success(let value, let remain):
                switch otherParser.parse(remain) {
                case .failure(let message):
                    return .failure(message)
                case .success(let innerValue, let innerString):
                    return .success((value, innerValue), innerString)
                }
            }
        }
    }
    
    func or(_ otherParser: Parser) -> Parser {
        return Parser{ string in
            let result = self.parse(string)
            switch self.parse(string) {
            case .success:
                return result
            case let .failure(message):
                let second = otherParser.parse(string)
                switch second {
                case .success:
                    return second
                    case .failure(<#T##String#>)
                default:
                    <#code#>
                }
            }
        }
    }
}

func characterParser(for characterToMatch: Character) -> Parser<Character> {
    return Parser<Character>{ string in
        guard let firstChar = string.first else {
            return .failure("String is empty")
        }
        if firstChar == characterToMatch {
            return .success(characterToMatch, String(string.dropFirst()))
        }
        return .failure("\(firstChar) from \(string) is not \(characterToMatch)")
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
parserAThenB.parse("ZZC")
parserAThenB.parse("AZC")
parserAThenB.parse("A")
parserAThenB.parse("")

let parserAOrB = parserA.or(parserB)

parserAOrB.parse("ABC")
parserAOrB.parse("BZC")
parserAOrB.parse("ZZC")
parserAOrB.parse("")



//: [TOC](00TOC) - [Previous](@previous) - [Next](@next)
