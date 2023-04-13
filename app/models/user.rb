class User < ApplicationRecord
    validates :line_user_id, presence: true
    has_one :current_problem
    has_many :flashcards
    has_many :learning_histories

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

    def set_status(status)
        self.update(status: status)
    end

    def make_history(status)
        LearningHistory.create(user_id: self.id, flashcard_id: current_problem.flashcard_id, correct: status)
    end

    def create_transcript
        transcript = {
            "dayly": {
                "worked_problem_count": learning_histories.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day).count,
                "correct_problem_count": learning_histories.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day, correct: CORRECT).count
            },
            "weekly": {
                "worked_problem_count": learning_histories.where(created_at: Time.now.beginning_of_week..Time.now.end_of_week).count,
                "correct_problem_count": learning_histories.where(created_at: Time.now.beginning_of_week..Time.now.end_of_week, correct: CORRECT).count
            }
        }

        return transcript
    end
end
