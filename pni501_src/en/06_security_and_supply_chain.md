# 6. Deep Dive: Security, Supply Chain & API Surface

Cobra `v1.10.2` achieves a near-perfect security posture (`security_vulnerability_audit`: **98/100, Grade S**; `security` dimension: **98/100**): all **4** direct Go module dependencies carry **zero CVEs** (`app_vuln_counts.total = 0`), deterministic Go AST SAST scanning across **19** source files (**4,888 LOC**) detects **zero CWE-classified dangerous execution sinks**, and Trivy + AST scans confirm **zero hardcoded secrets** and **zero container IaC misconfigurations**.

```drawlib align=center code=fold file=supply_chain_cve_comparison.png caption="Trivy v0.69.3 Vulnerability Isolation: Zero CVEs in Cobra v1.10.2 Go Module Dependencies vs. Ephemeral Test Harness OS"
from drawlib.canvas import save, setup
from drawlib.charts.bar import BarChart
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=68, dpi=150)

chart = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=["CRITICAL", "HIGH", "MEDIUM", "LOW"],
    width=88.0,
    height=46.5,
    title="Go Module Dependencies (go.mod / go.sum) CVE Count by Severity",
    title_style=Styles.BlackBold.patch(text_size=11.5),
    orientation="vertical",
    bar_mode="group",
    bar_width_ratio=0.68,
    bar_r=0.8,
    axis_text_style=Styles.DarkBold.patch(text_size=10.0),
    grid_style=Styles.MutedThin,
    value_text_style=Styles.DarkBold.patch(text_size=9.8),
    value_format="{:.0f}",
)
chart.add_series("Core cobra (pflag + mousetrap)", [0, 0, 0, 0], style=Styles.PrimaryFlat)
chart.add_series("cobra/doc (go-md2man + yaml/v3)", [0, 0, 0, 0], style=Styles.SecondaryFlat)
chart.configure_y_axis(min_value=0.0, max_value=10.0, tick_step=2.0, label="CVE Count")
chart.draw(xy=(5.5, 15.0))
chart.draw_legend(
    xy=(7.5, 8.0),
    text_style=Styles.DarkBold.patch(text_size=9.8),
    orientation="horizontal",
    item_gap=4.0,
)

panel = Panel(
    "Supply-Chain Posture",
    "Trivy v0.69.3",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Muted.patch(text_size=9.8),
    icon=phosphor.shield_check,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.2,
)
panel.draw((97.5, 6.0), width=44.0, height=56.0, align="bottom_left")
p_xy, p_w, p_h = panel.get_content_box(
    (97.5, 6.0), width=44.0, height=56.0, padding=(2.5, 2.5), align="bottom_left"
)

kpis = KpiCards(
    style=Styles.White,
    metric_style=Styles.PrimaryBold.patch(text_size=13.5),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.4),
    accent_style=Styles.PrimaryFlat,
    accent_position="top_bar",
    metric_layout="top_stack",
    spacing=2.5,
)
kpis.add("0 CVEs", "Go Module Graph", "All 4 direct packages clean")
kpis.add("0 Misconfigs", "Container IaC", "Non-root USER pni (10001)", accent_style=Styles.SecondaryFlat)
kpis.add("0 Secrets", "Credential Scan", "Trivy + AST verified")
kpis.draw(xy=p_xy, width=p_w, height=p_h, columns=1)

save()
```

---

## 6.1 Dependency Supply-Chain Inventory (`go.mod` & `go.sum`)

| Module Dependency | Locked Version | Scope / Consumer Package | Cryptographic `go.sum` Hash | Trivy CVE Count |
| :--- | :---: | :--- | :---: | :---: |
| `github.com/spf13/pflag` | `v1.0.9` | Core CLI flag parsing (`command.go`, `completions.go`, `flag_groups.go`) | Verified (`h1:...`) | **`0`** |
| `github.com/inconshreveable/mousetrap` | `v1.1.0` | Windows Explorer double-click detection (`command_win.go`) | Verified (`h1:...`) | **`0`** |
| `github.com/cpuguy83/go-md2man/v2` | `v2.0.6` | Markdown-to-roff Man page conversion (`doc/man_docs.go`) | Verified (`h1:...`) | **`0`** |
| `go.yaml.in/yaml/v3` | `v3.0.4` | YAML CLI reference serialization (`doc/yaml_docs.go`) | Verified (`h1:...`) | **`0`** |

> [!NOTE]
> **Ephemeral Test Harness OS Isolation**: Trivy's container image scan also inspected the Debian 12 (`golang:1.22-bookworm`) test runner OS layer (`harness_os_vuln_counts`), which is used strictly during build-time offline `go test` verification and is never linked into compiled Go binaries or imported by downstream `github.com/spf13/cobra` consumers.

---

## 6.2 AST CWE SAST & CLI Boundary Validation Primitives

```drawlib align=center code=fold file=security_posture_surface.png caption="Zero-Sink AST SAST Verification Gates & Cobra Built-In CLI Boundary Validation Primitives"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=70, dpi=150)

left_panel = Panel(
    "SAST & Hardening Gates",
    "Go AST + Trivy",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Muted.patch(text_size=9.8),
    icon=phosphor.shield_check,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
left_panel.draw((5.0, 5.5), width=62.0, height=59.0)
l_xy, l_w, l_h = left_panel.get_content_box(
    (5.0, 5.5), width=62.0, height=59.0, padding=(2.8, 2.8)
)

sast_kpis = KpiCards(
    style=Styles.White,
    metric_style=Styles.PrimaryBold.patch(text_size=14.0),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="top_bar",
    metric_layout="top_stack",
    spacing=2.8,
)
sast_kpis.add("0 Sinks", "AST CWE SAST", "No exec/SQLi/traversal")
sast_kpis.add("0 Secrets", "Secret Hygiene", "Trivy + AST clean")
sast_kpis.add(
    "0 Misconfigs",
    "IaC Hardening",
    "Non-root UID 10001",
    accent_style=Styles.SecondaryFlat,
    metric_style=Styles.SecondaryBold.patch(text_size=14.0),
)
sast_kpis.add(
    "0 Unsafe",
    "Memory Safety",
    "Zero unsafe.Pointer",
    accent_style=Styles.SecondaryFlat,
    metric_style=Styles.SecondaryBold.patch(text_size=14.0),
)
sast_kpis.draw(xy=l_xy, width=l_w, height=l_h, columns=2)

right_panel = Panel(
    "CLI Input Boundary Guards",
    "Pre-RunE Validation",
    style=Styles.PrimaryNeutral,
    header_style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=11.0),
    description_style=Styles.White.patch(text_size=9.8),
    icon=phosphor.lock_key,
    icon_style=Styles.WhiteBold,
    header_variant="filled",
    header_height=8.5,
)
right_panel.draw((70.5, 5.5), width=70.5, height=59.0)
r_xy, r_w, r_h = right_panel.get_content_box(
    (70.5, 5.5), width=70.5, height=59.0, padding=(2.8, 2.5)
)

sec_cards = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Muted.patch(text_size=9.5),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.4,
)
sec_cards.add(
    "PositionalArgs Combinators (args.go)",
    "NoArgs, ExactArgs, RangeArgs, OnlyValidArgs\n& MatchAll reject invalid CLI inputs early",
    icon=phosphor.check_circle,
    badge_style=Styles.PrimaryFlat,
    icon_style=Styles.WhiteBold,
)
sec_cards.add(
    "Relational Flag Groups (flag_groups.go)",
    "MarkFlagsMutuallyExclusive, OneRequired &\nRequiredTogether enforced before PreRunE",
    icon=phosphor.sliders_horizontal,
)
sec_cards.add(
    "Safe Shell Script Quoting (completions)",
    "__complete emits bitmask directives to stdout\nwithout invoking subshells in Go runtime",
    icon=phosphor.terminal_window,
)
sec_cards.draw(xy=r_xy, width=r_w, height=r_h)

save()
```
