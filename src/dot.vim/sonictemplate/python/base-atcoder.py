import sys
def ls(): return input().split()
def li(): return list(map(int, input().split()))
def lli(r: int): return [li() for _ in range(r)]
def int1(x: str): return int(x) - 1
def li1(): return list(map(int1, input().split()))
def lli1(r: int): return [li1() for _ in range(r)]
def read_table(r: int): return [list(input()) for _ in range(r)]
def new_table(r: int, c: int, v): return [[v] * c for _ in range(r)]
def new_table3(h, r, c, v): return [new_table(r, c, v) for _ in range(h)]
def print_capital_yes_no(v: bool): print("Yes" if v else "No")


debug = True
# debug = False


# def solve():
#     '''
#     >>> solve(1)
#     False
#     '''
#     return True


def main():
    global debug

    # {{_cursor_}}n, = li()
    # n, q = li()
    # for _ in range(q):
    #     a, = li()

    # ans = solve()
    # print(ans)
    # print_capital_yes_no(ans)


def debug_print(*argv):
    global debug
    if debug:
        print(*argv, file=sys.stderr)


# 2023-09 時点で、Python3 で 3.10 が利用できるようになっている。
# f-string `f"{var=}"` が利用できるため、不要である。
def debug_vars(*var_names):
    global debug
    if debug:
        import inspect
        frame = inspect.currentframe()
        outer_frames = inspect.getouterframes(frame)
        caller_frame = outer_frames[1][0]
        args = inspect.getargvalues(caller_frame)
        it = map(lambda n: n + "=" + str(args.locals[n]), var_names)
        debug_print(', '.join(it))


def debug_print_table(t):
    global debug
    if debug:
        debug_print("table:")
        for r in t:
            debug_print(*list(map(lambda c: str(c), r)))


def run_doctest():
    import doctest
    finder = doctest.DocTestFinder(exclude_empty=True)
    runner = doctest.DocTestRunner(verbose=True)
    for test in finder.find(sys.modules.get('__main__')):
        runner.run(test)
    runner.summarize()


if __name__ == "__main__":
    if len(sys.argv) >= 2 and sys.argv[1] == "doctest":
        run_doctest()
    else:
        main()

# === INPUT, 入力 ===

# node_to_edges = [[] for _ in range(n)]
# for _ in range(n-1):
#     u, v = li1()
#     node_to_edges[u].append(v)
#     node_to_edges[v].append(u)

# === bisect, 二分探索 ===

# import bisect

# import bisect_left from bisect

# def bisect_left(a, x, lo=0, hi=None, key=None):
#     """
#     2分探索でソート済み配列aに要素xを挿入するインデックスを探す。
#
#     計算量は O(log2 n) である。
#
#     返り値 index は a[:index] の各要素 e について e < x である。
#     返り値 index は a[index:] の各要素 e について e >= x である。
#     そのため、 a に1個以上 x が含まれる場合は x の最も左の index を返す。
#
#     >>> bisect_left([10, 20], 5)
#     0
#     >>> bisect_left([10, 20], 15)
#     1
#     >>> bisect_left([10, 20], 25)
#     2
#     >>> bisect_left([10, 20, 20, 30], 20)
#     1
#     >>> bisect_left([(10, "y"), (20, "x"), (20, "z")], 20, key=lambda e: e[0])
#     1
#     """
#     assert lo >= 0
#
#     if hi is None:
#         hi = len(a)
#
#     if key is None:
#         while lo < hi:
#             mid = (lo + hi) // 2
#             if a[mid] < x:
#                 lo = mid + 1
#             else:
#                 hi = mid
#     else:
#         while lo < hi:
#             mid = (lo + hi) // 2
#             if key(a[mid]) < x:
#                 lo = mid + 1
#             else:
#                 hi = mid
#     return lo

# import bisect_right from bisect

# def bisect_right(a, x, lo=0, hi=None, key=None):
#     """
#     2分探索でソート済み配列aに要素xを挿入するインデックスを探す。
#
#     計算量は O(log2 n) である。
#
#     返り値 index は a[:index] の各要素 e について e <= x である。
#     返り値 index は a[index:] の各要素 e について e > x である。
#     そのため、 a に1個以上 x が含まれる場合は x の最も右の次の index を返す。
#
#     >>> bisect_right([10, 20], 5)
#     0
#     >>> bisect_right([10, 20], 15)
#     1
#     >>> bisect_right([10, 20], 25)
#     2
#     >>> bisect_right([10, 20, 20, 30], 20)
#     3
#     >>> bisect_right([(10, "y"), (20, "x"), (20, "z")], 20, key=lambda e: e[0])
#     3
#     """
#     assert lo >= 0
#
#     if hi is None:
#         hi = len(a)
#
#     if key is None:
#         while lo < hi:
#             mid = (lo + hi) // 2
#             if x < a[mid]:
#                 hi = mid
#             else:
#                 lo = mid + 1
#     else:
#         while lo < hi:
#             mid = (lo + hi) // 2
#             if x < key(a[mid]):
#                 hi = mid
#             else:
#                 lo = mid + 1
#     return lo

# === RECURSION, 再帰 ===
# sys.setrecursionlimit(100000)
# sys.setrecursionlimit(200000)
# sys.setrecursionlimit(200005)

# === CONSTANTS, 定数 ===
# INF = 10 ** 20
# MOD = 998244353
# MOD = 1000000007
# YES, NO = 'yes', 'no'
# CAPITAL_TAKAHASHI, CAPITAL_AOKI = 'Takahashi', 'Aoki'

# === IMPORT, インポート ===
# from functools import partial
# from collections import Counter
# from collections import defaultdict
# from collections import deque

# from itertools import permutations
# >>> it = ["a", "b", "c"]
# >>> list(permutations(it, 2))
# [('a', 'b'), ('a', 'c'), ('b', 'a'), ('b', 'c'), ('c', 'a'), ('c', 'b')]

# from itertools import product
# >>> list(product([0, 1], repeat=2))
# [(0, 0), (0, 1), (1, 0), (1, 1)]

# 累積和
# from itertools import accumulate
# >>> a = [1, 2, 3]
# >>> b = list(accumulate(a))
# >>> a, b
# ([1, 2, 3], [1, 3, 6])

# from itertools import comibinations
# >>> it = ["a", "b", "c"]
# >>> list(combinations(it, 2))
# [('a', 'b'), ('a', 'c'), ('b', 'c')]

# import math
# from math import ceil
# from math import factorial
# from math import gcd
# from math import log2
# from string import ascii_uppercase
# from string import ascii_lowercase
# from string import digits

# === 乗 ===
# pow(base, exp, mod=None)
    # mod があれば、base の exp 乗に対する mod の剰余を返します。
    # pow(base, exp) % mod より効率よく計算されます。

# === 平方 ===
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

# def is_square(n1):
#     """
#     n1 が平方数か計算する。
#
#     >>> is_square(3)
#     False
#     >>> is_square(4)
#     True
#     """
#     n2 = floor_sqrt(n1)
#     return n2 ** 2 == n1

# import heapq

# from functools import lru_cache
# @lru_cache(maxsize=None)
# def f(n):
#     pass


# === DEF, 関数定義 ===

# def lcm(x: int, y: int):
#     """
#     最小公倍数(Least Common Multiple)を得る。
#
#     言い換えると x, y ともに割り切れる最小値を返す。
#     例: 6, 8 がともに割り切れる最小値は 24 であり、24を返す。
#
#     >>> lcm(6, 8)
#     24
#     """
#     return x * y // gcd(x, y)

# def get_list_of_divisors(n):
#     """
#     整数nのすべての約数のリストを得る。
#     約数とは、ある整数を割り切ることができる数である。
#     4 の約数は [1, 2, 4] である。
#
#         >>> get_list_of_divisors(4)
#         [1, 2, 4]
#     """
#     d = []
#     for i in range(1, int(n ** (1 / 2)) + 1):
#         if n % i == 0:
#             d.append(n // i)
#             d.append(i)
#     return sorted(set(d))

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

# === UF ===
# class UnionFind(object):
#     def __init__(self, n):
#         self.n = n
#         self.parents = [-1] * n
#
#     def find(self, x):
#         if self.parents[x] == -1:
#             return x
#         else:
#             self.parents[x] = self.find(self.parents[x])
#             return self.parents[x]
#
#     def unite(self, node1, node2):
#         x = self.find(node1)
#         y = self.find(node2)
#         if x == y:
#             return
#         self.parents[y] = x
#
#
# n, q = map(int, input().split())
# uf = UnionFind(n)
# for i in range(q):
#     p, a, b = map(int, input().split())
#     a -= 1
#     b -= 1
#     if p == 0:
#         uf.unite(a, b)
#     else:
#         if uf.find(a) == uf.find(b):
#             print("Yes")
#         else:
#             print("No")

# === OUTPUT, 出力 ===

# 入力と出力を StringIO で分ける。
# from io import StringIO
# q, = li()
# f = StringIO()
# for _ in range(q):
#     ...
#     print(ans, file=f)
# text = f.getvalue()
# print(text, end='')

# ans = None
# ans = -1
# ans = False
# ans = True
# print(YES if ans else NO)
# print(CAPITAL_TAKAHASHI if ans else CAPITAL_AOKI)
# print(CAPITAL_AOKI if ans else CAPITAL_TAKAHASHI)
# print(ans)

# === TEST, テスト ===
# python -m doctest -v .\Main.py
