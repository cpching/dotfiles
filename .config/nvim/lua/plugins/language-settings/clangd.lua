return {
    settings = { },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    cmd = {
        "clangd",
        "--header-insertion=never",
        "--query-driver=/usr/bin/clang",
        "--all-scopes-completion",
        "--completion-style=detailed",
    }
}
