class LineBotController < ApplicationController
    def callback
        request_body = request.body.read
        events = client.parse_events_from(request_body)

        events.each do |event|
            case event
            when Line::Bot::Event::Message
                case event.type
                when Line::Bot::Event::MessageType::Text
                    set_current_user(event['source']['userId'])

                    reply = create_reply(event.message["text"])
                    client.reply_message(event['replyToken'], reply)

                end
            end
        end
    end

    private

    def client
        @client ||= Line::Bot::Client.new { |config|
          config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
          config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
    end

    def create_reply(recieved_message)
        if @current_user.upload_status == NOW_UPLOADING
            begin
                upload_problems(recieved_message)
                text = "アップロード完了"
                @current_user.update(upload_status: UPLOAD_CONPLEATED)
            rescue => exception
                text = "Faild to uplpad data. Please contact eishin."
                @current_user.update(upload_status: UPLOAD_CONPLEATED)
            end
        elsif @current_user.flashcards.empty?
            if recieved_message == "新規追加"
                text = "先生からのメッセージを送ってね！"
                @current_user.update(upload_status: NOW_UPLOADING)
            else
                text = "「新規追加」から問題を追加してね！"
            end
        else
            if recieved_message == "問題を出して"
                problem = choose_random_flashcard

                text = problem.japanese
            elsif recieved_message == "答えを教えて"
                text = @current_user.solving_problem? ? @current_user.show_answer : "先に「問題を出して」と言ってみてね！"
                @current_user.finish_problem
            elsif recieved_message == "新規追加"
                text = "先生からのメッセージを送ってね！"
                @current_user.update(upload_status: NOW_UPLOADING)
            else
                text =  "問題を出してほしいときは、「問題を出して」と言ってね！"
            end
        end

        message = {
            type: "text",
            text: text
        }

        return message
    end

    def choose_random_flashcard
        flashcards = @current_user.flashcards
        flashcard_count = flashcards.count
        flashcard = flashcards[rand(0..flashcard_count-1)]

        @current_user.update_current_problem(flashcard)

        return flashcard
    end

    def set_current_user(line_user_id)
        @current_user = User.find_by(line_user_id: line_user_id) || User.create!(line_user_id: line_user_id)
    end

    def create_new_problems(problems_str)
        problems = problems_str.split("/")

        puts "problems:"
        puts problems

        prm_eng = nil
        prm_jap = nil

        problems.each_with_index do | sentence, i |
            if i % 2 == 0
                prm_eng = sentence
            else
                prm_jap = sentence
                param = {english: prm_eng, japanese: prm_jap, user_id: @current_user.id}

                begin
                    Flashcard.create!(param)
                rescue => exception
                    puts "Create Failed"
                    return false
                end
            end
        end
    end

    def answer_from_chatgpt(content)
        client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
        message_for_gpt = '文章をスラッシュ区切りの文字列としてまとめてください。はじめに概要と条件と出力例を説明します。 概要: 英語の文章に続いて、その文章に対応する日本語の文章が括弧内に書かれています 条件①: 英語とそれに対応する日本語を1つの配列に順番に格納してください。つまり、英語と日本語が交互になるようにしてください。条件②: #から始まる文章はコメントですので配列には含めないでください。 条件③: 配列の結果のみをレスポンスとしてください。説明書きは不要です。 出力例: I’m on my way home/家に向かっています/I drank alcohol with my friends from high school/高校の友達とお酒を飲みました/I had some assignments to do for the business class/ビジネスの授業の課題がありました 以下の文章を形式にそってまとめてください。' + content

        puts message_for_gpt

        response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", content: message_for_gpt }],
        })
        puts response.dig("choices", 0, "message", "content")
        return response.dig("choices", 0, "message", "content")
    end

    def upload_problems(content)
        problems_str = answer_from_chatgpt(content)
        create_new_problems(problems_str)
    end
end
