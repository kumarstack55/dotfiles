import sys
from functools import partial


debug_print = partial(print, file=sys.stderr)
def li(): return list(map(int, input().split()))


{{_cursor_}}# ===>>> DEBUG, デバッグ <<<===
# def debug_print_table(t): debug_print(*t, sep="\n", end="\n\n")
# def debug_print_table(t):
#     for r in t:
#         debug_print(*list(map(lambda c: "%2d" % (c), r)))

# ===>>> 初期化 <<<===
# def new_table(rows, cols, val): return [[val] * cols for _ in range(rows)]

# ===>>> INPUT, 入力 <<<===

# s = input()
# s1, s2 = input().split()

# ## 基数変更: 0
# n = int(input())
# a = li()
# n, m = li()
# n1, n2 = li()
# def lli(rows): return [li() for _ in range(rows)]
# table = lli(rows)

# ## 基数変更: -1
# int1 = lambda x: int(x)-1
# def li1(): return list(map(int1, input().split()))
# n = int1(input())
# a = li1()
# n, m = li1()
# n1, n2 = li1()
# def lli1(rows): return [li1() for _ in range(rows)]
# table = lli1(rows)

# edges = [[] for _ in range(n)]
# for _ in range(n-1):
#     u, v = li1()
#     edges[u].append(v)
#     edges[v].append(u)

# ===>>> RECURSION, 再帰 <<<===
# sys.setrecursionlimit(100000)
# sys.setrecursionlimit(200000)
# sys.setrecursionlimit(200005)

# ===>>> CONSTANTS, 定数 <<<===
# INF = 10 ** 20
# MOD = 998244353
# MOD = 1000000007
# CAPITAL_YES, CAPITAL_NO = 'Yes', 'No'
# CAPITAL_TAKAHASHI, CAPITAL_AOKI = 'Takahashi', 'Aoki'

# ===>>> IMPORT, インポート <<<===
# from collections import Counter
# from collections import defaultdict
# from collections import deque
# from itertools import permutations
# from math import ceil
# from math import factorial
# from math import gcd
# from math import log2

# from math import sqrt
# def floor_sqrt(n):
#     """
#     floor(sqrt(n)) を整数で計算する。
#
#     >>> floor_sqrt(1)
#     1
#     >>> floor_sqrt(2)
#     1
#     >>> floor_sqrt(4)
#     2
#     """
#     # 2分探索で探す。
#     left = 0
#     right = n
#     while left < right:
#         center = (left + right + 1) // 2
#         if center * center <= n:
#             left = center
#         else:
#             right = center - 1
#     return left

# import bisect
# import heapq

# from functools import lru_cache
# @lru_cache
# def f(n):
#     pass


# ===>>> DEF, 関数定義 <<<===

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

# ===>>> OUTPUT, 出力 <<<===
# ans = None
# ans = -1
# ans = False
# ans = True
# print(CAPITAL_YES if ans else CAPITAL_NO)
# print(CAPITAL_TAKAHASHI if ans else CAPITAL_AOKI)
# print(CAPITAL_AOKI if ans else CAPITAL_TAKAHASHI)
# print(ans)
