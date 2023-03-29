import 'package:flutter/material.dart';
import 'model/responsewatertank.dart';

// ignore: must_be_immutable
class WaterTankWidget extends StatelessWidget {
  ResponseWaterTank resp = ResponseWaterTank();

  WaterTankWidget({super.key, resp}) {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Column(
        children: <Widget>[
          Text("Capacidade Total : ${resp.totalCapacityByLiter} litro"),
          Text("Capacidade Atual : ${resp.currentCapacityByLiter} litro"),
          Text("Capacidade Total : ${resp.totalCapacityByMeter} metro"),
          Text("Capacidade Atual : ${resp.currentCapacityByMeter} metro"),
          Text("Data Envada : ${resp.sent.toString()}"),
          Image.asset(getStatusGraphWaterTank(resp.currentCapacityByLiter))
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
