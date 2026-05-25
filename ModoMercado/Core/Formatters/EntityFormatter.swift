import Foundation
import SwiftData

/// Responsável por serializar e desserializar dados entre os modelos de domínio (value types)
/// e as entidades SwiftData (reference types).
///
/// SwiftData não suporta `Decimal` nativamente. Toda conversão monetária usa `NSDecimalNumber`
/// para preservar precisão durante a serialização `Decimal` ↔ `Double`.
///
/// Valida: Requisitos 7.4, 7.5, 7.6, 3.10, 3.11
struct EntityFormatter {

    // MARK: - Produto

    /// Converte uma `ProdutoEntity` (SwiftData) para o modelo de domínio `Produto`.
    func toDomain(_ entity: ProdutoEntity) -> Produto {
        Produto(
            id: entity.id,
            nome: entity.nome,
            categoria: entity.categoria,
            unidade: entity.unidade,
            marca: entity.marca,
            quantidade: entity.quantidade,
            observacao: entity.observacao,
            criadoEm: entity.criadoEm,
            atualizadoEm: entity.atualizadoEm
        )
    }

    /// Converte um modelo de domínio `Produto` para uma `ProdutoEntity` (SwiftData).
    /// Insere a entidade no `ModelContext` fornecido.
    func toEntity(_ produto: Produto, context: ModelContext) -> ProdutoEntity {
        let entity = ProdutoEntity(
            id: produto.id,
            nome: produto.nome,
            categoria: produto.categoria,
            unidade: produto.unidade,
            marca: produto.marca,
            quantidade: produto.quantidade,
            observacao: produto.observacao,
            criadoEm: produto.criadoEm,
            atualizadoEm: produto.atualizadoEm
        )
        context.insert(entity)
        return entity
    }

    // MARK: - RegistroDePreco

    /// Converte uma `RegistroEntity` (SwiftData) para o modelo de domínio `RegistroDePreco`.
    /// O campo `valor` é armazenado como `Double` na entidade e convertido para `Decimal`
    /// via `NSDecimalNumber` para preservar precisão monetária.
    func toDomain(_ entity: RegistroEntity) -> RegistroDePreco {
        let valor = NSDecimalNumber(value: entity.valor).decimalValue
        return RegistroDePreco(
            id: entity.id,
            produtoId: entity.produtoId,
            mercadoId: entity.mercadoId,
            valor: valor,
            data: entity.data,
            fotoPath: entity.fotoPath,
            criadoEm: entity.criadoEm
        )
    }

    /// Converte um modelo de domínio `RegistroDePreco` para uma `RegistroEntity` (SwiftData).
    /// O campo `valor` é convertido de `Decimal` para `Double` via `NSDecimalNumber`.
    /// Insere a entidade no `ModelContext` fornecido.
    func toEntity(_ registro: RegistroDePreco, context: ModelContext) -> RegistroEntity {
        let valorDouble = NSDecimalNumber(decimal: registro.valor).doubleValue
        let entity = RegistroEntity(
            id: registro.id,
            produtoId: registro.produtoId,
            mercadoId: registro.mercadoId,
            valor: valorDouble,
            data: registro.data,
            fotoPath: registro.fotoPath,
            criadoEm: registro.criadoEm
        )
        context.insert(entity)
        return entity
    }

    // MARK: - Mercado

    /// Converte uma `MercadoEntity` (SwiftData) para o modelo de domínio `Mercado`.
    func toDomain(_ entity: MercadoEntity) -> Mercado {
        Mercado(
            id: entity.id,
            nome: entity.nome,
            criadoEm: entity.criadoEm
        )
    }

    /// Converte um modelo de domínio `Mercado` para uma `MercadoEntity` (SwiftData).
    /// Insere a entidade no `ModelContext` fornecido.
    func toEntity(_ mercado: Mercado, context: ModelContext) -> MercadoEntity {
        let entity = MercadoEntity(
            id: mercado.id,
            nome: mercado.nome,
            criadoEm: mercado.criadoEm
        )
        context.insert(entity)
        return entity
    }

    // MARK: - ListaDeCompras

    /// Converte uma `ListaEntity` (SwiftData) para o modelo de domínio `ListaDeCompras`.
    /// Converte recursivamente cada `ItemEntity` associado.
    func toDomain(_ entity: ListaEntity) -> ListaDeCompras {
        let itens = entity.itens.map { toDomain($0) }
        return ListaDeCompras(
            id: entity.id,
            nome: entity.nome,
            itens: itens,
            criadoEm: entity.criadoEm,
            atualizadoEm: entity.atualizadoEm
        )
    }

    /// Converte um modelo de domínio `ListaDeCompras` para uma `ListaEntity` (SwiftData).
    /// Converte recursivamente cada `ItemDeLista` e associa ao `ListaEntity`.
    /// Insere todas as entidades no `ModelContext` fornecido.
    func toEntity(_ lista: ListaDeCompras, context: ModelContext) -> ListaEntity {
        let listaEntity = ListaEntity(
            id: lista.id,
            nome: lista.nome,
            criadoEm: lista.criadoEm,
            atualizadoEm: lista.atualizadoEm
        )
        context.insert(listaEntity)

        let itemEntities = lista.itens.map { item -> ItemEntity in
            let itemEntity = toEntity(item, context: context)
            itemEntity.lista = listaEntity
            return itemEntity
        }
        listaEntity.itens = itemEntities

        return listaEntity
    }

    // MARK: - ItemDeLista

    /// Converte uma `ItemEntity` (SwiftData) para o modelo de domínio `ItemDeLista`.
    /// O campo `ultimoPrecoRegistrado` é armazenado como `Double?` na entidade e convertido
    /// para `Decimal?` via `NSDecimalNumber` para preservar precisão monetária.
    func toDomain(_ entity: ItemEntity) -> ItemDeLista {
        let ultimoPreco: Decimal? = entity.ultimoPrecoRegistrado.map {
            NSDecimalNumber(value: $0).decimalValue
        }
        return ItemDeLista(
            id: entity.id,
            produtoId: entity.produtoId,
            quantidade: entity.quantidade,
            concluido: entity.concluido,
            ultimoPrecoRegistrado: ultimoPreco
        )
    }

    /// Converte um modelo de domínio `ItemDeLista` para uma `ItemEntity` (SwiftData).
    /// O campo `ultimoPrecoRegistrado` é convertido de `Decimal?` para `Double?` via `NSDecimalNumber`.
    /// Insere a entidade no `ModelContext` fornecido.
    func toEntity(_ item: ItemDeLista, context: ModelContext) -> ItemEntity {
        let ultimoPrecoDouble: Double? = item.ultimoPrecoRegistrado.map {
            NSDecimalNumber(decimal: $0).doubleValue
        }
        let entity = ItemEntity(
            id: item.id,
            produtoId: item.produtoId,
            quantidade: item.quantidade,
            concluido: item.concluido,
            ultimoPrecoRegistrado: ultimoPrecoDouble
        )
        context.insert(entity)
        return entity
    }
}
