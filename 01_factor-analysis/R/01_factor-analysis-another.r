install.packages("psych")
library(psych)

# データの読み込み
dat <- read.csv("../data/factor_analysis_test_data.csv", row.names = 1, header = TRUE, stringsAsFactors = FALSE)

# 因子分析 因子数2、回転なし
result <- fa(dat, nfactors = 2, rotate = "none")

# 結果の表示
print(result$loadings)