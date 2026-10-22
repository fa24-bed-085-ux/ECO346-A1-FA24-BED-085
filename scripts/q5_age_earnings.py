import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

person = pd.read_csv(r"/pslm_person_subset.csv")
household = pd.read_csv(r"/pslm_hh_subset.csv")

merged_data = pd.merge(person, household, on="hhid")

sample_data = merged_data[
    (merged_data["prov_code"] == 1) &
    (merged_data["urban_rural"] == 2) &
    (merged_data["age"] >= 15) &
    (merged_data["age"] <= 64) &
    (merged_data["earn_annual"] > 0)
].copy()

labels = [
    "15-19", "20-24", "25-29", "30-34", "35-39",
    "40-44", "45-49", "50-54", "55-59", "60-64"
]

sample_data["age_band"] = pd.cut(
    sample_data["age"],
    bins=range(15, 66, 5),
    labels=labels,
    right=False
)

band_table = sample_data.groupby(
    "age_band", observed=False
).apply(
    lambda d: np.average(
        d["earn_annual"], weights=d["hhweight"]
    ) if len(d) else np.nan,
    include_groups=False
).reset_index(name="weighted_mean")

band_table["n_earners"] = sample_data.groupby(
    "age_band", observed=False
).size().values
band_table["midpoint"] = range(17, 63, 5)

print(band_table.to_string(index=False))

fig, ax = plt.subplots(figsize=(10, 6))

ax.scatter(
    sample_data["age"],
    sample_data["earn_annual"],
    alpha=0.25,
    label="Individual earners"
)

common = band_table["n_earners"] >= 30
thin = ~common

ax.plot(
    band_table.loc[common, "midpoint"],
    band_table.loc[common, "weighted_mean"],
    marker="o",
    label="Weighted mean (n >= 30)"
)

ax.scatter(
    band_table.loc[thin, "midpoint"],
    band_table.loc[thin, "weighted_mean"],
    facecolors="none",
    edgecolors="red",
    s=80,
    label="Thin band (n < 30)"
)

ax.set_yscale("log")
ax.set_title("Annual Earnings by Age Band")
ax.set_xlabel("Age (years)")
ax.set_ylabel("Annual Earnings (Rs, log scale)")
ax.legend()
ax.grid(True, alpha=0.2)

plt.tight_layout()
plt.savefig("q5_age_earnings.svg", format="svg", bbox_inches="tight")
plt.show()
