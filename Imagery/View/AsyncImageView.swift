//
//  AsyncImage.swift
//  Imagery
//
//  Created by Jun on 2023/09/14.
//

import SwiftUI

struct AsyncImageView: View {
    @State private var img: UIImage? = nil
    @State private var cropImage: UIImage? = nil
    @State private var cropSize: CGSize? = nil
    @State private var pallete: UIColor = .clear
    @State private var greyScale: UIColor = .clear
    @State private var intensity: Float = 0
    
    @State private var isDragging: Bool = false
    
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    var body: some View {
        ZStack {
            Group {
                if let image = self.img {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 390, height: 390)
                        .accessibilityLabel("이미지")
                        .accessibilityIdentifier("Image")
                        .gesture(DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                isDragging = true
                                if (value.location.x < 390 && value.location.x > 0) &&
                                    (value.location.y < 390 && value.location.y > 0) {
                                    if (HapticManager.shared.isEngineLoad == false) {
                                        HapticManager.shared.prepareHaptics()
                                    }
                                    if let (color, grey, light) = getPixelColorAtPoint(value.location, 1024/390) {
                                        pallete = color
                                        greyScale = grey
                                        intensity = light
                                        HapticManager.shared.playCustomVibration(intensity)
                                    }
                                }
                            })
                            .onEnded({ _ in
                                HapticManager.shared.stopHaptics()
                                HapticManager.shared.isEngineLoad = false
                                isDragging = false
                            })
                        )
                } else {
                    Color.gray
                        .opacity(0.5)
                        .frame(width: 390, height: 390)
                        .overlay {
                            VStack {
                                Text("Loading...")
                                ProgressView()
                            }
                        }
                }
            }
            if isDragging {
                ZStack {
                    VStack {
                        Color(uiColor: greyScale)
                            .frame(width: 250, height: 75)
                            .border(Color.OasisColors.yellow, width: 10)
                        Spacer()
                            .frame(height: cropSize!.height * 2.5 + 100)
                    }
                    if let image = self.cropImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: cropSize!.width * 2.5, height: cropSize!.height * 2.5)
                            .border(Color.OasisColors.white, width:10)//Color.OasisColors.yellow, width: 10)
                    }
                }
            }
        }
        .onAppear(perform: loadImage)
    }
    
    
    func getPixelColorAtPoint(_ point: CGPoint, _ ratio: CGFloat) -> (UIColor, UIColor, Float)? {
        guard let image = self.img else {
            return nil
        }
        
        let pixelData = image.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pointX = point.x * ratio
        let pointY = point.y * ratio
        
        let pixelIndex: Int = ((Int(image.size.width) * Int(pointY)) + Int(pointX)) * 4
        
        let cropRect = CGRect(x: pointX - 50, y: pointY - 50, width: 100, height: 100)
        let imageRef = image.cgImage!.cropping(to: cropRect);
        cropSize = CGSize(width: imageRef!.width, height: imageRef!.height)
        cropImage = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        
        let r = CGFloat(data[pixelIndex]) / CGFloat(255.0)
        let g = CGFloat(data[pixelIndex+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelIndex+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelIndex+3]) / CGFloat(255.0)
        
        let ave = (r + g + b) / 3
        
        return (UIColor(red: r, green: g, blue: b, alpha: a), UIColor(red: ave, green: ave, blue: ave, alpha: a), Float(ave))
    }
    
    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                self.img = image//.resized(toWidth: 374)
            }
        }.resume()
    }
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
