class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true

  belongs_to :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id

  has_many :responses,
    through: :answer_choices,
    source: :responses

  def results
    result = {}
    self.answer_choices.each do |answer|
      result[answer.text] = answer.responses.count
    end
    result
  end

  def better_results
    result = {}
    answers = self.answer_choices.includes(:responses)
    answers.each do |answer|
      result[answer.text] = answer.responses.length
    end
    result
  end

  def best_result
    # SELECT
    #   answer_choices.text, COUNT(responses.answer_choice_id)
    # FROM
    #   answer_choices
    # LEFT JOIN
    #   responses
    #   ON answer_choices.id = responses.answer_choice_id
    # WHERE
    #   answer_choices.question_id = #self.id
    # GROUP BY
    #   answer_choices.text
    result = {}
    answers = self.answer_choices.select('answer_choices.text, COUNT(responses.answer_choice_id) AS responses_count')
                       .joins('LEFT JOIN responses ON answer_choices.id = responses.answer_choice_id')
                       .where('answer_choices.question_id = ?', self.id)
                       .group('answer_choices.id')
    answers.each do |answer|
      result[answer.text] = answer.responses_count
    end
    result
  end
end
