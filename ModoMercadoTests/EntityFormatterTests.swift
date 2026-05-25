// Feature: modo-mercado-ios, Property 1: Round-trip de serialização de entidades
//
// Valida: Requisitos 3.10, 3.11, 7.4, 7.5, 7.6
//
// Verifica que toDomain(toEntity(x)) == x para todas as entidades de domínio:
// Produto, RegistroDePreco, Mercado, ItemDeLista e ListaDeCompras.

import XCTest
import SwiftData
import SwiftCheck
@testable import ModoMercado

// MARK: - Helpers de Precisão

/// Trunca uma `Date` para precisão de milissegundos, compatível com a precisão
/// de armazenamento do SwiftData.
private func truncarParaMilissegundos(_ date: Date) -> Date {
    let ms = (date.timeIntervalSinceReferenceDate * 1000).rounded() / 1000
    return Date(timeIntervalSinceReferenceDate: ms)
}

/// Converte um `Double` para `Decimal` via `NSDecimalNumber`, simulando exatamente
/// a conversão que o `EntityFormatter` realiza ao desserializar do SwiftData.
private func doubleParaDecimal(_ value: Double) -> Decimal {
    NSDecimalNumber(value: value).decimalValue
}

/// Converte um `Decimal` para `Double` e de volta para `Decimal`, simulando o
/// round-trip completo de serialização monetária do `EntityFormatter`.
private func roundTripDecimal(_ value: Decimal) -> Decimal {
    let asDouble = NSDecimalNumber(decimal: value).doubleValue
    return NSDecimalNumber(value: asDouble).decimalValue
}

// MARK: - Geradores Arbitrários

/// Gera strings não-vazias com caracteres alfanuméricos e espaços.
private let genString: Gen<String> = Gen<String>.fromElements(of: Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "))
    .proliferateNonEmpty
    .map { String($0) }

/// Gera strings opcionais (nil ou string não-vazia).
private let genStringOpcional: Gen<String?> = Gen<String?>.one(of: [
    Gen.pure(nil),
    genString.map { Optional($0) }
])

/// Gera UUIDs aleatórios.
private let genUUID: Gen<UUID> = Gen<UUID>.compose { _ in UUID() }

/// Gera Dates com precisão de milissegundos dentro de um intervalo razoável (últimos 10 anos).
private let genDate: Gen<Date> = Double.arbitrary
    .suchThat { $0.isFinite && !$0.isNaN }
    .map { offset in
        let base = Date(timeIntervalSinceReferenceDate: 0)
        let intervalo = abs(offset).truncatingRemainder(dividingBy: 315_360_000) // 10 anos em segundos
        return truncarParaMilissegundos(base.addingTimeInterval(intervalo))
    }

/// Gera valores `Double` positivos finitos adequados para preços monetários.
/// Restringe a valores que sobrevivem ao round-trip Decimal ↔ Double sem perda.
private let genValorMonetario: Gen<Double> = Double.arbitrary
    .suchThat { $0 > 0 && $0.isFinite && !$0.isNaN && $0 < 1_000_000 }

/// Gera valores `Double?` opcionais para preços.
private let genValorMonetarioOpcional: Gen<Double?> = Gen<Double?>.one(of: [
    Gen.pure(nil),
    genValorMonetario.map { Optional($0) }
])

/// Gera valores `Double` positivos para quantidades.
private let genQuantidade: Gen<Double> = Double.arbitrary
    .suchThat { $0 > 0 && $0.isFinite && !$0.isNaN && $0 < 10_000 }

// MARK: - Instâncias Arbitrárias dos Modelos de Domínio

extension Produto: Arbitrary {
    public static var arbitrary: Gen<Produto> {
        Gen<Produto>.compose { c in
            Produto(
                id: c.generate(using: genUUID),
                nome: c.generate(using: genString),
                categoria: c.generate(using: genString),
                unidade: c.generate(using: genString),
                marca: c.generate(using: genStringOpcional),
                quantidade: c.generate(using: genQuantidade.map { Optional($0) }),
                observacao: c.generate(using: genStringOpcional),
                criadoEm: c.generate(using: genDate),
                atualizadoEm: c.generate(using: genDate)
            )
        }
    }
}

extension RegistroDePreco: Arbitrary {
    public static var arbitrary: Gen<RegistroDePreco> {
        Gen<RegistroDePreco>.compose { c in
            let valorDouble = c.generate(using: genValorMonetario)
            // Usa o valor que sobrevive ao round-trip Double → Decimal → Double
            let valor = doubleParaDecimal(valorDouble)
            return RegistroDePreco(
                id: c.generate(using: genUUID),
                produtoId: c.generate(using: genUUID),
                mercadoId: c.generate(using: genUUID),
                valor: valor,
                data: c.generate(using: genDate),
                fotoPath: c.generate(using: genStringOpcional),
                criadoEm: c.generate(using: genDate)
            )
        }
    }
}

extension Mercado: Arbitrary {
    public static var arbitrary: Gen<Mercado> {
        Gen<Mercado>.compose { c in
            Mercado(
                id: c.generate(using: genUUID),
                nome: c.generate(using: genString),
                criadoEm: c.generate(using: genDate)
            )
        }
    }
}

extension ItemDeLista: Arbitrary {
    public static var arbitrary: Gen<ItemDeLista> {
        Gen<ItemDeLista>.compose { c in
            let ultimoPrecoDouble = c.generate(using: genValorMonetarioOpcional)
            let ultimoPreco: Decimal? = ultimoPrecoDouble.map { doubleParaDecimal($0) }
            return ItemDeLista(
                id: c.generate(using: genUUID),
                produtoId: c.generate(using: genUUID),
                quantidade: c.generate(using: genQuantidade),
                concluido: c.generate(using: Bool.arbitrary),
                ultimoPrecoRegistrado: ultimoPreco
            )
        }
    }
}

extension ListaDeCompras: Arbitrary {
    public static var arbitrary: Gen<ListaDeCompras> {
        Gen<ListaDeCompras>.compose { c in
            // Gera entre 0 e 5 itens para manter os testes rápidos
            let numItens = c.generate(using: Gen<Int>.choose((0, 5)))
            let itens = (0..<numItens).map { _ in c.generate(using: ItemDeLista.arbitrary) }
            return ListaDeCompras(
                id: c.generate(using: genUUID),
                nome: c.generate(using: genString),
                itens: itens,
                criadoEm: c.generate(using: genDate),
                atualizadoEm: c.generate(using: genDate)
            )
        }
    }
}

// MARK: - Testes de Propriedade

final class EntityFormatterTests: XCTestCase {

    private var container: ModelContainer!
    private var context: ModelContext!
    private let formatter = EntityFormatter()

    override func setUpWithError() throws {
        try super.setUpWithError()
        container = try ModelContainer(
            for: PersistenceController.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        context = ModelContext(container)
    }

    override func tearDownWithError() throws {
        context = nil
        container = nil
        try super.tearDownWithError()
    }

    // MARK: - Property 1: Round-trip de serialização de entidades

    /// Verifica que toDomain(toEntity(produto)) == produto para qualquer Produto válido.
    ///
    /// **Validates: Requirements 3.10, 3.11, 7.4, 7.5, 7.6**
    func testRoundTripSerializacaoProduto() {
        // Feature: modo-mercado-ios, Property 1: Round-trip de serialização de entidades
        property("Round-trip de serialização preserva todos os campos de Produto") <- forAll { (produto: Produto) in
            let entity = self.formatter.toEntity(produto, context: self.context)
            let resultado = self.formatter.toDomain(entity)
            return resultado == produto
        }
    }

    /// Verifica que toDomain(toEntity(registro)) == registro para qualquer RegistroDePreco válido.
    ///
    /// **Validates: Requirements 3.10, 3.11, 7.4, 7.5, 7.6**
    func testRoundTripSerializacaoRegistroDePreco() {
        // Feature: modo-mercado-ios, Property 1: Round-trip de serialização de entidades
        property("Round-trip de serialização preserva todos os campos de RegistroDePreco") <- forAll { (registro: RegistroDePreco) in
            let entity = self.formatter.toEntity(registro, context: self.context)
            let resultado = self.formatter.toDomain(entity)
            return resultado == registro
        }
    }

    /// Verifica que toDomain(toEntity(mercado)) == mercado para qualquer Mercado válido.
    ///
    /// **Validates: Requirements 7.4, 7.5, 7.6**
    func testRoundTripSerializacaoMercado() {
        // Feature: modo-mercado-ios, Property 1: Round-trip de serialização de entidades
        property("Round-trip de serialização preserva todos os campos de Mercado") <- forAll { (mercado: Mercado) in
            let entity = self.formatter.toEntity(mercado, context: self.context)
            let resultado = self.formatter.toDomain(entity)
            return resultado == mercado
        }
    }

    /// Verifica que toDomain(toEntity(item)) == item para qualquer ItemDeLista válido.
    ///
    /// **Validates: Requirements 7.4, 7.5, 7.6**
    func testRoundTripSerializacaoItemDeLista() {
        // Feature: modo-mercado-ios, Property 1: Round-trip de serialização de entidades
        property("Round-trip de serialização preserva todos os campos de ItemDeLista") <- forAll { (item: ItemDeLista) in
            let entity = self.formatter.toEntity(item, context: self.context)
            let resultado = self.formatter.toDomain(entity)
            return resultado == item
        }
    }

    /// Verifica que toDomain(toEntity(lista)) == lista para qualquer ListaDeCompras válida,
    /// incluindo seus itens aninhados.
    ///
    /// **Validates: Requirements 7.4, 7.5, 7.6**
    func testRoundTripSerializacaoListaDeCompras() {
        // Feature: modo-mercado-ios, Property 1: Round-trip de serialização de entidades
        property("Round-trip de serialização preserva todos os campos de ListaDeCompras e seus itens") <- forAll { (lista: ListaDeCompras) in
            let entity = self.formatter.toEntity(lista, context: self.context)
            let resultado = self.formatter.toDomain(entity)
            // Compara id, nome, datas e itens individualmente para diagnóstico mais claro
            guard resultado.id == lista.id else { return false }
            guard resultado.nome == lista.nome else { return false }
            guard resultado.criadoEm == lista.criadoEm else { return false }
            guard resultado.atualizadoEm == lista.atualizadoEm else { return false }
            guard resultado.itens.count == lista.itens.count else { return false }
            // Verifica cada item preservando a ordem
            for (itemResultado, itemOriginal) in zip(resultado.itens, lista.itens) {
                guard itemResultado == itemOriginal else { return false }
            }
            return true
        }
    }
}
