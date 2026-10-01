-- User-facing guidance: :EliteHelp (one-screen guide), :EliteTutor (practice
-- buffer), :EliteEdit (create/open your personal files), :EliteBackup.
local M = {}

local function cfg()
    return vim.fn.stdpath("config")
end

function M.repo()
    return vim.uv.fs_realpath(cfg()) or cfg()
end

-- Shared by every install (alongside or replace); scripts/user-layer.sh uses the same folder.
function M.backup_dir()
    return vim.fs.dirname(vim.fn.stdpath("state")) .. "/elite-backups"
end

function M.help_lines()
    local repo = vim.fn.fnamemodify(M.repo(), ":~")
    return {
        "ELITE NEOVIM: what you can do, and what you should do",
        "(open again any time: :EliteHelp or <leader>fi. <leader> is the Space bar.)",
        "",
        "FIND YOUR WAY",
        "  <leader>?    every key, grouped          <leader>fk   search all keys",
        "  <leader>fc   search commands             <leader>fC   generated cheatsheet",
        "  <leader>fh   Neovim's built-in help      :EliteTutor  short practice tutorial",
        "  New to Vim? :Tutor is Neovim's own 30-minute tutorial.",
        "",
        "MAKE IT YOURS (never edit shipped files: updates would stop)",
        "  :EliteEdit options     your options and vim.g.elite_* switches",
        "  :EliteEdit keymaps     your keys (always give each a desc = \"...\")",
        "  :EliteEdit plugins     your plugins, or tweaks to shipped ones",
        "  :EliteEdit languages   add a language (server, parser, formatter)",
        "  :EliteKeys             shipped keys your keymaps replaced or delayed",
        "  :EliteExtras           opt-in features (sessions, dashboard, docker, database, rest, dap)",
        "",
        "KEEP YOUR FILES SAFE (lua/user/ is yours and is NOT in git)",
        "  Save them:  :EliteBackup   or   scripts/user-layer.sh export FILE",
        "  Install/update scripts also save a safety copy first (see :checkhealth elite).",
        "  New machine: git clone, run scripts/install.sh, then",
        "               scripts/user-layer.sh import FILE",
        "  Never delete or re-clone the repo folder without exporting first:",
        "  " .. repo,
        "  Install with scripts/install.sh, not by cloning into ~/.config/nvim:",
        "  you get undo, a backup of your old config and the nvim-elite launcher.",
        "",
        "KEEP IT CURRENT",
        "  Config:  scripts/update.sh (run from the repo)     Plugins: :Lazy, then U",
        "  Undo:    scripts/uninstall.sh                      How installed: :EliteInfo",
        "",
        "WHEN SOMETHING IS WRONG",
        "  :checkhealth elite   tools, install state, your files, key conflicts",
        "  Icons show as boxes: set a Nerd Font as your terminal's font.",
        "  Docs: docs/GETTING_STARTED.md, INSTALL.md, MIGRATING.md, KEYBINDINGS.md",
    }
end

function M.tutor_lines()
    local rule = string.rep("-", 70)
    return {
        "ELITE NEOVIM TUTORIAL (about 10 minutes)",
        "This is a scratch buffer: type in it freely, nothing is saved. Close with :q",
        "<leader> is the Space bar. <C-s> means Ctrl+s. Arrow keys are off on purpose.",
        "Never used Vim? Run :Tutor first (Neovim's own tutorial), then come back.",
        "",
        rule,
        "1. MOVING AND EDITING",
        rule,
        "  h j k l   move             i    start typing      jk   leave Insert mode",
        "  w b e     by word          0 $  line start / end  u    undo   <C-r> redo",
        "  dd yy p   cut / copy / paste a line",
        "  ciw       change the word under the cursor   ci\"  change inside quotes",
        "  gcc       comment or uncomment the line",
        "Try: put the cursor on this word, type ciw, type a new word, press jk.",
        "",
        rule,
        "2. FINDING THINGS",
        rule,
        "  <leader>ff  find a file by name      <leader>fg  search text in the project",
        "  <leader>fr  recent files             <leader>fb  open buffers",
        "  H / L       previous / next buffer (open files are shown along the top)",
        "Try: press <leader>ff, type part of a file name, press Enter.",
        "(<leader>fg needs ripgrep: :checkhealth elite tells you if it is missing.)",
        "",
        rule,
        "3. CODE INTELLIGENCE (open a real file in a supported language)",
        rule,
        "  gd definition   gr references   K docs under cursor   <leader>rn rename",
        "  <leader>ca code action   <leader>cf format (also runs on save)",
        "  ]d / [d next / previous problem   <leader>xx list all problems",
        "  Completion while typing: <C-Space> open, Tab or <C-j>/<C-k> choose, Enter accept",
        "  <C-s> in Insert mode shows a function's signature.",
        "  Nothing happens? :checkhealth vim.lsp and :Mason show what is installed.",
        "",
        rule,
        "4. WINDOWS, FILES, TERMINAL",
        rule,
        "  <leader>e   file explorer (g? inside it lists its keys)",
        "  <C-h/j/k/l> move between windows    <leader>wv / <leader>ws  split",
        "  <C-\\>       toggle a terminal       jk or Esc  leave terminal mode",
        "  <C-s>       save the file            <leader>q  close the window",
        "",
        rule,
        "5. NEVER LOSE A KEY",
        rule,
        "  Press <leader> and wait: which-key lists what comes next.",
        "  <leader>?  every key      <leader>fk  search keys      <leader>fC  cheatsheet",
        "Try: press <leader>fk and type 'format'.",
        "",
        rule,
        "6. MAKE IT YOURS, AND KEEP IT",
        rule,
        "  :EliteEdit keymaps / options / plugins / languages   creates and opens your file",
        "  :EliteKeys      shows shipped keys your keymaps replaced",
        "  :EliteBackup    saves your personal files (they are not in git!)",
        "  :EliteHelp      the one-screen guide",
        "Try: :EliteEdit options, read the comments, then :EliteBackup.",
        "",
        "Done. Learning order and every key: docs/KEYBINDINGS.md",
    }
end

local TARGETS = {
    options = { file = "lua/user/options.lua", example = "lua/user/options.lua.example" },
    keymaps = { file = "lua/user/keymaps.lua", example = "lua/user/keymaps.lua.example" },
    plugins = { file = "lua/user/plugins/mine.lua", example = "lua/user/plugins/example.lua.example" },
    languages = {
        file = "lua/config/languages_local.lua",
        stub = "-- Your languages (server, parser, formatter). Restart Neovim after editing.\n"
            .. "-- Format and examples: docs/ADDING_LANGUAGES.md, languages_local.lua.example\n"
            .. "return {\n"
            .. '    -- go = { lsp = "gopls", parser = "go", formatter = "gofumpt", tools = { "gofumpt" } },\n'
            .. "}\n",
    },
}

local function edit(which)
    local t = TARGETS[which]
    if not t then
        vim.notify("Usage: :EliteEdit options|keymaps|plugins|languages", vim.log.levels.WARN)
        return
    end
    local root = cfg()
    local path = root .. "/" .. t.file
    if not vim.uv.fs_stat(path) then
        vim.fn.mkdir(vim.fs.dirname(path), "p")
        local example = t.example and (root .. "/" .. t.example)
        if example and vim.uv.fs_stat(example) then
            vim.uv.fs_copyfile(example, path)
        else
            vim.fn.writefile(vim.split(t.stub, "\n", { trimempty = true }), path)
        end
        vim.notify("Created " .. t.file .. " (yours: not in git, untouched by updates). Restart Neovim after editing.")
    end
    vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function backup(opts)
    local script = M.repo() .. "/scripts/user-layer.sh"
    if vim.fn.executable(script) ~= 1 then
        vim.notify("scripts/user-layer.sh was not found or is not executable.", vim.log.levels.WARN)
        return
    end
    local out = opts.args ~= "" and vim.fn.expand(opts.args)
        or vim.fn.expand("~/elite-user-layer-" .. os.date("%Y%m%d") .. ".tar.gz")
    vim.system({ script, "export", out }, { text = true }, function(res)
        vim.schedule(function()
            if res.code == 0 then
                vim.notify("Personal files exported to " .. out
                    .. "\nRestore on any machine: scripts/user-layer.sh import " .. out)
            else
                local msg = (res.stderr and res.stderr ~= "") and res.stderr or res.stdout
                vim.notify("Backup failed:\n" .. tostring(msg), vim.log.levels.ERROR)
            end
        end)
    end)
end

local function tutor()
    vim.cmd("tabnew")
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, M.tutor_lines())
    pcall(vim.api.nvim_buf_set_name, buf, "Elite tutorial")
    vim.bo[buf].filetype = "markdown"
    vim.cmd("normal! gg")
end

function M.setup()
    vim.api.nvim_create_user_command("EliteHelp", function()
        require("util.welcome").show(M.help_lines(), "Elite guide")
    end, { desc = "One-screen guide: what you can do and should do" })

    vim.api.nvim_create_user_command("EliteTutor", tutor, { desc = "Short practice tutorial for this config" })

    vim.api.nvim_create_user_command("EliteEdit", function(o)
        edit(o.args)
    end, {
        nargs = 1,
        desc = "Create/open your personal file: options, keymaps, plugins, languages",
        complete = function()
            return { "options", "keymaps", "plugins", "languages" }
        end,
    })

    vim.api.nvim_create_user_command("EliteExtras", function()
        require("util.welcome").show(require("util.extras").lines(), "Extras")
    end, { desc = "List opt-in extras and which are enabled" })

    vim.api.nvim_create_user_command("EliteBackup", backup, {
        nargs = "?",
        complete = "file",
        desc = "Export your personal files to an archive (default: ~/elite-user-layer-<date>.tar.gz)",
    })
end

return M
