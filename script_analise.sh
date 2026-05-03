#!/bin/bash

# ============================================================
# SCRIPT DE MENU INTERATIVO PARA ANÁLISE DE LOGS
# ============================================================
# Este script apresenta um menu com 10 opções voltadas para
# análise de arquivos de log em ambiente Linux.
#
# O usuário pode selecionar uma opção digitando o número
# correspondente para executar consultas, filtros ou inspeções
# nos logs do sistema.
#
# FUNCIONAMENTO:
# - Escolha de 1 a 10: executa rotinas de análise de logs
# - Opção 0: encerra o script imediatamente
# - Qualquer outro valor: retorna Opção inválida
#
# Após executar uma opção:
# - Pressione ENTER para voltar ao menu
# - Pressione q para sair do script
#
# Estrutura baseada em:
# - Loop contínuo (while)
# - Controle de fluxo com case (equivalente ao switch)
#
# OBJETIVO:
# Facilitar a análise rápida de logs, permitindo identificar
# eventos como erros, acessos, falhas e padrões relevantes.
# ============================================================

log="$1"

clear
while true; do

	echo "============== Menu =============="
	echo ""
	echo "1 - Detectar possíveis ataques de XSS (Cross-Site Scripting)"
	echo "2 - Detectar tentativas de SQL Injection"
	echo "3 - Detectar varredura de diretórios (Directory Traversal)"
	echo "4 - Detectar possíveis ataques por scanners (User-Agent suspeito)"
	echo "5 - Identificar tentativas de acesso a arquivos sensíveis (.env, .git, etc.)"
	echo "6 - Detectar possíveis ataques de força bruta a arquivos/pastas"
	echo "7 - Primeiro e ultimo acesso de um IP suspeito."
	echo "8 - Localizar user-agent utilizado por um IP suspeito"
	echo "9 - Listar os ips e verificar o numero de requisições"
	echo "10 - Localizar acesso a um determinado arquivo sensível"
	echo "0 - SAIR"
	echo ""
	read -p "Escolha uma opção: " op
	echo ""

	case "$op" in

		1)
			clear
			echo "Executando opção 1"
			echo "XSS (Cross-Site Scripting)"
			echo ""
			result=$(grep -iE "<script|%3Cscript" "$log")
			echo "$result"
			echo "Total: $(echo "$result" | wc -l)"
			;;

		2)
			clear
			echo "Executando opção 2"
			echo "SQL Injection"
			echo ""
			result=$(grep -iE "union|select|insert|drop|%27|%22" "$log")
			echo "$result"
			echo "Total: $(echo "$result" |wc -l)"
			;;

		3)
			clear
			echo "Executando opção 3"
			echo "Directory Traversal"
			echo ""
			result=$(grep -E "\.\./|\.\.%2f" "$log")
			echo "$result"
			echo "Total: $(echo "$result" | wc -l)"
			;;

		4)
			clear
			echo "Executando opção 4"
			echo "Scanner (User-Agent suspeito)"
			echo ""
			result=$(grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python" "$log")
			echo "$result"
			echo "Total: $(echo "$result" | wc -l)"
			;;

		5)
			clear
			echo "Executando opção 5"
			echo "Arquivos sensíveis"
			echo ""
			result=$(grep -iE "\.env|\.git|\.htaccess|\.bak" "$log")
			echo "$result"
			echo "Total: $(echo "$result" | wc -l)"
			;;
		6)
			clear
			echo "Executando opção 6"
			echo "Força bruta / enumeração (404)"
			echo ""
			result=$(grep "404" "$log" | cut -d " " -f1 | sort | uniq -c | sort -nr | head)
			echo -e "TOTAL\tIP"
			echo "$result"
			echo "Total: $(echo "$result" | wc -l)"
			;;
		7)
			clear
			echo "Executando opção 7"
			echo "Primeiro e último acesso (IP)"
			echo ""
			read -p "Digite o IP Suspeito: " ip
			result=$(grep "$ip" "$log" | head -n1; grep "$ip" "$log" | tail -n1)
			echo "$result"
			;;
		8)
			clear
			echo "Executando opção 8"
			echo "User-Agent (IP)"
			echo ""
			read -p "Digite o IP Suspeito: " ip
			grep "$ip" "$log" | cut -d '"' -f6 | sort | uniq
			;;
		9)
			clear
			echo "Executando opção 9"
			echo "Volume de requisições por IP"
			echo ""
			cat "$log" | cut -d " " -f1 | sort | uniq -c
			;;
		10)
			clear
			echo "Executando opção 10"
			echo "Acesso a arquivo específico"
			echo ""
			read -p "Digite o Arquivo para Análise: " arqsens
			result=$(grep -i "$arqsens" "$log")
			echo "$result"
			echo "Total: $(echo "$result" | wc -l)"
			;;
		0)
			clear
			break
			;;
		*)
			clear
			echo "Opção inválida"
			echo ""
			continue
			;;
	esac

	echo ""
	read -n 1 -s -p "[ENTER] Continuar | [q] Sair: " tec
	echo ""
	[[ "$tec" == "q" ]] && break

	clear
done
clear
