PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS questions_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);



CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    associated_author INTEGER NOT NULL,

    FOREIGN KEY (associated_author) REFERENCES users(id)
);



CREATE TABLE questions_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);



CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    parent_reply_id INTEGER,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);



CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
    users (fname, lname)
VALUES
    ('Taowei', 'Li'),
    ('Ryan', 'Mullen'),
    ('Darren', 'Eid'),
    ('Disnee', 'Tamang');

INSERT INTO 
    questions (title, body, associated_author)
VALUES
    ('Class start time', 'When does class start?', (SELECT id FROM users WHERE fname = 'Ryan')),
    ('Current time?', 'What time is it?', (SELECT id FROM users WHERE fname = 'Taowei')),
    ('Assessment date?', 'When is the next assessment?', (SELECT id FROM users WHERE fname = 'Disnee')),
    ('Query definition', 'What is a query?', (SELECT id FROM users WHERE fname = 'Darren'));

INSERT INTO
    questions_follows (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Query definition'), (SELECT id FROM users WHERE fname = 'Taowei')),
    ((SELECT id FROM questions WHERE title = 'Current time?'), (SELECT id FROM users WHERE fname = 'Ryan')),
    ((SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Darren')),
    ((SELECT id FROM questions WHERE title = 'Class start time'), (SELECT id FROM users WHERE fname = 'Disnee')),
    ((SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Taowei')),
    ((SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Ryan'));

INSERT INTO
    replies (body, question_id, user_id, parent_reply_id )
VALUES
    ('Class starts at 9:00am', (SELECT id FROM questions WHERE title = 'Class start time'), (SELECT id FROM users WHERE fname = 'Darren'), NULL),

    ('It''s 9:45am.', (SELECT id FROM questions WHERE title = 'Current time?'), (SELECT id FROM users WHERE fname = 'Ryan'), NULL),

    ('It is on Tuesday July 19th.', (SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Taowei'), NULL),

    ('A query is a way to look up data in a table.', (SELECT id FROM questions WHERE title = 'Query definition'), (SELECT id FROM users WHERE fname = 'Disnee'), NULL),

    ('I''m pretty sure the test is tomorrow!', (SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Ryan'), (SELECT id FROM replies WHERE body = 'It is on Tuesday July 19th.')),

    ('It''s way too early!', (SELECT id FROM questions WHERE title = 'Current time?'), (SELECT id FROM users WHERE fname = 'Disnee'), (SELECT id FROM replies WHERE body = 'It''s 9:45am.'));

INSERT INTO
    question_likes (question_id, user_id)
VALUES
    ((SELECT id FROM questions WHERE title = 'Query definition'), (SELECT id FROM users WHERE fname = 'Disnee')),
    ((SELECT id FROM questions WHERE title = 'Current time?'), (SELECT id FROM users WHERE fname = 'Darren')),
    ((SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Ryan')),
    ((SELECT id FROM questions WHERE title = 'Class start time'), (SELECT id FROM users WHERE fname = 'Taowei')),
    ((SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Darren')),
    ((SELECT id FROM questions WHERE title = 'Assessment date?'), (SELECT id FROM users WHERE fname = 'Disnee'));
