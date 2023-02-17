from swgoh.engine.swgohhelp import SWGOH
from swgoh.load import members, opponents
from swgoh.engine import save_log, swgohgg

def _upload_member_swgohgg(allycode):
    data = swgohgg.get_player(allycode)
    if data['result']:
        members.member_swgohgg(data)

def upload_guild_swgohgg(allycode=None):
    engine = SWGOH()       
        
    guild_data = engine.guild()
    members.prepare_current(guild_data[0]['roster'])
    for member in guild_data[0]['roster']:
        print(member['allyCode'])
        _upload_member_swgohgg(member['allyCode'])


def upload_guild(allycode=None):
    engine = SWGOH()
    if allycode==None:
        save_log('.', 'Guilds update members load started')
        
        
        guild_data = engine.guild()
        members.prepare_current(guild_data[0]['roster'])

        for member in guild_data[0]['roster']:
            print(member['name'])
            player = engine.player(member['allyCode'])[0]            
            member['grandArena'] = player['grandArena']           
            member['fleet_rank'] = player['arena']['ship']['rank']
            member['squad_rank'] = player['arena']['char']['rank']

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
    