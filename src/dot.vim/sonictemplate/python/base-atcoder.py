import sys
from functools import partial
# from collections import Counter
# from collections import defaultdict
# from collections import deque
# from itertools import permutations
# from math import ceil
# from math import factorial
# from math import gcd
# from math import log2
# from math import sqrt
# import bisect
# import heapq


debug_print = partial(print, file=sys.stderr)


# def lcm(x: int, y: int):
#     """ 最小公倍数(Least Common Multiple)を得る。 """
#     """ 言い換えると x, y ともに割り切れる最小値を返す。 """
#     """ 例: 6, 8 がともに割り切れる最小値は 24 であり、24を返す。 """
#     return x * y // gcd(x, y)
# def combinations_count(n: int, r: int):
#     """ 異なるn個のものからr個を選ぶ場合の数を得る。 """
#     return math.factorial(n) // (math.factorial(n - r) * math.factorial(r))
# def sum_of_arithmetic_progressions1(a: int, d: int, n: int):
#     """ 初項a, 公差d, 項数n の等差数列の初項から第n項までの和を得る。 """
#     return n * (2 * a + (n - 1) * d) // 2
# def sum_of_arithmetic_progressions2(a: int, n: int, la: int):
#     """ 初項a, 項数n, 末項la の等差数列の初項から第n項までの和を得る。 """
#     return n * (a + la) // 2
# def sum_of_geometric_progression(a: int, r: int, n: int):
#     """ 初項a, 公比r, 項数n の等比数列の和を得る。 """
#     return a * (1 - r ** n) // (1 - r)

# sys.setrecursionlimit(100000)
# sys.setrecursionlimit(200000)
# sys.setrecursionlimit(200005)
# int1 = lambda x: int(x)-1
# pDB = lambda *x: print(*x, end="\n", file=sys.stderr)
# p2D = lambda x: print(*x, sep="\n", end="\n\n", file=sys.stderr)
# def ii(): return int(sys.stdin.readline())
# def li(): return list(map(int, sys.stdin.readline().split()))
# def lli(rows_number): return [li() for _ in range(rows_number)]
# def li1(): return list(map(int1, sys.stdin.readline().split()))
# def lli1(rows_number): return [li1() for _ in range(rows_number)]
# def si(): return sys.stdin.readline().rstrip()

# INF = 10 ** 20
# MOD = 998244353
# MOD = 1000000007

# CAPITAL_YES, CAPITAL_NO = 'Yes', 'No'
# CAPITAL_TAKAHASHI, CAPITAL_AOKI = 'Takahashi', 'Aoki'

{{_cursor_}}
n = int(input())
# a, b = map(int, input().split())
# n1, n2 = map(int, input().split())
# a = list(map(int, input().split()))
# s = input()
# s1, s2 = input().split()

# edges = [[] for _ in range(n)]
# for _ in range(n-1):
#     u, v = li1()
#     edges[u].append(v)
#     edges[v].append(u)

ans = None
# ans = -1
# ans = False
# ans = True
# print(CAPITAL_YES if ans else CAPITAL_NO)
# print(CAPITAL_TAKAHASHI if ans else CAPITAL_AOKI)
# print(CAPITAL_AOKI if ans else CAPITAL_TAKAHASHI)
print(ans)
