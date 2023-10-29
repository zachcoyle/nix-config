{pkgs}: {
  lua = [
    {
      name = "stylua";
      pkg = pkgs.stylua;
    }
  ];
  python = [
    {
      name = "ruff_fix";
      pkg = pkgs.ruff;
    }
    {
      name = "ruff_format";
      pkg = pkgs.ruff;
    }
    # {
    #   name = "isort";
    #   pkg = pkgs.isort;
    # }
    # {
    #   name = "black";
    #   pkg = pkgs.black;
    # }
  ];
  javascript = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  javascriptreact = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  typescript = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  typescriptreact = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  json = [
    {
      name = "fixjson";
      pkg = pkgs.nodePackages.fixjson;
    }
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  css = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  graphql = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  vue = [
    {
      name = "prettierd";
      pkg = pkgs.prettierd;
    }
  ];
  swift = [
    {
      name = "swift_format";
      pkg = pkgs.swift-format;
    }
  ];
  nix = [
    {
      name = "alejandra";
      pkg = pkgs.alejandra;
    }
  ];
  rust = [
    {
      name = "rustfmt";
      pkg = pkgs.rustfmt;
    }
  ];
  go = [
    {
      name = "gofumpt";
      pkg = pkgs.gofumpt;
    }
  ];
  just = [
    {
      name = "just";
      pkg = pkgs.just;
    }
  ];
  ktlint = [
    {
      name = "ktlint";
      pkg = pkgs.ktlint;
    }
  ];
  yaml = [
    {
      name = "yamlfix";
      pkg = pkgs.yamlfix;
    }
    {
      name = "yamlfmt";
      pkg = pkgs.yamlfmt;
    }
  ];
}
