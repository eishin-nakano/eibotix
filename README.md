# README

## はじめに
Repositoryを訪れてくれてありがとうございます！
eibotixは ENGLISH GYMの受講生であるeishin-nakanoが運営するENGLISH GYM受講生向け、自分専用の英文章アプリが作れる英文章LINE Botです！（Now Cntinue to be Developing...）  

(一般の方へ)  
ENGLISH GYMでは、SLトレーニングと呼ばれる、瞬間英作文を鍛えるトレーニングメソッドが導入されています。

これは講師の方が自分の英語での口語日記についてFBとして添削を貰えるというものなのですが...

従来の方法だと、テスト勉強をするのが面倒。単語帳に移そうにも手間がかかる。  
日々のSL日記について、先生からもらうFBを次のテストのためにも気軽に勉強したい。そんな声から開発がはじまったLINE Botです!(ENGLISH GYM公認)

## 何ができるのか
### 登録機能
ENGLISH GYMの講師の先生からもらったFBをそのまま送るだけで、出題してほしい文章が新規追加できます！  
余計なことを考えることなくコピペして、そのままおくるだけ！

<img width="500" alt="localhost3000" src="https://user-images.githubusercontent.com/104289147/229550893-2d2e6fd5-b6be-4dec-b459-b7e451d3fd06.jpg">

① 「新規追加」と送信  
② 続けてENGLISH GYMの先生からのFBを送信  
③ 「アップロード完了」と表示されたらOK！(もしFaild to uplpad dataと表示されたらeishin-nakanoにまで直接ご連絡ください。)

### 出題機能
eibotixが君の登録した文章からランダムに出題してくれます！  
分からなかったら答えを教えてくれる！  

<img width="500" alt="localhost3000" src="https://user-images.githubusercontent.com/104289147/229550967-8bf60880-9949-434b-851f-c0dcf38cd1cd.jpg">

① 「問題を出して」と送信  
② 分からなかったら「答えを教えて」と送信

## eibotixの使い方
### Botを友達追加して動かす
現在まだサポートされておりません。  
4月中旬に公開予定です。

### ローカルで動かす
#### バージョン
Rails version: 7.0.4.3  
Ruby version: ruby 3.1.2  
ngrok version: 3.2.2  
ChatGPT-API version: gpt-3.5-turbo

#### 前準備
先にLINE Developersを登録し、Botを作成し、ご自身のLINEアカウントからBotを追加してください。参考: <a href="https://developers.line.biz/ja/docs/messaging-api/building-bot/">公式ドキュメント</a>   
次に、Chat GPT APIsに登録し、アクセストークンの発行を行ってください。（有料となる場合がございます） 参考: <a href="https://openai.com/blog/introducing-chatgpt-and-whisper-apis">公式サイト</a>  
最後に、ngrokのinstall/Sign up及びauthtokenの設定を完了してください 参考: <a href="https://ngrok.com/">公式サイト</a>

#### 導入
まずは手元にレポジトリをクローンしてください。
```
$ git clone git@github.com:eishin-nakano/eibotix.git
```
次にご自身の環境でローカルサーバーを立ち上げてください。
```
$ rails s
```
localhostにアクセスし、railsアプリケーションが立ち上がっていることを確認してください。

<img width="500" alt="localhost3000" src="https://user-images.githubusercontent.com/104289147/229550792-0f448cd0-388c-4a1d-ad4a-85cd08c54bde.png">

rails applicationが立ち上がっているポート番号をngrokにForwardingしてもらいます。例えば3000なら、
```
$ ngrok http 3000
```

すると管理画面が立ち上がりますので、Forwardingの横にあるURLをコピーしておきます。

<img width="500" alt="ngrok" src="https://user-images.githubusercontent.com/104289147/229551063-6fd7f645-7c5d-4e96-8bd9-943fc193fa65.png">

<a href="https://developers.line.biz/console/">LINE Developersコンソール</a>に行きます。

プロバイダー > (設定したプロバーダー名) > Messaging API設定 > Webhook設定 > Webhook URL を、`(コピーしたURL)/callback`に設定します。
```
例: https://abcd-10-101-102-103.jp.ngrok.io/callback
```

ここまできたら準備完了です。
Botに話しかけてみましょう。

<img width="500" alt="localhost3000" src="https://user-images.githubusercontent.com/104289147/229551121-6a2cd20e-1254-4c4b-aa44-f3c29a0da451.jpg">

### リソース配布
#### 問題集
「新規追加」と送信した後に↓の文章を送ってみてください！  
その後「問題をだして」と送信すると、eibotixが問題を出してくれるようになります！
```
#中学校1年生向け
Sushi is my favorite food. (寿司が私の好きな食べ物です。)
I love playing soccer. (サッカーをするのが大好きです。)
I have a cat named Mimi. (私にはミミという名前の猫がいます。)
I have a brother and a sister. (兄と妹がいます。)
My favorite color is blue. (私の好きな色は青です。)
I love English class. (英語の授業が大好きです。)
I want to be a doctor. (医者になりたいです。)
My best friend's name is Yuka. (私の親友の名前はユカです。)
My favorite book is Harry Potter. (私の好きな本はハリー・ポッターです。)
I like pop music. (ポップ音楽が好きです。)
```

### 備考
#### 新規追加の際のフォーマットについて
本LINE botでは、ENGLISH GYMの講師の方の添削のフォーマットに合わせ、英語(日本語訳) で統一されている文章のみを処理することが出来ます。  
また、#からはじまる文章はコメントとして無視して処理が行われます。
