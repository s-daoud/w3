class Question < ModelBase
  attr_accessor :title, :body, :user_id
  attr_reader :id

  TABLE_NAME = 'questions'

  def self.find_by_author_id(author_id)
    user = User.find_by_id(author_id)
    raise "Author doesn't exist" unless user
    questions = QuestionDBConnection.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL

    questions.map{|question| Question.new(question)}
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
