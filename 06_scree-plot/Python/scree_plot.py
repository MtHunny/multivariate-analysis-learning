import numpy as np
import pandas as pd
from pathlib import Path
import matplotlib.pyplot as plt


def compute_eigenvalues(df: pd.DataFrame) -> np.ndarray:
    """
    相関行列の固有値を降順で返す。

    Parameters
    ----------
    df : pd.DataFrame
        各列が観測変数、各行がサンプルのデータフレーム（数値列のみ想定）

    Returns
    -------
    np.ndarray
        固有値配列（降順）
    """
    # 相関行列を計算し、固有値を求める
    corr = df.corr()
    # np.linalg.eigvalshは対称行列の固有値を計算する関数で、相関行列は対称行列なのでこれを使用
    # 固有値を降順に並べ替えるために[::-1]で反転
    eigenvalues = np.linalg.eigvalsh(corr.values)[::-1]
    return eigenvalues


def plot_scree(eigenvalues: np.ndarray, output_path: Path) -> None:
    """
    スクリープロットを作成してPNG保存する。
    """
    # 固有値の数に応じたコンポーネント番号を作成
    component_numbers = np.arange(1, len(eigenvalues) + 1)

    # スクリープロットを作成
    # plot関数で点をマーカー付きでプロットし、axhlineで基準線を引く
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.plot(component_numbers, eigenvalues, marker="o")
    ax.axhline(1.0, color="red", linestyle="--", linewidth=1, label="eigenvalue = 1") # 基準線を追加 横線のため可読性も考えてaxhlineを利用
    ax.set_title("Scree Plot")
    ax.set_xlabel("Component Number")
    ax.set_ylabel("Eigenvalue")
    ax.set_xticks(component_numbers)
    ax.grid(True, linestyle=":", linewidth=0.7)
    ax.legend()
    fig.tight_layout()
    fig.savefig(output_path, dpi=150)
    plt.close(fig)


if __name__ == "__main__":
    # CSVファイルのパスと出力パスを設定
    repo_root = Path(__file__).resolve().parents[2]
    csv_path = repo_root / "01_factor-analysis" / "data" / "factor_analysis_test_data.csv"
    output_path = Path(__file__).resolve().parent / "scree_plot.png"

    # CSVを読み込む
    df = pd.read_csv(csv_path)

    # "ID"列があれば削除
    if "ID" in df.columns:
        df = df.drop(columns=["ID"])

    # 数値列のみを抽出
    numeric_df = df.select_dtypes(include=[np.number])

    # 数値列がない場合はエラーを出す
    if numeric_df.empty:
        raise ValueError("数値列が見つからないため、スクリープロットを作成できません。")

    # 固有値を計算してプロットを保存
    eigenvalues = compute_eigenvalues(numeric_df)
    plot_scree(eigenvalues, output_path)

    print("=== Scree Plot ===")
    print("CSV:", csv_path.relative_to(repo_root)) # ルートからの相対パスで表示
    print("Variables:", list(numeric_df.columns))
    print("Eigenvalues:", eigenvalues)
    print("Saved plot:", output_path.relative_to(repo_root))
