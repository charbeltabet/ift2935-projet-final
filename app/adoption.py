from datetime import datetime
from db import get_db_connection, rows_to_list

from flask import Blueprint, render_template, request, redirect, url_for
adoption_bp = Blueprint('adoptions', __name__, template_folder='templates')


@adoption_bp.route('/<int:id>/delete', methods=['GET'])
def delete_confirmation(id):
  with get_db_connection() as conn:
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM ADOPTIONS WHERE id = ?", (id,))
    adoption = rows_to_list(cursor)[0]

    cursor.execute("SELECT * FROM USERS WHERE id = ?", (adoption['user_id'],))
    user = rows_to_list(cursor)[0]

    cursor.execute("SELECT * FROM MOBILE_ENTITY WHERE id = ?", (adoption['mobile_entity_id'],))
    entity = rows_to_list(cursor)[0]

  return render_template('adoptions/delete.html', user=user, entity=entity, adoption_id=id)

@adoption_bp.route('/<int:id>/delete', methods=['POST'])
def delete(id):
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM ADOPTIONS WHERE id = ?", (id,))
        adoption = rows_to_list(cursor)[0]
        user_id = adoption['user_id']

        cursor.execute("DELETE FROM ADOPTIONS WHERE id = ?", (id,))
        conn.commit()

    return redirect(url_for('users.show', id=user_id))

@adoption_bp.route('', methods=['POST'])
def create():
    user_id = request.form['user_id']
    mobile_entity_id = request.form['mobile_entity_id']
    with get_db_connection() as conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO ADOPTIONS (user_id, mobile_entity_id, created_at, updated_at) VALUES (?, ?, ?, ?)", (user_id, mobile_entity_id, datetime.now(), datetime.now()))
        conn.commit()

    return redirect(request.form['redirect_url'])
