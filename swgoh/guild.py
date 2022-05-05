from swgoh.engine import SWGOH
from swgoh import load

def upload_guild(allycode=None):
    engine = SWGOH()
    if allycode==None:
        guild_data = engine.guild()
    else:
        guild_data = engine.guild(allycode)

    for member in guild_data[0]['roster']:
        print(member['name'])
        load.member(member)
        load.member_units(
            member['allyCode']
            , member['updated']
            , engine.player(member['allyCode'])[0]['roster']
            )