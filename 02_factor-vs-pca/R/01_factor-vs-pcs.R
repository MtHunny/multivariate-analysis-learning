# tidyverseパッケージをインストールして読み込む
install.packages("tidyverse") #初回のみ実行
library(tidyverse)

# データの読み込み
data <- read_csv("../../01_factor-analysis/data/factor_analysis_test_data.csv")

# 散布図の作成
# ggplot()で描画設定を開始
# aes()でX軸とY軸に使う列を指定
# geom_point()で散布図を描画
p <- ggplot(data, aes(x = 算数, y = 理科)) +
  geom_point() +
  labs(
    title = "算数と理科の得点の散布図",
    x = "算数",
    y = "理科"
  ) +
  theme_minimal()+
  theme(
    text = element_text(family = "Hiragino Kaku Gothic ProN"), # 日本語フォントの適用
    plot.title = element_text(hjust = 0.5),  # ここでタイトルを中央に揃える
    axis.title.x = element_text(hjust = 0.45), # x軸ラベルを中央に揃える
    axis.title.y = element_text(hjust = 0.5)  # y軸ラベルを中央に揃える
  )

# プロットオブジェクトを変数に格納した場合
ggsave("../fig/11_r_scatter.png", plot = p)

# データの標準化
# mutate()で新しい列（算数_std, 理科_std）を作成
# scale()で各列の値を標準化（平均0, 標準偏差1）
data_standardized <- data %>%
  mutate(
    算数_std = scale(算数),
    理科_std = scale(理科)
  )

# 標準化されたデータで散布図を作成
p2 <- ggplot(data_standardized, aes(x = 算数_std, y = 理科_std)) +
  geom_point() +
  labs(
    title = "算数と理科の得点の散布図 (標準化)",
    x = "算数 (標準化)",
    y = "理科 (標準化)"
  ) +
  theme_minimal() +
  theme(
    text = element_text(family = "Hiragino Kaku Gothic ProN"), # 日本語フォントの適用
    plot.title = element_text(hjust = 0.5),
    axis.title.x = element_text(hjust = 0.5),
    axis.title.y = element_text(hjust = 0.6)
  )

# グラフを画像ファイルとして保存
ggsave("../fig/12_r_scaled_scatter.png", plot = p2)