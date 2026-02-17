{ config, pkgs, ... }:

{
  home.username = "sdmichelini";
  home.homeDirectory = "/Users/sdmichelini";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    awscli2
    pixi
    uv
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    ripgrep  # for telescope live_grep
    fd       # for telescope find_files
    ruff     # Python linter/LSP
    pyright  # Python type checking (fallback for completions)
    go       # Go compiler and tools
    gopls    # Go LSP
    bun
    nodejs
    tree-sitter
    # Needed for IMG Generation
    libwebp
    pkg-config
  ];

  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
  home.sessionPath = [ "$HOME/.npm-global/bin" "$HOME/.bun/bin" ];

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "tmux" ];
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      hm = "cd ~/.config/home-manager && nix run github:nix-community/home-manager -- switch --flake .#sdmichelini";
    };

    initExtra = ''
       # Fix PATH order on macOS - put Nix paths first
       export PATH="$HOME/.local/bin:$PATH"
       export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"
       export PATH="$HOME/.bun/bin:$PATH"
     '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      editorconfig-vim
      vim-nix
      plenary-nvim      # required dependency for telescope
      telescope-nvim
      rose-pine
      (nvim-treesitter.withPlugins (p: [
        p.python
        p.go
        p.html
        p.javascript
        p.nix
      ]))
      harpoon2
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
    ];

    extraConfig = ''
      " File type detection
      filetype on
      filetype plugin on
      filetype indent on
      syntax on

      " Line numbers
      set number
      set relativenumber

      " Indentation
      set shiftwidth=4
      set tabstop=4

      " Search
      set ignorecase
      set smartcase
      set incsearch
      set hlsearch

      " UI
      set cursorline
      set showcmd
      set showmode
      set showmatch
      set scrolloff=10

      " Files
      set nobackup

      " History
      set history=1000

      " Completion
      set wildmenu
      set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

      " Wrapping
      set nowrap
    '';

    extraLuaConfig = builtins.readFile ./nvim/init.lua;
  };



  programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh}/bin/zsh";

    plugins = with pkgs.tmuxPlugins; [
      nord
    ];

    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Reload Config
      bind r source-file ~/.config/tmux/tmux.conf

      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Pass C-Space through to applications (for nvim completion)
      unbind C-Space

      set-option -g update-environment "PATH"
    '';
  };
}

