-- ~/.config/nvim/plugin/git_branch.lua

local M = {}

function M.create_branch()
  -- Проверяем, находимся ли в Git-репозитории
  if vim.fn.system("git rev-parse --git-dir 2>/dev/null"):match("fatal") then
    vim.notify("Not a git repository", vim.log.levels.ERROR)
    return
  end

  -- Шаг 1: Выбираем префикс
  vim.ui.select(
    { "feature", "bugfix" },
    { prompt = "Select branch prefix:" },
    function(prefix)
      if not prefix then
        return
      end

      -- Шаг 2: Запрашиваем суффикс
      vim.ui.input({
        prompt = "Enter branch suffix: ",
      }, function(suffix)
        if not suffix or suffix == "" then
          vim.notify("Suffix cannot be empty", vim.log.levels.WARN)
          return
        end

        -- Шаг 3: Формируем название ветки, создаём и переключаемся на неё
        local branch_name = string.format("%s/FROV-%s", prefix, suffix)
        local cmd = string.format("git switch -c %s 2>&1", vim.fn.shellescape(branch_name))
        local result = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          vim.notify(
            string.format("✓ Switched to new branch '%s'", branch_name),
            vim.log.levels.INFO
          )
        else
          vim.notify(
            string.format("✗ Error creating branch: %s", result),
            vim.log.levels.ERROR
          )
        end
      end)
    end
  )
end

-- Регистрируем команду
vim.api.nvim_create_user_command('GitCreateBranch', M.create_branch, {})

-- return M
--
