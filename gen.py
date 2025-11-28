
for row in range(9):

    res1 = "\t<cell row=\"" + f"{row}"
    for col in range(9):
        if (row < 3):
            zone = 0
        elif (row > 2 and row < 6):
            zone = 3
        else:
            zone = 6

        zone += col // 3
        res = res1 + "\" col=\"" + f"{col}" + "\" zone=\"" + f"{zone}" + "\"></cell>"
        print(res)  