# B-木入門

**B-木** はテーブルとインデックスを表現するためにSQLiteが使っているデータ構造です。
つまり、SQLiteのとても中心的なアイデアです。
この記事では、このデータ構造を導入します。コードは書きません。

なぜB-木はデータベースにとって良いデータ構造なのでしょう。

- 探索がとても早い（探索する項目の数に対して対数でしか計算量が増えません）。
- すでに見つけた項目を挿入や削除するのも早い（バランス再調整に定数時間しかかかりません）。
- 項目の範囲を線形に探索するのも早い。（ハッシュマップとの違いです）。

B-木は二分木ではありません（binary tree。Bはおそらく発明者の名前から取られていますが、もしかしたら"balanced"の頭文字かもしれません）。
下記がB-木の例です。

![上に7と16があり、左下に1と2と5と６があり、真ん中下に9と12があり、右下に18と21がある。7の左から左下に、7と16の間から真ん中下に、16の右から右下に矢印がある](./B-tree.png "B木の例（https://en.wikipedia.org/wiki/File:B-tree.svg）")

二分木と違って、それぞれのノードは2以上の子ノードを持つことができます。
それぞれのノードはある非負整数m以下のノードを持つことができて、このmを木の「オーダー」と言います。
木をほぼバランス取れている状態にするために、全てのノードはm/2を切り上げた数以上の子ノードを持つべきです。

例外としては

- 歯ノードは子ノードを持ちません。
- 根ノードはm/2未満の子ノードしか持たなくても構いませんが、最低でも2個の子ノードを持たなくてはいけません。
- もし、根ノードが葉ノードであり、そして唯一のノードであるならば、やはり子ノードを持ちません。

上記のB木の図は、SQLiteがインデックスの保存に使っているものです。
SQLiteはテーブルの保存には **B+木** を使っています。

||**B-Tree**|**B+Tree|
| ---- | ---- | ---- |
|発音|"Bee Tree"|"Bee Plus Tree"|
|何に使用されているか|インデックス|テーブル|
|内部ノードが値を持つか|はい|いいえ|
|子ノードの数|少ない|多い|
|内部ノード vs 葉ノード|同じ構造|違う構造|

インデックスを実装するまで、まずはB+木について説明します。
