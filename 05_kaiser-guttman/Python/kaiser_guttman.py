import numpy as np
import pandas as pd
from pathlib import Path


def kaiser_guttman_criterion(df: pd.DataFrame) -> tuple[int, np.ndarray]:
    """
    カイザー基準で因子数を決める。

    手順:
    1. 観測変数の相関行列を作る
    2. 相関行列の固有値を求める
    3. 固有値が 1 を超える数を数える（Kaiser-Guttman criterion）

    Parameters
    ----------
    df : pd.DataFrame
        各列が観測変数、各行がサンプルのデータフレーム（数値列のみ想定）

    Returns
    -------
    tuple[int, np.ndarray]
        (推奨因子数, 固有値配列[降順])
    """
    # df.corr() は各変数（列）どうしの相関係数をまとめた相関行列を作る。
    # 因子分析の前処理として、相関構造を見るのが基本になる。
    corr = df.corr()

    # np.linalg.eigvalsh は「対称行列（Hermitian）」向けの固有値計算。
    # 相関行列は対称行列なので、この関数が使える。
    # 戻り値は通常「昇順」なので、[::-1] で降順に並べ替える。
    eigenvalues = np.linalg.eigvalsh(corr.values)[::-1]

    # カイザー基準:
    # 標準化変数の相関行列を使う場合、固有値 > 1 の因子を残す。
    # （1変数分の分散 = 1 を上回る分散を説明している因子を残す、という考え方）
    n_factors = int(np.sum(eigenvalues > 1.0))
    return n_factors, eigenvalues


if __name__ == "__main__":
    # このファイル自身の場所からリポジトリルートを逆算している。
    # こうしておくと「どこから実行しても」同じCSVを参照しやすい。
    repo_root = Path(__file__).resolve().parents[2]
    csv_path = repo_root / "01_factor-analysis" / "data" / "factor_analysis_test_data.csv"
    display_csv_path = csv_path.relative_to(repo_root)

    # CSVを読み込む。1行目がヘッダとして解釈される。
    df = pd.read_csv(csv_path)

    # ID列は識別子なので分析対象から除外する
    # （相関や因子分析に入れると意味のない数値列になりやすい）
    if "ID" in df.columns:
        df = df.drop(columns=["ID"])

    # 数値列のみを使用（万一文字列列が混ざっていても安全）
    # 例: 名前列やカテゴリ列が混ざっていても、ここで除外できる。
    numeric_df = df.select_dtypes(include=[np.number])

    # 分析対象の数値列が1つもない場合は、その場で明示的に止める。
    if numeric_df.empty:
        raise ValueError("数値列が見つからないため、カイザー基準を計算できません。")

    # カイザー基準による推奨因子数と、判断材料になる固有値を計算。
    n_factors, eigenvalues = kaiser_guttman_criterion(numeric_df)

    # 学習用に、入力CSV・使用変数・固有値・最終判定を順に表示する。
    print("=== Kaiser-Guttman Criterion ===")
    print("CSV:", display_csv_path)
    print("Variables:", list(numeric_df.columns))
    print("Eigenvalues:", eigenvalues)
    print("Number of factors (eigenvalue > 1):", n_factors)
