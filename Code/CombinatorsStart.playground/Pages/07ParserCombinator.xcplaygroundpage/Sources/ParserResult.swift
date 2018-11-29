public enum ParserResult<Value> {
    case success(Value, String)
    case failure(String)
}

extension ParserResult: CustomStringConvertible where Value: CustomStringConvertible {
    public var description: String {
        switch self {
        case .failure(let message):
            return "failure: " + message
        case .success(let value, let remaining):
            return "success: \(value), \(remaining)"
        }
    }
}
