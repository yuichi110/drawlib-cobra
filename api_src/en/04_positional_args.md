# PositionalArgs Type & Built-in Validator Combinators

The `args.go` source file (`L22-L132`) defines the `cobra.PositionalArgs` function type, nine exported positional argument validators and combinators, the `legacyArgs` default fallback policy, and `(*Command).ValidateArgs(args []string) error` (`command.go:L1172-L1177`).

```drawlib align=center code=fold file=api_positional_args_hero.png caption="cobra.PositionalArgs Taxonomy — Arity Bounds, ValidArgs Whitelisting & MatchAll Combinators"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=188, height=78)

_ = Colors

col_specs = [
    (
        4.0,
        "1. Arity Validators",
        Styles.PrimaryNeutral,
        Styles.PrimaryFlat,
        Styles.WhiteBold.patch(text_size=11.0),
        phosphor.hash,
        Styles.WhiteBold,
        [
            ("NoArgs & ArbitraryArgs", "Exactly 0 args or unrestricted", phosphor.prohibit, True),
            ("ExactArgs(n) & RangeArgs", "Exact N or [min, max] bounds", phosphor.sliders_horizontal, False),
            ("MinimumNArgs / MaxNArgs", "Lower (>= N) & upper (<= N)", phosphor.arrows_out_line_horizontal, False),
        ],
    ),
    (
        65.5,
        "2. Set & Combinator Checks",
        Styles.Neutral,
        Styles.SecondaryNeutral,
        Styles.DarkBold.patch(text_size=11.0),
        phosphor.list_checks,
        Styles.PrimaryBold,
        [
            ("OnlyValidArgs", "Must match Command.ValidArgs", phosphor.check_circle, False),
            ("MatchAll(pargs...)", "Short-circuit AND combinator", phosphor.git_merge, False),
            ("ExactValidArgs(n)", "Deprecated: use MatchAll", phosphor.warning, False),
        ],
    ),
    (
        127.0,
        "3. Execution & Fallback",
        Styles.Neutral,
        Styles.SecondaryNeutral,
        Styles.DarkBold.patch(text_size=11.0),
        phosphor.play_circle,
        Styles.PrimaryBold,
        [
            ("type PositionalArgs", "func(*Command, []string) error", phosphor.code, False),
            ("cmd.ValidateArgs(args)", "Runs before PersistentPreRun", phosphor.shield_check, False),
            ("legacyArgs (Default nil)", "Root subcmd check in Find()", phosphor.tree_structure, False),
        ],
    ),
]

for x0, title, body_style, hdr_style, hdr_text_style, hdr_icon, hdr_icon_style, items in col_specs:
    panel = Panel(
        title,
        "",
        style=body_style,
        header_style=hdr_style,
        text_style=hdr_text_style,
        icon=hdr_icon,
        icon_style=hdr_icon_style,
        header_variant="filled",
        header_height=8.5,
    )
    panel.draw((x0, 4.0), width=57.0, height=70.0, align="bottom_left")
    inner_xy, inner_w, inner_h = panel.get_content_box(
        (x0, 4.0),
        width=57.0,
        height=70.0,
        padding=(2.8, 2.8),
        align="bottom_left",
    )

    cards = CardList(
        style=Styles.White,
        text_style=Styles.DarkBold.patch(text_size=10.5),
        description_style=Styles.Muted.patch(text_size=10.0),
        badge_shape="rounded_rect",
        badge_style=Styles.PrimaryNeutral,
        icon_style=Styles.PrimaryBold,
        direction="vertical",
        spacing=2.6,
    )
    for mod_name, mod_desc, mod_icon, is_focal in items:
        if is_focal:
            cards.add(
                mod_name,
                mod_desc,
                icon=mod_icon,
                badge_style=Styles.PrimaryFlat,
                icon_style=Styles.WhiteBold,
            )
        else:
            cards.add(mod_name, mod_desc, icon=mod_icon)
    cards.draw(inner_xy, width=inner_w, height=inner_h, align="bottom_left")

save()
```

---

## `type` cobra.PositionalArgs & `method` (*Command).ValidateArgs

`PositionalArgs` is the function signature assigned to `Command.Args` (`args.go:L22`, `command.go:L93`, `L1172-L1177`).

```go
type PositionalArgs func(cmd *Command, args []string) error

func (c *Command) ValidateArgs(args []string) error {
	if c.Args == nil {
		return ArbitraryArgs(c, args)
	}
	return c.Args(c, args)
}
```

| Symbol | Signature | Description |
| :--- | :--- | :--- |
| `PositionalArgs` | `type PositionalArgs func(cmd *Command, args []string) error` | Function type accepting the resolved `*Command` and the slice of non-flag positional arguments (`c.Flags().Args()`, or raw `a` when `DisableFlagParsing == true`). Returning a non-nil `error` aborts `cmd.execute()` before any `*Run` hook runs. |
| `(*Command).ValidateArgs` | `func (c *Command) ValidateArgs(args []string) error` | Invoked by `cmd.execute()` immediately after `c.preRun()` (`OnInitialize`) and before `PersistentPreRun[E]`. Delegates to `c.Args(c, args)` if `c.Args != nil`, or `ArbitraryArgs(c, args)` (`nil`) if `c.Args == nil`. |

---

## `func` Complete Positional Argument Validators Reference (`args.go`)

Cobra provides two categories of exported validators in `args.go`:
1. **Direct `PositionalArgs` functions** (`NoArgs`, `OnlyValidArgs`, `ArbitraryArgs`) passed **without parentheses** (`Args: cobra.NoArgs`).
2. **Higher-order factory functions** (`MinimumNArgs`, `MaximumNArgs`, `ExactArgs`, `RangeArgs`, `MatchAll`, `ExactValidArgs`) called **with arguments** (`Args: cobra.ExactArgs(2)`) to construct a `PositionalArgs` closure.

```go
// Direct PositionalArgs Functions
func NoArgs(cmd *Command, args []string) error
func OnlyValidArgs(cmd *Command, args []string) error
func ArbitraryArgs(cmd *Command, args []string) error

// Higher-Order PositionalArgs Factories & Combinators
func MinimumNArgs(n int) PositionalArgs
func MaximumNArgs(n int) PositionalArgs
func ExactArgs(n int) PositionalArgs
func RangeArgs(min int, max int) PositionalArgs
func MatchAll(pargs ...PositionalArgs) PositionalArgs
func ExactValidArgs(n int) PositionalArgs // Deprecated: use MatchAll(ExactArgs(n), OnlyValidArgs)

// Default Fallback When Command.Args == nil During Find()
func legacyArgs(cmd *Command, args []string) error
```

| Validator / Factory | Exact Condition Checked | Exact Error String Returned on Failure (`args.go`) |
| :--- | :--- | :--- |
| `cobra.NoArgs` | `len(args) == 0` | `fmt.Errorf("unknown command %q for %q", args[0], cmd.CommandPath())` |
| `cobra.OnlyValidArgs` | If `len(cmd.ValidArgs) > 0`, every `v` in `args` must match `strings.SplitN(validArg, "\t", 2)[0]` (strips `\t` completion descriptions before checking!). | `fmt.Errorf("invalid argument %q for %q%s", v, cmd.CommandPath(), cmd.findSuggestions(args[0]))` |
| `cobra.ArbitraryArgs` | Always succeeds (`return nil`) | Never returns an error (`nil`). |
| `cobra.MinimumNArgs(n int)` | `len(args) >= n` | `fmt.Errorf("requires at least %d arg(s), only received %d", n, len(args))` |
| `cobra.MaximumNArgs(n int)` | `len(args) <= n` | `fmt.Errorf("accepts at most %d arg(s), received %d", n, len(args))` |
| `cobra.ExactArgs(n int)` | `len(args) == n` | `fmt.Errorf("accepts %d arg(s), received %d", n, len(args))` |
| `cobra.RangeArgs(min, max int)` | `len(args) >= min && len(args) <= max` | `fmt.Errorf("accepts between %d and %d arg(s), received %d", min, max, len(args))` |
| `cobra.MatchAll(pargs ...PositionalArgs)` | Evaluates each `parg(cmd, args)` sequentially from left to right | Returns the first non-nil `error` encountered, or `nil` if all `pargs` succeed. |
| `cobra.ExactValidArgs(n int)` | **Deprecated**: Equivalent to `MatchAll(ExactArgs(n), OnlyValidArgs)` | Returns the `ExactArgs(n)` error if `len(args) != n`, otherwise the `OnlyValidArgs` error. |
| `legacyArgs` *(Default when `Args == nil`)* | Checked in `Find()` (`command.go:L775`):<br>• If `!cmd.HasSubCommands()` -> `nil`<br>• If `!cmd.HasParent() && len(args) > 0` -> error<br>• Otherwise (subcommands) -> `nil` | `fmt.Errorf("unknown command %q for %q%s", args[0], cmd.CommandPath(), cmd.findSuggestions(args[0]))` |

```drawlib align=center code=fold file=api_positional_args_combinator_flow.png caption="Composing PositionalArgs Validators with MatchAll() and Custom Closures"
from drawlib.canvas import save, setup
from drawlib.diagrams.architecture import ArchitectureDiagram, Node, NodeGroup, PhosphorIcon
from drawlib.styles import Colors, Styles

setup(width=184, height=80)

_ = Colors

d = ArchitectureDiagram(
    node_style=Styles.PrimaryBold,
    node_text_style=Styles.DarkBold.patch(text_size=10.0),
    edge_style=Styles.DarkBold.patch(line_width=1.5),
    edge_text_style=Styles.Dark.patch(text_size=9.8),
    node_card_style=Styles.White,
)

input_grp = d.add(
    NodeGroup(
        "1. Parsed CLI Args",
        width=52,
        height=70,
        style=Styles.Neutral.patch(shape_r=2.0),
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(4.0, 5.0),
)

flags_args = input_grp.add(
    Node(
        "c.Flags().Args()\nNon-flag positional slice",
        icon=PhosphorIcon.TERMINAL_WINDOW,
        icon_size=6.0,
        width=42,
        height=18,
        card_style=Styles.White.patch(shape_r=2.0),
    ),
    xy=(26.0, 47.0),
)

val_call = input_grp.add(
    Node(
        "c.ValidateArgs(args)\nInvokes Command.Args",
        icon=PhosphorIcon.PLAY_CIRCLE,
        icon_size=6.0,
        width=42,
        height=18,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.0),
        card_style=Styles.PrimaryFlat.patch(shape_r=2.0),
    ),
    xy=(26.0, 20.0),
)

match_grp = d.add(
    NodeGroup(
        "2. MatchAll(ExactArgs(1), OnlyValidArgs, customValidator)",
        width=120,
        height=70,
        style=Styles.PrimaryNeutral.patch(shape_r=2.0),
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(60.0, 5.0),
)

step1 = match_grp.add(
    Node(
        "Stage 1: ExactArgs(1)\nlen(args) == 1?",
        icon=PhosphorIcon.HASH,
        icon_size=6.0,
        width=50,
        height=18,
        card_style=Styles.White.patch(shape_r=2.0),
    ),
    xy=(31.0, 47.0),
)

step2 = match_grp.add(
    Node(
        "Stage 2: OnlyValidArgs\nIn Command.ValidArgs?",
        icon=PhosphorIcon.LIST_CHECKS,
        icon_size=6.0,
        width=50,
        height=18,
        card_style=Styles.White.patch(shape_r=2.0),
    ),
    xy=(31.0, 20.0),
)

step3 = match_grp.add(
    Node(
        "Stage 3: Custom Closure\nDomain regex / path check",
        icon=PhosphorIcon.CODE,
        icon_size=6.0,
        width=50,
        height=18,
        card_style=Styles.White.patch(shape_r=2.0),
    ),
    xy=(90.0, 47.0),
)

ok_node = match_grp.add(
    Node(
        "Proceed to PreRun & RunE\nAll validators returned nil",
        icon=PhosphorIcon.CHECK_CIRCLE,
        icon_size=6.0,
        width=50,
        height=18,
        card_style=Styles.SecondaryNeutral.patch(shape_r=2.0),
    ),
    xy=(90.0, 20.0),
)

d.connect(flags_args, val_call)
d.connect(val_call, step1)
d.connect(step1, step2)
d.connect(step2, step3)
d.connect(step3, ok_node)

d.draw((0.0, 0.0))
save()
```

---

## `func` Detailed Behavior & Edge Cases

### 1. Tab-Delimited Descriptions in `OnlyValidArgs` (`args.go:L51-L66`)

Because `Command.ValidArgs` (`[]Completion`) supports `CompletionWithDesc("staging", "Staging cluster")` (which formats entries as `"staging\tStaging cluster"`), `OnlyValidArgs` explicitly strips everything from the first `\t` character onward before validating `args`:

```go
validArgs := make([]string, 0, len(cmd.ValidArgs))
for _, v := range cmd.ValidArgs {
	validArgs = append(validArgs, strings.SplitN(v, "\t", 2)[0])
}
```

### 2. Why `legacyArgs` Allows Arbitrary Args on Subcommands (`args.go:L24-L39`)

When `Command.Args` is left `nil`:
- **Root command with subcommands**: `Find()` calls `legacyArgs`, which rejects any unparsed positional argument on the root command as an `"unknown command %q for %q"` (plus Levenshtein typo suggestions).
- **Subcommands with `Args == nil`**: Both `legacyArgs` and `ValidateArgs` return `nil`, meaning **leaf subcommands accept arbitrary positional arguments by default** unless you explicitly set `Args: cobra.NoArgs` or another validator.

> [!TIP]
> **Best Practice for Leaf & Category Commands**: Always set `Args: cobra.NoArgs` on commands that do not accept positional arguments so users immediately receive an error if they pass stray arguments or misspell a flag without a leading dash.

### Example: Composing Built-in and Custom `PositionalArgs` with `cobra.MatchAll`

```go
package main

import (
	"fmt"
	"strings"

	"github.com/spf13/cobra"
)

var promoteCmd = &cobra.Command{
	Use:   "promote <environment> <version>",
	Short: "Promote a release artifact to a target environment",
	ValidArgs: []cobra.Completion{
		cobra.CompletionWithDesc("staging", "Pre-production staging environment"),
		cobra.CompletionWithDesc("prod", "Production environment"),
	},
	Args: cobra.MatchAll(
		cobra.ExactArgs(2),
		func(cmd *cobra.Command, args []string) error {
			// Validate first arg against ValidArgs
			if err := cobra.OnlyValidArgs(cmd, args[:1]); err != nil {
				return err
			}
			// Validate second arg format (semver prefix)
			if !strings.HasPrefix(args[1], "v") {
				return fmt.Errorf("version %q must start with 'v' (e.g. v1.10.2)", args[1])
			}
			return nil
		},
	),
	RunE: func(cmd *cobra.Command, args []string) error {
		cmd.Printf("Promoting %s to %s\n", args[1], args[0])
		return nil
	},
}
```
