from datetime import datetime
from db import get_db_connection, rows_to_list

from flask import Blueprint, render_template, request, redirect, url_for
users_bp = Blueprint('users', __name__, template_folder='templates')

@users_bp.route('/', methods=['GET'])
def index():
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM USERS ORDER BY created_at DESC, id DESC")
        data = rows_to_list(cursor)

    return render_template('users/index.html', data=data)

@users_bp.route('/<int:id>')
def show(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM USERS WHERE id = ?", (id,))
        data = rows_to_list(cursor)[0]

        cursor.execute("""
            SELECT MOBILE_ENTITY.*, ADOPTIONS.created_at AS adoption_date, ADOPTIONS.id AS adoption_id
            FROM MOBILE_ENTITY
            JOIN ADOPTIONS ON MOBILE_ENTITY.id = ADOPTIONS.mobile_entity_id
            WHERE ADOPTIONS.user_id = ?
            ORDER BY ADOPTIONS.created_at DESC
        """, (id,))
        user_entities = rows_to_list(cursor)

        cursor.execute("""
            SELECT * FROM MOBILE_ENTITY ORDER BY type ASC, created_at DESC
        """)
        all_entities = rows_to_list(cursor)
        all_entities.insert(0, {'id': '', 'label': ''})

    return render_template('users/show.html', data=data, user_entities=user_entities, all_entities=all_entities)

@users_bp.route('/new')
def new():
    return render_template('users/new.html')

@users_bp.route('', methods=['POST'])
def create():
    full_name = request.form['full_name']
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO USERS (full_name, created_at, updated_at) VALUES (?, ?, ?)", (full_name, datetime.now(), datetime.now()))
        conn.commit()
        cursor.execute("SELECT @@IDENTITY")
        user_id = cursor.fetchone()[0]


    return redirect(url_for('users.show', id=user_id))

@users_bp.route('/<int:id>', methods=['POST'])
def update(id):
    full_name = request.form['full_name']
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("UPDATE USERS SET full_name = ?, updated_at = ? WHERE id = ?", (full_name, datetime.now(), id))
        conn.commit()

    return redirect(url_for('users.show', id=id))

@users_bp.route('/<int:id>/adopt', methods=['POST'])
def adopt(id):
    mobile_entity_id = request.form['mobile_entity_id']
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO ADOPTIONS (user_id, mobile_entity_id, created_at, updated_at) VALUES (?, ?, ?, ?)", (id, mobile_entity_id, datetime.now(), datetime.now()))
        conn.commit()

    return redirect(url_for('users.show', id=id))

@users_bp.route('/<int:id>/delete', methods=['GET'])
def delete_confirmation(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM USERS WHERE id = ?", (id,))
        data = rows_to_list(cursor)[0]

    return render_template('users/delete.html', data=data)

@users_bp.route('/<int:id>/delete', methods=['POST'])
def delete(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM USERS WHERE id = ?", (id,))
        conn.commit()

    return redirect(url_for('users'))
