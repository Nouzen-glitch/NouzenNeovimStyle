# Extras (opt-in features)

Heavier features ship as **extras**: off by default, so the config behaves
exactly as before until you ask for more. A disabled extra loads nothing and
defines no keys.

Enable them in `lua/user/options.lua` (`:EliteEdit options`), then restart:

```lua
vim.g.elite_extras = { "sessions", "dashboard", "dap" }
```

`:EliteExtras` lists every extra and shows which are enabled. An unknown name
gives a warning, not an error. Plugins of an enabled extra install on the next
start (watch `:Lazy`). Run `:checkhealth elite` to see which external tools an
enabled extra is missing (always a warning, never an error).

| Extra | What it gives you | Needs | Keys |
| --- | --- | --- | --- |
| `sessions` | Restore the files and splits of a folder | nothing | `<leader>ss` `sl` `sd` |
| `dashboard` | Start screen for a bare `nvim` | nothing | shortcut letters on the screen |
| `docker` | lazydocker in a floating terminal | `docker`, `lazydocker` | `<leader>kk` |
| `database` | Database UI and SQL completion | the DB's CLI client (`psql`, `mysql`, `sqlite3`) | `<leader>kd` |
| `rest` | Run `.http` requests | `curl` | `<leader>kr`, `:EliteRest` |
| `dap` | Debugging with a variables UI | Python 3 (debugpy), Node.js (JS); Mason installs the adapters | `<leader>t…`, F-keys |

Prefixes added by extras (declared only while the extra is enabled): `s`
Session, `k` Clients, `t` Debug.

## sessions

Uses `folke/persistence.nvim`. The session of the current folder (and git
branch) is saved when you quit. It is **never** restored automatically:

| Key | Action |
| --- | --- |
| `<leader>ss` | Restore the session of this folder |
| `<leader>sl` | Restore the last session |
| `<leader>sd` | Do not save this session |

Saved in `stdpath("state")/sessions/`. Terminal and nvim-tree windows are left
out (they do not restore well). Nothing is saved from headless runs. Starting
with `nvim somefile` is unaffected.

## dashboard

Uses `goolord/alpha-nvim`. Shown only for a bare `nvim` (not for `nvim file`,
`nvim .`, stdin or headless runs). Buttons: find file, recent files, restore
session (only when `sessions` is enabled), guide, tutorial, plugins, quit. The
dashboard buffer is not listed, so `H` / `L` and the buffer tabline ignore it.
The first-run install window still appears on top of it.

## docker

No plugin: toggleterm runs `lazydocker` in a hidden floating terminal. If the
program is missing you get a message instead of an empty terminal. `jk`,
`<Esc>` and `<C-h/j/k/l>` go to lazydocker. `<C-\>` and `:TermSelect` are not
affected. Install `docker` and `lazydocker` yourself.

## database

Uses `vim-dadbod`, `vim-dadbod-ui` and `vim-dadbod-completion` (SQL buffers
only; the shipped completion sources are untouched). `<leader>kd` toggles the UI.
Needs a Nerd Font and the command-line client of each database.

**Secrets.** Connection strings contain passwords. Keep them in environment
variables, for example `export DBUI_URL=postgres://user:pass@host/db`, or add
them in the UI (saved to `stdpath("data")/db_ui/`, outside the repo). Do not put
them in files under `lua/user/`: `scripts/user-layer.sh export` and the
safety copies pack that folder, so a secret there ends up in every archive.

## rest

A small built-in runner, no plugin. `kulala.nvim` was evaluated and is not
used: it now downloads a separate `kulala-core` binary (with a license prompt)
and needs the `tree-sitter` CLI, which does not fit this config. The runner
sends the request block under the cursor with `curl` and shows the response in
a split (`q` closes it).

```http
### list
GET https://example.com/api/items
Authorization: Bearer {{API_TOKEN}}

### create
POST https://example.com/api/items
Content-Type: application/json

{"name": "x"}
```

Blocks are separated by `###`. `{{NAME}}` is replaced by the environment
variable `NAME`; an unset variable stops the request with a message. Keep
tokens in the environment, never in the file. Not supported: scripting, request
chaining, `.env` files. Prefer a full client? Add one from `lua/user/plugins/`.

## dap

Uses `nvim-dap`, `nvim-dap-ui` and `nvim-nio`. Mason installs the adapters
`debugpy`, `codelldb` and `js-debug-adapter`. Adapters and a "launch" setup are
built in for Python, C, C++, Rust, JavaScript and TypeScript. The UI opens when
a session starts and closes when it ends.

| Key | Action |
| --- | --- |
| `<leader>tb` / `<F9>` | Toggle breakpoint |
| `<leader>tc` / `<F5>` | Start / continue |
| `<F10>` `<F11>` `<S-F11>` | Step over / into / out |
| `<leader>tu` | Toggle the debug UI |
| `<leader>tx` | Stop |

Some terminals intercept F-keys (and `<S-F11>`); the `<leader>t` keys always work.
`<leader>d…` (diagnostics) is unchanged.

**Add or change an adapter** without editing shipped files, in
`lua/user/options.lua`:

```lua
vim.api.nvim_create_autocmd("User", {
    pattern = "EliteDapSetup",
    callback = function()
        local dap = require("dap")
        dap.configurations.python = {
            { type = "python", request = "launch", name = "With args", program = "${file}", args = { "--debug" } },
        }
    end,
})
```

Install extra adapters through `lua/config/languages_local.lua`'s `tools` field
or `:Mason`. Notes: `debugpy` is installed into a venv (needs Python 3 with
`venv`); `codelldb` expects a binary built with debug info (`gcc -g`).

## Persistent terminals (detach / reattach)

Not implemented as a feature. The dependable way is to run Neovim itself inside
`tmux` or `zellij`: detach with the multiplexer, and the editor, its terminals
and their running commands survive. Inside Neovim, `<C-\>` and `2<C-\>` keep
working as usual. Wrapping each toggleterm shell in `dtach` or `abduco` is
possible but needs per-terminal sockets, so it was left out until it can be
tested.

## Not shipped (needs a decision)

- **AI assistant**: depends on the vendor you pick (`claudecode.nvim`,
  `codecompanion.nvim`, Copilot, ...). Keys would come from environment variables only.
- **Windows installer**: the supported route is WSL ([INSTALL.md](INSTALL.md)).
