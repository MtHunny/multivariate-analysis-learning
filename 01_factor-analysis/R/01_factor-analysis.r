# データの読み込み
dat <- read.csv("../data/factor_analysis_test_data.csv", row.names = 1, header = TRUE, stringsAsFactors = FALSE)

# 因子分析 因子数2、回転なし
result <- factanal(dat, factors = 2, rotation = "none")

# 因子負荷量の表示
print(result$loadings)
