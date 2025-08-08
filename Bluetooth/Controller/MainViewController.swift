//
//  MainViewController.swift
//  Bluetooth
//
//  Created by imac-2627 on 2024/9/18.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbLightNumber: UILabel!
    
    // MARK: - Property
    
    private var peripherals: [CBPeripheral] = []
    private var connectedPeripheral: CBPeripheral?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        BluetoothService.shared.delegate = self
    }
    
    // MARK: - UI Settings
    
    func setUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BluetoothCell")
        lbLightNumber.text = "等待數據..."
    }
    
    // MARK: - IBAction
    
    // MARK: - Function
}

// MARK: - Extensions

extension MainViewController: BluetoothServiceDelegate, CBPeripheralDelegate {
    
    func getBLEPeripherals(peripherals: [CBPeripheral]) {
        
        self.peripherals = peripherals
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getBLEPeripheralsValue(value: String) {
        
        DispatchQueue.main.async {
            self.lbLightNumber.text = "光線強度：\(value)"
        }
        
        print("\(value)")
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell", for: indexPath)
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name ?? "未知設備"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeripheral = peripherals[indexPath.row]
        BluetoothService.shared.connectPeripheral(peripheral: selectedPeripheral)
    }
}
