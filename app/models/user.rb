class User < ApplicationRecord
    validates :line_user_id, presence: true
    has_one :current_problem

    def update_current_problem(flashcard)
        problem = CurrentProblem.find_by(user_id: self.id) || CurrentProblem.create({user_id: self.id, flashcard_id: nil})
        problem.update(flashcard_id: flashcard.id)
    end

end
