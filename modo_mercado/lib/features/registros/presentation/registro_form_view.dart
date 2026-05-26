import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/domain/models/produto.dart';
import '../../../core/formatters/money_formatter.dart';
import 'registro_notifier.dart';

class RegistroFormView extends ConsumerStatefulWidget {
  final Produto? produtoPreSelecionado;
  const RegistroFormView({super.key, this.produtoPreSelecionado});

  @override
  ConsumerState<RegistroFormView> createState() => _RegistroFormViewState();
}

class _RegistroFormViewState extends ConsumerState<RegistroFormView> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();
  final _formatter = const MoneyFormatter();
  String? _mercadoIdSelecionado;
  DateTime _data = DateTime.now();
  String? _valorErro;

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _data = picked);
  }

  Future<void> _criarMercado() async {
    final controller = TextEditingController();
    final nome = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Novo Mercado'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome do mercado'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Criar'),
          ),
        ],
      ),
    );
    if (nome != null && nome.trim().isNotEmpty) {
      final id = await ref.read(registroNotifierProvider.notifier).criarMercado(nome);
      setState(() => _mercadoIdSelecionado = id);
    }
  }

  Future<void> _salvar() async {
    setState(() => _valorErro = null);
    if (!_formKey.currentState!.validate()) return;
    if (_mercadoIdSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um mercado')),
      );
      return;
    }
    int valorCentavos;
    try {
      valorCentavos = _formatter.parse(_valorController.text);
    } catch (e) {
      setState(() => _valorErro = 'Valor inválido. Use o formato: 12,50');
      return;
    }
    final produto = widget.produtoPreSelecionado;
    if (produto == null) return;
    final ok = await ref.read(registroNotifierProvider.notifier).registrar(
      produtoId: produto.id,
      mercadoId: _mercadoIdSelecionado!,
      valorCentavos: valorCentavos,
      data: _data,
    );
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registroNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Preço')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.produtoPreSelecionado != null)
              ListTile(
                title: const Text('Produto'),
                subtitle: Text(widget.produtoPreSelecionado!.nome),
                tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor (R\$) *',
                errorText: _valorErro,
                prefixText: 'R\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _mercadoIdSelecionado,
              decoration: const InputDecoration(labelText: 'Mercado *'),
              items: state.mercados
                  .map((m) => DropdownMenuItem(value: m.id, child: Text(m.nome)))
                  .toList(),
              onChanged: (v) => setState(() => _mercadoIdSelecionado = v),
            ),
            TextButton.icon(
              onPressed: _criarMercado,
              icon: const Icon(Icons.add),
              label: const Text('Novo mercado'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Data'),
              subtitle: Text('${_data.day}/${_data.month}/${_data.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selecionarData,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: state.isLoading ? null : _salvar,
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
