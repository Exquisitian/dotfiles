return {
  'git@github.com:FeiyouG/command_center.nvim.git',

  config = function()
    local command_center = require("command_center")

    -- Integrate with telescope
    local has_telescope, telescope = pcall(require, "telescope")
    if has_telescope then
      telescope.setup {
        extensions = {
          command_center = {
            components = {
              command_center.component.DESCRIPTION,
              command_center.component.KEYBINDINGS,
            },
            sort_by = {
              command_center.component.DESCRIPTION,
              command_center.component.KEYBINDINGS,
            },
            auto_replace_desc_with_cmd = false,
          }
        }
      }

      telescope.load_extension('command_center')
    end
  end,

  defer = function()
    local command_center = require("command_center")
    local noremap = { noremap = true }

    command_center.add({
      {
        description = "Open command_center",
        cmd = "<CMD>Telescope command_center<CR>",
        keybindings = {
          { "n", "<Leader>fc", noremap },
          { "v", "<Leader>fc", noremap },

          -- If ever hesitate when using telescope start with <leader>f,
          -- also open command center
          { "n", "<Leader>f", noremap },
          { "v", "<Leader>f", noremap },
        },
      }
    }, command_center.mode.REGISTER_ONLY)
  end
}
