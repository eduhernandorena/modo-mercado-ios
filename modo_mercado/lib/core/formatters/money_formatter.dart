import '../domain/errors/app_error.dart';

/// Converte valores monetários entre centavos (int) e strings formatadas.
///
/// Usa centavos (int) para evitar imprecisão de ponto flutuante.
/// Exemplo: 1250 centavos → "R$ 12,50"
class MoneyFormatter {
  const MoneyFormatter();

  /// Formata centavos para string de exibição.
  /// Exemplo: 1250 → "R$ 12,50"
  String format(int centavos) {
    final reais = centavos ~/ 100;
    final centavosResto = centavos.abs() % 100;
    return 'R\$ ${reais.toString()},${centavosResto.toString().padLeft(2, '0')}';
  }

  /// Faz parse do input do usuário para centavos.
  /// Aceita: "12,50", "12.50", "1250", "R$ 12,50"
  /// Lança [ValorInvalidoError] se o input for inválido ou não-positivo.
  int parse(String input) {
    // Remove prefixo "R$" e espaços
    var cleaned = input.replaceAll('R\$', '').replaceAll(' ', '').trim();

    // Normaliza separador decimal: troca vírgula por ponto
    // Mas só se houver vírgula como separador decimal (ex: "12,50")
    // Caso contrário, remove pontos de milhar (ex: "1.250,00")
    if (cleaned.contains(',')) {
      // Formato brasileiro: "1.250,50" ou "12,50"
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    }

    final valor = double.tryParse(cleaned);

    if (valor == null) {
      throw const ValorInvalidoError('valor', 'não é um número válido');
    }

    if (valor <= 0) {
      throw const ValorInvalidoError('valor', 'deve ser maior que zero');
    }

    return (valor * 100).round();
  }
}
