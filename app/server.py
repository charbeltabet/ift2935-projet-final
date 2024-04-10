from datetime import datetime
from db import get_db_connection, rows_to_list

from flask import Flask, render_template, request, redirect, url_for
app = Flask(__name__)

from entities import entities_bp
app.register_blueprint(entities_bp, url_prefix='/entities')
from users import users_bp
app.register_blueprint(users_bp, url_prefix='/users')
from adoption import adoption_bp
app.register_blueprint(adoption_bp, url_prefix='/adoptions')

from helpers import humanize
app.jinja_env.filters['humanize'] = humanize

@app.route('/enonce')
def enonce():
    return render_template('enonce.html')

@app.route('/')
def index():
    with get_db_connection() as conn:
        cursor = conn.cursor()

        # Query 1: Nombre d'entités adoptées par nombre d'utilisateurs, trié par ordre décroissant
        cursor.execute("""
            SELECT TOP 10
                ME.type AS entity_type,
                ME.name AS entity_name,
                COUNT(A.user_id) AS adoptions_count
            FROM
                MOBILE_ENTITY AS ME
                LEFT JOIN ADOPTIONS AS A ON ME.id = A.mobile_entity_id
            GROUP BY
                ME.type, ME.name
            ORDER BY
                adoptions_count DESC;
        """)
        entities_by_users = rows_to_list(cursor)

        # Query 2: Liste des utilisateurs et le nombre d'entités qu'ils ont adoptées, triée par nombre d'adoptions
        cursor.execute("""
            SELECT
                U.full_name AS user_full_name,
                COUNT(A.mobile_entity_id) AS number_of_adoptions
            FROM
                USERS AS U
                LEFT JOIN ADOPTIONS AS A ON U.id = A.user_id
            GROUP BY
                U.full_name
            ORDER BY
                number_of_adoptions DESC;
        """)
        users_by_adoptions = rows_to_list(cursor)

        # Query 3: Détails des entités mobiles qui n'ont pas été adoptées
        cursor.execute("""
            SELECT
                ME.type AS entity_type,
                ME.name AS entity_name
            FROM
                MOBILE_ENTITY AS ME
                LEFT JOIN ADOPTIONS AS A ON ME.id = A.mobile_entity_id
            WHERE
                A.mobile_entity_id IS NULL;
        """)
        unadopted_entities = rows_to_list(cursor)

        # Query 4: Afficher le dernier emplacement enregistré pour chaque entité mobile
        cursor.execute("""
            SELECT
                ME.name AS entity_name,
                L.*
            FROM
                MOBILE_ENTITY AS ME
                JOIN LOGS AS L ON ME.id = L.mobile_entity_id
                INNER JOIN (
                    SELECT
                        mobile_entity_id,
                        MAX(recorded_at) as LastRecorded
                    FROM
                        LOGS
                    GROUP BY
                        mobile_entity_id
                ) AS LastLogs ON L.mobile_entity_id = LastLogs.mobile_entity_id AND L.recorded_at = LastLogs.LastRecorded;
        """)
        last_logs_per_entity = rows_to_list(cursor)

        # Query 5: Afficher les utilisateurs qui ont adopté plus d'une entité
        cursor.execute("""
            SELECT
                U.full_name AS user_full_name,
                COUNT(A.mobile_entity_id) AS number_of_adoptions
            FROM
                USERS AS U
                JOIN ADOPTIONS AS A ON U.id = A.user_id
            GROUP BY
                U.full_name
            HAVING
                COUNT(A.mobile_entity_id) > 1
            ORDER BY
                number_of_adoptions DESC;
        """)
        users_with_multiple_adoptions = rows_to_list(cursor)

        # Query 6: Afficher les entités mobiles par type avec le nombre d'adoptions
        cursor.execute("""
            SELECT
                ME.type AS entity_type,
                COUNT(A.mobile_entity_id) AS NombreAdoptions
            FROM
                MOBILE_ENTITY AS ME
                LEFT JOIN ADOPTIONS AS A ON ME.id = A.mobile_entity_id
            GROUP BY
                ME.type;
        """)
        adoptions_by_type = rows_to_list(cursor)

        # Query 7: Afficher la moyenne des températures enregistrées pour chaque type d'entité mobile
        cursor.execute("""
            SELECT
                ME.type AS entity_type,
                ROUND(AVG(L.temperature), 2) AS average_temperature
            FROM
                LOGS AS L
                JOIN MOBILE_ENTITY AS ME ON L.mobile_entity_id = ME.id
            GROUP BY
                ME.type;
        """)
        avg_temperature_by_type = rows_to_list(cursor)

        # Query 8: Afficher les entités mobiles avec le plus grand nombre de logs enregistrés
        cursor.execute("""
            SELECT TOP 15
                ME.name AS entity_name,
                COUNT(L.id) AS NombreDeLogs
            FROM
                MOBILE_ENTITY AS ME
            JOIN LOGS AS L ON ME.id = L.mobile_entity_id
            GROUP BY
                ME.name
            ORDER BY
                NombreDeLogs DESC
        """)
        entities_with_most_logs = rows_to_list(cursor)

        # Query 9: Afficher les conditions moyennes pour chaque type d'entité mobile
        cursor.execute("""
            SELECT
                ME.type AS entity_type,
                ROUND(AVG(L.temperature), 2) AS average_temperature,
                ROUND(AVG(L.wind_speed), 2) AS VitesseVentMoyenne,
                ROUND(AVG(L.solar_intensity), 2) AS IntensiteSolaireMoyenne
            FROM
                MOBILE_ENTITY AS ME
            JOIN LOGS AS L ON ME.id = L.mobile_entity_id
            GROUP BY
                ME.type;
        """)
        avg_conditions_by_type = rows_to_list(cursor)

    return render_template('index.html',
        entities_by_users=entities_by_users,
        users_by_adoptions=users_by_adoptions,
        unadopted_entities=unadopted_entities,
        last_logs_per_entity=last_logs_per_entity,
        users_with_multiple_adoptions=users_with_multiple_adoptions,
        adoptions_by_type=adoptions_by_type,
        avg_temperature_by_type=avg_temperature_by_type,
        entities_with_most_logs=entities_with_most_logs,
        avg_conditions_by_type=avg_conditions_by_type
    )


if __name__ == '__main__':
    app.run(debug=True)
