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

    def choose_random_flashcard
        flashcard_count = Flashcard.last.id
        flashcard = Flashcard.find(rand(1..flashcard_count))

        @current_user.update_current_problem(flashcard)

        return flashcard
    end

    def create_reply(recieved_message)
        if recieved_message == "問題を出して"
            problem = choose_random_flashcard

            text = problem.japanese
        elsif recieved_message == "答えを教えて"
            text = @current_user.solving_problem? ? @current_user.show_answer : "先に「問題を出して」と言ってみてね！"
            @current_user.finish_problem
        else
            text =  "問題を出してほしいときは、「問題をだして」と言ってね！"   
        end

        message = {
            type: "text",
            text: text
        }

        return message
    end

    def set_current_user(line_user_id)
        @current_user = User.find_by(line_user_id: line_user_id) || User.create!(line_user_id: line_user_id)
    end

end
