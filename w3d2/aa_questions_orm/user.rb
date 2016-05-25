class User < ModelBase
  attr_accessor :fname, :lname
  attr_reader :id

  TABLE_NAME = 'users'

  def self.find_by_name(fname, lname)
    user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ?, lname = ?
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end

  def initialize(options)
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    average = QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        COUNT(question_likes.question_id) / CAST(COUNT(DISTINCT(questions.id)) AS FLOAT) AS average_karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes
      ON
        question_likes.question_id = questions.id
      JOIN
        users
      ON
        questions.user_id = users.id
      WHERE
        users.id = ?
    SQL
  end
end
