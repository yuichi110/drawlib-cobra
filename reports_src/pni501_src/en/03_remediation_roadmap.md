# 3. Recommended Remediation Roadmap

Cobra `v1.10.2` enters remediation planning from an exceptional **94/100 (Grade S)** baseline with **zero `P0` urgent blockers**, **zero `FAIL` compliance rules**, and **zero `CRITICAL` or `HIGH` source-code or CVE findings** across all 19 Go source files and 424 passing hermetic tests. The 5-item engineering roadmap focuses on **1 `P1` high-leverage dispatcher complexity decomposition** followed by **4 `P2` test-coverage, GoDoc, library hygiene, and `go.mod` toolchain polish items**.

```drawlib align=center code=fold file=remediation_timeline_roadmap.png caption="Figure 3.1 — Phased Engineering Refinement Roadmap for Cobra v1.10.2 (0 P0 Blockers · 1 P1 High-Leverage · 4 P2 Polish)"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.shapes import rectangle
from drawlib.smartarts import Roadmap
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=146, height=66, dpi=150)

rectangle(
    (73.0, 59.5),
    width=134.0,
    height=7.5,
    style=Styles.Neutral.patch(shape_r=1.8, shape_fill_color=Colors.Gray1, shape_line_color=Colors.Gray3),
)
phosphor.rocket_launch((11.0, 59.5), width=4.4, style=Styles.PrimaryBold)
text(
    (75.0, 59.5),
    "Cobra v1.10.2 Remediation Horizon  ·  0 P0 Blockers  |  1 P1 Refinement  |  4 P2 Polish Items",
    style=Styles.DarkBold.patch(text_size=11.0),
)

rm = Roadmap(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Dark.patch(text_size=9.8),
    spine_style=Styles.DarkBold,
    badge_style=Styles.SecondaryNeutral,
    badge_text_style=Styles.DarkBold.patch(text_size=10.5),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    curve_bend=0.0,
    card_shape="rounded_rect",
    spacing=2.8,
)

rm.add(
    "P0: None Required (0 Blockers)",
    "424/424 offline tests pass · 0 CVEs in go.mod/go.sum · 0 CWE sinks · 0 circular imports",
    badge_text="Phase 0",
    icon=phosphor.shield_check,
)

rm.add(
    "P1: Decompose getCompletions & execute Hotspots",
    "Split completions.go:getCompletions (cognitive=96) and command.go:execute (66) into helpers",
    badge_text="Phase 1",
    icon=phosphor.git_branch,
    style=Styles.PrimaryNeutral,
    badge_style=Styles.PrimaryFlat,
    badge_text_style=Styles.WhiteBold.patch(text_size=10.5),
    icon_style=Styles.PrimaryBold,
)

rm.add(
    "P2: Completion File Wrapper Tests, GoDoc 100% & go.mod 1.22+",
    "Add t.TempDir() file wrapper tests, document 3 missing symbols, remove fmt.Println in yaml_docs.go",
    badge_text="Phase 2",
    icon=phosphor.check_circle,
)

rm.draw(xy=(6.0, 5.0), width=134.0, height=50.5, align="bottom_left")

save()
```

---

## 3.1 Actionable Engineering Backlog & Traceability Matrix

```drawlib align=center code=fold file=remediation_traceability_table.png caption="Figure 3.2 — Prioritized Action Plan Traceability Matrix Across Target Files & PNI501 Rules"
from drawlib.canvas import save, setup
from drawlib.smartarts import Panel, Table
from drawlib.styles import Colors, Styles

setup(width=146, height=64, dpi=150)

outer = Panel(
    "Prioritized Remediation Backlog (5 Action Items)",
    "Mapped to Exact Target Files & Active Engineering Rules",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.2),
    description_style=Styles.Muted.patch(text_size=9.8),
    header_variant="filled",
    header_height=8.2,
)
outer.draw((4.0, 4.0), width=138.0, height=56.0, align="bottom_left")

tbl_body = Styles.Dark.patch(text_size=9.4)
tbl_hdr = Styles.WhiteBold.patch(text_size=9.8)

tbl = Table(
    cell_style=Styles.White,
    text_style=tbl_body,
    header_cell_style=Styles.PrimaryFlat,
    header_text_style=tbl_hdr,
    border_style=Styles.MutedThin,
)
tbl.set_style_cell_evenodd(
    even_color=Colors.Light,
    even_text_style=tbl_body,
    odd_color=Colors.White,
    odd_text_style=tbl_body,
)
tbl.set_style_cell_header(
    background_color=Colors.Primary,
    text_style=tbl_hdr,
)

rows = [
    ["Pri.", "Action Item Title", "Target Files", "Related Rules", "Expected Impact"],
    ["P1", "Decompose getCompletions & execute", "completions.go, command.go", "common/maintainability", "Max cognitive <= 30"],
    ["P2", "Add t.TempDir() Completion File Tests", "zsh/bashV2/pwsh_test.go", "common/runtime_verif.", "File cov >= 85%"],
    ["P2", "Document Remaining 3 Exported Symbols", "args.go, command.go", "go/code_quality", "GoDoc 98.4% -> 100%"],
    ["P2", "Remove fmt.Println in GenYamlCustom", "doc/yaml_docs.go", "common/library_guide.", "Pure error return"],
    ["P2", "Advance go.mod Directive to Go 1.22+", "go.mod", "go/dependencies", "Modern MVS pruning"],
]

tbl.draw_flexible(
    xy=(7.0, 49.5),
    column_widths=[10.0, 38.0, 31.0, 28.0, 25.0],
    row_heights=[7.2] + [7.0] * 5,
    data=rows,
    align="top_left",
)

save()
```

| Priority | Category | Action Title & Target Files | Concrete Engineering Action | Expected Impact |
| :---: | :--- | :--- | :--- | :--- |
| **`P1`** | `code_quality` | **Decompose `Command.getCompletions` and `Command.execute` Hotspots** (`completions.go`, `command.go`, `flag_groups.go`) | Factor flag-completion resolution, positional `ValidArgsFunction` invocation, and ActiveHelp synthesis out of `Command.getCompletions` (`cognitive=96`), and extract hook-chain traversal (`PersistentPreRunE`..`PersistentPostRunE`) out of `Command.execute` (`cognitive=66`). | Reduces maximum cognitive complexity below `30` and simplifies maintenance of the CLI dispatch and completion engines. |
| **`P2`** | `testing` | **Add `t.TempDir()` Unit Tests for Completion File Wrapper Methods** (`zsh_completions_test.go`, `bash_completionsV2_test.go`, `powershell_completions_test.go`) | Add table-driven unit tests using `t.TempDir()` for `GenZshCompletionFile`, `GenZshCompletionFileNoDesc`, `GenBashCompletionFileV2`, and `GenPowerShellCompletionFile`. | Lifts per-file statement coverage in `zsh_completions.go` (`52.6%`) and `bash_completionsV2.go` (`57.1%`) above `85%`. |
| **`P2`** | `documentation` | **Add GoDoc Comments to Remaining 3 Exported Symbols** (`args.go`, `command.go`, `completions.go`) | Add standard leading GoDoc comments to `PositionalArgs` (`args.go:22`), `Command.ValidateArgs` (`command.go:1172`), and `CompletionOptions.SetDefaultShellCompDirective` (`completions.go:123`). | Raises exported GoDoc coverage from `98.4%` (`173/176`) to `100.0%` (`176/176`). |
| **`P2`** | `code_quality` | **Remove Direct `fmt.Println(err)` Side Effect in `doc/yaml_docs.go`** (`doc/yaml_docs.go`) | Delete `fmt.Println(err)` at `doc/yaml_docs.go:139` before `return err` in `GenYamlCustom`. | Ensures pure library error propagation without unexpected stdout output. |
| **`P2`** | `dependencies` | **Modernize `go.mod` Toolchain Directive to Go 1.22+** (`go.mod`) | Advance `go 1.15` in `go.mod` to `go 1.22` (or `go 1.23`) once legacy consumer support windows close. | Enables modern Go module graph pruning and standard library generics/slices idioms. |
