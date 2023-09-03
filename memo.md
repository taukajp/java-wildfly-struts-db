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
