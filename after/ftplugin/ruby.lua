vim.opt_local.foldmethod = 'syntax'
vim.opt_local.foldlevel = 99
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.api.nvim_set_hl(0, 'rubyComment', { ctermfg = 76 })

-- Toggle comments in Ruby
vim.api.nvim_create_user_command("ToggleRbComment", function(args)
    local start_line = args.line1 - 1
    local end_line = args.line2
    local lines = vim.api.nvim_buf_get_lines(
        0,
        start_line,
        end_line,
        false
    )
    local new_lines = {}

    for _i, line in pairs(lines) do
        if string.sub(line, 1, 1) == "#" then
            table.insert(new_lines, string.sub(line, 2))
        else
            table.insert(new_lines, "#" .. line)
        end
    end

    vim.api.nvim_buf_set_lines(0, start_line, end_line, false, new_lines)

    return ""
end, { range = true })

vim.keymap.set('v', 'gc', ":ToggleRbComment<cr>")

local function create_autocmd_and_mappings()
    vim.api.nvim_create_autocmd({'FileType ruby'}, {
        pattern = {"*.rb"},
        callback = function(ev)
            vim.o.omnifunc = 'v:lua.vim.lsp.omnifunc'
            vim.o.tagfunc = 'v:lua.vim.lsp.tagfunc'

            vim.keymap.set('n', '<Leader>K', vim.lsp.buf.hover, {
                buffer = true
            })

            vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, {
                buffer = true
            })

            -- Jump to declaration
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
                buffer = true
            })

            -- Lists all the implementations for the symbol under the cursor
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
                buffer = true
            })

            -- Jumps to the definition of the type symbol
            vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, {
                buffer = true
            })

            -- Lists all the references 
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
                buffer = true
            })

            -- Displays a function's signature information
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {
                buffer = true
            })

            -- Renames all references to the symbol under the cursor
            vim.keymap.set('n', '<Leader>n', vim.lsp.buf.rename, {
                buffer = true
            })

            -- Selects a code action available at the current cursor position
            vim.keymap.set('n', '<Leader>co', vim.lsp.buf.code_action, {
                buffer = true
            })

            -- Show diagnostics in a floating window
            vim.keymap.set('n', 'gl', vim.diagnostic.open_float, {
                buffer = true
            })

            -- Move to the previous diagnostic
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {
                buffer = true
            })

            -- Move to the next diagnostic
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
                buffer = true
            })
        end
    })
end

-- TODO: use plugins to manage most of the gory details like everone else
local function start_ruby_lsp()
    local config = {
        cmd = {'solargraph', 'stdio'},
        name = 'solargraph',
        settings = {
            solargraph = {
                diagnostics = true,
            },
        },
        init_options = { formatting = true },
        filetypes = { 'ruby' },
        root_dir = vim.fn.getcwd()
    }

    local client_id = vim.lsp.start_client(config)


    if client_id then
        create_autocmd_and_mappings()
        local bufs = vim.api.nvim_list_bufs()

        for _i, buf_id in pairs(bufs) do
            if vim.api.nvim_buf_get_option(buf_id, "filetype") == "ruby" then
                vim.lsp.buf_attach_client(buf_id, client_id)
            end
        end
    else
      print("Failed to launch server")
    end
end

vim.api.nvim_create_user_command('LaunchRubyLsp', start_ruby_lsp, {})
