from swgoh.engine import SWGOH

def run_swgoh_engine():
    try:
        swgoh = SWGOH()
        print('[SUCCESS] Test object creation SWGOH()')
    except:
        print('[FAILED] Test object creation SWGOH()')

    try:
        if len(swgoh.head) > 0:
            print('[SUCCESS] Test SWGOH.__get_token()')
        else:
            print('[FAILED] Test SWGOH.__get_token()')
    except:
        print('[FAILED] Test SWGOH.__get_token()')

    try:
        player = swgoh.player()
        if player[0]['name'] == 'DeusArt':
            print('[SUCCESS] Test SWGOH.player()')
        else:
            print('[FAILED] Test SWGOH.player()')
    except:
        print('[FAILED] Test SWGOH.player()')
    
    try:
        guild = swgoh.guild()
        guildname = player[0]['guildName']
        if guildname == guild[0]['name']:
            print('[SUCCESS] Test SWGOH.guild()')
        else:
            print('[FAILED] Test SWGOH.guild()')
    except:
        print('[FAILED] Test SWGOH.guild()')

    try:
        collection = swgoh.collection('categoryList')
        if collection[0]['descKey'] == 'PLACEHOLDER':
            print('[SUCCESS] Test SWGOH.collection()')
        else:
            print('[FAILED] Test SWGOH.collection()')
    except:
        print('[FAILED] Test SWGOH.collection()')
