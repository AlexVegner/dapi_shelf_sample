
-- Insert sample data

-- Users
INSERT INTO users(login, password) VALUES('alex', 'pwd');
INSERT INTO users(login, password) VALUES('ted', 'pwd');
INSERT INTO users(login, password) VALUES('max', 'pwd');

-- Events
INSERT INTO events (user_id, start_date, start_at, duration, status, title, detail, comment) 
VALUES((select id from users limit 1), '2022-07-03', '2022-07-03 19:10:25', 60, 'todo', 'Task', 'details', 'comments');

INSERT INTO events (user_id, start_date, start_at, duration, status, title, detail, comment) 
VALUES((select id from users limit 1), '2022-07-04', '2022-07-03 19:10:25', 60, 'todo', 'Task', 'details', 'comments');

-- Drafts
INSERT INTO drafts (user_id, start_date, start_at, end_date, days, duration, title, detail) 
VALUES((select id from users limit 1), '2022-07-03', '2022-07-03 19:10:25','2022-08-03', 0, 60, 'Task', 'details');

INSERT INTO drafts (user_id, start_date, start_at, end_date, days, duration, title, detail) 
VALUES((select id from users limit 1), '2022-07-03', '2022-07-03 18:00:00','2022-08-03', 0, 60, 'Task2', 'details');


SELECT * from events