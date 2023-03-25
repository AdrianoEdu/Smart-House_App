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
          Text("Capacidade Total : ${resp.totalCapacityByLiter} metro"),
          Text("Capacidade Atual : ${resp.currentCapacityByLiter}"),
          Text("Data Envada : ${resp.sent.toString()}")
        ],
      ),
    );
  }
}
