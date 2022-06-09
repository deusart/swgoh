def relic_fix(character_relic):
    if character_relic == 1:
        return 759
    if character_relic == 2:
        return 1561
    if character_relic == 3:
        return 2505
    if character_relic == 4:
        return 3492
    if character_relic == 5:
        return 4554
    if character_relic == 6:
        return 6072 
    if character_relic == 7:
        return 7969
    if character_relic == 8:
        return 10246
    if character_relic == 9:
        return 0   
    else:
        return 0

def bool_int(value):
    if value:
        return 1
    else:
        return 0