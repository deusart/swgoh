import gspread
from swgoh.sql import select
from oauth2client.service_account import ServiceAccountCredentials
scope = [
    "https://spreadsheets.google.com/feeds",
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name("swgoh-key.json", scope)

def update_google_legends():
    client = gspread.authorize(creds)
    file = 'thehordeby'
    sheet = client.open(file)

    # data = sheet.worksheet("LEGEND").get_all_records()    
    query = """
    select 
    member_name, CAST(updated_at as nvarchar(10)) as updated_at
    , glkylo, glsse, glrey, glkenobi
    , glluke, glvader, glexecutor
    from hordeby.google.legend_status
    order by check_sum desc
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("LEGEND")
    worksheet.update('A3', gdata)

    query = """
    select 
    member_name, CAST(updated_at as nvarchar(10)) as updated_at
    , jlyoda, jlemperor, jlthrawn
    , jlr2d2, jlbb8 , jlpadme
    , jlcls, jlrey, jlmando
    , jlchimera, jljkrevan, jldrevan
    , jlc3p0, jlchewbacca, jlfalcon
    , jlstarkiller, jlmalak, jljediluke
    , jlgas
    from hordeby.google.journey_status
    order by check_sum desc
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("JOURNEY")
    worksheet.update('A3', gdata)


def update_google_guildwars():
    client = gspread.authorize(creds)
    file = 'thehordeby'
    sheet = client.open(file)

    query = """
    SELECT 
        track
        , analitics
        , guild_units_count
        , guild_units_power
        , enemy_units_count
        , enemy_units_power
    FROM hordeby.google.gvg_rosters
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILDWARS")
    worksheet.update('A3', gdata)


    query = """
    SELECT TOP 1
    concat('The Horder BY vs ', custom_value_char) as value
    FROM hordeby.stage.customs
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILDWARS")
    worksheet.update('A1', gdata)