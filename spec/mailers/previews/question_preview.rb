# Preview all emails at http://localhost:3000/rails/mailers/quesition
class QuestionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/quesition/new_answer
  def new_answer
    user = User.first
    question = Question.first
    answer = question.answers.first
    QuestionMailer.new_answer(user, question, answer)
  end
end
