import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

void main() {
  runApp(
    MaterialApp(
      home: const Home(),
    )
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("HTTP Request"),
        ),
        body: Body(),
      ),
    );
  }
}
class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  TextEditingController _controller = TextEditingController();

  final url = "https://api.hgbrasil.com/finance/quotations?key=5b3e6b86";
  double dolar = 0;

  Future<double> pegarCotacaoDolar()async {
    http.Response request = await http.get(Uri.parse(url));
    if(request.body.isNotEmpty){
      return (json.decode(request.body)["results"]["currencies"]["USD"]["buy"]);
    }
    else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _controller,
            decoration: InputDecoration(
                label: Text("Insira o valor em reais que deseja converter")
            ),
          ),
          ElevatedButton(
              onPressed: (){
                double real = 0;
                  pegarCotacaoDolar().then((value){
                    String text = _controller.text;
                    if(text.isNotEmpty) {
                    real = double.parse(text);
                  }
                  setState(() {
                      dolar = real / value;
                    });
                  });
              },
              child: Text("Carregar")),
          SizedBox(height: 80,),
          Text("Preço em dólar: USD ${dolar.toStringAsFixed(2)}", style: TextStyle(fontSize: 20))
        ],
      ),
    );
  }
}

