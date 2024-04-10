from datetime import datetime
from db import get_db_connection, rows_to_list

from flask import Blueprint, render_template, request, redirect, url_for
entities_bp = Blueprint('entities', __name__, template_folder='templates')

entity_types = [
    '',
    'baleine',
    'iceberg',
    'oiseau',
    'ours',
    'requin',
]

from helpers import remove_second_instance

@entities_bp.route('/', methods=['GET'])
def index():
    user_id = request.args.get('user_id', None)
    with get_db_connection() as conn:
        if user_id:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM MOBILE_ENTITY WHERE id IN (SELECT mobile_entity_id FROM ADOPTIONS WHERE user_id = ?)", (user_id,))
            data = rows_to_list(cursor)
        else:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM MOBILE_ENTITY ORDER BY created_at DESC, id DESC")
            data = rows_to_list(cursor)

        cursor.execute("SELECT * FROM USERS")
        all_users = rows_to_list(cursor)
        if user_id:
            cursor.execute("SELECT * FROM USERS WHERE id = ?", (user_id,))
            user = rows_to_list(cursor)[0]
            all_users.remove(user)
            all_users.insert(0, user)
            all_users.append({'id': '', 'name': ''})
        else:
            all_users.insert(0, {'id': '', 'name': ''})

    return render_template('entities/index.html', data=data, all_users=all_users)

@entities_bp.route('/<int:id>')
def show(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM MOBILE_ENTITY WHERE id = ?", (id,))
        data = rows_to_list(cursor)[0]

        local_entity_types = entity_types.copy()
        local_entity_types[0] = data['type']
        local_entity_types = remove_second_instance(local_entity_types)

        cursor.execute("""
            SELECT USERS.*, ADOPTIONS.created_at AS adoption_date, ADOPTIONS.id AS adoption_id
            FROM USERS
            JOIN ADOPTIONS ON USERS.id = ADOPTIONS.user_id
            WHERE ADOPTIONS.mobile_entity_id = ?
            ORDER BY ADOPTIONS.created_at DESC
        """, (id,))
        entity_users = rows_to_list(cursor)

        cursor.execute("SELECT * FROM USERS")
        all_users = rows_to_list(cursor)
        all_users.insert(0, {'id': '', 'name': ''})

        cursor.execute("""
            SELECT
                recorded_at, lng, lat, temperature, wind_speed, solar_intensity
            FROM LOGS
            WHERE mobile_entity_id = ?
            ORDER BY recorded_at DESC
        """, (id,))
        logs = rows_to_list(cursor)

    return render_template(
        'entities/show.html',
        data=data,
        entity_types=local_entity_types,
        entity_users=entity_users,
        all_users=all_users,
        logs=logs
    )

@entities_bp.route('/new')
def new():
    return render_template('entities/new.html', entity_types=entity_types)

@entities_bp.route('', methods=['POST'])
def create():
    name = request.form['name']
    entity_type = request.form['entity_type']
    label = request.form['label']

    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO MOBILE_ENTITY (name, type, label, created_at, updated_at) VALUES (?, ?, ?, ?, ?)",
            (name, entity_type, label, datetime.now(), datetime.now())
        )
        conn.commit()
        cursor.execute("SELECT @@IDENTITY")
        entity_id = cursor.fetchone()[0]

    return redirect(url_for('entities.show', id=entity_id))

@entities_bp.route('/<int:id>', methods=['POST'])
def update(id):
    name = request.form['name']
    entity_type = request.form['entity_type']
    label = request.form['label']

    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE MOBILE_ENTITY SET name = ?, type = ?, label = ?, updated_at = ? WHERE id = ?",
            (name, entity_type, label, datetime.now(), id)
        )
        conn.commit()

    return redirect(url_for('entities.show', id=id))

@entities_bp.route('/<int:id>/delete', methods=['GET'])
def delete_confirmation(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM MOBILE_ENTITY WHERE id = ?", (id,))
        data = rows_to_list(cursor)[0]

    return render_template('entities/delete.html', data=data)

@entities_bp.route('/<int:id>/delete', methods=['POST'])
def delete(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM MOBILE_ENTITY WHERE id = ?", (id,))
        conn.commit()

    return redirect(url_for('entities'))

@entities_bp.route('/<int:id>/log', methods=['POST'])
def log(id):
    mobile_entity_id = id
    recorded_at = datetime.now()
    lng = request.form['lng']
    lat = request.form['lat']
    temperature = request.form['temperature']
    wind_speed = request.form['wind_speed']
    solar_intensity = request.form['solar_intensity']
    created_at = datetime.now()
    updated_at = datetime.now()

    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO LOGS (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (mobile_entity_id, recorded_at, lng, lat, temperature, wind_speed, solar_intensity, created_at, updated_at))
        conn.commit()

    return redirect(url_for('entities.show', id=id))
