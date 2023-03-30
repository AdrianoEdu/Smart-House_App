import 'package:flutter/material.dart';
import 'model/responsewatertank.dart';

class WaterTankWidget extends StatelessWidget {
  final double totalByLiter;
  final double currentByLitter;
  final double totalByMeter;
  final double currentByMeter;
  final String date;

  WaterTankWidget(
      {super.key,
      this.totalByLiter = 0.0,
      this.currentByLitter = 0.0,
      this.totalByMeter = 0.0,
      this.currentByMeter = 0.0,
      this.date = "2023/03/29"});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: <Widget>[
          Text("Capacidade Total : $totalByLiter litro"),
          Text("Capacidade Atual : $currentByLitter litro"),
          Text("Capacidade Total : $totalByMeter metro"),
          Text("Capacidade Atual : $currentByLitter metro"),
          Text("Data Envada : $date"),
          Image.asset(getStatusGraphWaterTank(currentByLitter))
        ],
      ),
    );
  }

  String getStatusGraphWaterTank(double status) {
    switch (status.toString()) {
      case "100.0":
        return "images/Caixa1.png";
      case "200.0":
        return "images/Caixa2.png";
      case "300.0":
        return "images/Caixa3.png";
      case "400.0":
        return "images/Caixa4.png";
      case "500.0":
        return "images/Caixa5.png";
      case "600.0":
        return "images/Caixa6.png";
      case "700.0":
        return "images/Caixa7.png";
      case "800.0":
        return "images/Caixa8.png";
      case "900.0":
        return "images/Caixa9.png";
      case "1000.0":
        return "images/Caixa10.png";
      default:
        return "images/Caixa0.png";
    }
  }
}
