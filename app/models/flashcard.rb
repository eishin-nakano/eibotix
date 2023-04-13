class Flashcard < ApplicationRecord
    validates :english, presence: true
    validates :japanese, presence: true
    belongs_to :user, dependent: :destroy
    has_many :learning_histories

    # check whether the languages of new flashcard are correct using regular expression
    def check_languages
        if japanese =~ /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/ && english =~ /[a-zA-Z]/ 
            return true
        else
            return false
        end
    end
end
