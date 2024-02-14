from word_file import WordFinder
from timer import Timer


def main():
    my_finder = WordFinder("words.italian.txt")

    starting_word = input("Write a starting word: ")
    my_finder.set_word(starting_word, True)

    ending_word = input("Write the ending word: ")
    my_finder.set_word(ending_word, False)
    t = Timer()
    t.start()
    route, cost = my_finder.find_path()
    t.stop()
    if route:
        print("Route:", route)
        print("Cost:", cost)
    else:
        print("No path found")


main()

#  R!: aggiungo/tolgo una lettera : pro->poro->porro (sia agli estremi che in mezzo)
#     R2:  anagramma            :   torta     -> trota
# R3:  sostituire una lettera           :   torta     -> torto
