return {
  'mzlogin/vim-markdown-toc',

  ft = { "markdown" },

  config = function()
    vim.cmd "let g:vmt_fence_text='TOC'"
    vim.cmd "let g:vmt_fence_closing_text='/TOC'"
    vim.cmd "let g:vmt_list_item_char = '-'"
    vim.cmd "let g:vmt_include_headings_before = 0"
  end,

  commands = function()
    return {
      {
        description = "Generate table of contents (GFM)",
        cmd = "<CMD>GenTocGFM<CR>",
      }
    }
  end
}
