-- lua_ls は既定では Neovim のランタイムを知らず、グローバルの `vim` が未定義扱いに
-- なる。.luarc.json を持たないプロジェクト (= この設定ディレクトリ自身) のときだけ
-- ランタイムパスとライブラリを注入する。
vim.lsp.config("lua_ls", {
  on_init = function(client)
    local folder = client.workspace_folders and client.workspace_folders[1]
    if folder and (vim.uv.fs_stat(folder.name .. "/.luarc.json")
      or vim.uv.fs_stat(folder.name .. "/.luarc.jsonc")) then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
      }
    })
  end
})

vim.lsp.enable({
  "bashls",
  "gopls",
  "jsonls",
  "lua_ls",
  "ruby_lsp",
  "terraformls",
  "vtsls",
  "yamlls"
})
