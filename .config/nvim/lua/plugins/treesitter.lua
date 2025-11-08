return {
	-- Treesitter configuration for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			-- Ensure GraphQL parser is installed
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"graphql",
				"typescript",
				"tsx",
				"javascript",
			})

			-- Enable additional features
			opts.highlight = opts.highlight or {}
			opts.highlight.enable = true
			opts.highlight.additional_vim_regex_highlighting = false

			-- Enable indentation
			opts.indent = opts.indent or {}
			opts.indent.enable = true

			-- Incremental selection
			opts.incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			}
		end,
	},

	-- GraphQL injection queries for Relay
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter",
				opts = function()
					-- Add after_install hook to set up GraphQL injections
					vim.schedule(function()
						local queries_dir = vim.fn.stdpath("config") .. "/after/queries"
						local tsx_queries = queries_dir .. "/tsx"
						local typescript_queries = queries_dir .. "/typescript"

						-- Create directories if they don't exist
						vim.fn.mkdir(tsx_queries, "p")
						vim.fn.mkdir(typescript_queries, "p")

						-- GraphQL injection query for TSX files
						local tsx_injection = [[
;; Relay graphql template literals
(call_expression
  function: (identifier) @_name
  arguments: (template_string) @injection.content
  (#eq? @_name "graphql")
  (#set! injection.language "graphql")
  (#offset! @injection.content 0 1 0 -1))

;; graphql.experimental template literals
(call_expression
  function: (member_expression
    object: (identifier) @_obj
    property: (property_identifier) @_prop)
  arguments: (template_string) @injection.content
  (#eq? @_obj "graphql")
  (#eq? @_prop "experimental")
  (#set! injection.language "graphql")
  (#offset! @injection.content 0 1 0 -1))

;; gql template literals (alternative tag)
(call_expression
  function: (identifier) @_name
  arguments: (template_string) @injection.content
  (#eq? @_name "gql")
  (#set! injection.language "graphql")
  (#offset! @injection.content 0 1 0 -1))
]]

						-- Write injection queries
						local tsx_file = io.open(tsx_queries .. "/injections.scm", "w")
						if tsx_file then
							tsx_file:write(tsx_injection)
							tsx_file:close()
						end

						local typescript_file = io.open(typescript_queries .. "/injections.scm", "w")
						if typescript_file then
							typescript_file:write(tsx_injection)
							typescript_file:close()
						end
					end)
				end,
			},
		},
	},
}

