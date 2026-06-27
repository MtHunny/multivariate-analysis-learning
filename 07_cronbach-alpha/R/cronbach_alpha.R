library(psych)

df <- read.csv("../data/cronbach_alpha_test_data.csv")

bunkei <- df[, c("Kokugo", "Shakai")]
rikei <- df[, c("Sugaku", "Rika")]

bunkei_result <- alpha(bunkei)
rikei_result <- alpha(rikei)

print(bunkei_result)
print(rikei_result)

bunkei_alpha <- bunkei_result$total$raw_alpha
rikei_alpha <- rikei_result$total$raw_alpha

cat("Bunkei alpha:", sprintf("%.16g", bunkei_alpha), "\n")
cat("Rikei alpha:", sprintf("%.16g", rikei_alpha), "\n")
