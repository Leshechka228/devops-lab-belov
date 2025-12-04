from flask import Flask, request, jsonify
from flask_cors import CORS
import json
import os
from datetime import datetime

app = Flask(__name__)
CORS(app)  # Разрешаем CORS для фронтенда

FEEDBACK_FILE = '/app/feedbacks.json'

def read_feedbacks():
    """Чтение отзывов из JSON файла"""
    try:
        if os.path.exists(FEEDBACK_FILE):
            with open(FEEDBACK_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        return []
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def write_feedbacks(feedbacks):
    """Запись отзывов в JSON файл"""
    try:
        with open(FEEDBACK_FILE, 'w', encoding='utf-8') as f:
            json.dump(feedbacks, f, indent=2, ensure_ascii=False)
        return True
    except Exception as e:
        print(f"Error writing feedbacks: {e}")
        return False

@app.route('/')
def index():
    """Информация о API"""
    return jsonify({
        "service": "DevOps Lab 4 - Feedback API",
        "student": "belov",
        "endpoints": {
            "GET /api/posts": "Get all feedbacks",
            "POST /api/post": "Add new feedback"
        },
        "timestamp": datetime.now().isoformat()
    })

@app.route('/api/posts', methods=['GET'])
def get_posts():
    """Получить все отзывы"""
    feedbacks = read_feedbacks()
    return jsonify({
        "count": len(feedbacks),
        "student": "belov",
        "feedbacks": feedbacks
    })

@app.route('/api/post', methods=['POST'])
def add_post():
    """Добавить новый отзыв"""
    try:
        post = request.get_json()
        
        # Добавляем метаданные
        post['id'] = len(read_feedbacks()) + 1
        post['timestamp'] = datetime.now().isoformat()
        post['student'] = 'belov'
        
        # Читаем существующие отзывы
        feedbacks = read_feedbacks()
        feedbacks.append(post)
        
        # Сохраняем
        if write_feedbacks(feedbacks):
            return jsonify({
                "success": True,
                "message": "Feedback added successfully",
                "feedback": post
            }), 201
        else:
            return jsonify({
                "success": False,
                "message": "Failed to save feedback"
            }), 500
            
    except Exception as e:
        return jsonify({
            "success": False,
            "message": f"Error: {str(e)}"
        }), 400

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "service": "feedback-api",
        "student": "belov",
        "timestamp": datetime.now().isoformat(),
        "storage": os.path.exists(FEEDBACK_FILE)
    })

@app.route('/api/stats', methods=['GET'])
def get_stats():
    """Статистика по отзывам"""
    feedbacks = read_feedbacks()
    
    # Группировка по имени
    name_counts = {}
    for fb in feedbacks:
        name = fb.get('name', 'Anonymous')
        name_counts[name] = name_counts.get(name, 0) + 1
    
    return jsonify({
        "total_feedbacks": len(feedbacks),
        "name_distribution": name_counts,
        "last_feedback": feedbacks[-1] if feedbacks else None,
        "student": "belov"
    })

if __name__ == '__main__':
    # Создаем файл если не существует
    if not os.path.exists(FEEDBACK_FILE):
        write_feedbacks([])
        print(f"Created feedback file: {FEEDBACK_FILE}")
    
    print("=" * 50)
    print("DevOps Lab 4 - Feedback API")
    print("Student: belov")
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"Storage: {FEEDBACK_FILE}")
    print("=" * 50)
    
    app.run(host='0.0.0.0', port=8080, debug=False)
