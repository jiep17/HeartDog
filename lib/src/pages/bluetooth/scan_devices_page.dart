import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:heartdog/src/models/BLE_item.dart';
import 'package:heartdog/src/models/ble_notify_data.dart';
import 'package:heartdog/src/models/ble_write_data.dart';
import 'package:heartdog/src/util/widget_properties.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import '../../util/app_colors.dart';

// ignore: must_be_immutable
class ScanDevicesPage extends StatefulWidget {
  ScanDevicesPage({Key? key}) : super(key: key);
  final List<BleItem> devicesList = <BleItem>[];
  final List<BleItem> connectedDeviceList = <BleItem>[];
  //final Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  // OWN
  BluetoothCharacteristic? connectedWriteCharacteristic;
  BluetoothCharacteristic? connectedNotifyCharacteristic;

  @override
  State<StatefulWidget> createState() => ScanDevicesPageState();
}

class ScanDevicesPageState extends State<ScanDevicesPage> {
  StreamSubscription<List<BluetoothDevice>>? _connectedDevicesSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;
  StreamSubscription<List<int>>? _notifySubscription;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passWifiController = TextEditingController();
  bool _obscurePasswordWifi = false;

  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _services = [];

  // bool isConnected = false;
  final targetDeviceName = "IoT Barkbeat Device";

  // ignore: prefer_final_fields
  List<BleNotifyData> _receivedMessages = [];

  late SharedPreferences prefs;

  String _dogId = "";

  _addDeviceTolist(BluetoothDevice device, int rssi, DateTime timeStamp) {
    //print(device);
    bool existItem = false;
    for (BleItem item in widget.devicesList) {
      if (item.device.remoteId == device.remoteId) {
        existItem = true;
        setState(() {
          item.rssi = rssi;
          item.timeStamp = timeStamp;
        });
      }

      if (DateTime.now().difference(item.timeStamp) >
          const Duration(seconds: 2)) {
        setState(() {
          widget.devicesList.remove(item);
        });
        return;
      }
    }

    if (!existItem) {
      setState(() {
        widget.devicesList
            .add(BleItem(device: device, rssi: rssi, timeStamp: timeStamp));
      });
    }
  }

  _addConnectedDeviceToList(BluetoothDevice device) {
    bool existItem = false;
    for (BleItem item in widget.connectedDeviceList) {
      if (item.device.remoteId == device.remoteId) {
        existItem = true;
      }
    }

    if (!existItem) {
      setState(() {
        widget.connectedDeviceList
            .add(BleItem(device: device, rssi: 0, timeStamp: DateTime(0)));
      });
    }
  }

  Future<void> _getDogId() async {
    prefs = await SharedPreferences.getInstance();
    _dogId = prefs.getString('dogId')!;
  }

  @override
  void initState() {
    super.initState();

    _getDogId();

    _connectedDevicesSubscription = FlutterBluePlus.connectedSystemDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addConnectedDeviceToList(device);
      }
    });

    _scanResultsSubscription =
        FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (result.device.localName == targetDeviceName) {
          _addDeviceTolist(result.device, result.rssi, result.timeStamp);
        }
      }
    });

    //widget.connectedCharacteristic = FlutterBluePlus.

    FlutterBluePlus.startScan(removeIfGone: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    // Realiza tareas de limpieza o liberación de recursos aquí
    _connectedDevicesSubscription?.cancel();
    _scanResultsSubscription?.cancel();
    _notifySubscription?.cancel();

    FlutterBluePlus.stopScan();
    super.dispose(); // No olvides llamar a la implementación de la superclase
    //print("Se detuvo el scanero y se cerro la pagina");
  }

  //ListView _buildListViewOfDevices() {
  _buildListViewOfDevices() {
    List<Widget> foundDevices = <Widget>[];
    for (BleItem item in widget.devicesList) {
      /// FOUNDED DEVICE CARD
      if (item.device != _connectedDevice) {
        var cardDevice = GestureDetector(
          onTap: () async {
            if (_connectedDevice == null &&
                widget.connectedDeviceList.isEmpty) {
              _showWiFiFormDialog(context, item);
            } else {
              _showInformationDialog(context);
            }
          },
          onTapDown: (_) {
            setState(() {
              item.isHovered = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              item.isHovered = false;
            });
          },
          onTapCancel: () {
            setState(() {
              item.isHovered = false;
            });
          },
          child: Card(
            elevation: item.isHovered ? 5 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SignalStrengthIndicator.bars(
                        value: 100 + item.rssi,
                        maxValue: 100,
                        minValue: 0,
                        size: 30,
                        activeColor: AppColors.blueColor,
                        barCount: 5,
                        radius: const Radius.circular(20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        (item.rssi) == 0 ? "Ok" : item.rssi.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.device.localName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.62,
                        child: Text(
                          "UUID: ${item.device.remoteId.toString()}",
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w100,
                              fontSize: 14),
                        ),
                      ),
                      if (item.isTouched)
                        const Row(
                          children: [
                            Text('Conectando...'),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        );

        foundDevices.add(cardDevice);
      }
    }

    return Column(children: [
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

  _buildListViewOfConnectedDevices() {
    List<Widget> foundDevices = <Widget>[];
    for (BleItem item in widget.connectedDeviceList) {
      /// FOUNDED DEVICE CARD

      var cardDevice = GestureDetector(
        onDoubleTap: () {
          _showDisconnectDialog(context, item);
          _receivedMessages.clear();
        },
        child: Card(
          elevation: item.isHovered ? 5 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SignalStrengthIndicator.bars(
                      value: 100 + item.rssi,
                      maxValue: 100,
                      minValue: 0,
                      size: 30,
                      activeColor: AppColors.blueColor,
                      barCount: 5,
                      radius: const Radius.circular(20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (item.rssi) == 0 ? "Ok" : item.rssi.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w100, fontSize: 12),
                    )
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    item.device.localName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.62,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Conexión exitosa'),
                          const SizedBox(
                            height: 5,
                          ),

                          if (_connectedDevice != null)
                            Row(
                              children: [
                                const Text('Comprobación de estado:'),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Row(
                                    children: [
                                      if (_receivedMessages.length != 3)
                                        const SizedBox(
                                          height: 7,
                                          width: 7,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("${_receivedMessages.length}"),
                                      const Text("/3"),
                                    ],
                                  ),
                                )
                              ],
                            ),

                          if (_connectedDevice != null)
                            const SizedBox(
                              height: 5,
                            ),

                          if (_connectedDevice != null)
                            SizedBox(
                              height: 125,
                              width: 225,
                              child: ListView.builder(
                                  itemCount: _receivedMessages.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _receivedMessages[index].success
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                            width: 190,
                                            child: Text(
                                                _receivedMessages[index].msg,
                                                textAlign: TextAlign.justify)),
                                        const SizedBox(height: 5)
                                      ],
                                    );
                                  }),
                            )
                          //for(int i = 0; i < 3; i++)
                          //Text(receivedMessages[i].msg)
                        ],
                      ))
                ])
              ],
            ),
          ),
        ),
      );

      foundDevices.add(cardDevice);
    }

    return Column(children: [
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
          child: Container(
            color: AppColors.backgroundSecondColor,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Selecciona un dispositivo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Toque uno para conectarse',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: _buildListViewOfDevices()),
                      ],
                    ),
                  ),
                ),
                if (widget.connectedDeviceList.isNotEmpty)
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Dispositivo conectado',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Toque dos veces para desconectarse',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.30,
                              child: _buildListViewOfConnectedDevices()),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  void getBLECharacteristics() {
    for (BluetoothService service in _services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          widget.connectedWriteCharacteristic = characteristic;
        } else if (characteristic.properties.notify) {
          widget.connectedNotifyCharacteristic = characteristic;
          widget.connectedNotifyCharacteristic?.setNotifyValue(true);
          //Asignamos accion al ser notificado
          _notifySubscription = widget
              .connectedNotifyCharacteristic?.lastValueStream
              .listen((value) {
            if (value.isNotEmpty) {
              //print('notify: ');
              _manageMessagesReceived(value);
            }
          });
        }
      }
    }
  }

  Future<void> sendWifiCredentialsByBluetooth() async {
    BleWriteData wifiData = BleWriteData(
        subject: 'wifi-credentials',
        ssid: _ssidController.text,
        password: _passWifiController.text);

    /// SEND THE MESSAGE VIA BLUETOOTH
    await widget.connectedWriteCharacteristic!
        .write(utf8.encode(jsonEncode(wifiData.toJson())));
  }

  void _showWiFiFormDialog(BuildContext context, BleItem item) {
    //final dialogContext = context;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
              builder: (statefulContext, setStateInsideDialog) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(statefulContext)!.animation!,
                  curve: Curves.easeInOut,
                ),
              ),
              child: AlertDialog(
                title: const Text("Credenciales WiFi"),
                content: Form(
                  key: _formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Text(
                        "Ingresa las credenciales para conectar el dispositivo a internet."),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _ssidController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese el nombre';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      cursorColor: AppColors.primaryColor,
                      style: const TextStyle(
                        color: AppColors.textColor,
                      ),
                      decoration: WidgetCustomProperties.customInputDecoration(
                          hintText: "Nombre de la red WiFi"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passWifiController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingrese la contraseña';
                        }
                        return null;
                      },
                      cursorColor: AppColors.primaryColor,
                      style: const TextStyle(
                        color: AppColors.textColor,
                      ),
                      obscureText: !_obscurePasswordWifi,
                      decoration:
                          WidgetCustomProperties.customPasswordInputDecoration(
                        gestureDetector: GestureDetector(
                          onTap: () {
                            setStateInsideDialog(
                              () {
                                _obscurePasswordWifi = !_obscurePasswordWifi;
                              },
                            );
                          },
                          child: Icon(
                              _obscurePasswordWifi
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ]),
                ),
                actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(statefulContext).pop();
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: AppColors.primaryColor),
                      )),
                  ElevatedButton(
                    onPressed: () async {
                      // ignore: use_build_context_synchronously
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(statefulContext).pop();
                        await _connectBleDevice(item);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor),
                    child: const Text(
                      "Conectar",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  void _manageMessagesReceived(List<int> value) {
    String jsonStr = utf8.decode(value);
    Map<String, dynamic> jsonData = json.decode(jsonStr);

    BleNotifyData bleNotifyData = BleNotifyData(
      success: jsonData['success'],
      msg: jsonData['msg'],
    );

    setState(() {
      if (_receivedMessages.length < 3) {
        _receivedMessages.add(bleNotifyData);
      }
    });

    if (_receivedMessages.length == 3) {
      int countFails = 0;
      for (var msg in _receivedMessages) {
        if (msg.success == false) countFails += 1;
      }

      if (countFails == 3) {
        Future.delayed(const Duration(seconds: 3));
        _disconnectBleDevice(null);
      }
    }
  }

  _disconnectBleDevice(BleItem? item) {
    //Eliminamos los servicios
    _services = [];

    //Desconectamos el actual dispostivo si existe
    item?.device.disconnect(timeout: 3);
    _connectedDevice?.disconnect(timeout: 3);
    _connectedDevice = null;

    //Cancelamos la suscripcion del characteristics
    _notifySubscription?.cancel();
    _notifySubscription = null;
    widget.connectedNotifyCharacteristic = null;
    widget.connectedWriteCharacteristic = null;

    FlutterBluePlus.startScan();
  }

  Future<void> sendDogUUIDbyBluetooth() async {
    BleWriteData dogUuidData = BleWriteData(
      subject: 'dog-id',
      uuid: _dogId,
    );

    await widget.connectedWriteCharacteristic!
        .write(utf8.encode(jsonEncode(dogUuidData.toJson())));
  }

  Future<void> _connectBleDevice(BleItem item) async {
    try {
      //_disconnectBleDevice(null);
      await item.device.connect(autoConnect: false);
    } on PlatformException catch (e) {
      if (e.code != 'already_connected') {
        rethrow;
      }
    } finally {
      _services = await item.device.discoverServices();
      FlutterBluePlus.stopScan();

      setState(() {
        item.isTouched = true;
      });

      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _connectedDevice = item.device;
      });
      widget.connectedDeviceList.add(item);
      getBLECharacteristics();
      await sendWifiCredentialsByBluetooth();
      await sendDogUUIDbyBluetooth();

      setState(() {
        _receivedMessages.clear();
      });

      _passWifiController.text = "";
    }
  }

  void _showInformationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content:
                const Text("Solo puedes conectarte a un dispositivo a la vez"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                child: const Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  void _showDisconnectDialog(BuildContext context, BleItem item) {
    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content: const Text("¿Desea desconectarse del dispositivo?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: AppColors.primaryColor),
                  )),
              ElevatedButton(
                onPressed: () async {
                  // ignore: use_build_context_synchronously
                  Navigator.of(dialogContext).pop();
                  await _disconnectBleDevice(item);
                  setState(() {
                    widget.connectedDeviceList.remove(item);
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor),
                child: const Text(
                  "Sí",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }
}
