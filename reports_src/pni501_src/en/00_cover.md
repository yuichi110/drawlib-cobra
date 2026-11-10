# PNI Software Health Diagnostic Report

**Cobra (`github.com/spf13/cobra`) `v1.10.2`** — *Automated Go AST, Architecture, Hermetic Runtime & Supply-Chain Diagnostic*

This independent technical showcase evaluates **Cobra `v1.10.2`** (created by Steve Francia / [`@spf13`](https://github.com/spf13) and the Cobra Maintainers, Apache-2.0 License) across 7 software engineering dimensions using [PNI501 (`v0.1.3`)](https://pypi.org/project/pni501/) and [Drawlib](https://www.drawlib.com/). All upstream Go source files, test suites, and module manifests (`go.mod` / `go.sum`) are inspected unmodified in zero-pollution hermetic environments.

```drawlib align=center code=fold file=pni_cover_scorecard.png caption="Cobra v1.10.2 — PNI501 Overall Engineering Health Scorecard"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Colors, Styles

setup(width=146, height=58, dpi=150)

white_card = Styles.Neutral.patch(shape_fill_color=Colors.White)

outer = Panel(
    "Cobra v1.10.2 — Health Scorecard",
    "PNI501 v0.1.3 (wf-5b36d0e3) · Go Module github.com/spf13/cobra",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=12.0),
    description_style=Styles.Muted.patch(text_size=10.0),
    icon=phosphor.gauge,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=9.0,
)
outer.draw((4.5, 4.5), width=137.0, height=49.0, align="bottom_left")
inner_xy, inner_w, inner_h = outer.get_content_box(
    (4.5, 4.5),
    width=137.0,
    height=49.0,
    padding=(3.5, 3.0),
    align="bottom_left",
)

kpis = KpiCards(
    style=white_card,
    metric_style=Styles.DarkBold.patch(text_size=14.0),
    text_style=Styles.DarkBold.patch(text_size=11.2),
    description_style=Styles.Muted.patch(text_size=10.0),
    accent_style=Styles.PrimaryFlat,
    icon_style=Styles.PrimaryBold,
    accent_position="left_pill",
    metric_layout="left_column",
    metric_width_ratio=0.30,
    spacing=3.5,
)

kpis.add(
    "94 / 100",
    "Grade S Health",
    "11/14 Rules Passed (0 Fail)",
    icon=phosphor.trophy,
    style=Styles.PrimaryNeutral,
    metric_style=Styles.PrimaryBold.patch(text_size=14.5),
    accent_style=Styles.PrimaryFlat,
)
kpis.add(
    "86.8%",
    "Stmt Coverage",
    "1,631 / 1,880 Stmts · 424 Tests",
    icon=phosphor.check_circle,
    accent_style=Styles.SecondaryFlat,
)
kpis.add(
    "98.4%",
    "GoDoc Coverage",
    "173/176 Exported · 94.1% Typed",
    icon=phosphor.code,
    accent_style=Styles.PrimaryFlat,
)
kpis.add(
    "0 CVEs",
    "Module Security",
    "4 Direct Deps · 0 CWE Sinks",
    icon=phosphor.shield_check,
    accent_style=Styles.SecondaryFlat,
)

kpis.draw(xy=inner_xy, width=inner_w, height=inner_h, columns=2)

save()
```

| Audit Attribute | Value |
| :--- | :--- |
| **Target Project & Version** | `github.com/spf13/cobra` `v1.10.2` (upstream tag `88b30ab8`, Apache-2.0 License) |
| **Workflow & Run ID** | `pni501` (`wf-5b36d0e3`, category: `audit`, PNI501 `v0.1.3`) |
| **Language & Build System** | Go (`go_mod`, `go.mod` + `go.sum`, tested in `golang:1.22-bookworm`) |
| **Codebase Footprint** | `19` production `.go` files (`4,888` LOC, `17` types, `269` functions) + `17` test files (`280` test funcs) |
| **Hermetic Test & Coverage** | `424` passed, `0` failed (`--network=none`), `86.8%` statement coverage (`1,631/1,880` stmts) |
| **Overall Health Score** | **94 / 100 (`Grade S`)** — Security `98`, Testing `96`, Docs `95`, Arch `94`, Typing `93`, Deps `93`, Quality `90` |
| **Companion Documentation Portals** | [Cobra User Guide (`EN/JA`)](https://cobra.drawlib.com/) · [API Catalog](https://cobra.drawlib.com/api/) · [Internal Architecture](https://cobra.drawlib.com/architecture/) |
