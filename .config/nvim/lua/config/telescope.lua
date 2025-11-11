require("telescope").setup({
    extensions = {
      project = {
        on_project_selected = function(prompt_bufnr)
          local action_state = require("telescope.actions.state")
          local project_actions = require("telescope._extensions.project.actions")
          
          -- Change dir to the selected project
          project_actions.change_working_directory(prompt_bufnr, false)
  
          -- Change monorepo directory to the selected project
          local selected_entry = action_state.get_selected_entry(prompt_bufnr)
          require("monorepo").change_monorepo(selected_entry.value)
  
          require("telescope.builtin").find_files()
        end,
      }
    }
  }
)

require('telescope').load_extension('pnpm_workspace')