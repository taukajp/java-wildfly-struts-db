# メモ

## PostgreSQL

ホスト名: `db-postgres`、データベース: `myappdb`、ユーザ: `docker`（パスワードなし）で作成。

### コマンド

データベース接続。

```shell
$ psql -h db-postgres -U docker myappdb
myappdb=>
```

コマンド一覧。

```shell
myappdb=> \?
```

接続先切り替え。

```shell
myappdb=> \c データベース名 [ユーザ]
```

データベース一覧。

```shell
myappdb=> \l
```

ユーザ（ロール）一覧。

```shell
myappdb=> \du
```

テーブル一覧。

```shell
myappdb=> \d
```

テーブル定義確認。

```shell
myappdb=> \d テーブル名
```

## 管理画面

[http://localhost:9990](http://localhost:9990)にアクセス。id: `myadmin`、password: `P@ssw0rd`。

管理CLIを使う場合

```sh
$ ./[jboss.home.dir]/jboss.home.dir>/bin/jboss-cli.sh
```

### JDBCドライバーのmodule登録

`[jboss.home.dir]/modules/system/layers/base/`に`org/postgresql/main`ディレクトリを作成する。

```sh
$ cd [jboss.home.dir]/modules/system/layers/base
$ mkdir -p org/postgresql/main
```

作成したディレクトリに、JDBCドライバー`postgresql-42.6.0.jar`と`module.xml`を配置する。`module.xml`は以下を記述する。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<module name="org.postgresql" xmlns="urn:jboss:module:1.9">
    <resources>
        <resource-root path="postgresql-42.6.0.jar"/>
    </resources>
    <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
    </dependencies>
</module>
```

### JDBCドライバーとデータソースの登録

`[jboss.home.dir]/standalone/configuration/standalone.xml`を以下の通り編集する。

```xml
<subsystem xmlns="urn:jboss:domain:datasources:6.0">
    <datasources>
        ...
        <datasource jndi-name="java:/PostgresDS" pool-name="PostgresDS" enabled="true" use-java-context="true" statistics-enabled="${wildfly.datasources.statistics-enabled:${wildfly.statistics-enabled:false}}">
            <connection-url>jdbc:postgresql://db-postgres:5432/myappdb</connection-url>
            <driver-class>org.postgresql.Driver</driver-class>
            <driver>postgresql</driver>
            <security>
                <user-name>docker</user-name>
                <password></password>
            </security>
            <validation>
                <check-valid-connection-sql>select 1</check-valid-connection-sql>
                <valid-connection-checker class-name="org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker"/>
                <validate-on-match>true</validate-on-match>
                <background-validation>false</background-validation>
                <exception-sorter class-name="org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter"/>
            </validation>
        </datasource>
        <drivers>
            ...
            <driver name="postgresql" module="org.postgresql">
                <xa-datasource-class>org.postgresql.xa.PGXADataSource</xa-datasource-class>
            </driver>
        </drivers>
    </datasources>
</subsystem>
```

#### 管理画面からデータソースを登録する場合（Non-XA）

`Configuration` > `Subsystems` > `Datasources & Drivers` > `Datasources`クリックし、`Add Datasource`を選択。

1. Choose Template

    - `PostgreSQL`選択。

2. Attributes

    - Name: `PostgresDS`
    - JNDI NAME: `java:/PostgresDS`

3. JDBC Driver

    - Driver Name: `postgresql`
    - Driver Module Name: `org.postgresql`
    - Driver Class Name: `org.postgresql.Driver`

4. Connection

    - Connection URL: `jdbc:postgresql://db-postgres:5432/myappdb`
    - User Name: `docker`
    - Password:
    - Security Domain:

5. Test Connection

    - `Test Connection`クリック。
