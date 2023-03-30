import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import 'package:smarthouseapp/model/responsewatertank.dart';
import 'dart:convert';

import 'WaterTankWidget.dart';
import 'local_notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

ResponseWaterTank responseWaterTank = ResponseWaterTank();

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final client = MqttServerClient.withPort("test.mosquitto.org", "", 1883);
  double totalByLiter = 0;
  double currentByLiter = 0;
  double totalByMeter = 0;
  double currentByMeter = 0;
  String date = "";

  var pongCount = 0;

  @override
  void initState() {
    super.initState();

    ///Initialize notification component
    LocalNotification.initialize(flutterLocalNotificationsPlugin);

    ///Connect mqtt client
    WidgetsBinding.instance.addPostFrameCallback((_) => _connect());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          child: WaterTankWidget(
            totalByLiter: totalByLiter,
            totalByMeter: totalByMeter,
            currentByLitter: currentByLiter,
            currentByMeter: currentByMeter,
            date: date,
          ),
        ),
      ),
    );
  }

  _connect() async {
    ///Configuring mqtt client
    client.logging(on: true);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.connectTimeoutPeriod = 2000; // milliseconds
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);

    print('EXAMPLE::Mosquitto client connecting....');

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      /// Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      /// Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    print('EXAMPLE::Subscribing to the wokwi-iot-simulator-dm120/test');
    const topic = 'project/water/tank/response';
    client.subscribe(topic, MqttQos.atMostOnce);

    ///Listener used to capture messages
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');

      Map responsePayload = json.decode(pt);
      print(responsePayload);

      ///Update values received from mqtt server
      setState(() {
        totalByLiter =
            double.parse(responsePayload["TotalCapacityByLiter"].toString());
        currentByLiter =
            double.parse(responsePayload["CurrentCapacityByLiter"].toString());
        totalByMeter =
            double.parse(responsePayload["TotalCapacityByMeter"].toString());
        currentByMeter = double.parse(
            responsePayload["CurrentTotalCapacityByMeter"].toString());
        date = responsePayload["Sent"].toString();
      });

      ///Show notification after receiving message
      LocalNotification.showBigTextNotification(
          title: "Reponse Water Tank Alert",
          body: "Status of water tank",
          fln: flutterLocalNotificationsPlugin);
    });

    return 0;
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
    if (pongCount == 3) {
      print('EXAMPLE:: Pong count is correct');
    } else {
      print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
    }
  }

  /// The successful connect callback
  void onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }

  /// Pong callback
  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
    pongCount++;
  }
}
