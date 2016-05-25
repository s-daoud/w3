class QuestionLike
  attr_accessor :user_id, :question_id

  def self.likers_for_question_id(question_id)
    users = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      JOIN
        question_likes
      ON
        users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    users.map{|user| User.new(user)}
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
    SQL
    questions.map{|question| Question.new(question)}
  end

  def self.num_likes_for_question_id(question_id)
    num_likes = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
      GROUP BY
        question_id
    SQL
    num_likes.first.values.first
  end

  def self.most_liked_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.user_id
      FROM
        questions
      JOIN
        question_likes
      ON
        questions.id = question_likes.question_id
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
