class LearningHistory < ApplicationRecord
    belongs_to :user
    belongs_to :flashcard
end
