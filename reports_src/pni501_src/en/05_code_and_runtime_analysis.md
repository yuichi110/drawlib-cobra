# 5. Deep Dive: Code Quality, Testing & Runtime

Cobra `v1.10.2` pairs a compact, zero-bloat API surface with rigorous runtime verification across **19 Go production files** (**4,888 LOC**, **17 types**, **269 functions**) and **17 test files** (**280 test functions**). Static Go AST inspection confirms **100.0%** import hygiene, **98.4%** exported GoDoc coverage, **94.1%** type-safety coverage, and **0** excessive-parameter functions, while hermetic `--network=none` container execution verifies **424/424** passing test cases (**0** failures in `7.03s`) and **86.8%** measured statement coverage (**1,631 / 1,880** statements).

```drawlib align=center code=fold file=code_quality_fitness_heatmap.png caption="Cobra v1.10.2 Core File × Engineering Quality Dimension Fitness Matrix (0–100 Scale)"
from drawlib.canvas import save, setup
from drawlib.charts.heatmap import HeatmapChart
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=70, dpi=150)

heatmap = HeatmapChart(
    styles=[
        Styles.WarningNeutral,
        Styles.SecondaryNeutral,
        Styles.PrimaryNeutral,
        Styles.PrimaryFlat,
    ],
    x_categories=[
        "Type Safety",
        "Stmt Cov.",
        "GoDoc Cov.",
        "Maintain.",
        "Imports",
    ],
    axis_line_style=Styles.Muted,
    axis_text_style=Styles.DarkBold.patch(text_size=10.0),
    value_text_style=Styles.DarkBold.patch(text_size=10.0),
    width=91.0,
    height=49.0,
    cell_gap=0.7,
    cell_r=0.6,
    title="Core Module Fitness Matrix Across 5 Engineering Dimensions",
    title_style=Styles.BlackBold.patch(text_size=11.8),
    value_format="{:.1f}",
)
heatmap.add_row("args.go", [100.0, 100.0, 90.0, 96.0, 100.0])
heatmap.add_row("flag_groups.go", [100.0, 95.3, 100.0, 82.0, 100.0])
heatmap.add_row("completions.go", [96.0, 92.5, 93.8, 72.0, 100.0])
heatmap.add_row("bash_completions.go", [100.0, 93.3, 100.0, 86.0, 100.0])
heatmap.add_row("command.go", [91.5, 85.2, 99.0, 76.0, 100.0])
heatmap.add_row("doc/man_docs.go", [100.0, 87.5, 100.0, 92.0, 100.0])
heatmap.draw(xy=(5.5, 12.0))

panel = Panel(
    "AST & Runtime KPIs",
    "v1.10.2",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Muted.patch(text_size=9.8),
    icon=phosphor.code,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.2,
)
panel.draw((101.0, 6.0), width=40.5, height=58.0, align="bottom_left")
p_xy, p_w, p_h = panel.get_content_box(
    (101.0, 6.0), width=40.5, height=58.0, padding=(2.5, 2.5), align="bottom_left"
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
kpis.add("98.4%", "GoDoc Coverage", "173/176 exported")
kpis.add("94.1%", "Type Safety", "0 unsafe.Pointer")
kpis.add("86.8%", "Stmt Coverage", "1,631/1,880 stmts", accent_style=Styles.SecondaryFlat)
kpis.draw(xy=p_xy, width=p_w, height=p_h, columns=1)

save()
```

---

## 5.1 Hermetic Container Coverage Distribution Across Source Files

```drawlib align=center code=fold file=runtime_coverage_breakdown.png caption="Measured Statement Coverage Across Cobra v1.10.2 Source Files (go test -coverprofile in --network=none Container)"
from drawlib.canvas import save, setup
from drawlib.charts.bar import BarChart
from drawlib.shapes import rectangle
from drawlib.styles import Colors, Styles

setup(width=146, height=68, dpi=150)

rectangle(
    (73.0, 34.0),
    width=138.0,
    height=60.0,
    style=Styles.Neutral.patch(shape_r=2.0, shape_fill_color=Colors.White, shape_line_color=Colors.Gray3),
)

chart = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=[
        "zsh_\ncomp",
        "bash_\ncompV2",
        "cobra\n.go",
        "pwsh_\ncomp",
        "yaml_\ndocs",
        "doc/\nutil",
        "command\n.go",
        "man_\ndocs",
        "rest_\ndocs",
        "shell_\ncomp",
        "comp\n.go",
        "bash_\ncomp",
        "flag_\ngroups",
        "args\n.go",
    ],
    width=128.0,
    height=46.0,
    title="Measured Statement Coverage by Go Source File (%, Overall = 86.8%)",
    title_style=Styles.DarkBold.patch(text_size=11.5),
    orientation="vertical",
    bar_mode="group",
    bar_width_ratio=0.62,
    bar_r=0.8,
    axis_text_style=Styles.Dark.patch(text_size=9.2),
    grid_style=Styles.MutedThin,
    value_text_style=Styles.DarkBold.patch(text_size=9.0),
    value_format="{:.1f}",
)
chart.add_series(
    "Statement Coverage (%)",
    [52.6, 57.1, 59.4, 60.0, 78.5, 84.6, 85.2, 87.5, 90.4, 90.9, 92.5, 93.3, 95.3, 100.0],
    style=Styles.PrimaryFlat,
)
chart.configure_y_axis(min_value=0.0, max_value=110.0, tick_step=20.0, label="Coverage (%)")
chart.draw(xy=(11.0, 12.0))

save()
```

### Key Runtime & Static Analysis Observations

1. **Core Dispatch & Completion Coverage Exceeds 85%–100%**:
   - `args.go` (`100.0%`, `39/39` stmts), `active_help.go` (`100.0%`), `doc/md_docs.go` (`100.0%`), `fish_completions.go` (`100.0%`), `flag_groups.go` (`95.3%`, `121/127` stmts), `bash_completions.go` (`93.3%`, `140/150` stmts), `completions.go` (`92.5%`, `272/294` stmts), and `command.go` (`85.2%`, `647/759` stmts) are heavily exercised by the 424 offline test cases.
2. **File-Wrapper Coverage Gaps Are Isolated to Thin `os.Create` Helpers**:
   - In `zsh_completions.go` (`52.6%`, `10/19` stmts), `bash_completionsV2.go` (`57.1%`, `8/14` stmts), and `powershell_completions.go` (`60.0%`, `12/20` stmts), the core script-generation templates (`genZshComp`, `genBashComp`, `genPowerShellComp`) are 100% tested via `bytes.Buffer`, while only the convenience `Gen*CompletionFile` methods that open a disk file and delegate to `Gen*Completion(io.Writer)` remain unexercised.
3. **Linker Deadcode Elimination Verified (`TestDeadcodeElimination`)**:
   - `cobra_test.go:245` compiles a standalone CLI binary and runs `go tool nm` to verify that `reflect.Value.MethodByName` is eliminated by the Go linker when `text/template` functions are not invoked on the hot path.
