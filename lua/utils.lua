local M = {}

--- Возвращает список строк, которые начинаются с указанного ключа
---@param lines string[] Список строк
---@param key string Префикс для фильтрации
---@return string[] Отфильтрованный список строк
function M.filter_by_prefix(lines, key)
  local result = {}
  for _, line in ipairs(lines) do
    if line:sub(1, #key) == key then
      table.insert(result, line)
    end
  end
  return result
end

return M