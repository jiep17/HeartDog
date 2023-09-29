import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:heartdog/src/models/BLE_item.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';

import '../../util/app_colors.dart';

// ignore: must_be_immutable
class ScanDevicesPage extends StatefulWidget {
  ScanDevicesPage({Key? key}) : super(key: key);
  final List<BleItem> devicesList = <BleItem>[];
  final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  // OWN
  late BluetoothCharacteristic connectedCharacteristic;

  @override
  State<StatefulWidget> createState() => ScanDevicesPageState();
}

class ScanDevicesPageState extends State<ScanDevicesPage> {
  final _writeController = TextEditingController();
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];

  // bool isConnected = false;
  bool isNotifiy = false;
  final targetDeviceName = "IoT Barkbeat Device";

  List<dynamic> receivedMessages = [
    // {'message': 'Message1', 'time': '12:01'}, // EXAMPLE
  ];

  _addDeviceTolist(final BluetoothDevice device, final int rssi) {
    //print(device);
    bool existItem = false;
    for (BleItem item in widget.devicesList) {
      if (item.device.remoteId == device.remoteId) {
        existItem = true;
      }
    }

    if (!existItem) {
      setState(() {
        widget.devicesList.add(BleItem(device: device, rssi: rssi));
      });
    }
  }

  _cleanDeviceList() {
    setState(() {
      widget.devicesList.clear();
    });
  }

  void _toggleNotfiy(characteristic) async {
    setState(() {
      isNotifiy = !isNotifiy;
    });
    if (isNotifiy) {
      characteristic.value.listen((value) {
        print('notify: ');
        print(utf8.decode(value));
        String msg = utf8.decode(value);
        var dt = DateTime.now();
        String time = '${dt.hour}:${dt.minute}';

        setState(() {
          receivedMessages.add({'message': msg, 'time': time});
        });
      });
      await characteristic.setNotifyValue(true);
    } else {
      await characteristic.setNotifyValue(false);
    }
  }

  @override
  void initState() {
    super.initState();

    // print(_connectedDevice);
    // if (_connectedDevice != null) {
    //   _connectedDevice!.disconnect();
    //   print('device disconnected');
    // }

    FlutterBluePlus.connectedSystemDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device, 0);
      }
    });
    FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      _cleanDeviceList();

      for (ScanResult result in results) {
        //print(results);

        if (result.device.localName == targetDeviceName) {
          print(result.rssi);
          _addDeviceTolist(result.device, result.rssi);
        }
      }
    });
    FlutterBluePlus.startScan(removeIfGone: const Duration(seconds: 5));
  }

  //ListView _buildListViewOfDevices() {
  _buildListViewOfDevices() {
    List<Widget> foundDevices = <Widget>[];
    for (BleItem item in widget.devicesList) {
      /// FOUNDED DEVICE CARD
      foundDevices.add(Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  SignalStrengthIndicator.bars(
                    value: 60,
                    maxValue: 50,
                    minValue: 0,
                    size: 30,
                    activeColor: AppColors.blueColor,
                    barCount: 5,
                    radius: const Radius.circular(20),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    item.rssi.toString(),
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 12),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                item.device.localName,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ],
          ),
        ),
      ));
    }

    return Column(children: [
      // SEARCH BUTTON & STOP SEARCH BUTTON
      /*Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              await FlutterBluePlus.stopScan();
              FlutterBluePlus.startScan();
              setState(() {
                widget.devicesList.clear();
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.38,
                    MediaQuery.of(context).size.height * 0.06)),
            child: Text(
              'SEARCH DEVICES',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                FlutterBluePlus.stopScan();
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 63, 44, 38),
                fixedSize: Size(MediaQuery.of(context).size.width * 0.38,
                    MediaQuery.of(context).size.height * 0.06)),
            child: Text(
              'STOP SEARCH',
            ),
          )
        ],
      ),
      const SizedBox(height: 25),
      Text(
        'DEVICES FOUND:',
        textAlign: TextAlign.left,
      ),*/

      const SizedBox(height: 10),
      Expanded(
        child: ListView(
          //padding: const EdgeInsets.all(8),
          children: <Widget>[
            ...foundDevices,
          ],
        ),
      )
    ]);
  }

  _buildConnectDeviceView() {
    for (BluetoothService service in _services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        /// CHECK IF READ AND WRITE PROPERTIES AVAILABLE
        /// THEN USE THIS CHARACTERISTIC
        if (characteristic.properties.write) {
          setState(() {
            widget.connectedCharacteristic = characteristic;
          });
        }
      }
    }

    /// RETURN THE ACTIVE CONNECTION SCREEN
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// ACTIVE CONNECTION CARD
        Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 63, 44, 38),
                  borderRadius: BorderRadius.circular(8)),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.17,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // DEVICE NAME
                    Row(
                      children: [
                        const Text(
                          'Device Name:',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          _connectedDevice!.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // DEVICE ID
                    Row(
                      children: [
                        const Text(
                          'Device ID:',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 29.0),
                          child: Text(
                            _connectedDevice!.id.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.brown),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // CHARACTERISTIC
                    Row(
                      children: [
                        const Text(
                          'Characteristic:',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.connectedCharacteristic.uuid.toString(),
                          style: TextStyle(
                              fontSize: 10.2,
                              fontWeight: FontWeight.w600,
                              color: Colors.brown),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _connectedDevice?.removeBond();
                          setState(() {
                            _connectedDevice?.disconnect();
                            _connectedDevice = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                        ),
                        child: const Text('Disconnect',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              )),
        ),

        /// END ACTIVE CONNECTION CARD

        const SizedBox(height: 10),
        Text(
          'SEND MESSAGE:',
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 20),

        /// SEND MESSAGE CARD
        Row(
          children: [
            // SEND MESSAGE
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.width * 0.12,
                child: TextField(
                  controller: _writeController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 135, 94, 81),
                        ),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8))),

                    focusedBorder:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    // focusedBorder: OutlineInputBorder(
                    //     borderSide: BorderSide(color: brownDarkest),
                    //     borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(8),
                    //         bottomLeft: Radius.circular(8))),
                    hintText: 'Write message to send..',
                    hintStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                    fillColor: Color.fromARGB(255, 135, 94, 81),
                    filled: true,
                  ),
                )),

            // SEND BUTTON
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await widget.connectedCharacteristic.setNotifyValue(false);

                  /// SEND THE MESSAGE VIA BLUETOOTH
                  await widget.connectedCharacteristic
                      .write(utf8.encode('${_writeController.text}\n'));

                  await widget.connectedCharacteristic.setNotifyValue(true);

                  setState(() {
                    _writeController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  });

                  final snackBar = SnackBar(
                    backgroundColor: Colors.brown,
                    content: const Center(child: Text('Message send!')),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8))),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.width * 0.12,
                    child: const Icon(
                      Icons.send,
                      size: 24,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),

        /// END WRITE MESSAGE CARD

        const SizedBox(height: 25),
        Text(
          'RECEIVED MESSAGES:',
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 17),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// NOTIFY BUTTON
            SizedBox(
              width: 58,
              height: 18,
              child: ElevatedButton(
                onPressed: () {
                  _toggleNotfiy(widget.connectedCharacteristic);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: isNotifiy ? Colors.green : Colors.brown),
                child: const Text('Notify',
                    style: TextStyle(fontSize: 9, color: Colors.white)),
              ),
            ),

            const SizedBox(width: 100),

            /// END NOTIFY BUTTON

            /// CLEAR BUTTON
            SizedBox(
              width: 58,
              height: 18,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    receivedMessages.clear();
                  });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text('Clear',
                    style: TextStyle(fontSize: 9, color: Colors.white)),
              ),
            ),

            /// END CLEAR BUTTON
          ],
        ),

        const SizedBox(height: 8),

        /// RECEIVE MESSAGES
        Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 214, 108, 75),
              borderRadius: BorderRadius.circular(8)),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: receivedMessages.length,
                          itemBuilder: (BuildContext context, int index) {
                            /// RECEIVED MESSAGE CARD
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color.fromARGB(255, 200, 125, 103)),
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      receivedMessages[index]['message']
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    bottom: 8,
                                    child: Text(
                                      receivedMessages[index]['time']
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color.fromARGB(
                                              218, 255, 255, 255)),
                                    ),
                                  )
                                ]),
                              ),
                            );

                            /// END RECEIVED MESSAGE CARD
                          }),
                    )),

                /// END RECEIVED MESSAGES
              ],
            ),
          ),
        )
      ],
    );
  }

  //ListView _buildView() {
  _buildView() {
    if (_connectedDevice != null) {
      return _buildConnectDeviceView();
    }
    return _buildListViewOfDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: AppColors.textColor, // establecer el color de los iconos
          ),
          title: Image.asset(
            'assets/images/barbeat_logo.png', // Ruta de la imagen del logo
            fit: BoxFit.contain, // Ajustar la imagen dentro del AppBar
            height: AppBar().preferredSize.height,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: AppColors.backgroundSecondColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Selecciona un dispositivo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                SignalStrengthIndicator.bars(
                                  value: 60,
                                  maxValue: 50,
                                  minValue: 0,
                                  size: 30,
                                  activeColor: AppColors.blueColor,
                                  barCount: 5,
                                  radius: const Radius.circular(20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '- 45',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'IPhone 12 PRO',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.72,
                        child: _buildView()),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
