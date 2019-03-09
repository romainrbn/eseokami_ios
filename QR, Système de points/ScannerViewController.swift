//
//  ScannerViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 12/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var topbar: UIView!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topbar)
        
        // Initialisation de la session de capture de qr
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr] // un qr code
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                
                view.bringSubviewToFront(qrCodeFrameView)
                
            }
            
        } catch {
            let alertController = UIAlertController(title: "Erreur", message: error.localizedDescription, preferredStyle: .alert)
            let actionDismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(actionDismiss)
            self.present(alertController, animated: true, completion: nil)
            return
        }

        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "Aucun QR Code détecté"
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                let alertController = UIAlertController(title: metadataObj.stringValue, message: "Nombre de points actuel: \(metadataObj.stringValue)", preferredStyle: .alert)
                alertController.addTextField { (textField) in
                    textField.placeholder = "Entre un nombre de points à rajouter"
                }
                let action1 = UIAlertAction(title: "OK", style: .default) { (action) in
                    // Ajouter points sur db
                    let nbDePointsARajouter: Int = Int((alertController.textFields?.first?.text!)!)!
                }
                
                let action2 = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                alertController.addAction(action1)
                alertController.addAction(action2)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

}
