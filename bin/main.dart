import 'dart:convert';
import 'dart:io';
import 'dart:async';

List chart = ["⠇", "⠇", "⠇", "⠇", "⠇", "⠇"];
void main() async {
  final socket =
      await WebSocket.connect('wss://stream.binance.com:9443/ws/btcusdt@trade');
  String? latestPrice;
  int? previousIntPrice;

  Timer.periodic(Duration(seconds: 5), (_) {
    if (latestPrice != null) {
      final priceIntPart = int.tryParse(latestPrice!.split('.')[0]) ?? 0;

      final fiveDigit = priceIntPart.toString().padLeft(5, '0').substring(0, 5);
      bool narxTushsa = false;
      bool narxKotar = false;
      // List chart = ["⠇", "⠇", "⠇", "⠇", "⠇", "⠇"];
      if (previousIntPrice != null) {
        if (priceIntPart > previousIntPrice!) {
          narxKotar = true;
          chart.add("⠇");
        } else if (priceIntPart < previousIntPrice!) {
          chart.remove("⠇");
          narxTushsa = true;
        } else {}
      }
      final now = DateTime.now().toLocal().toIso8601String();
      String chartingString = chart.join("");
      previousIntPrice = priceIntPart;
      if (narxKotar) {
        print("[$now] BTC: $fiveDigit \x1B[32m$chartingString\x1B[0m");
      } else if (narxTushsa) {
        print("[$now] BTC: $fiveDigit \x1B[31m$chartingString\x1B[0m");
      } else {
        print("[$now] BTC: $fiveDigit $chartingString");
      }
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