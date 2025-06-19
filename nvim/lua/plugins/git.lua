return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "┃" },
          change       = { text = "┃" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, keys, func, desc)
            vim.keymap.set(mode, keys, func, {
              buffer = bufnr,
              noremap = true,
              silent = true,
              desc = desc,
            })
          end

          map("n", "]c", gs.next_hunk, "Next Hunk")
          map("n", "[c", gs.prev_hunk, "Previous Hunk")

          map("n", "<leader>hs", gs.stage_hunk, "Stage Hunk")
          map("n", "<leader>hr", gs.reset_hunk, "Reset Hunk")
          map("v", "<leader>hs", function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, "Stage Visual")
          map("v", "<leader>hr", function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, "Reset Visual")
          map("n", "<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>hS", gs.stage_buffer, "Stage Buffer")
          map("n", "<leader>hR", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>hp", gs.preview_hunk, "Preview Hunk")
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame Line")
          map("n", "<leader>td", gs.toggle_deleted, "Toggle Deleted Lines")

          local function git_cmd(cmd, msg)
            vim.keymap.set("n", cmd[1], function()
              vim.cmd("terminal git " .. cmd[2])
            end, { desc = msg, noremap = true, silent = true })
          end

          git_cmd({ "<leader>gp", "push" }, "Git Push")
          git_cmd({ "<leader>gf", "fetch" }, "Git Fetch")
          git_cmd({ "<leader>gl", "pull" }, "Git Pull")
          git_cmd({ "<leader>gcm", "commit" }, "Git Commit")
          git_cmd({ "<leader>gm", "merge" }, "Git Merge")
          git_cmd({ "<leader>grb", "rebase" }, "Git Rebase")
          git_cmd({ "<leader>gst", "status" }, "Git Status")
        end,
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
}
