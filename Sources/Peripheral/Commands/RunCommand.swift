import Foundation
import ArgumentParser

struct RunCommand: ParsableCommand {

    // MARK: - Error

    private enum CommandError: Error, CustomStringConvertible {
        case invalidUUID

        var description: String {
            switch self {
            case .invalidUUID:
                return "The provided UUID is invalid."
            }
        }
    }

    // MARK: - Properties

    static var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: "peripheral",
            abstract: "Advertise a Bluetooth peripheral.",
            version: "0.1.0"
        )
    }

    @Option(help: "The uuid of the peripheral. (default: random UUID)", transform: {
        guard let uuid = UUID(uuidString: $0) else {
            throw CommandError.invalidUUID
        }
        return uuid
    })
    var uuid: UUID?

    @Option(help: "The service id of the peripheral. (default: random UUID)", transform: {
        guard let uuid = UUID(uuidString: $0) else {
            throw CommandError.invalidUUID
        }
        return uuid
    })
    var service: UUID?

    // MARK: - ParsableCommand

    mutating func run() throws {
        PeripheralManager.shared.startAdvertising(
            uuid: uuid ?? UUID(),
            serviceUUID: service ?? UUID()
        )
        RunLoop.main.run()
    }
}
