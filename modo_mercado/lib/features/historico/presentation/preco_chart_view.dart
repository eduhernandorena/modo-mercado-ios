import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/domain/models/registro_de_preco.dart';
import '../../../core/formatters/money_formatter.dart';

class PrecoChartView extends StatelessWidget {
  final List<RegistroDePreco> registros;
  const PrecoChartView({super.key, required this.registros});

  @override
  Widget build(BuildContext context) {
    if (registros.isEmpty) return const SizedBox.shrink();

    const formatter = MoneyFormatter();
    // Ordenar por data crescente para o gráfico
    final ordenados = List<RegistroDePreco>.from(registros)
      ..sort((a, b) => a.data.compareTo(b.data));

    final spots = ordenados.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.valorCentavos / 100.0);
    }).toList();

    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  getTitlesWidget: (value, _) => Text(
                    formatter.format((value * 100).round()),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final idx = value.toInt();
                    if (idx < 0 || idx >= ordenados.length) return const SizedBox.shrink();
                    final d = ordenados[idx].data;
                    return Text('${d.day}/${d.month}', style: const TextStyle(fontSize: 9));
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: false,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 2,
                dotData: FlDotData(show: registros.length == 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
