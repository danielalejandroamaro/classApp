import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lab/common/extensions.dart';
import 'package:lab/services/http_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// import 'package:lab/components/service_tile.dart';
import '../common/constants.dart';
import './service_tile.dart';

class BazaarMessage {
  final int? id;
  final int? bazaar_id;
  final int? user_id;
  final Map<String, dynamic>? description;
  final String? sended_at;

  final String text;

  const BazaarMessage(
      {this.id,
      this.bazaar_id,
      this.user_id,
      this.description,
      this.sended_at,
      required this.text});

  factory BazaarMessage.fromJSON(String stringData) {
    var data = jsonDecode(stringData);
    BazaarMessage bazaarMessage;

    try {
      return BazaarMessage(
          id: data['id'],
          bazaar_id: data["bazaar_id"],
          user_id: data["user_id"],
          description: data["description"],
          sended_at: data["sended_at"],
          text: stringData);
    } catch (_) {
      return BazaarMessage(text: stringData);
    }
  }
}

class DetailsView extends StatefulWidget {
  final double price;
  final String? text;

  const DetailsView({super.key, required this.price, this.text});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late WebSocketChannel channel;
  final List<BazaarMessage> messages = [];
  final StreamController<String> messageStream = StreamController<String>();
  final _httpService = HttpService();

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final wsUrl = '${R.urls.wsUrlBase}/bazaar/ws'
        .toUri(qParams: {"token": _httpService.token});

    channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen(addMessage);
  }

  void addMessage(message) {
    messages.add(BazaarMessage.fromJSON(message));
    messageStream.sink.add(message);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ServiceTitle(
              price: widget.price,
              text: widget.text,
              noNavigate: true,
            ),
            Expanded(
                child: ListView(children: [
              StreamBuilder(
                stream: messageStream.stream,
                builder: (context, snapShot) {
                  List<Widget> children = [];
                  for (var message in messages) {
                    children.add(Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(message.description != null
                          ? message.description.toString()
                          : message.text),
                    ));
                  }
                  return Column(children: children);
                },
              )
            ])),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(label: Text("new price")),
                  ),
                )),
                IconButton(onPressed: sendData, icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }

  void sendData() {
    if (_controller.text.isNotEmpty) {
      channel.sink
          .add(json.encode({"message": _controller.text, "bazaar_id": 1}));
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
