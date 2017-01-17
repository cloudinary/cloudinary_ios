import Foundation

let verbose = true

// MARK: - Exception Handling
let handler: @convention(c) (NSException) -> Void = {
    exception in
    print("FATAL EXCEPTION: \(exception)")
    exit(1)
}
NSSetUncaughtExceptionHandler(handler)

// MARK: - Task Utilities
func runShellCommand(command: String) -> String? {
    let args: [String] = command.characters.split { $0 == " " }.map(String.init)
    let other = args[1..<args.count]
    let outputPipe = Pipe()
    let process = Process()
    process.launchPath = args[0]
    process.arguments = other.map { $0 }
    process.standardOutput = outputPipe
    process.launch()
    process.waitUntilExit()

    guard process	.terminationStatus == 0 else { return nil }

    let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
    return String(data:outputData, encoding: .utf8)
}

// MARK: - File System Utilities
func fileExists(filePath: String) -> Bool {
    return FileManager.default.fileExists(atPath: filePath)
}

func mkdir(path: String) -> Bool {
    do {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        return true
    }
    catch {
        return false
    }
}

// MARK: - String Utilities
func trim(s: String) -> String {
    return ((s as NSString).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String)
}

func trim(s: String?) -> String? {
    return (s == nil) ? nil : (trim(s:s!) as String)
}

func reportError(message: String) -> Never {
    print("ERROR: \(message)")
    exit(1)
}

// MARK: GenerateCommonCryptoModule
enum SDK: String {
    case iOS = "iphoneos",
        iOSSimulator = "iphonesimulator"
    static let all = [iOS, iOSSimulator]

}

guard let sdk = SDK(rawValue: CommandLine.arguments[1])?.rawValue else {
    reportError(message: "SDK must be one of \(SDK.all.map { $0.rawValue })") }
guard let sdkVersion = trim(s: runShellCommand(command: "/usr/bin/xcrun --sdk \(sdk) --show-sdk-version")) else {
    reportError(message: "ERROR: Failed to determine SDK version for \(sdk)")
}
guard let sdkPath = trim(s: runShellCommand(command: "/usr/bin/xcrun --sdk \(sdk) --show-sdk-path")) else {
    reportError(message: "ERROR: Failed to determine SDK path for \(sdk)")
}

if verbose {
    print("SDK: \(sdk)")
    print("SDK Version: \(sdkVersion)")
    print("SDK Path: \(sdkPath)")
}

let moduleDirectory: String
let moduleFileName: String
if CommandLine.arguments.count > 2 {
    moduleDirectory =  "\(CommandLine.arguments[2])/Cloudinary/Frameworks/CLDCrypto/\(sdk)/CLDCrypto.framework"
    moduleFileName = "module.map"
}
else {
    moduleDirectory = "\(sdkPath)/System/Library/Frameworks/CLDCrypto/CLDCrypto.framework"
    moduleFileName = "module.map"

    if fileExists(filePath: moduleDirectory) {
        reportError(message: "Module directory already exists at \(moduleDirectory).")
    }
}

if !mkdir(path: moduleDirectory) {
    reportError(message: "Failed to create module directory \(moduleDirectory)")
}

let headerDir = "\(sdkPath)/usr/include/CommonCrypto"
let headerFile1 = "\(headerDir)/CommonCrypto.h"
let headerFile2 = "\(headerDir)/CommonRandom.h"

let moduleMapFile =
"module CLDCrypto [system] {\n" +
"  header \"\(headerFile1)\"\n" +
"  header \"\(headerFile2)\"\n" +
"  export *\n" +
"}\n"

let moduleMapPath = "\(moduleDirectory)/\(moduleFileName)"
do {
    try moduleMapFile.write(toFile:moduleMapPath, atomically: true, encoding:.utf8)
    print("Successfully created module \(moduleMapPath)")
    exit(0)
}
catch {
    reportError(message: "Failed to write module map file to \(moduleMapPath)")
}
