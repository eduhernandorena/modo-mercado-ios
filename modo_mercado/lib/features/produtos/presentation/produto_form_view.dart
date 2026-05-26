import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/errors/app_error.dart';
import '../../../core/domain/models/produto.dart';
import 'produtos_notifier.dart';

class ProdutoFormView extends ConsumerStatefulWidget {
  final Produto? produto;
  const ProdutoFormView({super.key, this.produto});

  @override
  ConsumerState<ProdutoFormView> createState() => _ProdutoFormViewState();
}

class _ProdutoFormViewState extends ConsumerState<ProdutoFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nome;
  late final TextEditingController _categoria;
  late final TextEditingController _unidade;
  late final TextEditingController _marca;
  late final TextEditingController _quantidade;
  late final TextEditingController _observacao;

  bool get _editando => widget.produto != null;

  @override
  void initState() {
    super.initState();
    final p = widget.produto;
    _nome = TextEditingController(text: p?.nome ?? '');
    _categoria = TextEditingController(text: p?.categoria ?? '');
    _unidade = TextEditingController(text: p?.unidade ?? '');
    _marca = TextEditingController(text: p?.marca ?? '');
    _quantidade = TextEditingController(
        text: p?.quantidade?.toString() ?? '');
    _observacao = TextEditingController(text: p?.observacao ?? '');
  }

  @override
  void dispose() {
    _nome.dispose(); _categoria.dispose(); _unidade.dispose();
    _marca.dispose(); _quantidade.dispose(); _observacao.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(produtosNotifierProvider.notifier);
    bool ok;
    if (_editando) {
      ok = await notifier.editar(widget.produto!.copyWith(
        nome: _nome.text.trim(),
        categoria: _categoria.text.trim(),
        unidade: _unidade.text.trim(),
        marca: _marca.text.trim().isEmpty ? null : _marca.text.trim(),
        quantidade: double.tryParse(_quantidade.text),
        observacao: _observacao.text.trim().isEmpty ? null : _observacao.text.trim(),
      ));
    } else {
      ok = await notifier.cadastrar(
        nome: _nome.text.trim(),
        categoria: _categoria.text.trim(),
        unidade: _unidade.text.trim(),
        marca: _marca.text.trim().isEmpty ? null : _marca.text.trim(),
        quantidade: double.tryParse(_quantidade.text),
        observacao: _observacao.text.trim().isEmpty ? null : _observacao.text.trim(),
      );
    }
    if (ok && mounted) Navigator.of(context).pop();
  }

  Future<void> _excluir() async {
    final produto = widget.produto!;
    final notifier = ref.read(produtosNotifierProvider.notifier);
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text(
            'Excluir "${produto.nome}"? Todos os registros vinculados também serão removidos.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await notifier.excluir(produto.id, produto.nome);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (e is ProdutoPossuiRegistrosError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.mensagem)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar Produto' : 'Novo Produto'),
        actions: _editando
            ? [IconButton(icon: const Icon(Icons.delete), onPressed: _excluir)]
            : null,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nome,
              decoration: const InputDecoration(labelText: 'Nome *'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoria,
              decoration: const InputDecoration(labelText: 'Categoria *'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _unidade,
              decoration: const InputDecoration(labelText: 'Unidade *'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _marca, decoration: const InputDecoration(labelText: 'Marca')),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantidade,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _observacao, decoration: const InputDecoration(labelText: 'Observação'), maxLines: 3),
            const SizedBox(height: 24),
            FilledButton(onPressed: _salvar, child: Text(_editando ? 'Salvar' : 'Cadastrar')),
          ],
        ),
      ),
    );
  }
}
