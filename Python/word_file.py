import heapq

# const
ROUTE_COST = 3
HIGHER_CHARS_COST = 3
LOWER_CHARS_COST = 2
ANAGRAM_COST = 1
DIFFERENT_CHARS_COST = 2
ALPHABET = "abcdefghijklmnopqrstuvwxyz"  # alphabet is in italian, so some letters could be removed(?)


class WordError(Exception):
    pass


class WordFinder:
    def __init__(self, file_path):
        self.starting_word = None
        self.ending_word = None
        self.word_groups = {}  # Save words by length
        self.file_path = file_path
        self.read_file()

    def read_file(self):
        with open(self.file_path, "r") as file:
            for new_word in file.readlines():
                word = new_word.strip()
                length = len(word)
                if length not in self.word_groups:
                    self.word_groups[length] = []
                self.word_groups[length].append(word)

    def set_words(self, start, end):
        self.set_word(start, True)
        self.set_word(end, False)

    def set_word(self, word, is_start):

        if word not in self.word_groups[len(word)]:
            raise WordError(f"Word error. Word not in dictionary. Exiting...")
            # print('Error. Word not in dictionary. Exiting..')
            # exit()
        if is_start:
            self.starting_word = word
        else:
            self.ending_word = word

    def find_path(self):
        # A* Search Algorithm

        # faster to start from longer word to shorter one
        changed = False
        if len(self.starting_word) < len(self.ending_word):
            temp = self.starting_word
            self.starting_word = self.ending_word
            self.ending_word = temp
            changed = True

        queue = []
        heapq.heappush(queue, (0, self.starting_word, [self.starting_word]))
        visited = {self.starting_word}

        while queue:
            costo, word, route = heapq.heappop(queue)

            if word == self.ending_word:
                return (list(reversed(
                    route)), costo) if changed else (route, costo)

            # Explore next words
            for next_word in self.get_transformations(word):
                if next_word == self.ending_word:
                    heapq.heappush(queue, (
                        self.calculate_cost(next_word, route), next_word, route + [next_word]))
                    break  # if found a path, stop looking for other transformations, give that
                if next_word not in visited:  # and next_word in self.file_contents:
                    visited.add(next_word)
                    cost = self.calculate_cost(next_word, route)
                    heapq.heappush(queue, (cost, next_word, route + [next_word]))

        return [], 0  # No path found

    def calculate_cost(self, word, route):
        cost = len(route) * ROUTE_COST

        # diff_length = abs(len(word) - len(self.ending_word)) * HIGHER_CHARS_COST

        diff_length = (len(word) - len(self.ending_word)) * HIGHER_CHARS_COST if \
            len(word) - len(self.ending_word) >= 0 else (len(self.ending_word) - len(word)) * LOWER_CHARS_COST

        diff_chars = sum(c1 != c2 for c1, c2 in zip(word, self.ending_word)) * DIFFERENT_CHARS_COST

        diff_positions = sum(i for i, (c1, c2) in enumerate(zip(word, self.ending_word)) if c1 != c2) * ANAGRAM_COST

        cost += diff_length + diff_chars + diff_positions

        return cost
    
    def get_transformations(self, word):
        transformations = set()

        # Rule 1: Add/Remove a letter
        for i in range(len(word) + 1):
            # add
            for char in ALPHABET:
                new_word = str(word[:i] + char + word[i:])
                if new_word != word and new_word in self.word_groups[len(new_word)]:
                    transformations.add(new_word)
            # remove
            if i < len(word):
                new_word = word[:i] + word[i + 1:]
                if new_word in self.word_groups[len(new_word)]:
                    transformations.add(new_word)

        # Rule 2: Change a letter
        for i in range(len(word)):
            for char in ALPHABET:
                if char != word[i]:
                    new_word = word[:i] + char + word[i + 1:]
                    if new_word in self.word_groups[len(new_word)]:
                        transformations.add(new_word)

        # Rule 3: Anagram
        length = len(word)
        sorted_word = sorted(word)
        if length in self.word_groups:
            for w in self.word_groups[length]:
                if sorted(w) == sorted_word:
                    transformations.add(w)

        return list(transformations)
