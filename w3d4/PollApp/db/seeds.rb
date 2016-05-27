# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = User.create([{user_name: 'Anne'}, {user_name: 'Bob'}, {user_name: 'Carla'}])

polls = Poll.create([{title: 'Cats', author_id: '1'}, {title: 'Not about cats', author_id: '2'}])

questions1 = Question.create([{text: 'What is your favorite cat?', poll_id: '1'}, {text: 'What is your favorite color of cat?', poll_id: '1'}])
questions2 = Question.create([{text: 'What city would you like to visit?', poll_id: '2'}, {text: 'What is your favorite food?', poll_id: '2'}])

answer_choices1_1 = AnswerChoice.create([{text: 'Pretty cats', question_id: '1'}, {text: 'Lazy cats', question_id: '1'}, {text: 'Cute cats', question_id: '1'}])
answer_choices1_2 = AnswerChoice.create([{text: 'Black', question_id: '2'}, {text: 'White', question_id: '2'}, {text: 'Orange', question_id: '2'}])
answer_choices2_1 = AnswerChoice.create([{text: 'San Francisco', question_id: '3'}, {text: 'New York', question_id: '3'}])
answer_choices2_2 = AnswerChoice.create([{text: 'Burgers', question_id: '4'}, {text: 'Pizza', question_id: '4'}])

responses = Response.create([{answer_choice_id: '3', respondent_id: '3'}, {answer_choice_id: '4', respondent_id: '3'}, {answer_choice_id: '7', respondent_id: '3'}, {answer_choice_id: '10', respondent_id: '3'}])
