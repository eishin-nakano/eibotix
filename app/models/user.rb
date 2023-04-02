class User < ApplicationRecord
    validates :line_user_id, presence: true
    has_one :current_problem

    def update_current_problem(flashcard)
        problem = CurrentProblem.find_by(user_id: self.id) || CurrentProblem.create({user_id: self.id, flashcard_id: nil})
        problem.update(flashcard_id: flashcard.id)
    end

    def finish_problem
        problem = CurrentProblem.find_by(user_id: self.id)
        problem.update(flashcard_id: nil)
    end

    def solving_problem?
        return self.current_problem.flashcard_id != nil
    end

    def show_answer
        Flashcard.find(self.current_problem.flashcard_id).english
    end
end
