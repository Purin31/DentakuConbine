//
//  ContentView.swift
//  IoTBluetoothSample2
//
//  Created by npc on 2022/06/13.
//

import SwiftUI
import CoreBluetooth

let id = "M5SCP01"

enum Answer {
    case up
    case down
    case `default`
    
    init?(string: String) {
        switch string {
        case "up":
            self = .up
        case "down":
            self = .down
        case "default":
            self = .default
        default:
            return nil
        }
    }
    
    var value: String {
        switch self {
            
        case .up:
            return "完了"
        case .down:
            return "まだ"
        case .default:
            return "未回答"
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    var body: some View {
        VStack {
            Button{
                viewModel.reConnect()
            } label: {
                Text("再接続")
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .foregroundColor(.white)
                    .background(Color.blue)
            }
            List(viewModel.m5Data.sorted {$0.0 < $1.0}, id: \.key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text(viewModel.m5Data[key]?.0.value ?? "何かしらのエラー")
                }
                .onTapGesture {
                    if let services = viewModel.m5Data[key]?.1.services {
                        
                        for service in services {
                            if let characteristics = service.characteristics {
                                for characteristic in characteristics {
                                    viewModel.m5Data[key]?.1.writeValue("LED".data(using: .utf8)!, for: characteristic, type: .withResponse)
                                }
                            }
                        }
                    }
                }
            }

        }
    }
}

class ContentViewModel: ObservableObject, BLEServiceDelegate {

    @Published var m5Data: [String : (Answer, CBPeripheral)]
    
    let service: BLEService
    
    func completion(name: String, data: Data, peripheral: CBPeripheral) {
        if let dataString = String(data: data, encoding: String.Encoding.utf8) {
            print(dataString)
            print(name)
            
            if m5Data.updateValue((Answer(string: dataString) ?? Answer.default, peripheral), forKey: name) != nil {
                print("update")
            } else {
                print("insert")
            }

            
        }
    }
    
    func disConnected(name: String) {
        self.m5Data[name] = nil
    }
    
    func reConnect() {
        service.centralManager.stopScan()
        service.centralManager.scanForPeripherals(withServices: nil)
    }
    
    init() {
        m5Data = [:]
        service = BLEService()
        service.delegate = self
    }
    
}


protocol BLEServiceDelegate {
    func completion(name: String, data: Data, peripheral: CBPeripheral)
    func disConnected(name: String)
}

class BLEService: NSObject {

    // 接続用のマネージャー
    var centralManager: CBCentralManager!
    // ペリフェラル（周辺機器）
    var peripherals: [CBPeripheral]!

    var delegate: BLEServiceDelegate?
    
    // 初期化処理
    override init() {
        super.init()
        centralManager = CBCentralManager()
        peripherals = []
        centralManager.delegate = self
    }
}

// セントラルの処理
extension BLEService: CBCentralManagerDelegate {
    
    // ①のステータスが更新された時に呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
        // 電源ONを待って、スキャンする
        // というか、自分がセントラルなのでここに最初にここに来る時点でpowerOnじゃないとおかしいんだけど
        case .poweredOn:
            print("poweredOn")
            
            // withServicesを指定しないと全てのペリフェラルを探そうとする
            // 周囲のBLE全部受け取ることになる
            centralManager.scanForPeripherals(withServices: nil)
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        @unknown default:
            print("default")
        }
    }
    
    // 接続イベントが発生した時に呼ばれる
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
    }
    
    // ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral.name ?? "")
        print(RSSI)
        
        if let name = peripheral.name,
           name.contains(id) {
            self.peripherals.append(peripheral)
            //centralManager?.stopScan()
            central.connect(peripheral, options: nil)
        }
        
    }
    
    // 接続されると呼ばれる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([])
    }
    
    // ペリフェラルと切断された時に呼ばれる
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            print(error.debugDescription)
            delegate?.disConnected(name: peripheral.name!)
            
            for (index, localPeripheral) in peripherals.enumerated() {
                if localPeripheral === peripheral {
                    peripherals.remove(at: index)
                }
            }
            return
        }
    }
}



// ペリフェラルの処理をどうするか？
extension BLEService: CBPeripheralDelegate {
    
    // サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        //キャリアクタリスティク探索開始
        if let service = peripheral.services?.first {
            // もしも通知をUUIDを指定するならば配列にUUIDを詰める
            peripheral.discoverCharacteristics([], for: service)
        
        }
    }
    
    // キャリアクタリスティク発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print(error.debugDescription)
            return
        }

        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                switch characteristic.properties {
                case .notify:
                    peripheral.setNotifyValue(true, for: characteristic)
                default:
                    break
                }
            }
        }

    }

    // データ送信時
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print(error.debugDescription)
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
    }
    
    // データ更新時
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        if error != nil {
            print(error.debugDescription)
            return
        }
        
        if let delegate = self.delegate {
            delegate.completion(name: peripheral.name ?? "",  data: characteristic.value!, peripheral: peripheral)
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
