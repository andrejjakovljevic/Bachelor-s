import pstats
from pstats import SortKey

matrices = ["mycielskian2","mycielskian4","mycielskian5","mycielskian6","bcspwr02","bcspwr04","GD00_a","mycielskian10","delaunay_n10","bcspwr08"]

for m in matrices:
    p = pstats.Stats('tri_count_'+m+'txt')
    p.sort_stats(SortKey.CUMULATIVE).print_stats(10,'recv')
