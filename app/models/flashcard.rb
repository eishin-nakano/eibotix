class Flashcard < ApplicationRecord
    validates :english, presence: true
    validates :japanese, presence: true
    belongs_to :user, dependent: :destroy
    has_many :learning_histories
end
