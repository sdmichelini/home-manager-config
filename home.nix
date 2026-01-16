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
  ];

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
     '';
  };

  programs.vim = {
  enable = true;
  defaultEditor = true;
  
  plugins = with pkgs.vimPlugins; [
    editorconfig-vim
    vim-nix
  ];
  
  # Only a few settings are actually supported by Home Manager
  settings = {
    ignorecase = true;
  };
  
  # Most vim options need to go in extraConfig
  extraConfig = ''
    set nocompatible
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
};



  programs.tmux = {
    enable = true;

    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Reload Config
      bind r source-file ~/.tmux.conf

      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      set-option -g update-environment "PATH"
    '';
  };
}

