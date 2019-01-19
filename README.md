# absences -- manage your absences

[![tipmona](https://img.shields.io/badge/tipme-%40tipmona-orange.svg)](https://twitter.com/share?text=%40tipmona%20tip%20%40Cj-bc%20)  [![monya/mona](https://img.shields.io/badge/tipme-%40monya/mona-orange.svg)](https://monya-wallet.github.io/a/?address=MBdCkYyfTsCxtm1wZ1XyKWNLFLYj8zMK3V&scheme=monacoin)  [![tipkotone](https://img.shields.io/badge/tipme-%40tipkotone-orange.svg)](https://twitter.com/share?text=%40tipkotone%20tip%20%40Cj-bc%20{1:39})


## feature

  - Manage how many times you're absent from each classes, category, etc.
  - Display how many times left till the limit.

## dependencies

  - [0k/shyaml](https://github.com/0k/shyaml)

## usage

  - Add new absence: `absences add [absent] <category> <date>`
  - Add category: `absences add category <new_category>`
  - Show summary: `absences`
  - Show details for category: `absences <category>`
  - Show categories that is about to over limit: `absences alert`

## config file

  `absences` read config at `$HOME/.config/absences/config`
  It's written in YAML style, though we don't use anything but hash
  available configs are:

    - `datapath`: the path to file that contains raw absences data
    - `alert_line`: number. define when to alert
