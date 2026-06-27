import pandas as pd
import pingouin as pg


df = pd.read_csv("07_cronbach-alpha/data/cronbach_alpha_test_data.csv")

bunkei = df[["Kokugo", "Shakai"]]
rikei = df[["Sugaku", "Rika"]]

bunkei_alpha, bunkei_ci = pg.cronbach_alpha(data=bunkei)
rikei_alpha, rikei_ci = pg.cronbach_alpha(data=rikei)

print("Bunkei alpha:", bunkei_alpha)
print("Bunkei CI:", bunkei_ci)

print("Rikei alpha:", rikei_alpha)
print("Rikei CI:", rikei_ci)
