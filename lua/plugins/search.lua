-- Поиск
return {
  -- Управление проектами
  {
    "coffebar/neovim-project",
    opts = {
      projects = { "~/src/*" },
      last_session_on_startup = false,
      picker = {
        type = "fzf-lua",
        opts = {
          sorting = "history", -- недавние проекты сверху
        },
      },
    },
    cmd = { "NeovimProjectDiscover" },
    init = function()
      -- terminal убран из sessionoptions: mksession сохраняет term:// буферы, при
      -- загрузке сессии 'buffer term://...' + 'normal! zt' падает E11 "Can't re-enter
      -- normal mode from terminal mode".
      vim.opt.sessionoptions:append("globals")
      vim.opt.sessionoptions:remove("terminal")
      -- В сессию проекта не должны попадать файлы вне каталога проекта:
      -- SessionSavePre (перед mksession) удаляем buflisted-буферы вне cwd.
      vim.api.nvim_create_autocmd("User", {
        pattern = "SessionSavePre",
        callback = function()
          local root = vim.uv.cwd()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
              local name = vim.api.nvim_buf_get_name(buf)
              if name ~= "" and not name:find(root, 1, true) then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end
        end,
      })
    end,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "Shatur/neovim-session-manager" },
    },
    lazy = false,
    priority = 100,
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local utils = require("fzf-lua.utils")
      local path = require("fzf-lua.path")

      require("fzf-lua").setup({
        winopts = {
	  fullscreen = true,
	  preview = {
	    layout = "vertical", -- всегда снизу (дефолт flex на широком экране даёт "справа")
	    vertical = "down:45%",
	    horizontal = "right:40%", -- для ручной ротации F5
	  },
        },
        formatters = {
          path = {
            truncate_left = {
              MAX_WIDTH = vim.o.columns,
              enrich = function(o)
                o.fzf_opts = vim.tbl_extend("keep", o.fzf_opts or {}, { ["--tabstop"] = 1 })
                return o
              end,
              to = function(s, opts, m)
                local _path, _utils = m.path, m.utils
                local s_clean = _utils.strip_ansi_coloring(s)
                local tail = _path.tail(s_clean)
                local parent = _path.parent(s_clean)
                if not parent then return tail end

                local display = _path.remove_trailing(parent) .. "/" .. tail
                local max_w = opts and opts.MAX_WIDTH or 80
                if #display > max_w then
                  local keep = max_w - 4
                  display = "..." .. display:sub(#display - keep + 1)
                end

                local dir_part = display:sub(1, #display - #tail)
                local fname = display:sub(#display - #tail + 1)
                return dir_part .. fname
              end,
              from = function(s)
                s = utils.strip_ansi_coloring(s)
                local fname, parent = s:match("^(.+)\t(.+)$")
                if fname and parent then
                  return path.remove_trailing(parent) .. "/" .. fname
                end
                return s
              end,
            },
          },
        },
        files = {
          -- previewer = false,
          -- fd_opts = [[--color=never --glob *.py]],
          fzf_opts = { ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-files-history' },
          -- formatter = "path.truncate_left",
        },
        grep = {
          fzf_opts = { ['--history'] = vim.fn.stdpath('data') .. '/fzf-lua-grep-history' },
        },
        buffers = {
          prompt = 'Buffers> ',
          cmd = 'echo $FZF_BUFFERS',
          formatter = 'path.dirname_first',
          show_unloaded = true,
          ignore_current_buffer = false,
        },
        lsp = {
          document_symbols = {
            regex_filter = function(item, curbuf)
              local exclude = { 'Variable', 'Field', 'EnumMember' }
              for _, kind in ipairs(exclude) do
                if item.kind == kind then return false end
              end
              return true
            end,
          },
        },
      })
    end,
  }
}
