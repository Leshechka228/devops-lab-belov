-- Инициализация базы данных для DevOps лабы
CREATE TABLE IF NOT EXISTS deployment_logs (
    id SERIAL PRIMARY KEY,
    deployment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    commit_hash VARCHAR(50),
    student_name VARCHAR(100) DEFAULT 'belov',
    status VARCHAR(20) DEFAULT 'success'
);

CREATE TABLE IF NOT EXISTS page_views (
    id SERIAL PRIMARY KEY,
    view_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    page_url VARCHAR(255),
    visitor_ip VARCHAR(50)
);

-- Вставляем начальные данные
INSERT INTO deployment_logs (deployment_time, commit_hash, student_name) 
VALUES (CURRENT_TIMESTAMP, 'initial-lab4', 'belov');

-- Создаем пользователя для приложения (опционально)
CREATE USER IF NOT EXISTS app_user WITH PASSWORD 'app_password';
GRANT SELECT, INSERT ON deployment_logs TO app_user;
GRANT SELECT, INSERT ON page_views TO app_user;
