/// Hierarquia de erros do Modo Mercado.
sealed class AppError implements Exception {
  const AppError();

  String get mensagem;
  String? get sugestao => null;

  @override
  String toString() => 'AppError: $mensagem';
}

// --- Validação ---

class CampoObrigatorioAusenteError extends AppError {
  final String campo;
  const CampoObrigatorioAusenteError(this.campo);

  @override
  String get mensagem => 'O campo "$campo" é obrigatório.';

  @override
  String? get sugestao => 'Preencha o campo "$campo" antes de continuar.';
}

class ValorInvalidoError extends AppError {
  final String campo;
  final String motivo;
  const ValorInvalidoError(this.campo, this.motivo);

  @override
  String get mensagem => 'Valor inválido no campo "$campo": $motivo.';
}

class ProdutoSemPrecoError extends AppError {
  final String nomeProduto;
  const ProdutoSemPrecoError(this.nomeProduto);

  @override
  String get mensagem =>
      'O produto "$nomeProduto" não pode ser adicionado pois não possui preço registrado.';

  @override
  String? get sugestao => 'Registre um preço para "$nomeProduto" antes de adicioná-lo à lista.';
}

// --- Persistência ---

class FalhaAoSalvarError extends AppError {
  final String entidade;
  final Object causa;
  const FalhaAoSalvarError(this.entidade, this.causa);

  @override
  String get mensagem => 'Falha ao salvar $entidade.';

  @override
  String? get sugestao => 'Tente novamente. Se o problema persistir, reinicie o aplicativo.';
}

class FalhaAoLerError extends AppError {
  final String entidade;
  final Object causa;
  const FalhaAoLerError(this.entidade, this.causa);

  @override
  String get mensagem => 'Falha ao carregar $entidade.';
}

class FalhaAoExcluirError extends AppError {
  final String entidade;
  final Object causa;
  const FalhaAoExcluirError(this.entidade, this.causa);

  @override
  String get mensagem => 'Falha ao excluir $entidade.';
}

class DadosCorrempidosError extends AppError {
  const DadosCorrempidosError();

  @override
  String get mensagem => 'Os dados do aplicativo estão corrompidos.';

  @override
  String? get sugestao => 'O aplicativo será iniciado com dados vazios.';
}

// --- Negócio ---

class ProdutoPossuiRegistrosError extends AppError {
  final String nomeProduto;
  const ProdutoPossuiRegistrosError(this.nomeProduto);

  @override
  String get mensagem =>
      'O produto "$nomeProduto" possui registros de preço vinculados.';

  @override
  String? get sugestao =>
      'Ao excluir o produto, todos os registros vinculados também serão removidos.';
}

class ListaVaziaError extends AppError {
  const ListaVaziaError();

  @override
  String get mensagem => 'A lista de compras está vazia.';
}
