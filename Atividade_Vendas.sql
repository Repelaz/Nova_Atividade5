
/* 1 - Altere a tabela de débitos para corrigir o campo situacao_debito. Se o débito estiver
vencido e não for 'Negociado' nem 'Pago', informe 'Atrasado'. */

UPDATE DEBITOS d 
	SET d.SITUACAO_DEBITO = 'Atrasado'
   WHERE d.DATAVENCIMENTO < CURRENT_DATE
  AND d.SITUACAO_DEBITO  NOT IN ('Negociado', 'Pago')
  
  
/* 2 - Altere a tabela de débitos para corrigir o campo situacao_debito.
Se o débito não estiver vencido e não for 'Pago', informe 'Pendente' */
  
UPDATE DEBITOS d 
	SET d.SITUACAO_DEBITO = 'Pendente'
   WHERE d.DATAVENCIMENTO > CURRENT_DATE
   AND d.SITUACAO_DEBITO NOT IN ('Pago')
 

/* 3 - Altere a tabela débitos para corrigir o campo data de vencimento, Se o débito
estiver com a situação  'Negociado', altere o ano da data de vencimento para ano -5 anos. */

UPDATE DEBITOS d 
	SET d.DATAVENCIMENTO = DATEADD(-5 YEAR TO DATAVENCIMENTO) 
   WHERE d.SITUACAO_DEBITO  NOT IN ('Negociado')

/* 4 - Selecione o nome, e-mail, e telefone de todas as pessoas. */

SELECT p.NOME, p.EMAIL, p.TELEFONE
	FROM PESSOA p
	

/* 5 - Liste os produtos com preço unitárito acima de R$ 100. */
	
SELECT p.NOME, p.PRECO_UNITARIO 
FROM PRODUTO p 
WHERE p.PRECO_UNITARIO > 100 


/* 6 - Retorne todas as vendas realizadas em uma determinada data. */

SELECT *
	FROM VENDA v 
   WHERE v.DATA_VENDA = '2022-11-14' 
   
   
/* 7 - Mostre o nome, a data de nascimento e a idade dos fornecedores que não têm produtos em estoque */

SELECT p.NOME, p.DATA_NASCIMENTO 
	FROM FORNECEDOR f
   LEFT JOIN PESSOA p ON p.ID_PESSOA = f.ID_PESSOA


/* 8 - Liste os clientes que já realizaram compras com débitos vencidos. */
   
SELECT d.situacao_debito
	FROM DEBITOS d
   WHERE d.SITUACAO_DEBITO = 'Vencido'
 
  
/* 11 - Atualize o preço unitário de todos os produtos com estoque inferior
a 10 unidades para mais 10% */
   
UPDATE PRODUTO p
	SET p.PRECO_UNITARIO = p.PRECO_UNITARIO + p.PRECO_UNITARIO * 0.10
   WHERE p.QUANTIDADE_ESTOQUE < 10
   
   
/* 10 - Selecione os 10 maiores devedores trazendo código, nome, idade
e a soma total dos débitos vencidos e a soma total dos débitos pagos */
  
SELECT FIRST 10 CLIENTE.ID_CLIENTE, PESSOA.NOME, 
EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM PESSOA.DATA_NASCIMENTO) AS IDADE, COALESCE((
SELECT SUM(DEBITOS.VALOR_TOTAL) FROM DEBITOS
	WHERE DEBITOS.ID_CLIENTE = CLIENTE.ID_CLIENTE
		AND DEBITOS.DATAVENCIMENTO < CURRENT_DATE
		AND DEBITOS.SITUACAO_DEBITO IN ('Atrasado', 'Pendente')),0) AS DEBITO_PENDENTE, (SELECT SUM(DEBITOS.VALOR_TOTAL) FROM DEBITOS
	WHERE DEBITOS.ID_CLIENTE = CLIENTE.ID_CLIENTE
		AND SITUACAO_DEBITO = 'Pago') AS DEBITO_PAGO FROM PESSOA
			INNER JOIN CLIENTE ON CLIENTE.ID_PESSOA = PESSOA.ID_PESSOA
ORDER BY 4 DESC
   

/* 13 - Altere todos os débitos que estão com situação = 'Atrasado' para 'Pagos'
se o mesmo ter o resgistro na tabela de pagamento */
  
UPDATE DEBITOS d 
	  SET d.SITUACAO_DEBITO = 'Pagos'
		WHERE d.SITUACAO_DEBITO = 'Atrasado'


/* 15 - Selecione as vendas entre o mês de dezembro de 2023 até janeiro de 2024 */
		
SELECT v.DATA_VENDA
	FROM VENDA v 
      WHERE v.DATA_VENDA BETWEEN '2023-12-01' AND '2024-01-31'


/* 16 - Liste os produtos com estoque entre 5 e 20 unidades */
      
SELECT p.*
	FROM PRODUTO p
	  WHERE p.QUANTIDADE_ESTOQUE BETWEEN 5 AND 20
      

/* 17 - Retorne todas as pessoas com nomes que começam com 'A' */
	  
SELECT p.*
	FROM PESSOA p
	  WHERE p.NOME LIKE 'A%'
	  

/* 18 - Selecione os produtos que não foram vendidos */
	  
SELECT p.*
	FROM PRODUTO p 
		LEFT JOIN ITENSVENDA i ON p.ID_PRODUTO = i.ID_VENDA 
			WHERE i.ID_VENDA IS NULL 


/* 19 - Liste os produtos vendidos para os clientes 'Carla Souza', 'Larrisa Fereira' */
		
SELECT v.*
	FROM VENDA v 
		INNER JOIN PESSOA p ON p.ID_PESSOA = v.ID_PESSOA 
			WHERE p.NOME IN ('Carla Souza', 'Larissa Ferreira')
					
		
/* 20 - Mostre as pessoas que são clientes OU fornwcedores */

SELECT p.*
	FROM PESSOA p
		WHERE p.ID_PESSOA IN (SELECT ID_PESSOA FROM CLIENTE c WHERE c.id_pessoa IS NOT NULL) OR 
			p.ID_PESSOA  IN (SELECT ID_PESSOA FROM FORNECEDOR f WHERE f.id_pessoa IS NOT NULL)

			
/* 21 - Retorne todas as informações da venda com detalhes do cliente e forma de pagamento */

SELECT v.ID_VENDA, p.NOME, p.EMAIL, v.VALOR_TOTAL, fp.ID_FORMA_PAGAMENTO 
	FROM VENDA v
		INNER JOIN PESSOA p ON v.ID_PESSOA = p.ID_PESSOA
		INNER JOIN FORMA_PAGAMENTO fp ON v.ID_FORMA_PAGAMENTO = fp.ID_FORMA_PAGAMENTO
	ORDER BY 2


/* 22 - Mostre todas as compras de um determinado produto
('Placa de Captura'), incluindo detalhes do produto */

SELECT P.NOME, P.DESCRICAO, P.PRECO_UNITARIO, V.DATA_VENDA, V.VALOR_TOTAL, I.QUANTIDADE
     FROM ITENSVENDA i
     INNER JOIN Produto p ON p.ID_PRODUTO = i.ID_PRODUTO
     INNER JOIN VENDA v ON v.ID_VENDA = i.ID_VENDA
    WHERE p.NOME = 'Placa de Captura'


/* 23 - Combine os nomes dos fornecedores com os nomes dos clientes
e suas respectivas idades que irão fazer no ano de 2025 */

SELECT p.NOME, (CURRENT_DATE - p.DATA_NASCIMENTO) / 365 + 1 idade2025 
	FROM PESSOA p 
		WHERE p.ID_PESSOA IN (SELECT ID_PESSOA FROM CLIENTE c WHERE c.id_pessoa IS NOT NULL) OR 
			p.ID_PESSOA  IN (SELECT ID_PESSOA FROM FORNECEDOR f WHERE f.id_pessoa IS NOT NULL)

			
/* 24 - Retorne todos os logradouros e bairros, indicando se pertencem ou não a uma pessoa */
			
SELECT  b.ID_BAIRRO, b.NOME, l.ID_LOGRADOURO, l.NOME, p.EMAIL, p.NOME 
	FROM ENDERECO e 
		INNER JOIN LOGRADOURO l ON e.ID_LOGRADOURO = l.ID_LOGRADOURO 
		INNER JOIN BAIRRO b ON e.ID_BAIRRO = b.ID_BAIRRO
		INNER JOIN PESSOA p ON e.ID_PESSOA = p.ID_PESSOA 
		ORDER BY 2, 4, 6
		
		
/* 25 - Selecione os produtos que têm preço unitário superior à média */
		
SELECT p.ID_PRODUTO, p.NOME, p.PRECO_UNITARIO
	FROM PRODUTO p 
		WHERE p.PRECO_UNITARIO > (SELECT AVG(p.PRECO_UNITARIO) FROM PRODUTO p)

		
/* 26 - Liste os clientes que fizeram compras em cidades com mais de 1 milhão de habitantes */

SELECT p.NOME, m.ID_MUNICIPIO, m.NOME, m.UF, m.POPULACAO
      FROM ENDERECO e
      INNER JOIN PESSOA p ON p.ID_PESSOA = e.ID_PESSOA
      INNER JOIN MUNICIPIO m ON m.ID_MUNICIPIO = e.ID_MUNICIPIO
     WHERE m.populacao > 1000000
ORDER BY 1


/* 27 - Mostre a quantidade total de produtos vendidos por fornecedor */

SELECT f.id_fornecedor, p2.nome, SUM(i.quantidade) AS total_vendido
	FROM FORNECEDOR f 
		INNER JOIN PESSOA p2 ON f.ID_PESSOA = p2.ID_PESSOA 
		INNER JOIN PRODUTO p ON f.ID_FORNECEDOR = p.ID_FORNECEDOR 
		INNER JOIN ITENSVENDA i ON p.ID_PRODUTO = i.ID_PRODUTO 
GROUP BY f.ID_FORNECEDOR, p2.NOME
ORDER BY 2


/* 28 - Liste os clientes que realizaram compras com valor superior a R$ 500 */

SELECT p.nome, hc.valor_total
	FROM HISTORICO_COMPRAS_CLIENTE hc
		INNER JOIN CLIENTE c ON hc.ID_CLIENTE = c.ID_CLIENTE
		INNER JOIN PESSOA p ON c.ID_PESSOA = p.ID_PESSOA 
WHERE hc.valor_total > 500


/* 29 - Retorne todas as pessoas com seus endereços de correspondência
a residência, se tiverem */

SELECT p.nome AS pessoa, b.nome AS bairro, m.nome AS municipio, l.nome AS rua
	FROM ENDERECO e 
		INNER JOIN PESSOA p ON p.ID_PESSOA = e.ID_PESSOA 
		INNER JOIN LOGRADOURO l ON e.ID_LOGRADOURO = l.ID_LOGRADOURO 
		INNER JOIN MUNICIPIO m ON e.ID_MUNICIPIO = m.ID_MUNICIPIO 
		INNER JOIN BAIRRO b ON e.ID_BAIRRO = b.ID_BAIRRO 
ORDER BY 1, 2, 3, 4

		
/* 30 - Liste os produtos e seus preços, juntamente com o nome do fornecedor,
mesmo que não tenham fornecedor */

SELECT p.nome, p.preco_unitario, p2.nome AS FORNCECEDOR
	FROM PRODUTO p 
		INNER JOIN FORNECEDOR f ON p.ID_FORNECEDOR = f.ID_FORNECEDOR 
		INNER JOIN PESSOA p2 ON f.ID_PESSOA = p2.ID_PESSOA 
ORDER BY 1, 3

		
/* 31 - Liste os produtos em ordem decrescente de quantidade em estoque */

SELECT p.nome, p.quantidade_estoque
	FROM PRODUTO p 
ORDER BY QUANTIDADE_ESTOQUE DESC 


/* 32 - Retorne as vendas em ordem crescente em valor total */

SELECT v.ID_VENDA, v.VALOR_TOTAL 
	FROM VENDA v 
ORDER BY v.VALOR_TOTAL ASC 	


/* 33 - Liste os produtos com quantidade em estoque menor que a média de todos os produtos */

SELECT p.*
	FROM PRODUTO p 
		WHERE p.QUANTIDADE_ESTOQUE > (SELECT AVG(p.QUANTIDADE_ESTOQUE) FROM PRODUTO p)

/* 34 - Selecione todas as pessoas cujo número de telefone seja igual ao de outra pessoa */

SELECT p1.nome AS pessoa1, p2.nome AS pessoa2, p1.telefone
	FROM PESSOA p1
		INNER JOIN PESSOA p2 ON p1.telefone = p2.TELEFONE
			WHERE p1.id_pessoa <> p2.ID_PESSOA 
ORDER BY 1


/* 35 - Aumente em 10% o preço unitário de todos os produtos fornecidos
por fornecedores de São Paulo */

UPDATE PRODUTO p
	SET p.PRECO_UNITARIO = p.PRECO_UNITARIO + p.PRECO_UNITARIO * 0.10
	WHERE p.ID_FORNECEDOR IN (SELECT f.id_fornecedor FROM FORNECEDOR f
		INNER JOIN PESSOA pe ON f.id_pessoa = pe.id_pessoa
		INNER JOIN ENDERECO e ON pe.id_pessoa = e.id_pessoa
		INNER JOIN MUNICIPIO m ON e.id_municipio = m.id_municipio
	WHERE m.nome = 'São Paulo')


/* 36 - Liste todas as vendas que estão com débito 'Negociado' */

SELECT p.nome, d.situacao_debito
	FROM DEBITOS d 
		INNER JOIN CLIENTE c ON c.ID_CLIENTE = d.ID_CLIENTE 
		INNER JOIN PESSOA p ON p.ID_PESSOA = c.ID_PESSOA 
	WHERE d.SITUACAO_DEBITO = ('Negociado')















