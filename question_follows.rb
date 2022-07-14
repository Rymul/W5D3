require "sqlite3"
require_relative "questions_db.rb"
require_relative "users.rb"
require_relative "replies.rb"


class QuestionFollow
    attr_accessor :id, :user_id, :question_id

    def initialize(options)
        @id = options["id"]
        @user_id = options["user_id"]
        @question_id = options["question_id"]
    end

    def self.followers_for_question_id(question_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
        SELECT
            users.id, fname, lname
        FROM 
            questions_follows
        JOIN 
            users ON users.id = questions_follows.user_id
        WHERE 
            question_id = ?
        SQL
        data.map { |datum| User.new(datum) }
    end

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
        SELECT
           questions.id, title, body, associated_author
        FROM
            questions_follows
        JOIN
            questions ON questions.id = questions_follows.question_id
        WHERE
            user_id = ?
        SQL
        data.map { |datum| Question.new(datum) }
    end

end