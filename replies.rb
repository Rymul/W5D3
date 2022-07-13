require "sqlite3"
require_relative "questions_db.rb"

class Reply
  attr_accessor :id, :body, :question_id, :user_id, :parent_reply_id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @body = options["body"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
    @parent_reply_id = options["parent_reply_id"]
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE id = ?
    SQL
    data.map { |datum| Reply.new(datum) }
    # data[0]
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT * FROM replies WHERE question_id = ?
    SQL
    data.map { |datum| Reply.new(datum) }
    # data[0]
  end

  def self.find_by_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT * FROM replies WHERE user_id = ?
    SQL
    data.map { |datum| Reply.new(datum) }
    # data[0]
  end

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT * FROM replies WHERE parent_reply_id IS NULL
    SQL
    data.map { |datum| Reply.new(datum) }
  end

  def child_replies
    data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT * FROM replies WHERE parent_reply_id IS NOT NULL
    SQL
    data.map { |datum| Reply.new(datum) }
  end
end
