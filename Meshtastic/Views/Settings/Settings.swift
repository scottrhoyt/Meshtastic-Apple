//
//  Settings.swift
//  MeshtasticApple
//
//  Copyright (c) Garth Vander Houwen 6/9/22.
//

import SwiftUI

struct Settings: View {
	
	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	@EnvironmentObject var userSettings: UserSettings
	
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(key: "lastHeard", ascending: false)],
		animation: .default)

	private var nodes: FetchedResults<NodeInfoEntity>
	
	var body: some View {
		NavigationView {
			List {
				
				let connectedNodeNum = bleManager.connectedPeripheral != nil ? bleManager.connectedPeripheral.num : 0
				
				NavigationLink {
					AppSettings()
				} label: {
					
					Image(systemName: "gearshape")
						.symbolRenderingMode(.hierarchical)
					Text("App Settings")
				}
				
				Section("Radio Configuration") {
					
					NavigationLink {
						ShareChannel(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
						Image(systemName: "qrcode")
							.symbolRenderingMode(.hierarchical)
						Text("Share Channel QR Code")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					NavigationLink {
						UserConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "person.crop.rectangle.fill")
							.symbolRenderingMode(.hierarchical)

						Text("User")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					NavigationLink() {
						
						LoRaConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "dot.radiowaves.left.and.right")
							.symbolRenderingMode(.hierarchical)

						Text("LoRa")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					NavigationLink {
						DeviceConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "flipphone")
							.symbolRenderingMode(.hierarchical)
						Text("Device")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					NavigationLink {
						DisplayConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "display")
							.symbolRenderingMode(.hierarchical)
						Text("Display (Device Screen)")
					}
					.disabled(bleManager.connectedPeripheral == nil)
				
					NavigationLink {
						PositionConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "location")
							.symbolRenderingMode(.hierarchical)

						Text("Position")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					Text("Default settings values are prefered as they consume no bandwidth when sent over the mesh.")
						.font(.caption2)
						.fixedSize(horizontal: false, vertical: true)
				}
				Section("Module Configuration") {
					
					NavigationLink {
						CannedMessagesConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {

						Image(systemName: "list.bullet.rectangle.fill")
							.symbolRenderingMode(.hierarchical)

						Text("Canned Messages")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					NavigationLink {
						ExternalNotificationConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "megaphone")
							.symbolRenderingMode(.hierarchical)

						Text("External Notification")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					
					NavigationLink {
						RangeTestConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "point.3.connected.trianglepath.dotted")
							.symbolRenderingMode(.hierarchical)

						Text("Range Test")
					}
					.disabled(bleManager.connectedPeripheral == nil)
						//nodes.first(where: { $0.num == connectedNodeNum })?.myInfo?.hasWifi ?? true)//||
						//	  nodes.first(where: { $0.num == connectedNodeNum })!.rangeTestConfig != nil)
					
					NavigationLink {
						SerialConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "terminal")
							.symbolRenderingMode(.hierarchical)

						Text("Serial")
					}
					.disabled(bleManager.connectedPeripheral == nil)
					

					NavigationLink {
						TelemetryConfig(node: nodes.first(where: { $0.num == connectedNodeNum }) ?? NodeInfoEntity())
					} label: {
					
						Image(systemName: "chart.xyaxis.line")
							.symbolRenderingMode(.hierarchical)

						Text("Telemetry (Sensors)")
					}
					.disabled(bleManager.connectedPeripheral == nil)
				}
				Section(header: Text("Logging")) {
					
					NavigationLink {
						
						MeshLog()
						
					} label: {

						Image(systemName: "list.bullet.rectangle")
							.symbolRenderingMode(.hierarchical)

						Text("Mesh Log")
					}
					
					NavigationLink {
						
						let connectedNode = nodes.first(where: { $0.num == connectedNodeNum })
						
						AdminMessageList(user: connectedNode?.user ?? UserEntity())
					} label: {

						Image(systemName: "building.columns")
							.symbolRenderingMode(.hierarchical)

						Text("Admin Message Log")
					}
					.disabled(bleManager.connectedPeripheral == nil)
				}
				
				// Not Implemented:
				// Store Forward Config - Not Working, TBEAM Only
				// WiFi Config - Would break connection to device
				// MQTT Config - Part of WiFi
			}
			.listStyle(GroupedListStyle())
			.navigationTitle("Settings")
		}
	}
}