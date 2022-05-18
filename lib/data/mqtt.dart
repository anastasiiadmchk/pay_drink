import 'dart:async';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart'
    if (dart.library.html) 'package:mqtt_client/mqtt_browser_client.dart';

class Mqtt {
  MqttClient? _client;
  String topic = '';
  String? _deviceId;
  final String uuid;
  Completer<bool> _connectionCompleater = Completer();
  Completer<bool> _subscriptionToTopicCompleter = Completer();

  Mqtt(
      {
      // Unique userId in the mobileApp
      required this.uuid,
      String? phoneNumber,
      // Unique device ID
      required String deviceId,
      required String productId}) {
    _deviceId = deviceId;
    topic += '$_deviceId';
    topic += '/$productId';

    _client = MqttServerClient.withPort('pay-drink.cloud.shiftr.io', uuid, 1883,
        maxConnectionAttempts: 20);

    // }
    print('connecting....');
    _client?.websocketProtocols = ['websockets', 'mqtt'];
    // _client?.useWebSocket = true;
    // _client?.port = 1883;
    // _client?.websocketProtocols = ['mqtt'];

    /// Set the correct MQTT protocol for mosquito
    _client?.setProtocolV311();
    _client?.keepAlivePeriod = 200;
    _client?.logging(on: false);
    _client?.onDisconnected = _onDisconnected;
    _client?.onConnected = _onConnected;
    _client?.onSubscribed = _onSubscribed;
  }

  Stream<dynamic>? connect() async* {
    //'kyiv_city/device-01/beverages/QpgLEYEbHdcGfAgcLTni'
    print('TOPIC');
    print(topic);

    final connMess = MqttConnectMessage()
        .withClientIdentifier(uuid)
        .withWillTopic(
            'connection-check') // If you set this you must set a will message
        .withWillMessage('Init connection check')
        .startClean() // Non persistent session for testing
        .authenticateAs("pay-drink", "S6Ys9VJWrzHsVpYt")
        .withWillQos(MqttQos.atMostOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    // BlocProvider.instance.vmConnectionBloc.setLoading(true);
    try {
      _client?.connectionMessage = connMess;

      /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
      /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
      /// never send malformed messages.

      MqttClientConnectionStatus? status = await _client?.connect();
      yield status;
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      // BlocProvider.instance.vmConnectionBloc.setLoading(false);
      _client?.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      // BlocProvider.instance.vmConnectionBloc.setLoading(false);
      _client?.disconnect();
    }

    /// Check we are connected
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');

      // final builder = MqttClientPayloadBuilder();
      // builder.addString(data);
      print('EXAMPLE::Publishing our topic');
      // _client?.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
      _client?.subscribe(topic, MqttQos.atMostOnce);
      yield _client?.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        /// The above may seem a little convoluted for users only interested in the
        /// payload, some users however may be interested in the received publish message,
        /// lets not constrain ourselves yet until the package has been in the wild
        /// for a while.
        /// The payload is a byte buffer, this will be specific to the topic
        // BlocProvider.instance.vmConnectionBloc.setLoading(false);
        print(
            'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
        print('');
      });
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client?.connectionStatus}');
      _client?.disconnect();
      // exit(-1);
    }
  }

  void publishMessage(String message) async {
    /// Use the payload builder rather than a raw buffer
    /// Our known topic to publish to
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (_client?.connectionStatus!.state == MqttConnectionState.connected) {
      /// Publish it
      print('EXAMPLE::Publishing our topic');
      _client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${_client?.connectionStatus}');
    }
  }

  /// The subscribed callback
  void _onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

// /// The unsolicited disconnect callback
  void _onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client?.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      // exit(255);
    }
  }

// /// The successful connect callback
  void _onConnected() {
    print(
        'EXAMPLE::OnConnected client callback - Client connection was successful');
  }
}
