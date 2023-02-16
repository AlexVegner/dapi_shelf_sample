-- uudi generator
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE IF NOT EXISTS users (
    id uuid DEFAULT uuid_generate_v4 (),
    login VARCHAR(255) UNIQUE,
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

-- DROP TABLE IF EXISTS log_items;
-- DROP TABLE IF EXISTS events;
CREATE TABLE IF NOT EXISTS events (
    id uuid DEFAULT uuid_generate_v4 (),
    user_id uuid NOT NULL,
    draft_id uuid NOT NULL,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date DATE NOT NULL,
    start_at TIMESTAMP NOT NULL,
    duration INT DEFAULT 60,
    status VARCHAR(16) DEFAULT 'todo',
    title VARCHAR(100) NOT NULL,
    detail VARCHAR(255),
    comment VARCHAR(255),
    PRIMARY KEY (id),
    CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
	      REFERENCES users(id)
        -- ON DELETE SET NULL
        ON DELETE CASCADE
);

-- DROP TABLE IF EXISTS drafts;
CREATE TABLE IF NOT EXISTS drafts (
    id uuid DEFAULT uuid_generate_v4 (),
    user_id uuid NOT NULL,
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_at TIMESTAMP NOT NULL,
    days INT NOT NULL DEFAULT 0,
	duration INT DEFAULT 60,
    title VARCHAR(100) NOT NULL,
    detail VARCHAR(255),
    PRIMARY KEY (id),
    CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
	      REFERENCES users(id)
        -- ON DELETE SET NULL
        ON DELETE CASCADE
);
