//
//  QRCodeViewController.swift
//  Chartr
//
//  Created by Jay Martinez on 7/17/22.
//

import UIKit
import AVFoundation

protocol ScannerDelegate {
    func postAddress(address: String)
}

class ScannerViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrcodeFrame: UIView!
    var scannerDelgate: ScannerDelegate!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
                
                let metadataOutput = AVCaptureMetadataOutput()

                if (captureSession.canAddOutput(metadataOutput)) {
                    captureSession.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr]
                    
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = view.layer.bounds
                    previewLayer.videoGravity = .resizeAspectFill
                    view.layer.addSublayer(previewLayer)
                    
                    let qrcodeFrame = UIView(frame: CGRect(x: view.frame.midX - 128, y: view.frame.midY - 128, width: 256, height: 256))
                    qrcodeFrame.layer.borderColor = AppColor.yellow.color.cgColor
                    qrcodeFrame.layer.borderWidth = 2
                    view.addSubview(qrcodeFrame)
                    view.bringSubviewToFront(qrcodeFrame)
                    
                } else {
                    failure()
                    return
                }
            } else {
                failure()
                return
            }
        } catch {
            failure()
            return
        }

        captureSession.startRunning()
    }
    
    private func failure() {
        showAlert(
            LocalizedStrings.Alert.scannerErrorTitle,
            LocalizedStrings.Alert.scannerErrorMessage,
            "Ok", nil) { _ in
                
            print("noop")
        }
    }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.scannerDelgate.postAddress(address: stringValue)
        }

        dismiss(animated: true)
    }
}
