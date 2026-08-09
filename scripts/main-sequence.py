#!/usr/bin/env python3

import argparse
import csv
import sys

def read_components():
    rows = list(csv.DictReader(sys.stdin))
    required = {"Name", "I", "A", "D"}
    missing = required.difference(rows[0] if rows else set())
    if missing:
        raise ValueError("missing columns: " + ", ".join(sorted(missing)))
    return rows


def main():
    parser = argparse.ArgumentParser(
        description="Plot Muck component cleanliness data against the Main Sequence."
    )
    parser.add_argument("output", help="PDF file to create")
    parser.add_argument(
        "--labels",
        type=int,
        default=12,
        help="number of furthest-from-sequence components to label (default: 12)",
    )
    args = parser.parse_args()

    try:
        import matplotlib.pyplot as plt
    except ImportError as error:
        parser.error("Matplotlib is required: " + str(error))

    try:
        rows = read_components()
    except (csv.Error, ValueError) as error:
        parser.error(str(error))

    if not rows:
        parser.error("no component rows found on standard input")

    instability = [float(row["I"]) for row in rows]
    abstractness = [float(row["A"]) for row in rows]
    distance = [float(row["D"]) for row in rows]

    figure, axes = plt.subplots(figsize=(8, 8))
    points = axes.scatter(
        instability, abstractness, c=distance, cmap="viridis", s=100,
        edgecolors="black", linewidths=0.5,
    )
    labelled_rows = sorted(rows, key=lambda row: float(row["D"]), reverse=True)
    for row in labelled_rows[:args.labels]:
        x = float(row["I"])
        y = float(row["A"])
        axes.annotate(
            row["Name"],
            (x, y),
            xytext=(5, 5),
            textcoords="offset points",
            fontsize=8,
            bbox={"boxstyle": "round,pad=0.2", "fc": "white", "alpha": 0.75},
        )

    axes.plot([0, 1], [1, 0], "--", color="gray", label="Main Sequence")
    axes.set_xlim(0, 1)
    axes.set_ylim(0, 1)
    axes.set_xlabel("Instability (I)")
    axes.set_ylabel("Abstractness (A)")
    axes.set_title("Muck Components vs. Main Sequence")
    axes.grid(True, alpha=0.3)
    axes.legend()
    figure.colorbar(points, ax=axes, label="Distance (D)")
    figure.tight_layout()
    figure.savefig(args.output, format="pdf")


if __name__ == "__main__":
    main()
