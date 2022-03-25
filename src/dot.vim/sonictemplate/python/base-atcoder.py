import sys
# from math import ceil
# from math import factorial
# from math import log2
# from math import sqrt
# from itertools import permutations
# from collections import Counter
# from collections import defaultdict
# from collections import deque
# import bisect
# import queue
# import heapq


# def combinations_count(n: int, r: int):
#     """ 異なるn個のものからr個を選ぶ場合の数を得る。 """
#     return math.factorial(n) // (math.factorial(n - r) * math.factorial(r))
# def sum_of_arithmetic_progressions1(a: int, d: int, n: int):
#     """ 初項a, 公差d, 項数n の踏査数列の初項から第n項までの和を得る。 """
#     return n * (2 * a + (n - 1) * d) // 2
# def sum_of_arithmetic_progressions2(a: int, n: int, la: int):
#     """ 初項a, 項数n, 末項la の踏査数列の初項から第n項までの和を得る。 """
#     return n * (a + la) // 2
# def sum_of_geometric_progression(a: int, r: int, n: int):
#     """ 初項a, 公比r, 項数n の等比数列の和を得る。 """
#     return a * (1 - r ** n) // (1 - r)

CAPITAL_YES = 'Yes'
CAPITAL_NO = 'No'
INF = 10**20
MOD = 998244353
# MOD = 1000000007

sys.setrecursionlimit(100000)

debug = True
# debug = False{{_cursor_}}
N = int(input())
A = list(map(int, input().split()))
N, M = list(map(int, input().split()))
S1, S2 = input().split()

ans = -1
print(ans)
