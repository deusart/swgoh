import gspread
from swgoh.sql import select
from oauth2client.service_account import ServiceAccountCredentials
scope = [
    "https://spreadsheets.google.com/feeds",
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive.file",
    "https://www.googleapis.com/auth/drive"]
creds = ServiceAccountCredentials.from_json_keyfile_name(".\config\swgoh-key.json", scope)

def _create_clean_array(columns):
    clean = []
    row = []

    for _ in range(columns):
        row.append('')
    for _ in range(50):
        clean.append(row)

    return clean

def update_google_legends():
    client = gspread.authorize(creds)
    file = 'thehordeby'
    sheet = client.open(file)

    # clean = _create_clean_array(11)
    # worksheet = sheet.worksheet("LEGEND")
    # worksheet.update('A3', clean)

    # data = sheet.worksheet("LEGEND").get_all_records()    
    query = """
    select 
    member_name, CAST(updated_at as nvarchar(10)) as updated_at
    , glkylo, glsse, glrey, glkenobi
    , glluke, glvader, gljabba, glexecutor, glprofundity
    from google.legend_status
    order by check_sum desc
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("LEGEND")
    worksheet.update('A3', gdata)

    # clean = _create_clean_array(22)
    # worksheet = sheet.worksheet("JOURNEY")
    # worksheet.update('A3', clean)

    query = """
    select 
    member_name, CAST(updated_at as nvarchar(10)) as updated_at
    , jlyoda, jlemperor, jlthrawn
    , jlr2d2, jlbb8 , jlpadme
    , jlcls, jlrey, jlmando
    , jlchimera, jljkrevan, jldrevan
    , jlc3p0, jlchewbacca, jlfalcon
    , jlstarkiller, jlgrandinq
    , jlmalak, jljediluke, jlgas
    from google.journey_status
    order by check_sum desc
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("JOURNEY")
    worksheet.update('A3', gdata)

    query = """
    select 
    member_name, CAST(updated_at as nvarchar(10)) as updated_at
    , grgeos, grtroopers, grclones, grpadme
    from google.guild_requirements
    order by check_sum desc
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILDREQUIREMENTS")
    worksheet.update('A3', gdata)

def update_google_guildwars():
    client = gspread.authorize(creds)
    file = 'thehordeby'
    sheet = client.open(file)

    query = """
SELECT
	ligue
    , analitics
    , member_count
    , member_power
    , opponent_count
    , opponent_power
    , delat_count
    , delat_power
FROM swgoh.google.gvg_ligue
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILDWARS")
    worksheet.update('A3', gdata)

    query = """
    SELECT 
        track
        , analitics
        , guild_units_count
        , guild_units_power
        , enemy_units_count
        , enemy_units_power
    FROM swgoh.google.gvg_rosters
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILDWARS")
    worksheet.update('A9', gdata)


    query = """
    SELECT TOP 1
    concat('The Horde BY -- vs -- ', custom_value_char) as value
    FROM swgoh.stage.customs
    ;
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILDWARS")
    worksheet.update('A1', gdata)

def update_google_guild():
    client = gspread.authorize(creds)
    file = 'thehordeby'
    sheet = client.open(file)
    

    clean = _create_clean_array(25)
    worksheet = sheet.worksheet("GUILD")
    worksheet.update('A3', clean)
    
    query = """
    SELECT
        member_name, member_allycode, member_ligue
        , avg_tickets_lifetime, avg_tickets_month
        , avg_tickets_half_month, tickets_last_updated
        , member_power, avg_monthly_power, member_power_characters, member_power_ships
        , legends_count, relics_count, omicrons_count, zetas_count
        , r9_count, r8_count, r7_count, r0_6_count, g12_count
        , top_unit
        , omicrons_ga5x5, omicrons_ga3x3, omicrons_tb, omicrons_tw        
    FROM swgoh.google.members
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GUILD")
    worksheet.update('A3', gdata)

    clean = _create_clean_array(11)
    worksheet = sheet.worksheet("GAC")
    worksheet.update('A2', clean)

    query = """
    SELECT member_name, member_allycode, member_ligue
      , gac_bucket, gac_history, member_power, avg_monthly_power
      , zetas_count, relics_count, omicrons_ga5x5
      , omicrons_ga3x3
    FROM swgoh.google.gac
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GAC")
    worksheet.update('A2', gdata)

    clean = _create_clean_array(27)
    worksheet = sheet.worksheet("GACHISTORY")
    worksheet.update('A4', clean)

    query = """
        SELECT member_name, member_allycode, current_ligue
            , IIF(ligue_gac30 IS NULL, -1, gac_banners_gac30) AS gac_banners_gac30, ligue_gac30
            , IIF(ligue_gac31 IS NULL, -1, gac_banners_gac31) AS gac_banners_gac31, ligue_gac31
            , IIF(ligue_gac32 IS NULL, -1, gac_banners_gac32) AS gac_banners_gac32, ligue_gac32
            , IIF(ligue_gac33 IS NULL, -1, gac_banners_gac33) AS gac_banners_gac33, ligue_gac33
            , IIF(ligue_gac34 IS NULL, -1, gac_banners_gac34) AS gac_banners_gac34, ligue_gac34
            , IIF(ligue_gac35 IS NULL, -1, gac_banners_gac35) AS gac_banners_gac35, ligue_gac35
            , IIF(ligue_gac36 IS NULL, -1, gac_banners_gac36) AS gac_banners_gac36, ligue_gac36
            , IIF(ligue_gac37 IS NULL, -1, gac_banners_gac37) AS gac_banners_gac37, ligue_gac37
            , IIF(ligue_gac38 IS NULL, -1, gac_banners_gac38) AS gac_banners_gac38, ligue_gac38
            , IIF(ligue_gac39 IS NULL, -1, gac_banners_gac39) AS gac_banners_gac39, ligue_gac39
            , IIF(ligue_gac40 IS NULL, -1, gac_banners_gac40) AS gac_banners_gac40, ligue_gac40
            , IIF(ligue_gac41 IS NULL, -1, gac_banners_gac41) AS gac_banners_gac41, ligue_gac41
        FROM google.gac_history
    """
    data = select(query)
    gdata = []
    for item in data:
        gdata.append(list(item))
    worksheet = sheet.worksheet("GACHISTORY")
    worksheet.update('A4', gdata)

def update_google_gac():
   pass