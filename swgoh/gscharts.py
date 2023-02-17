import gspread
from swgoh.sql import select
from oauth2client.service_account import ServiceAccountCredentials
scope = [
    "https://spreadsheets.google.com/feeds",
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name(".\config\swgoh-key.json", scope)

query = {}

query['total_characters_alignment'] = """
    SELECT 
        fn.alignment(character_id) as alignment        
        , SUM(character_power) as character_power
    FROM swgoh.core.members_characters
    WHERE fn.is_current(member_allycode) = 1 
        AND character_gear >= 12
    GROUP BY fn.alignment(character_id)
"""
query['total_ships_alignment'] = """
    SELECT
        fn.alignment(ship_id) as alignment       
        , SUM(ship_power) as character_power
    FROM swgoh.stage.members_ships
    WHERE fn.is_current(member_allycode) = 1 
    GROUP BY fn.alignment(ship_id)
"""
query['total_monthly'] = """
    SELECT 
        CONCAT_WS(
            '-'
            , year_month/100
            , IIF(
                year_month%100<10
                , CONCAT('0',CAST(year_month%100 AS nvarchar(20)))
                , CAST(year_month%100 AS nvarchar(20))
            )
        ) AS year_month
        , ROUND(CAST(SUM(member_power) AS float)/1000000,2) AS member_power
        , SUM(member_relics) AS member_relics
        , SUM(member_omicrons) AS member_omicrons
        , SUM(member_legends) AS member_legends
    FROM google.charts
    GROUP BY year_month
"""
query['total_roster_gl'] = """
    WITH cte AS (
        SELECT 
            character_id
            , count(*) as count_units
        FROM swgoh.core.members_characters
        WHERE fn.is_current(member_allycode) = 1
        AND fn.is_legend(character_id) = 1
        GROUP BY character_id
    )
    SELECT c.character_name, COALESCE(cte.count_units, 0) AS units
    FROM stage.characters c
    LEFT JOIN cte ON c.character_id = cte.character_id
    WHERE fn.is_legend(c.character_id) = 1
"""
query['total_roster_capitals'] = """
    WITH cte AS (
        SELECT 
            ship_id
            , count(*) as count_units
        FROM swgoh.stage.members_ships
        WHERE fn.is_current(member_allycode) = 1
        AND fn.is_capital(ship_id) = 1
        GROUP BY ship_id
    )
    SELECT s.ship_name, COALESCE(cte.count_units, 0) AS units
    FROM stage.ships s
    LEFT JOIN cte ON s.ship_id = cte.ship_id
    WHERE fn.is_capital(s.ship_id) = 1
"""
query['total_tb_shards'] = """
    select character_id, shards
    from rules.tb_shards
"""

def update_google_roster():
    client = gspread.authorize(creds)
    file = 'Charts'
    sheet = client.open(file)

    data = select(query['total_roster_gl'])
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("ROSTER")
    worksheet.update('A3', gdata)

    data = select(query['total_roster_capitals'])
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("ROSTER")
    worksheet.update('C3', gdata)

    data = select(query['total_characters_alignment'])
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("ROSTER")
    worksheet.update('E3', gdata)

    data = select(query['total_ships_alignment'])
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("ROSTER")
    worksheet.update('G3', gdata)

def update_google_monthly():
    client = gspread.authorize(creds)
    file = 'Charts'
    sheet = client.open(file)

    data = select(query['total_monthly'])
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("MONTH")
    worksheet.update('A2', gdata)

def update_google_tb():
    client = gspread.authorize(creds)
    file = 'Charts'
    sheet = client.open(file)

    data = select(query['total_tb_shards'])
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("TB")
    worksheet.update('J2', gdata)