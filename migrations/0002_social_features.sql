ALTER TABLE users ADD COLUMN is_banned INTEGER NOT NULL DEFAULT 0;
CREATE TABLE friend_requests(id TEXT PRIMARY KEY,from_user TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,to_user TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,status TEXT NOT NULL DEFAULT 'pending',created_at INTEGER NOT NULL,UNIQUE(from_user,to_user));
CREATE TABLE friendships(user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,friend_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,created_at INTEGER NOT NULL,PRIMARY KEY(user_id,friend_id));
CREATE TABLE dm_threads(id TEXT PRIMARY KEY,user_a TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,user_b TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,created_at INTEGER NOT NULL,UNIQUE(user_a,user_b));
CREATE TABLE dm_messages(id TEXT PRIMARY KEY,thread_id TEXT NOT NULL REFERENCES dm_threads(id) ON DELETE CASCADE,user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,body TEXT NOT NULL,created_at TEXT NOT NULL);
CREATE INDEX dm_messages_thread_time_idx ON dm_messages(thread_id,created_at);
CREATE INDEX friend_requests_to_status_idx ON friend_requests(to_user,status);

CREATE TABLE admin_sessions(token_hash TEXT PRIMARY KEY,user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,expires_at INTEGER NOT NULL);
