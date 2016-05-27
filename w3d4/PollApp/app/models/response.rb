class Response < ActiveRecord::Base
  validates :answer_choice_id, :respondent_id, presence: true
  validate  :respondent_already_answered?
  validate  :author_cant_respond

  belongs_to :answer_choice,
    class_name: "AnswerChoice",
    foreign_key: :answer_choice_id,
    primary_key: :id

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :respondent_id,
    primary_key: :id

  has_one :question,
    through: :answer_choice,
    source: :question



  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    if sibling_responses.exists?(respondent_id: respondent.id)
      errors[:respondent] << "user can't vote twice"
    end
  end

  def author_cant_respond
    if self.answer_choice.question.poll.author_id == respondent.id
      errors[:respondent] << "author can't vote in own poll"
    end
  end

  # def does_not_respond_to_own_poll
  #   # ans = Poll.joins(:questions).joins(:answer_choices).joins(:responses).where('author_id = ?', respondent.id)
  #   # joins(:answer_choices).joins(:questions).joins(:polls).where('author_id = ?', respondent.id)
  #
  #   ans = Response.select('responses.id').joins('JOIN answer_choices ON responses.answer_choice_id = answer_choices.id')
  #         .joins('JOIN questions ON answer_choices.question_id = questions.id')
  #         .joins('JOIN polls ON polls.id = questions.poll_id')
  #         .where('polls.author_id = ?', self.respondent_id).where('polls.id = questions.poll_id')
  #         .where('questions.id = answer_choices.question_id').where('answer_choices.id = responses.answer_choice_id').count
  #
  # end
end
