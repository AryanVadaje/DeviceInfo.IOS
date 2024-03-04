//
//  ContentView.swift
//  DeviceInfo.IOS
//
//  Created by Aryan Vadaje on 04/03/24.
//

import Metal
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Device Information").font(.title).padding()
            DeviceInformationView()
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}

struct DeviceInformationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            InformationItem(title: "Model Name:", value: UIDevice.current.model)
            InformationItem(title: "Model Number:", value: UIDevice.current.localizedModel)
            InformationItem(title: "iOS Version:", value: UIDevice.current.systemVersion)
            InformationItem(title: "Device Serial Number:", value: getSerialNumber())
            InformationItem(title: "Storage:", value: getStorage())
            InformationItem(title: "Battery Health:", value: getBatteryHealth())
            //To retrieve the battery health information of an iOS device, you can use the BatteryHealth API provided by Apple
            
            InformationItem(title: "Battery Level:", value: getBatteryLevel())
            InformationItem(title: "Camera MegaPixel:", value: "Not Available")
            InformationItem(title: "Camera Aperture:", value: "Not Available")
            //Camera's megapixel information, Aperture is not possible directly using public APIs on iOS
            
            InformationItem(title: "Processor (CPU) Information:", value: getCPUInfo())
            InformationItem(title: "GPU Information:", value: getGPUName())
            InformationItem(title: "IMEI:", value: getDeviceIdentifier())
            
            Text("Note: To retrieve the Battery Health, Camera's megapixel information & Aperture is not possible directly using public APIs on iOS.")
            
        }
    }
    
    func getSerialNumber() -> String {
        var serial: String?
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            serial = uuid
        }
        return serial ?? "N/A"
    }
    
    func getStorage() -> String {
        if let totalSpace = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemSize] as? NSNumber,
           let freeSpace = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())[.systemFreeSize] as? NSNumber {
            return "Total: \(totalSpace.int64Value / (1024 * 1024 * 1024)) GB, Free: \(freeSpace.int64Value / (1024 * 1024 * 1024)) GB"
        }
        return "N/A"
    }
    
    func getBatteryHealth() -> String {
        if #available(iOS 11.3, *) {
            let batteryHealth = UIDevice.current.batteryState == .unplugged ? "Normal" : "Unknown"
            return batteryHealth
        } else {
            return "N/A"
        }
    }
    
    func getBatteryLevel() -> String {
        let batteryLevel = UIDevice.current.batteryLevel * 100
        return "\(batteryLevel)%"
    }
    
    func getCPUInfo() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
        
    func getGPUName() -> String {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return "N/A"
        }
        return device.name
    }
        
    
    func getDeviceIdentifier() -> String {
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            return identifierForVendor.uuidString
        } else {
            return "N/A"
        }
    }
    
}

struct InformationItem: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title).font(.headline)
            Spacer()
            Text(value).font(.subheadline).foregroundColor(.gray)
        }.padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
