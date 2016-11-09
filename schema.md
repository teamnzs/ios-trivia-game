## User table
- id
- name
- score
- ranking
- photo_url
- is_active
- facebook_auth_token
- created_at

## Game room table
- room_id
- room_name
- room_state : idle, playing, end
- current_question
- max_num_of_question
- max_num_of_people
- is_public

## User in Game (Current Game)
- room_id
- user_id
- user_state

## Question table
- question_id
- room_id
- question_text
- answer_text

## Answer table (For each question)
- user_id
- user_selected_answer_text
- correct_answer_text
- question_id
- timestamp
- room_id
