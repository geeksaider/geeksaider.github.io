import Foundation
import CoreImage
import CoreGraphics

let source = URL(fileURLWithPath: CommandLine.arguments[1])
let destination = URL(fileURLWithPath: CommandLine.arguments[2])

guard let image = CIImage(contentsOf: source, options: [.applyOrientationProperty: true]) else {
    fatalError("Could not read image")
}

let context = CIContext()
try context.writeJPEGRepresentation(
    of: image,
    to: destination,
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    options: [.lossyCompressionQuality: 0.9]
)
