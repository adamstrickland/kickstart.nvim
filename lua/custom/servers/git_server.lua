-- Git/GitHub MCP Server Configuration
-- Provides comprehensive git operations, repository information, and GitHub integration

return {
  name = 'git',
  displayName = 'Git & GitHub Operations',
  capabilities = {
    tools = {
      {
        name = 'git_status',
        description = 'Get the current git status of the repository',
        inputSchema = {
          type = 'object',
          properties = {
            porcelain = {
              type = 'boolean',
              description = 'Use porcelain format for machine-readable output',
              default = false,
            },
          },
        },
        handler = function(req, res)
          local cmd = req.params.porcelain and 'git status --porcelain' or 'git status'
          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error 'Not a git repository or git command failed'
          end
          return res:text(output):send()
        end,
      },
      {
        name = 'git_add',
        description = 'Add files to the git staging area',
        inputSchema = {
          type = 'object',
          properties = {
            files = {
              type = 'array',
              items = { type = 'string' },
              description = "Files to add (use '.' for all files)",
            },
          },
          required = { 'files' },
        },
        handler = function(req, res)
          local files = table.concat(req.params.files, ' ')
          local output = vim.fn.system('git add ' .. files)
          if vim.v.shell_error ~= 0 then
            return res:error('Git add failed: ' .. output)
          end
          return res:text('Successfully added files: ' .. files):send()
        end,
      },
      {
        name = 'git_commit',
        description = 'Create a git commit with a message',
        inputSchema = {
          type = 'object',
          properties = {
            message = {
              type = 'string',
              description = 'Commit message',
            },
            add_all = {
              type = 'boolean',
              description = 'Add all modified files before committing',
              default = false,
            },
          },
          required = { 'message' },
        },
        handler = function(req, res)
          local cmd = req.params.add_all and 'git commit -am ' or 'git commit -m '
          local message = vim.fn.shellescape(req.params.message)
          local output = vim.fn.system(cmd .. message)
          if vim.v.shell_error ~= 0 then
            return res:error('Git commit failed: ' .. output)
          end
          return res:text('Commit successful: ' .. output):send()
        end,
      },
      {
        name = 'git_push',
        description = 'Push commits to remote repository',
        inputSchema = {
          type = 'object',
          properties = {
            remote = {
              type = 'string',
              description = 'Remote name',
              default = 'origin',
            },
            branch = {
              type = 'string',
              description = 'Branch name (defaults to current branch)',
            },
            force = {
              type = 'boolean',
              description = 'Force push',
              default = false,
            },
          },
        },
        handler = function(req, res)
          local remote = req.params.remote or 'origin'
          local branch = req.params.branch or ''
          local force_flag = req.params.force and ' --force' or ''
          local cmd = 'git push' .. force_flag .. ' ' .. remote .. ' ' .. branch
          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error('Git push failed: ' .. output)
          end
          return res:text('Push successful: ' .. output):send()
        end,
      },
      {
        name = 'git_pull',
        description = 'Pull changes from remote repository',
        inputSchema = {
          type = 'object',
          properties = {
            remote = {
              type = 'string',
              description = 'Remote name',
              default = 'origin',
            },
            branch = {
              type = 'string',
              description = 'Branch name (defaults to current branch)',
            },
            rebase = {
              type = 'boolean',
              description = 'Use rebase instead of merge',
              default = false,
            },
          },
        },
        handler = function(req, res)
          local remote = req.params.remote or 'origin'
          local branch = req.params.branch or ''
          local rebase_flag = req.params.rebase and ' --rebase' or ''
          local cmd = 'git pull' .. rebase_flag .. ' ' .. remote .. ' ' .. branch
          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error('Git pull failed: ' .. output)
          end
          return res:text('Pull successful: ' .. output):send()
        end,
      },
      {
        name = 'git_branch',
        description = 'Git branch operations',
        inputSchema = {
          type = 'object',
          properties = {
            action = {
              type = 'string',
              enum = { 'list', 'create', 'delete', 'switch', 'current' },
              description = 'Branch action to perform',
            },
            name = {
              type = 'string',
              description = 'Branch name (required for create, delete, switch)',
            },
            force = {
              type = 'boolean',
              description = 'Force operation (for delete)',
              default = false,
            },
          },
          required = { 'action' },
        },
        handler = function(req, res)
          local action = req.params.action
          local name = req.params.name
          local force = req.params.force

          local cmd
          if action == 'list' then
            cmd = 'git branch -a'
          elseif action == 'current' then
            cmd = 'git branch --show-current'
          elseif action == 'create' then
            if not name then
              return res:error 'Branch name is required for create action'
            end
            cmd = 'git checkout -b ' .. name
          elseif action == 'delete' then
            if not name then
              return res:error 'Branch name is required for delete action'
            end
            local flag = force and '-D' or '-d'
            cmd = 'git branch ' .. flag .. ' ' .. name
          elseif action == 'switch' then
            if not name then
              return res:error 'Branch name is required for switch action'
            end
            cmd = 'git checkout ' .. name
          else
            return res:error('Invalid action: ' .. action)
          end

          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error('Git branch operation failed: ' .. output)
          end
          return res:text(output):send()
        end,
      },
      {
        name = 'git_log',
        description = 'View git commit history',
        inputSchema = {
          type = 'object',
          properties = {
            count = {
              type = 'integer',
              description = 'Number of commits to show',
              default = 10,
            },
            oneline = {
              type = 'boolean',
              description = 'Show one line per commit',
              default = true,
            },
            author = {
              type = 'string',
              description = 'Filter by author',
            },
            since = {
              type = 'string',
              description = "Show commits since date (e.g., '2 weeks ago')",
            },
          },
        },
        handler = function(req, res)
          local count = req.params.count or 10
          local cmd = 'git log -n ' .. count

          if req.params.oneline then
            cmd = cmd .. ' --oneline'
          end

          if req.params.author then
            cmd = cmd .. ' --author=' .. vim.fn.shellescape(req.params.author)
          end

          if req.params.since then
            cmd = cmd .. ' --since=' .. vim.fn.shellescape(req.params.since)
          end

          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error('Git log failed: ' .. output)
          end
          return res:text(output):send()
        end,
      },
      {
        name = 'git_diff',
        description = 'Show git differences',
        inputSchema = {
          type = 'object',
          properties = {
            staged = {
              type = 'boolean',
              description = 'Show staged changes',
              default = false,
            },
            file = {
              type = 'string',
              description = 'Specific file to diff',
            },
            commit = {
              type = 'string',
              description = 'Compare with specific commit',
            },
          },
        },
        handler = function(req, res)
          local cmd = 'git diff'

          if req.params.staged then
            cmd = cmd .. ' --staged'
          end

          if req.params.commit then
            cmd = cmd .. ' ' .. req.params.commit
          end

          if req.params.file then
            cmd = cmd .. ' ' .. req.params.file
          end

          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error('Git diff failed: ' .. output)
          end
          return res:text(output):send()
        end,
      },
      {
        name = 'github_create_pr',
        description = 'Create a GitHub pull request (requires gh CLI)',
        inputSchema = {
          type = 'object',
          properties = {
            title = {
              type = 'string',
              description = 'Pull request title',
            },
            body = {
              type = 'string',
              description = 'Pull request body',
            },
            base = {
              type = 'string',
              description = 'Base branch',
              default = 'main',
            },
            draft = {
              type = 'boolean',
              description = 'Create as draft',
              default = false,
            },
          },
          required = { 'title' },
        },
        handler = function(req, res)
          -- Check if gh CLI is available
          local gh_check = vim.fn.system 'which gh'
          if vim.v.shell_error ~= 0 then
            return res:error 'GitHub CLI (gh) is not installed. Please install it first.'
          end

          local cmd = 'gh pr create --title ' .. vim.fn.shellescape(req.params.title)

          if req.params.body then
            cmd = cmd .. ' --body ' .. vim.fn.shellescape(req.params.body)
          end

          if req.params.base then
            cmd = cmd .. ' --base ' .. req.params.base
          end

          if req.params.draft then
            cmd = cmd .. ' --draft'
          end

          local output = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            return res:error('GitHub PR creation failed: ' .. output)
          end
          return res:text('Pull request created successfully: ' .. output):send()
        end,
      },
    },
    resources = {
      {
        name = 'current_branch',
        uri = 'git://branch/current',
        description = 'Get the current git branch name',
        handler = function(req, res)
          local branch = vim.fn.system 'git branch --show-current'
          if vim.v.shell_error ~= 0 then
            return res:error 'Not a git repository'
          end
          return res:text(vim.trim(branch)):send()
        end,
      },
      {
        name = 'repo_info',
        uri = 'git://repo/info',
        description = 'Get repository information',
        handler = function(req, res)
          local remote_url = vim.fn.system 'git remote get-url origin'
          local branch = vim.fn.system 'git branch --show-current'
          local last_commit = vim.fn.system 'git log -1 --oneline'

          if vim.v.shell_error ~= 0 then
            return res:error 'Not a git repository'
          end

          local info = string.format(
            'Repository Info:\n' .. 'Remote URL: %s' .. 'Current Branch: %s' .. 'Last Commit: %s',
            vim.trim(remote_url),
            vim.trim(branch),
            vim.trim(last_commit)
          )

          return res:text(info):send()
        end,
      },
      {
        name = 'git_status_summary',
        uri = 'git://status/summary',
        description = 'Get a summary of git repository status',
        handler = function(req, res)
          local status = vim.fn.system 'git status --porcelain'
          if vim.v.shell_error ~= 0 then
            return res:error 'Not a git repository'
          end

          local lines = vim.split(status, '\n')
          local modified = 0
          local added = 0
          local deleted = 0
          local untracked = 0

          for _, line in ipairs(lines) do
            if line ~= '' then
              local status_code = line:sub(1, 2)
              if status_code:match 'M' then
                modified = modified + 1
              elseif status_code:match 'A' then
                added = added + 1
              elseif status_code:match 'D' then
                deleted = deleted + 1
              elseif status_code:match '??' then
                untracked = untracked + 1
              end
            end
          end

          local summary = string.format(
            'Git Status Summary:\n' .. 'Modified: %d\n' .. 'Added: %d\n' .. 'Deleted: %d\n' .. 'Untracked: %d',
            modified,
            added,
            deleted,
            untracked
          )

          return res:text(summary):send()
        end,
      },
    },
    resourceTemplates = {
      {
        name = 'commit_history',
        uriTemplate = 'git://commits/{count}',
        description = 'Get recent commit history with specified count',
        handler = function(req, res)
          local count = tonumber(req.params.count) or 10
          local output = vim.fn.system(string.format('git log -n %d --oneline', count))
          if vim.v.shell_error ~= 0 then
            return res:error 'Git log failed'
          end
          return res:text(output):send()
        end,
      },
      {
        name = 'file_history',
        uriTemplate = 'git://file/{filepath}/history',
        description = 'Get commit history for a specific file',
        handler = function(req, res)
          local filepath = req.params.filepath
          local output = vim.fn.system('git log --oneline -- ' .. vim.fn.shellescape(filepath))
          if vim.v.shell_error ~= 0 then
            return res:error('Git log failed for file: ' .. filepath)
          end
          return res:text('History for ' .. filepath .. ':\n' .. output):send()
        end,
      },
      {
        name = 'branch_info',
        uriTemplate = 'git://branch/{name}/info',
        description = 'Get information about a specific branch',
        handler = function(req, res)
          local branch_name = req.params.name
          local exists = vim.fn.system('git show-ref --verify --quiet refs/heads/' .. branch_name)

          if vim.v.shell_error ~= 0 then
            return res:error("Branch '" .. branch_name .. "' does not exist")
          end

          local last_commit = vim.fn.system('git log -1 --oneline ' .. branch_name)
          local commit_count = vim.fn.system('git rev-list --count ' .. branch_name)

          local info = string.format('Branch: %s\n' .. 'Last Commit: %s' .. 'Total Commits: %s', branch_name, vim.trim(last_commit), vim.trim(commit_count))

          return res:text(info):send()
        end,
      },
    },
    prompts = {
      {
        name = 'commit_message_help',
        description = 'Get help writing a commit message',
        arguments = {
          {
            name = 'type',
            description = 'Type of commit (feat, fix, docs, style, refactor, test, chore)',
            required = true,
          },
          {
            name = 'scope',
            description = 'Scope of the change (optional)',
            required = false,
          },
        },
        handler = function(req, res)
          local commit_type = req.params.type
          local scope = req.params.scope

          local scope_text = scope and ('(' .. scope .. ')') or ''
          local template = commit_type .. scope_text .. ': '

          return res
            :user()
            :text(string.format("Help me write a %s commit message. Here's what I've changed:", commit_type))
            :llm()
            :text("I'll help you write a good commit message. Based on conventional commits, here's a template:")
            :text('\n\n' .. template .. '[brief description]')
            :text('\n\nGuidelines:')
            :text('\n- Use imperative mood ("add" not "added")')
            :text('\n- Keep the first line under 50 characters')
            :text('\n- Add detailed explanation in body if needed')
            :text('\n- Reference issues with #issue-number')
            :send()
        end,
      },
      {
        name = 'pr_template',
        description = 'Generate a pull request template',
        arguments = {
          {
            name = 'feature_type',
            description = 'Type of feature/change (feature, bugfix, hotfix, docs)',
            required = true,
          },
        },
        handler = function(req, res)
          local feature_type = req.params.feature_type

          return res
            :user()
            :text(string.format('Help me create a pull request for a %s', feature_type))
            :llm()
            :text("I'll help you create a comprehensive pull request. Here's a template:")
            :text('\n\n## Summary')
            :text('\nBrief description of what this PR does')
            :text('\n\n## Type of Change')
            :text('\n- [ ] Bug fix (non-breaking change which fixes an issue)')
            :text('\n- [ ] New feature (non-breaking change which adds functionality)')
            :text('\n- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)')
            :text('\n- [ ] Documentation update')
            :text('\n\n## Testing')
            :text('\n- [ ] Tests pass locally')
            :text('\n- [ ] Added tests for new functionality')
            :text('\n\n## Checklist')
            :text('\n- [ ] Code follows project style guidelines')
            :text('\n- [ ] Self-review completed')
            :text('\n- [ ] Documentation updated if needed')
            :send()
        end,
      },
    },
  },
}
