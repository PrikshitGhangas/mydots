-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- Editing
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Don't wrap long code lines
vim.opt.wrap = false

--Indentation
vim.keymap.set("n", "==", "gg=G", {
    desc = "Indent entire file",
})

-- Transparent background so Caelestia:/Foot shows through
vim.cmd.colorscheme("habamax")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

-- Plugin manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "saghen/blink.cmp",
        version = "1.*",

        opts = {
            keymap = {
                preset = "default",
            
                ["<Tab>"] = {
                    "select_and_accept",
                    "snippet_forward",
                    "fallback",
                },
            
                ["<S-Tab>"] = {
                    "snippet_backward",
                    "select_prev",
                    "fallback",
                },
            },
        
            snippets = {
                preset = "luasnip",
            },
        
            completion = {
                documentation = {
                    auto_show = true,
                },
            },
        
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            
                providers = {
                    lsp = {
                        transform_items = function(_, items)
                            local duplicates = {
                                ["main"] = true,
                                ["for"] = true,
                                ["forr"] = true,
                                ["foreach"] = true,
                                ["while"] = true,
                                ["if"] = true,
                                ["ife"] = true,
                                ["sout"] = true,
                                ["print"] = true,
                                ["scan"] = true,
                                ["method"] = true,
                                ["ctor"] = true,
                                ["arr"] = true,
                                ["nexti"] = true,
                                ["nextd"] = true,
                                ["nexts"] = true,
                                ["class"] = true,
                            }
            
                            return vim.tbl_filter(function(item)
                                return not duplicates[item.label]
                            end, items)
                        end,
                    },
                },
            },
        },

        opts_extend = { "sources.default" },
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
    
        config = function()
            local ts = require("nvim-treesitter")
    
            ts.install({
                "c",
                "cpp",
                "lua",
                "python",
                "java",
                "bash",
                "javascript",
                "typescript",
                "json",
                "html",
                "css",
                "markdown",
            })
    
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },

    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    
        config = function()
            local fzf = require("fzf-lua")
    
            fzf.setup({})
    
            vim.keymap.set("n", "<leader>ff", fzf.files,
                { desc = "Find files" })
    
            vim.keymap.set("n", "<leader>fg", fzf.live_grep,
                { desc = "Search project text" })
    
            vim.keymap.set("n", "<leader>fb", fzf.buffers,
                { desc = "Find buffers" })
    
            vim.keymap.set("n", "<leader>fr", fzf.oldfiles,
                { desc = "Recent files" })
        end,
    },

    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
            })
    
            vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>",
                { desc = "Open parent directory" })
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "",
                },
            })
        end,
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    
        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    separator_style = "thin",
                },
            })
    
            vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>",
                { desc = "Next buffer" })
    
            vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>",
                { desc = "Previous buffer" })
    
            vim.keymap.set("n", "<leader>x", "<Cmd>bdelete<CR>",
                { desc = "Close buffer" })
        end,
    },

    {
        "akinsho/toggleterm.nvim",
        version = "*",
    
        config = function()
            local toggleterm = require("toggleterm")
            local Terminal = require("toggleterm.terminal").Terminal
    
            toggleterm.setup({
                size = 50,
                direction = "vertical",
                shade_terminals = false,
                start_in_insert = true,
                persist_mode = false,
            })
    
            local terminal = Terminal:new({
                direction = "vertical",
                size = 50,
            })

            local function close_open_terminals()
                local ui = require("toggleterm.ui")
                local terms = require("toggleterm.terminal")
                local has_open, wins = ui.find_open_windows()
                if has_open then
                    for _, win in ipairs(wins) do
                        local t = terms.get(win.term_id)
                        if t then
                            t:close()
                        elseif vim.api.nvim_win_is_valid(win.window) then
                            vim.api.nvim_win_close(win.window, true)
                        end
                    end
                    vim.cmd("stopinsert!")
                    return true
                end
                return false
            end

            local function toggle_terminal()
                if close_open_terminals() then
                    return
                end

                local dir = vim.fn.expand("%:p:h")
                if dir == "" or vim.fn.isdirectory(dir) == 0 then
                    dir = vim.fn.getcwd()
                end

                terminal.dir = dir
                terminal:open()
            end

            -- Alt+Space: open/toggle/hide terminal across all modes
            vim.keymap.set({ "n", "i", "t" }, "<M-Space>", toggle_terminal, { desc = "Toggle terminal" })
        end,
    },

	{
	    "L3MON4D3/LuaSnip",
	    version = "v2.*",
	    build = "make install_jsregexp",
	    dependencies = {
	        "rafamadriz/friendly-snippets",
	    },
	
	    config = function()
	        require("luasnip.loaders.from_vscode").lazy_load({
	            exclude = { "java", "c" },
	        })
	    
	        local ls = require("luasnip")
	    
	        ls.add_snippets("java", require("snippets.java"))
	        ls.add_snippets("c", require("snippets.c"))
	    end,
	},

	{
	        "kylechui/nvim-surround",
	        version = "^4.0.0",
	        event = "VeryLazy",
	},
	    
    {
        "XiaoCRQ/Faster-OJ.nvim",
        opts = function()
            local cp_dir = vim.fn.expand("~/comp")
    
            return {
                warning_msg = true,
    
                -- Directories
                work_dir = cp_dir,
                temp_dir = cp_dir .. "/.temp",
                data_dir = cp_dir .. "/.problem",
                solve_dir = cp_dir .. "/.solve",
                template_dir = cp_dir .. "/.template",
                template_default = cp_dir .. "/.template/template.java",
    
                -- Compile commands
                compile_command = {
                    c = {
                        exec = "gcc",
                        args = {
                            "-std=c17", "-O2", "-Wall",
                            "$(FABSPATH)", "-o", "$(DIR)/$(FNOEXT)",
                        },
                    },
    
                    cpp = {
                        exec = "g++",
                        args = {
                            "-std=c++20", "-O2", "-Wall",
                            "$(FABSPATH)", "-o", "$(DIR)/$(FNOEXT)",
                        },
                    },
    
                    java = {
                        exec = "javac",
                        args = {
                            "-d", "$(DIR)", "$(FABSPATH)",
                        },
                    },
    
                    py = {
                        exec = "python3",
                        args = {
                            "-m", "py_compile", "$(FABSPATH)",
                        },
                    },
                },
    
                -- Run commands
                run_command = {
                    c = {
                        exec = "$(DIR)/$(FNOEXT)",
                    },
    
                    cpp = {
                        exec = "$(DIR)/$(FNOEXT)",
                    },
    
                    java = {
                        exec = "java",
                        args = {
                            "-cp", "$(DIR)", "$(FNOEXT)",
                        },
                    },
    
                    py = {
                        exec = "python3",
                        args = {
                            "$(FABSPATH)",
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            local foj = require("faster-oj")
            foj.setup(opts)

            local notify = require("faster-oj.module.notify")
            local handler = require("faster-oj.server.http.handler")

            local function get_problem_id(url, name)
                url = url or ""
                name = name or ""

                -- Codeforces problemset: /problemset/problem/71/A
                local c, p = url:match("codeforces%.com/problemset/problem/(%d+)/([%a%d]+)")
                if c and p then
                    return "CF" .. c .. p:upper()
                end

                -- Codeforces contest: /contest/71/problem/A
                c, p = url:match("codeforces%.com/.-contest/(%d+)/problem/([%a%d]+)")
                if c and p then
                    return "CF" .. c .. p:upper()
                end

                -- Codeforces gym: /gym/102951/problem/A
                c, p = url:match("codeforces%.com/gym/(%d+)/problem/([%a%d]+)")
                if c and p then
                    return "CF" .. c .. p:upper()
                end

                -- AtCoder: /tasks/abc300_a
                local task = url:match("atcoder%.jp/contests/[^/]+/tasks/([%a%d_]+)")
                if task then
                    return task:upper()
                end

                -- CSES: /task/1068
                local cses_id = url:match("cses%.fi/problemset/task/(%d+)")
                if cses_id then
                    return "CSES" .. cses_id
                end

                -- Direct match: e.g. "71A" or "4A"
                local num, letter = name:match("^%s*(%d+)([%a%d]+)%s*$")
                if num and letter then
                    return "CF" .. num .. letter:upper()
                end

                -- Fallback: sanitize name
                local clean = name:gsub("[^%w_]", "_"):gsub("^_+", ""):gsub("_+$", "")
                if clean == "" then
                    clean = "Solution"
                elseif clean:match("^%d") then
                    clean = "CF" .. clean
                end
                return clean
            end

            local function write_text_file(path, content)
                local f = io.open(path, "w")
                if not f then
                    return false
                end
                f:write(content)
                f:close()
                return true
            end

            handler.handle = function(json, cfg)
                handler.config = cfg
                local data_dir = cfg.data_dir
                if not data_dir or data_dir == "" then
                    return
                end
                vim.fn.mkdir(data_dir, "p")

                if not json.name then
                    return
                end

                local problem_id = get_problem_id(json.url, json.name)
                local tests = json.tests or {}
                local problem_dir = data_dir .. "/" .. problem_id
                vim.fn.mkdir(problem_dir, "p")

                local problem_json = {
                    url = json.url or "",
                    name = problem_id,
                    originalName = json.name,
                    testCount = #tests,
                    memoryLimit = json.memoryLimit or 256,
                    timeLimit = json.timeLimit or 2000,
                }

                local ok, json_str = pcall(vim.fn.json_encode, problem_json)
                if ok then
                    write_text_file(problem_dir .. "/problem.json", json_str)
                end

                for i, tc in ipairs(tests) do
                    local idx = i - 1
                    write_text_file(problem_dir .. "/" .. idx .. ".in", tc.input or "")
                    write_text_file(problem_dir .. "/" .. idx .. ".out", tc.output or "")
                end

                vim.schedule(function()
                    notify.show("Problem received: " .. problem_id .. " (" .. json.name .. ")", "INFO", 3000)
                end)

                local ext = nil
                local content = ""

                if cfg.template_default and cfg.template_default ~= "" then
                    local template_file = cfg.template_default
                    local tf = io.open(template_file, "r")
                    if tf then
                        content = tf:read("*a")
                        tf:close()
                        ext = template_file:match("^.+(%..+)$") or cfg.template_default_ext
                    end
                end

                if ext == nil then
                    ext = cfg.template_default_ext or ".java"
                end

                -- Replace class name in template with problem_id
                content = content:gsub("public%s+class%s+Main%f[%s{]", "public class " .. problem_id)
                content = content:gsub("class%s+Main%f[%s{]", "class " .. problem_id)
                content = content:gsub("%$%(CLASSNAME%)", problem_id)
                content = content:gsub("%$%(PROBLEM%)", problem_id)

                vim.fn.mkdir(cfg.work_dir, "p")
                local target_file = cfg.work_dir .. "/" .. problem_id .. ext

                local should_write = true
                if vim.fn.filereadable(target_file) == 1 then
                    local choice = vim.fn.confirm('"' .. problem_id .. '" already exists. Overwrite?', "&Yes\n&No", 2)
                    if choice ~= 1 then
                        should_write = false
                    end
                end

                if should_write then
                    local tf_out = io.open(target_file, "w")
                    if tf_out then
                        tf_out:write(content)
                        tf_out:close()
                    end
                end

                if cfg.auto_open then
                    vim.schedule(function()
                        vim.cmd("edit " .. vim.fn.fnameescape(target_file))
                        vim.api.nvim_win_set_cursor(0, { 1, 0 })
                    end)
                end
            end

            -- Auto-start FOJ services so Competitive Companion connects immediately
            vim.schedule(function()
                foj.start()
            end)
        end,
    },

	
})


-- Codeforces / Faster-OJ
	local cp_map = vim.keymap.set
	local cp_opts = { noremap = true, silent = true }

	cp_map("n", "<leader>cr", "<cmd>FOJ<CR>",
	    vim.tbl_extend("force", cp_opts, {
	        desc = "CP: Start services"
	    }))

	cp_map("n", "<leader>ct", "<cmd>FOJ run<CR>",
	    vim.tbl_extend("force", cp_opts, {
	        desc = "CP: Run test cases"
	    }))

	cp_map("n", "<leader>cs", "<cmd>FOJ submit<CR>", {
	    desc = "CP: Submit solution",
	})

	cp_map("n", "<leader>ce", "<cmd>FOJ edit<CR>",
	    vim.tbl_extend("force", cp_opts, {
	        desc = "CP: Edit custom test cases"
	    }))

	-- Put cursor inside solve() for competitive programming Java files under ~/comp/
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	    pattern = "*.java",
	    callback = function(args)
	        local file = vim.api.nvim_buf_get_name(args.buf)
	        if file == "" then
	            return
	        end

	        local real_file = vim.fs.normalize(vim.fn.fnamemodify(file, ":p"))
	        local cp_dir = vim.fs.normalize(vim.fn.expand("~/comp")) .. "/"

	        if not vim.startswith(real_file, cp_dir) then
	            return
	        end

	        local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

	        -- If this is a new empty file, populate it from template.java with matching class name
	        if #lines <= 1 and (lines[1] == nil or lines[1] == "") then
	            local class_name = vim.fn.fnamemodify(file, ":t:r")
	            local template_file = vim.fn.expand("~/comp/.template/template.java")
	            local tf = io.open(template_file, "r")
	            if tf then
	                local content = tf:read("*a")
	                tf:close()
	                content = content:gsub("public%s+class%s+Main%f[%s{]", "public class " .. class_name)
	                content = content:gsub("class%s+Main%f[%s{]", "class " .. class_name)
	                content = content:gsub("%$%(CLASSNAME%)", class_name)
	                content = content:gsub("%$%(PROBLEM%)", class_name)
	                lines = vim.split(content, "\n", { plain = true })
	                vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
	            end
	        end

	        vim.schedule(function()
	            if not vim.api.nvim_buf_is_valid(args.buf) then
	                return
	            end

	            lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)

	            local win = vim.fn.bufwinid(args.buf)
	            if win == -1 then
	                win = 0
	            end

	            for i, line in ipairs(lines) do
	                local is_comment = line:match("^%s*//") or line:match("^%s*/%*")
	                if not is_comment and line:match("^%s*.-void%s+solve%s*%(") then
	                    local target_line = i + 1
	                    if not line:find("{") then
	                        for j = i + 1, math.min(#lines, i + 5) do
	                            if lines[j]:find("{") then
	                                target_line = j + 1
	                                break
	                            end
	                        end
	                    end

	                    local target_content = lines[target_line] or ""
	                    local col = #target_content
	                    pcall(vim.api.nvim_win_set_cursor, win, { target_line, col })
	                    return
	                end
	            end
	        end)
	    end,
	})
	
	cp_map("n", "<leader>cq", "<cmd>FOJ stop<CR>",
	    vim.tbl_extend("force", cp_opts, {
	        desc = "CP: Stop services"
	    }))


-- Code runner terminal
    local runner = nil
    
    vim.keymap.set("n", "<leader>rr", function()
        if vim.bo.buftype ~= "" then
            vim.notify("Run this from a source file", vim.log.levels.WARN)
            return
        end
    
        -- Save source file
        vim.cmd("write")
    
        local file = vim.fn.expand("%:t")
        local name = vim.fn.expand("%:t:r")
        local dir = vim.fn.expand("%:p:h")
        local ft = vim.bo.filetype
    
        local cmd
    
        if ft == "java" then
            cmd = string.format(
                "cd %q && javac %q && java %q",
                dir,
                file,
                name
            )
    
        elseif ft == "c" then
            cmd = string.format(
                "cd %q && gcc %q -o %q && ./%q",
                dir,
                file,
                name,
                name
            )
    
        elseif ft == "cpp" then
            cmd = string.format(
                "cd %q && g++ %q -o %q && ./%q",
                dir,
                file,
                name,
                name
            )
    
        elseif ft == "python" then
            cmd = string.format(
                "cd %q && python %q",
                dir,
                file
            )
    
        else
            vim.notify(
                "No runner configured for " .. ft,
                vim.log.levels.WARN
            )
            return
        end
    
        local Terminal = require("toggleterm.terminal").Terminal
        local ui = require("toggleterm.ui")
        local terms = require("toggleterm.terminal")

        if runner then
            runner:shutdown()
        end

        local has_open, wins = ui.find_open_windows()
        if has_open then
            for _, win in ipairs(wins) do
                local t = terms.get(win.term_id)
                if t then
                    t:close()
                elseif vim.api.nvim_win_is_valid(win.window) then
                    vim.api.nvim_win_close(win.window, true)
                end
            end
        end

        runner = Terminal:new({
            direction = "vertical",
            size = 50,

            on_open = function()
                -- Wait for Bash/Fastfetch to finish starting
                vim.defer_fn(function()
                    runner:send(cmd, true)

                    -- Enter terminal-input mode automatically
                    vim.cmd("startinsert!")
                end, 500)
            end,
        })

        runner:open()
    
    end, { desc = "Run current file" })

-- Java LSP
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",

    callback = function()
        local jdtls = require("jdtls")

        local file = vim.api.nvim_buf_get_name(0)
        local file_dir = vim.fs.dirname(file)

        -- Find a real project root
        local root = vim.fs.root(file, {
            "pom.xml",
            "build.gradle",
            "build.gradle.kts",
            "settings.gradle",
            "settings.gradle.kts",
            ".git",
        })

        -- Standalone Java file
        if not root then
            root = file_dir
        end

        -- Every root gets its own JDTLS workspace
        local workspace = vim.fn.stdpath("cache")
            .. "/jdtls/"
            .. vim.fn.sha256(root):sub(1, 16)

        jdtls.start_or_attach({
            cmd = {
                "jdtls",
                "-data",
                workspace,
            },

            root_dir = root,
        })
    end,
})

-- C / C++ LSP
vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".git",
    },
})

vim.lsp.enable("clangd")

-- LSP signature help
vim.keymap.set("i", "<C-k>", function()
    vim.lsp.buf.signature_help()
end, { desc = "Show function signature" })

vim.api.nvim_create_autocmd("InsertCharPre", {
    callback = function()
        if vim.v.char == "(" or vim.v.char == "," then
            vim.schedule(function()
                vim.lsp.buf.signature_help({
                    focusable = false,
                    silent = true,
                })
            end)
        end
    end,
})

-- LSP navigation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float()
end, { desc = "Show diagnostic" })

-- LSP diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
        source = true,
    },
})

-- Show diagnostic under cursor
vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float()
end, { desc = "Show diagnostic" })

-- Some Keybinds
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true })
vim.keymap.set("i", "<C-Del>", "<C-o>dw", { noremap = true })
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")
