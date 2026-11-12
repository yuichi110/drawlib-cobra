# 2. Architecture & Source Code Structure

Cobra `v1.10.2` organizes **19 Go production source files** (**4,888 LOC**, **17 exported types**, **269 functions**) and **17 test files** (**280 test functions**) into a clean **4-Layer Composite Command Tree & Extension Subsystem** architecture (**94/100**, Grade **S**). The root package (`github.com/spf13/cobra`) encapsulates the composite `Command` tree, `pflag` inheritance, relational flag groups, and the Shell Completion V2 engine while isolating Markdown, Man, ReST, and YAML reference generators inside the `github.com/spf13/cobra/doc` subpackage.

```drawlib align=center code=fold file=arch_source_tree.png caption="Cobra v1.10.2 Source Package Tree & Subsystem LOC Distribution (19 Production Files, 4,888 LOC)"
from drawlib.canvas import save, setup
from drawlib.fonts import FontMonoSpace, FontRoboto
from drawlib.icons import phosphor
from drawlib.smartarts import Panel, Table, TreeNode
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=146, height=82, dpi=150)

text(
    (73.0, 78.2),
    "Cobra v1.10.2 — Physical Package Layout & Subsystem Inventory (19 Source Files · 4,888 LOC)",
    style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=12.5),
)

left_panel = Panel(
    "Go Module Tree",
    "0 Cycles",
    style=Styles.Neutral,
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=11.0),
    description_style=Styles.Muted.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5),
    icon=phosphor.folder_open,
    icon_style=Styles.DarkBold,
    header_variant="filled",
    header_height=7.8,
)
left_panel.draw((4.0, 4.5), width=56.0, height=70.0, align="bottom_left")

TreeNode.register_drawing_item(
    name="pkg_dir",
    location="before",
    padding_width=3.8,
    function=phosphor.folder,
    style=Styles.Primary.patch(icon_color=Colors.Primary, icon_style="fill"),
    args={"width": 2.7},
)
TreeNode.register_drawing_item(
    name="go_mod",
    location="before",
    padding_width=3.8,
    function=phosphor.file_code,
    style=Styles.Secondary.patch(icon_color=Colors.Secondary, icon_style="regular"),
    args={"width": 2.6},
)

node_text = Styles.Dark.patch(text_font=FontMonoSpace.ROBOTO_MONO_REGULAR, text_size=9.5)
root_text = Styles.DarkBold.patch(text_font=FontMonoSpace.ROBOTO_MONO_BOLD, text_size=9.6)

root = TreeNode(
    "github.com/spf13/cobra (4,888 LOC)",
    text_style=root_text,
    line_style=Styles.Muted.patch(line_width=1.1),
    line_horizontal_margin=2.2,
    line_horizontal_length=2.4,
    line_vertical_margin=4.05,
).set_drawing_item("pkg_dir")

root.add("command.go (1,417 LOC)", text_style=root_text).set_drawing_item("go_mod")
root.add("cobra.go (159 LOC)", text_style=node_text).set_drawing_item("go_mod")
root.add("args.go (83 LOC)", text_style=node_text).set_drawing_item("go_mod")
root.add("flag_groups.go (211 LOC)", text_style=node_text).set_drawing_item("go_mod")
root.add("completions.go (600 LOC)", text_style=root_text).set_drawing_item("go_mod")
root.add("active_help.go & shell (61 LOC)", text_style=node_text).set_drawing_item("go_mod")
root.add("bash_completions*.go (1,004)", text_style=node_text).set_drawing_item("go_mod")
root.add("zsh/fish/pwsh_*.go (723)", text_style=node_text).set_drawing_item("go_mod")

doc_dir = root.add("doc/ (5 files · 608 LOC)", text_style=root_text).set_drawing_item("pkg_dir")
doc_dir.add("md/man/rest/yaml_docs.go", text_style=node_text).set_drawing_item("go_mod")

root.draw(xy=(7.0, 64.5))

right_panel = Panel(
    "Subsystem Breakdown",
    "19 Files · 86.8% Cov",
    style=Styles.White,
    header_style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=11.0),
    description_style=Styles.White.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5),
    icon=phosphor.table,
    icon_style=Styles.White,
    header_variant="filled",
    header_height=7.8,
)
right_panel.draw((63.0, 4.5), width=79.0, height=70.0, align="bottom_left")

tbl_body = Styles.Dark.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5)
tbl_code = Styles.DarkBold.patch(text_font=FontMonoSpace.ROBOTO_MONO_REGULAR, text_size=9.4)
tbl_hdr = Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=9.8)

tbl = Table(
    cell_style=Styles.White,
    text_style=tbl_body,
    header_cell_style=Styles.SecondaryNeutral,
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
    background_color=Colors.SecondaryNeutral,
    text_style=tbl_hdr,
)
tbl.set_style_cell(
    background_color=Colors.Light,
    text_style=tbl_code,
    rows=[1, 2, 3, 4, 5, 6],
    columns=[0],
)

inventory_rows = [
    ["Subsystem", "Files", "LOC", "Cov.", "Primary Responsibility"],
    ["Core Tree & Exec", "4", "1,598", "84.1%", "Command struct, Find, ExecuteC"],
    ["Args & Flag Groups", "2", "294", "96.4%", "PositionalArgs & flag groups"],
    ["Completion Engine", "3", "661", "92.6%", "__complete protocol & ActiveHelp"],
    ["Shell Generators", "5", "1,727", "86.1%", "Bash V1/V2, Zsh, Fish & Pwsh"],
    ["cobra/doc Package", "5", "608", "86.5%", "MD, Man, ReST & YAML doc trees"],
    ["Total / Overall", "19", "4,888", "86.8%", "17 exported types · 269 funcs"],
]

tbl.draw_flexible(
    xy=(65.5, 63.5),
    column_widths=[21.5, 6.5, 8.0, 9.0, 29.0],
    row_heights=[6.5] + [7.6] * 6,
    data=inventory_rows,
    align="top_left",
)

save()
```

---

## 2.1 Four-Layer Subsystem Dependency Topology

```drawlib align=center code=fold file=arch_layer_thermal_dag.png caption="Cobra v1.10.2 Four-Layer Internal Architecture & External Dependency Isolation"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=146, height=72, dpi=150)

white_card = Styles.Neutral.patch(shape_fill_color=Colors.White)

left = Panel(
    "4-Layer Internal Subsystem Stack",
    "Acyclic Layering",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.2),
    description_style=Styles.Muted.patch(text_size=9.8),
    icon=phosphor.stack,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
left.draw((4.5, 4.5), width=82.0, height=63.0, align="bottom_left")
l_xy, l_w, l_h = left.get_content_box(
    (4.5, 4.5), width=82.0, height=63.0, padding=(3.0, 2.5), align="bottom_left"
)

layers = CardList(
    style=white_card,
    text_style=Styles.DarkBold.patch(text_size=10.4),
    description_style=Styles.Muted.patch(text_size=9.5),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.2,
)
layers.add(
    "Layer 4 · CLI Doc Generators (cobra/doc)",
    "md_docs.go · man_docs.go · rest_docs.go · yaml_docs.go",
    icon=phosphor.file_text,
)
layers.add(
    "Layer 3 · Shell Completion V2 & Script Generators",
    "completions.go · active_help.go · bash/zsh/fish/powershell",
    icon=phosphor.terminal_window,
)
layers.add(
    "Layer 2 · Positional Args & Relational Flag Groups",
    "args.go (NoArgs..MatchAll) · flag_groups.go (MutuallyExclusive)",
    icon=phosphor.sliders_horizontal,
)
layers.add(
    "Layer 1 · Core Command Tree & Lifecycle Engine",
    "command.go (Command, Find, Traverse, ExecuteC) · cobra.go",
    icon=phosphor.tree_structure,
    style=Styles.PrimaryNeutral,
    badge_style=Styles.PrimaryFlat,
    icon_style=Styles.WhiteBold,
)
layers.draw(xy=l_xy, width=l_w, height=l_h)

right = Panel(
    "External Dependencies",
    "4 Direct",
    style=Styles.Neutral,
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.2),
    description_style=Styles.Muted.patch(text_size=9.8),
    icon=phosphor.package,
    icon_style=Styles.DarkBold,
    header_variant="filled",
    header_height=8.5,
)
right.draw((89.5, 4.5), width=52.0, height=63.0, align="bottom_left")
r_xy, r_w, r_h = right.get_content_box(
    (89.5, 4.5), width=52.0, height=63.0, padding=(3.0, 2.5), align="bottom_left"
)

deps = CardList(
    style=white_card,
    text_style=Styles.DarkBold.patch(text_size=10.0),
    description_style=Styles.Muted.patch(text_size=9.2),
    badge_shape="rounded_rect",
    badge_style=Styles.SecondaryNeutral,
    icon_style=Styles.SecondaryBold,
    direction="vertical",
    spacing=2.2,
)
deps.add(
    "spf13/pflag v1.0.9",
    "POSIX/GNU FlagSet (Layer 1–3)",
    icon=phosphor.flag,
    style=Styles.PrimaryNeutral,
    badge_style=Styles.PrimaryFlat,
    icon_style=Styles.WhiteBold,
)
deps.add(
    "mousetrap v1.1.0",
    "Win Explorer guard (command_win)",
    icon=phosphor.desktop,
)
deps.add(
    "go-md2man/v2 v2.0.6",
    "Man roff serializer (cobra/doc)",
    icon=phosphor.book_open,
)
deps.add(
    "go.yaml.in/yaml/v3",
    "YAML doc serializer (cobra/doc)",
    icon=phosphor.brackets_curly,
)
deps.draw(xy=r_xy, width=r_w, height=r_h)

save()
```

---

## 2.2 Core Execution Flows & Runtime Lifecycles

```drawlib align=center code=fold file=arch_execution_flows.png caption="Cobra v1.10.2 Core Runtime Lifecycles: ExecuteC Command Dispatch, __complete V2 Protocol & cobra/doc Synthesis"
from drawlib.canvas import save, setup
from drawlib.fonts import FontRoboto
from drawlib.icons import phosphor
from drawlib.smartarts import Panel, Roadmap
from drawlib.styles import Styles

setup(width=146, height=74, dpi=150)

frame = Panel(
    "Cobra v1.10.2 — Core Runtime Execution Lifecycles",
    "In-Memory Tree Resolution & Hook Chain",
    style=Styles.White,
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=11.5),
    description_style=Styles.Muted.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.8),
    icon=phosphor.pulse,
    icon_style=Styles.DarkBold,
    header_variant="filled",
    header_height=8.2,
)
frame.draw((4.0, 4.0), width=138.0, height=66.0, align="bottom_left")
inner_xy, inner_w, inner_h = frame.get_content_box(
    (4.0, 4.0),
    width=138.0,
    height=66.0,
    padding=(4.0, 3.2),
    align="bottom_left",
)

rm = Roadmap(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=10.6),
    description_style=Styles.Dark.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.6),
    spine_style=Styles.DarkBold,
    badge_style=Styles.SecondaryNeutral,
    badge_text_style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=10.0),
    icon_style=Styles.DarkBold,
    direction="vertical",
    curve_bend=0.0,
    card_shape="rounded_rect",
    spacing=3.0,
)

rm.add(
    "Flow 1 · CLI Command Resolution & Hook Pipeline (Execute / ExecuteContext)",
    "Find()/Traverse() + stripFlags() -> mergePersistentFlags() -> FlagGroups/Args -> PreRunE..PostRunE",
    badge_text="ExecuteC",
    icon=phosphor.terminal_window,
    style=Styles.PrimaryNeutral,
    badge_style=Styles.PrimaryFlat,
    badge_text_style=Styles.WhiteBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=10.0),
    icon_style=Styles.PrimaryBold,
)

rm.add(
    "Flow 2 · Dynamic Shell Completion V2 Protocol (__complete / __completeNoDesc)",
    "initCompleteCmd -> getCompletions() -> checkIfFlagCompletion / ValidArgsFunction -> :Directive",
    badge_text="TAB Comp",
    icon=phosphor.lightning,
)

rm.add(
    "Flow 3 · Static Multi-Format Reference Tree Synthesis (cobra/doc)",
    "GenMarkdownTree / GenManTree / GenReSTTree / GenYamlTree -> Recursive Command Tree Walk",
    badge_text="DocGen",
    icon=phosphor.file_code,
)

rm.draw(xy=inner_xy, width=inner_w, height=inner_h, align="bottom_left")

save()
```

### Three Canonical Execution Lifecycles

1. **Flow 1 — CLI Command Resolution & Hook Execution Pipeline (`Command.ExecuteC`)**:
   - `ExecuteContext(ctx)` binds `context.Context` to the root `Command` and invokes `ExecuteC()`.
   - `ExecuteC()` initializes default completion, help, and version commands/flags, then resolves `os.Args[1:]` via `Command.Find()` (or `Command.Traverse()` when `TraverseChildren: true`), using `stripFlags()` to skip flag tokens and flag values while descending the subcommand tree.
   - `Command.execute()` merges ancestor `PersistentFlags()` via `mergePersistentFlags()`, parses flags with `pflag`, runs `cobra.OnInitialize(...)` callbacks, validates required flags (`ValidateRequiredFlags`), relational flag groups (`ValidateFlagGroups`), and positional arguments (`ValidateArgs`), and executes hooks in strict order: `PersistentPreRunE` -> `PreRunE` -> `RunE` -> `PostRunE` -> `PersistentPostRunE` -> `OnFinalize`.
2. **Flow 2 — Dynamic Shell Completion V2 Protocol (`__complete` / `__completeNoDesc`)**:
   - Shell scripts generated by `GenBashCompletionV2`, `GenZshCompletion`, `GenFishCompletion`, and `GenPowerShellCompletionWithDesc` invoke `<binary> __complete <args...>` when the user presses `TAB`.
   - `Command.getCompletions()` parses partial flags without invoking `RunE`, checks whether the cursor is completing a flag via `checkIfFlagCompletion()`, or enforces flag-group exclusions (`enforceFlagGroupsForCompletion`) and calls `ValidArgsFunction` / `ValidArgs`, emitting candidates plus a trailing `:<ShellCompDirective>` bitmask (`ShellCompDirectiveNoFileComp = 4`, etc.) and optional `_activeHelp_` hints.
3. **Flow 3 — AST-Free Multi-Format Documentation Synthesis (`cobra/doc`)**:
   - `GenMarkdownTree`, `GenManTree`, `GenReSTTree`, and `GenYamlTree` walk the live `Command` hierarchy, rendering `Use`, `Short`, `Long`, `Example`, local flags, inherited persistent flags, and sorted parent/child cross-links without requiring source-code AST parsing.
