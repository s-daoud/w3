
class QuestionFollow
  attr_accessor :user_id, :question_id

  def self.followers_for_question_id(question_id)
    users = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_follows
      ON
        users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL
    users.map{|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      WHERE
        question_follows.user_id = ?
    SQL
    questions.map{|question| Question.new(question)}
  end

  def self.most_followed_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_follows
      ON
        questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL
    questions.map{|question| Question.new(question)}
  end

  def initialize(options)
    @user_id = options["user_id"]
    @question_id = options["question_id"]
  end
end
