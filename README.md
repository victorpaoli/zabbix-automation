# 🚀 **Automatizando o Zabbix em Container com Shell Script** 🐳

Este **script shell** automatiza a instalação do **Zabbix** dentro de um **container Docker**, facilitando a criação e configuração do ambiente. Ele segue os passos abaixo:

### O que o Script Faz:
1. **Instala o Docker** 🐳
2. Cria o diretório conforme a **documentação padrão** 🗂️
3. Gera o arquivo **docker-compose.yaml** 📜
4. **Configuração Dinâmica:** Você precisará preencher campos no arquivo `docker-compose.yaml` para que ele funcione corretamente no seu ambiente:
   - **DB_SERVER_HOST**: IP ou DNS do seu servidor Zabbix.
   - **ZBX_PASSIVESERVERS**: IP ou DNS de servidores passivos do Zabbix.

### 💡 Dicas:
- Salve o script com o nome de sua escolha, mas **sempre com a extensão `.sh`** (ex: `zabbix.sh`).
- Não se esqueça de dar permissão de execução ao script após criá-lo.


### Criar o script

Abra o terminal e crie o script com o comando abaixo:

```bash
nano zabbix.sh
```

### 2. Conceder permissões de execução

Após salvar o arquivo, conceda permissões de execução com o comando:
```bash
chmod +x zabbix.sh
```
### Executar o script

Após conceder as permissões, execute o script com o seguinte comando:

```bash
./zabbix.sh
