# Cobra User Guide, API Reference, Architecture & PNI501 Audit (`drawlib-cobra`)

> **Unofficial Multi-Portal Documentation & Diagnostic Suite — Built with [Drawlib](https://www.drawlib.com/) & [PNI501](https://pypi.org/project/pni501/)**
>
> This repository hosts an **independent, unofficial** four-portal documentation, API catalog, internal architecture guide, and software diagnostic site covering **[Cobra (`github.com/spf13/cobra`)](https://cobra.dev/)** (`v1.10.2`, tag `88b30ab8`).
> For official Cobra documentation, generators, and release notes, always visit **[https://cobra.dev/](https://cobra.dev/)** and **[https://github.com/spf13/cobra](https://github.com/spf13/cobra)**.

---

## Live Portals (`https://cobra.drawlib.com/`)

- **Showcase Hub (`docs/index.html`)**: [https://cobra.drawlib.com/](https://cobra.drawlib.com/) (English & 日本語)
  - Unified landing hub indexing all four documentation portals, build archetypes, and bilingual entry points.
1. **Cobra User Guide (`user_guide_src/` -> `docs/user_guide/`)**: [https://cobra.drawlib.com/user_guide/](https://cobra.drawlib.com/user_guide/) (English & 日本語)
   - Practical CLI developer guide, `kubectl`/`gh`-grade enterprise CLI factory patterns (`NewRootCmd`), persistent/local flags, flag groups, Viper configuration precedence, dynamic Shell Completion V2 & ActiveHelp, `ExecuteContext` signal lifecycle, and `go test`-verified `v1.10.2` examples.
2. **Cobra API Reference Catalog (`api_src/` -> `docs/api/`)**: [https://cobra.drawlib.com/api/](https://cobra.drawlib.com/api/) (English & 日本語)
   - Searchable symbol catalog (`type = "catalog"`) covering every exported type, struct field, lifecycle hook, `PositionalArgs` validator, flag-group helper, `ShellCompDirective` bitmask, completion method, and `github.com/spf13/cobra/doc` documentation generator in Cobra `v1.10.2`.
3. **Cobra Internal Architecture Guide (`architecture_src/` -> `docs/architecture/`)**: [https://cobra.drawlib.com/architecture/](https://cobra.drawlib.com/architecture/) (English & 日本語)
   - Source-level walkthrough of how Cobra `v1.10.2` works internally: `Command` tree topology, `Find()` / `Traverse()` & `stripFlags()` argument resolution, `ExecuteC()` hook chain & `mergePersistentFlags()`, `flag_groups.go` relational validation engine, `__complete` / `__completeNoDesc` V2 shell completion protocol across Bash/Zsh/Fish/PowerShell, and `doc/` AST-free reference synthesis.
4. **PNI501 Engineering & Architecture Diagnostic Report (`pni501_src/` -> `docs/pni501/`)**: [https://cobra.drawlib.com/pni501/](https://cobra.drawlib.com/pni501/) ([PDF](https://cobra.drawlib.com/pni501/pni501.pdf))
   - Deterministic Go AST, module dependency DAG, library hygiene, hermetic container runtime (`go test` & `go vet`), and supply-chain audit generated with `pni501 v0.1.3`.

---

## Quickstart & Usage Example (Cobra `v1.10.2`)

Install Cobra in your Go module:

```bash
go get -u github.com/spf13/cobra@v1.10.2
```

Construct a testable root and subcommand tree using the factory pattern:

```go
package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

func NewRootCmd() *cobra.Command {
	var verbose bool

	rootCmd := &cobra.Command{
		Use:           "app",
		Short:         "Production CLI powered by spf13/cobra v1.10.2",
		SilenceUsage:  true,
		SilenceErrors: true,
	}
	rootCmd.PersistentFlags().BoolVarP(&verbose, "verbose", "v", false, "enable verbose output")

	versionCmd := &cobra.Command{
		Use:   "version",
		Short: "Print semantic version",
		Args:  cobra.NoArgs,
		RunE: func(cmd *cobra.Command, args []string) error {
			_, err := fmt.Fprintf(cmd.OutOrStdout(), "app v1.10.2 (verbose=%v)\n", verbose)
			return err
		},
	}
	rootCmd.AddCommand(versionCmd)
	return rootCmd
}

func main() {
	if err := NewRootCmd().Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
```

---

## Repository Layout

```text
drawlib-cobra/
├── *.go                      # Upstream Cobra v1.10.2 root package source & tests (Apache-2.0, unmodified)
├── doc/                      # Upstream Cobra v1.10.2 doc generation subpackage (Apache-2.0, unmodified)
├── go.mod                    # Upstream Cobra v1.10.2 Go module manifest (unmodified)
├── go.sum                    # Upstream Cobra v1.10.2 Go checksum lockfile (unmodified)
├── LICENSE-COBRA             # Upstream Apache-2.0 License (Copyright (c) 2013 Steve Francia)
├── LICENSE                   # Apache-2.0 License for original documentation, diagrams & audit assets
├── .pni/                     # PNI501 v0.1.3 Go workflow & audit configuration
├── user_guide_src/           # Portal 1: Cobra User Guide source (bilingual en/ja, type = "site")
├── api_src/                  # Portal 2: Cobra API Reference source (bilingual en/ja, type = "catalog")
├── architecture_src/         # Portal 3: Cobra Internal Architecture Guide source (bilingual en/ja, type = "site")
├── pni501_src/               # Portal 4: PNI501 diagnostic report source (type = "doc")
├── build.sh                  # Unified build script for all 4 portals + link checker
├── serve.sh                  # Local preview server launcher (uvx drawlib serve docs/)
└── docs/                     # Unified compiled GitHub Pages output
    ├── index.html            # Showcase Hub (All Portals landing page)
    ├── user_guide/           # Portal 1: User Guide (EN/JA)
    ├── api/                  # Portal 2: API Reference Catalog (EN/JA)
    ├── architecture/         # Portal 3: Internal Architecture Guide (EN/JA)
    └── pni501/               # Portal 4: PNI501 HTML & PDF report (pni501.pdf)
```

---

## Development, Testing & Reproducing Locally with `uvx`

Upstream `*.go`, `doc/`, `go.mod`, and `go.sum` remain unmodified from Cobra `v1.10.2`; `drawlib` and `pni501` run ephemerally via `uvx`:

```bash
# Run upstream Go unit tests & static analysis
go test -v ./...
go vet ./...

# Build all 4 portals (User Guide + API Catalog + Internal Architecture + PNI501 HTML/PDF) & check links
./build.sh

# Or build each portal individually:
./user_guide_src/build_html.sh
./api_src/build_html.sh
./architecture_src/build_html.sh
./pni501_src/build_html.sh
./pni501_src/build_pdf.sh

# Preview locally (fast start with --skip-check by default, or pass --check to validate links)
./serve.sh
./serve.sh --check
```

---

## Licensing & Attribution Notice

- **Upstream Cobra Snapshot (`*.go`, `doc/`, `go.mod`, `go.sum`)**:
  Copyright (c) 2013 Steve Francia and Cobra Contributors. Distributed under the **Apache License, Version 2.0** — see [`LICENSE-COBRA`](./LICENSE-COBRA).
- **Original Documentation, API Catalog, Diagrams & PNI501 Audit (`user_guide_src/`, `api_src/`, `architecture_src/`, `pni501_src/`, `docs/`, `.pni/`, build scripts)**:
  Copyright (c) 2026 Yuichi Ito. Distributed under the **Apache License, Version 2.0** — see [`LICENSE`](./LICENSE).
- **Attribution**:
  This repository is an independent community documentation and architecture study built with [Drawlib](https://www.drawlib.com/) and [PNI501](https://pypi.org/project/pni501/) and is not affiliated with, sponsored by, or endorsed by Steve Francia or the official Cobra maintainers.