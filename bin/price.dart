import 'dart:convert';
import "package:http/http.dart" as http;

Future<void> getBitcoinPrice() async {
  final url = Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd');

  final responnse = await http.get(url);

  if (responnse.statusCode == 200) {
    final data = jsonDecode(responnse.body);
    final price = data['bitcoin']['usd'];
    print("1 Bitcoin narxi: \$${price}");
  } else {
    print("Xatolik yuz berdi: ${responnse.statusCode}");
  }
}

void main(List<String> args) {
  getBitcoinPrice();
}
