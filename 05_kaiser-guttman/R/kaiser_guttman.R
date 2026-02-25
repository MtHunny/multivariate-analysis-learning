# カイザー基準（Kaiser-Guttman criterion）で因子数を決める
# 手順:
# 1. 相関行列を作る
# 2. 相関行列の固有値を求める
# 3. 固有値 > 1 の個数を因子数とする

kaiser_guttman_criterion <- function(df) {
  # 相関行列（列どうしの相関）を作成
  # 列の組み合わせごとに使える行だけ使うようにするため、use = "pairwise.complete.obs" を指定
  corr_matrix <- cor(df, use = "pairwise.complete.obs")

  # eigen() 関数で固有値を求める
  # 相関行列は対称行列なので symmetric = TRUE を指定
  # 固有値だけが必要なので only.values = TRUE を指定 (FALSE にすると固有ベクトルも計算される。その場合 $vectors で固有ベクトルを取り出せる)
  eigenvalues <- eigen(corr_matrix, symmetric = TRUE, only.values = TRUE)$values

  # カイザー基準: 固有値が1を超える因子を残す
  n_factors <- sum(eigenvalues > 1)

  list(
    n_factors = n_factors,
    eigenvalues = eigenvalues,
    corr_matrix = corr_matrix
  )
}


# 実行中スクリプトのパスを取得する（Rscript / source() の両方をできるだけ考慮）
get_script_path <- function() {
  args_all <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args_all, value = TRUE)

  if (length(file_arg) > 0) {
    return(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/", mustWork = FALSE))
  }

  # RStudio などで source() 実行した場合に入ることがある
  if (!is.null(sys.frames()[[1]]$ofile)) {
    return(normalizePath(sys.frames()[[1]]$ofile, winslash = "/", mustWork = FALSE))
  }

  stop("スクリプトのパスを取得できませんでした。Rscriptで実行するか、source()で実行してください。")
}


# ---- メイン処理 ----

script_path <- get_script_path()
script_dir <- dirname(script_path)

# 05_kaiser-guttman/R/kaiser_guttman.R から2階層上がリポジトリルート
repo_root <- normalizePath(file.path(script_dir, "..", ".."), winslash = "/", mustWork = TRUE)

csv_path <- file.path(
  repo_root,
  "01_factor-analysis",
  "data",
  "factor_analysis_test_data.csv"
)

# 表示用は repo_root からの相対パス（GitHub公開時に見やすい）
display_csv_path <- file.path("01_factor-analysis", "data", "factor_analysis_test_data.csv")

# check.names = FALSE にして、日本語列名をそのまま扱う
df <- read.csv(csv_path, check.names = FALSE, stringsAsFactors = FALSE)

# ID列は識別子なので分析対象から除外
if ("ID" %in% names(df)) {
  df$ID <- NULL
}

# 数値列のみを分析対象にする
is_num <- vapply(df, is.numeric, logical(1))
numeric_df <- df[, is_num, drop = FALSE]

if (ncol(numeric_df) == 0) {
  stop("数値列が見つからないため、カイザー基準を計算できません。")
}

result <- kaiser_guttman_criterion(numeric_df)

# 文字列をそのまま表示するのにcat()を利用
cat("=== Kaiser-Guttman Criterion ===\n")
cat("CSV:", display_csv_path, "\n")
# paste() は文字列を結合する関数
cat("Variables:", paste(names(numeric_df), collapse = ", "), "\n")
cat("Eigenvalues:", paste(round(result$eigenvalues, 6), collapse = ", "), "\n")
cat("Number of factors (eigenvalue > 1):", result$n_factors, "\n")
