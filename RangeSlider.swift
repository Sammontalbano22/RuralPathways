//
//  RangeSlider.swift
//  CollegePathwaysAI
//
//  Created by sam Montalbano on 11/7/24.
//

import SwiftUI

struct RangeSlider: View {
    @Binding var value: ClosedRange<Double>
    let inRange: ClosedRange<Double>
    let step: Double
    let format: String

    var body: some View {
        VStack {
            // Display the current range values
            HStack {
                Text(String(format: format, value.lowerBound))
                Spacer()
                Text(String(format: format, value.upperBound))
            }
            .font(.footnote)
            .padding(.horizontal)

            // Slider Track and Handles
            GeometryReader { geometry in
                let sliderWidth = geometry.size.width
                let sliderHeight = geometry.size.height
                let totalRange = inRange.upperBound - inRange.lowerBound
                let lowerPercentage = (value.lowerBound - inRange.lowerBound) / totalRange
                let upperPercentage = (value.upperBound - inRange.lowerBound) / totalRange

                let lowerX = lowerPercentage * sliderWidth
                let upperX = upperPercentage * sliderWidth

                let rangeWidth = upperX - lowerX

                ZStack(alignment: .leading) {
                    // Track
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .cornerRadius(2)
                        .position(x: sliderWidth / 2, y: sliderHeight / 2)

                    // Range Highlight
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: rangeWidth, height: 4)
                        .cornerRadius(2)
                        .position(x: lowerX + rangeWidth / 2, y: sliderHeight / 2)

                    // Lower Handle
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .position(x: lowerX, y: sliderHeight / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    var newLower = (gesture.location.x / sliderWidth) * totalRange + inRange.lowerBound
                                    newLower = min(max(inRange.lowerBound, newLower), value.upperBound - step)
                                    newLower = (newLower / step).rounded() * step
                                    value = newLower...value.upperBound
                                }
                        )
                        .accessibilityLabel("Lower Handle")
                        .accessibilityValue("\(String(format: format, value.lowerBound))")

                    // Upper Handle
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 20, height: 20)
                        .position(x: upperX, y: sliderHeight / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    var newUpper = (gesture.location.x / sliderWidth) * totalRange + inRange.lowerBound
                                    newUpper = max(min(inRange.upperBound, newUpper), value.lowerBound + step)
                                    newUpper = (newUpper / step).rounded() * step
                                    value = value.lowerBound...newUpper
                                }
                        )
                        .accessibilityLabel("Upper Handle")
                        .accessibilityValue("\(String(format: format, value.upperBound))")
                }
            }
            .frame(height: 40) // Increased height to accommodate handles
            .padding(.horizontal, 10)
        }
        .frame(height: 60) // Total height to include labels and slider
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RangeSlider(
                value: .constant(20.0...80.0),
                inRange: 0...100,
                step: 0.1,
                format: "%.1f"
            )
            .padding()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)

            RangeSlider(
                value: .constant(20.0...80.0),
                inRange: 0...100,
                step: 0.1,
                format: "%.1f"
            )
            .padding()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
    }
}

