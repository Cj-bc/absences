# absences -- 欠席日数を管理しよう

[![tipmona](https://img.shields.io/badge/tipme-%40tipmona-orange.svg)](https://twitter.com/share?text=%40tipmona%20tip%20%40Cj-bc%2039)  [![monya/mona](https://img.shields.io/badge/tipme-%40monya/mona-orange.svg)](https://monya-wallet.github.io/a/?address=MBdCkYyfTsCxtm1wZ1XyKWNLFLYj8zMK3V&scheme=monacoin)  [![tipkotone](https://img.shields.io/badge/tipme-%40tipkotone-orange.svg)](https://twitter.com/share?text=%40tipkotone%20tip%20%40Cj-bc%20{1:39})


## 機能

  - 各クラス、カテゴリ毎に何回休んでいるかを記録する
  - リミットまであと何回残っているかを表示する

## 依存パッケージ

  - [0k/shyaml](https://github.com/0k/shyaml)

## 使用方法

  - 欠席を記録する: `absences add [absent] <category> <date>`
  - カテゴリを追加する: `absences add category <new_category>`
  - 全体の概要を表示する: `absences`
  - カテゴリの詳細を表示する: `absences <category>`
  - リミットまでの残り回数が少ないカテゴリを表示: `absences alert`

## config file

  `absences`は`$HOME/.config/absences/config`をコンフィグファイルとして認識します。
  コンフィグはYAMLベースで書かれていますが、一番簡単なハッシュしか使われていません。
  使用可能な設定は以下の通りです:

    - `datapath`: absencesの生データを保存しているファイルへのパス。デフォルト: `$HOME/.config/absences/data`
    - `alert_line`: 数字。`alert`で警告を出す残り回数を指定します。`alert_line: 5`だと、リミットと欠席回数の差が5以下の時に`alert`に表示されるようになります。
