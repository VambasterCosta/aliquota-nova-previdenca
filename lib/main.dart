import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController rendaControler = TextEditingController();

  String _infoText = "Informe sua renda";
  String _percet = "";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetFild() {
    rendaControler.text = "";
    setState(() {
      _infoText = "Informe sua renda";
      _percet ="";
    });
  }

  double _calcularValorIntegraldaFaixa(double renda, double faixa) {
    return renda * faixa / 100;
  }

  double _calcularValorParcialdaFaixa(
      double renda, double limite, double faixa) {
    return (renda - limite) * faixa / 100;
  }

  void _calcular() {
    setState(() {
      double renda = double.parse(rendaControler.text);
      double contrib = 0.0;
      double descPrev = 0.0;
      if (renda <= 998) {
        contrib = _calcularValorIntegraldaFaixa(renda, 7.5);
      } else {
        contrib += _calcularValorIntegraldaFaixa(
            998, 7.5); //faixa de 0 até 998 integralmente
        if (renda > 2000) {
          contrib += _calcularValorIntegraldaFaixa(
              1001.99, 9.0); // faixa integral de 998 até 2000
          if (renda > 3000) {
            contrib += _calcularValorIntegraldaFaixa(
                999.99, 12.0); //faixa integral de 2.000 ate 3.000
            if (renda > 5839.45) {
              contrib += _calcularValorIntegraldaFaixa(
                  2839.44, 14.0); // faixa integral de 3000 até 5839.45
              if (renda > 10000) {
                contrib += _calcularValorIntegraldaFaixa(
                    4160.54, 14.5); // faixa integral de 3000 até 5839.45
                if (renda > 20000) {
                  contrib += _calcularValorIntegraldaFaixa(9999.99, 16.5);
                  if (renda > 39000) {
                    contrib += _calcularValorIntegraldaFaixa(18999.99, 19);
                    contrib += _calcularValorParcialdaFaixa(renda, 39000, 22);
                  } else {
                    contrib += _calcularValorParcialdaFaixa(renda, 20000, 19);
                  }
                } else {
                  contrib += _calcularValorParcialdaFaixa(renda, 10000, 16.5);
                }
              } else {
                contrib += _calcularValorParcialdaFaixa(renda, 5839.45, 14.5);
              }
            } else {
              contrib += _calcularValorParcialdaFaixa(renda, 3000.0, 14.0);
            }
          } else {
            contrib += _calcularValorParcialdaFaixa(renda, 2000.0, 12.0);
          }
        } else {
          contrib += _calcularValorParcialdaFaixa(renda, 998.0, 9);
        }
      }

      print(contrib);
      descPrev = contrib / renda * 100;
      _infoText ="R\$(${contrib.toString().substring(0,contrib.toString().indexOf('.',0)+3)})";
      _percet = "Desc. Prev: ${descPrev.toString().substring(0,descPrev.toString().indexOf('.',0)+2)}%";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora de Aliquota"),
          centerTitle: true,
          backgroundColor: Colors.white30,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFild,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Text("%",style: TextStyle(color: Colors.blueGrey, fontSize: 120.0),textAlign: TextAlign.center,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Renda (R\$)",
                        labelStyle: TextStyle(color: Colors.blueGrey)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 25.0),
                    controller: rendaControler,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "O Valor é requerido";
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _calcular();
                          }
                        },
                        child: Text(
                          "Calcular",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Text(
                    _infoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                  ),
                  Text(
                    _percet,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 25.0),
                  )
                ],
              )),
        ));
  }
}
