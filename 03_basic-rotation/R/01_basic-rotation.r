install.packages("psych")
library(psych)

# データの読み込み
dat <- read.csv("../../01_factor-analysis/data/factor_analysis_test_data.csv", row.names = 1, header = TRUE, stringsAsFactors = FALSE)

# 因子分析 因子数2、バリマックス回転
varimax_result <- fa(dat, nfactors = 2, rotate = "varimax")

# 結果の表示
print(varimax_result$loadings)

# 因子分析 因子数2、プロマックス回転
promax_result <- fa(dat, nfactors = 2, rotate = "promax")

# 結果の表示
print(promax_result$loadings)

# 因子分析 因子数2、回転なし
norotation_result <- fa(dat, nfactors = 2, rotate = "none")

# 結果の表示
print(norotation_result$loadings)