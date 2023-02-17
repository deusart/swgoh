from swgoh.engine.swgohhelp import SWGOH
from swgoh.load import misc
from swgoh.engine import save_log, get_player

def upload_players():    
    engine = SWGOH()

    for allycode in misc.get_players_list():
        print(allycode)
        player = engine.player(allycode)
        try:
            misc.load_player(player)
        except:
            print(allycode,' failed')
            pass

    