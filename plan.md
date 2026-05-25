# Modo Mercado
## Documento Base do Projeto

Versão: MVP 1.0  
Autor: Eduardo  
Plataforma: Mobile  
Tecnologia sugerida: Flutter + Spring Boot

---

# Visão Geral

O Modo Mercado é um aplicativo mobile focado em ajudar usuários a economizar dinheiro e acompanhar a evolução dos preços de produtos do dia a dia.

O app permite registrar produtos através de:
- foto de etiquetas
- código de barras
- cupom fiscal
- entrada manual

Com isso, o sistema cria:
- histórico de preços
- comparação entre mercados
- análise de inflação pessoal
- alertas inteligentes
- lista de compras inteligente

---

# Problema

Os consumidores atualmente:
- não conseguem acompanhar preços reais
- caem em promoções falsas
- não percebem aumentos graduais
- esquecem preços antigos
- gastam mais do que imaginam

Além disso:
- aplicativos atuais são complexos
- dependem de bancos
- não focam no comportamento de compra

---

# Objetivo

Criar um aplicativo simples, rápido e inteligente que transforme compras comuns em dados úteis para economia doméstica.

---

# Público-Alvo

- Famílias
- Universitários
- Pessoas organizadas financeiramente
- Consumidores afetados pela inflação
- Pequenos comerciantes
- Pessoas que fazem compras recorrentes

---

# Diferenciais

## Simplicidade
Poucos cliques para registrar preços.

## Inteligência Local
Criação de base de preços regionais.

## Histórico Real
O usuário acompanha quanto cada produto custava anteriormente.

## Economia Inteligente
Detecção de promoções falsas e hábitos de compra.

---

# Funcionalidades do MVP

# 1. Cadastro de Produto

Campos:
- nome
- categoria
- marca
- quantidade
- unidade
- observação

---

# 2. Registro de Preço

Campos:
- produto
- valor
- mercado
- data
- foto opcional

---

# 3. Histórico de Preços

Exibir:
- menor preço
- maior preço
- média
- evolução temporal

---

# 4. Lista de Compras

Funções:
- adicionar itens
- marcar concluídos
- estimativa de total
- agrupamento por categoria

---

# 5. Dashboard

Mostrar:
- gasto mensal
- categorias mais caras
- produtos com maior aumento
- economia estimada

---

# 6. Comparação Entre Mercados

Exemplo:

Arroz 5kg

Mercado A: R$ 29,90
Mercado B: R$ 32,50
Mercado C: R$ 27,99

---

# Funcionalidades Futuras

## OCR
Leitura automática de:
- etiquetas
- cupons
- notas fiscais

## Código de Barras
Identificação automática de produtos.

## IA de Consumo
Análise de hábitos financeiros.

## Alertas Inteligentes
Exemplos:
- produto em promoção
- preço acima da média
- aumento repentino

## Comunidade
Compartilhamento de preços entre usuários.

## Geolocalização
Mercados próximos e promoções locais.

---

# Estrutura Técnica

# Frontend

Tecnologia:
- Flutter

Arquitetura sugerida:
- feature-first
- clean architecture
- provider ou riverpod

---

# Backend

Tecnologia:
- Spring Boot
- Java 21

Arquitetura:
- REST API
- Clean Architecture

---

# Banco de Dados

Sugestão inicial:
- PostgreSQL

---

# Roadmap

# Fase 1 - MVP
- cadastro manual
- histórico de preços
- dashboard
- lista de compras

---

# Fase 2
- OCR
- código de barras
- alertas
- gráficos avançados

---

# Fase 3
- IA de comportamento
- recomendações
- comparação colaborativa

---

# Monetização

## Gratuito
- funcionalidades básicas

## Premium
- alertas inteligentes
- histórico ilimitado
- sincronização familiar
- IA de economia

---

# Slogan

"Entenda seus preços. Economize de verdade."
