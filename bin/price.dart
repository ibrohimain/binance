import 'dart:convert';
import 'dart:io';
import 'dart:async';

void main() async {
  final socket = await WebSocket.connect('wss://stream.binance.com:9443/ws/btcusdt@trade');
  String? latestPrice;
  int? previousIntPrice;

  Timer.periodic(Duration(seconds: 5), (_) {
    if (latestPrice != null) {
      final priceIntPart = int.tryParse(latestPrice!.split('.')[0]) ?? 0;

      final fiveDigit = priceIntPart.toString().padLeft(5, '0').substring(0, 5);

      String direction = '';
      if (previousIntPrice != null) {
        if (priceIntPart > previousIntPrice!) {
          direction = '↑'; 
        } else if (priceIntPart < previousIntPrice!) {
          direction = '↓'; 
        } else {
          direction = '→';
        }
      }
  
      previousIntPrice = priceIntPart;

      final now = DateTime.now().toLocal().toIso8601String();
      print("[$now] BTC: $fiveDigit $direction");
    }
  });

  socket.listen((data) {
    final jsonData = jsonDecode(data);
    latestPrice = jsonData['p'];
  }, onError: (error) {
    print("Xatolik: $error");
  }, onDone: () {
    print("Ulanish yopildi.");
  });
}
