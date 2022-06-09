from swgoh.engine.swgohhelp import SWGOH
from swgoh.load import members, opponents

def upload_guild(allycode=None):
    engine = SWGOH()
    if allycode==None:
        guild_data = engine.guild()
        members.prepare_current(guild_data[0]['roster'])

        for member in guild_data[0]['roster']:
            print(member['name'])
            player = engine.player(member['allyCode'])[0]            
            member['grandArena'] = player['grandArena']

            members.member(member)
            members.member_units(
                member['allyCode']
                , member['updated']
                , player['roster']
                )    
    else:
        guild_data = engine.guild(allycode)
        opponents.opponent_name(guild_data[0]['name'])        
        opponents.opponent_truncate()
        for opponent in guild_data[0]['roster']:
            print(opponent['name'])
            player = engine.player(opponent['allyCode'])[0]            
            opponent['grandArena'] = player['grandArena']            
            opponents.opponent(opponent)
            opponents.opponent_units(
                opponent['allyCode']
                , opponent['updated']
                , engine.player(opponent['allyCode'])[0]['roster']
                )
    