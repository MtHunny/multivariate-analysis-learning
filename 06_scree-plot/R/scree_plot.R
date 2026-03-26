# 相関行列の固有値を求めて、スクリープロットを描く

compute_eigenvalues <- function(df) {
  corr_matrix <- cor(df, use = "pairwise.complete.obs") # pairwise.complete.obsは、各ペアの変数に対して利用可能な観測値を使用して相関を計算するオプション。これにより、欠損値がある場合でも相関行列を計算できる。
  eigen(corr_matrix, symmetric = TRUE, only.values = TRUE)$values # 固有値計算。only.values = TRUEで固有ベクトルを計算せず、固有値のみを返す。Rのeigen関数は固有値を大きい順に返すため、降順に並べ替える必要はない。
}


get_script_path <- function() {
  args_all <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args_all, value = TRUE)

  if (length(file_arg) > 0) {
    return(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/", mustWork = FALSE))
  }

  if (!is.null(sys.frames()[[1]]$ofile)) {
    return(normalizePath(sys.frames()[[1]]$ofile, winslash = "/", mustWork = FALSE))
  }

  stop("スクリプトのパスを取得できませんでした。Rscriptで実行するか、source()で実行してください。")
}


plot_scree <- function(eigenvalues, output_path) {
  # PNGファイルとして描画
  # plot関数はRの基本的なプロット関数
  png(filename = output_path, width = 800, height = 500)
  plot(
    x = seq_along(eigenvalues),
    y = eigenvalues,
    type = "b",
    pch = 19,
    xlab = "Component Number",
    ylab = "Eigenvalue",
    main = "Scree Plot"
  )
  abline(h = 1, col = "red", lty = 2)
  grid()
  dev.off()
}


script_path <- get_script_path()
script_dir <- dirname(script_path)
# normalizePathで絶対パスに変換
# winslash = "/"でWindowsでもスラッシュ区切りにする
# mustWork = TRUEで存在しないパスの場合はエラーにする。
repo_root <- normalizePath(file.path(script_dir, "..", ".."), winslash = "/", mustWork = TRUE)

csv_path <- file.path(
  repo_root,
  "01_factor-analysis",
  "data",
  "factor_analysis_test_data.csv"
)

output_path <- file.path(script_dir, "scree_plot.png")

df <- read.csv(csv_path, check.names = FALSE, stringsAsFactors = FALSE)

# "ID"列があれば削除
if ("ID" %in% names(df)) {
  df$ID <- NULL
}

# 数値列のみを抽出
is_num <- vapply(df, is.numeric, logical(1)) # vapplayはdfの各列にis.numericを適用する。かつ型を第3引数で確認しており、logcial型が1つ返されることを期待している。logical型はTRUE/FALSE/NAのベクトル。
numeric_df <- df[, is_num, drop = FALSE]

if (ncol(numeric_df) == 0) {
  stop("数値列が見つからないため、スクリープロットを作成できません。")
}

eigenvalues <- compute_eigenvalues(numeric_df)
plot_scree(eigenvalues, output_path)

cat("=== Scree Plot ===\n")
cat("CSV: 01_factor-analysis/data/factor_analysis_test_data.csv\n")
cat("Variables:", paste(names(numeric_df), collapse = ", "), "\n")
cat("Eigenvalues:", paste(round(eigenvalues, 6), collapse = ", "), "\n")
cat("Saved plot: 06_scree-plot/R/scree_plot.png\n")
