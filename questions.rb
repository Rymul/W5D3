require "sqlite3"
require_relative "questions_db.rb"
require_relative "users.rb"
require_relative "replies.rb"


class Question
  attr_accessor :id, :title, :body, :associated_author

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def initialize(options)
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @associated_author = options["associated_author"]
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ?
    SQL
    data.map { |datum| Question.new(datum) }
    # data[0]
  end

  def self.find_by_title(title)
    data = QuestionsDBConnection.instance.execute(<<-SQL, title)
      SELECT * FROM questions WHERE title = ?
    SQL
    data.map { |datum| Question.new(datum) }
    # data[0]
  end

  def self.find_by_author_id(associated_author)
    data = QuestionsDBConnection.instance.execute(<<-SQL, associated_author)
      SELECT * FROM questions WHERE associated_author = ?
    SQL
    data.map { |datum| Question.new(datum) }
    # data[0]
  end

  def author
    User.find_by_id(self.associated_author)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers 
    QuestionFollow.followers_for_question_id(self.id)
  end 

end
