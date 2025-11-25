# Neovim Config (Rebuild)

This is the repository for my personal Neovim configuration. The goal is to make Neovim an effective tool and environment for mixed methods (mainly computational/quantitative) social science research and academic writing. It is substantially based on the [kickstart.nvim project](https://github.com/nvim-lua/kickstart.nvim) (especially the [kickstart-modular version](https://github.com/dam9000/kickstart-modular.nvim)), but rebuilt/rewritten from the ground up, partly as an exercise in better understanding how Neovim works, partly to try and eliminate some configuration bugs I was having, and partly because I like having a configuration that is not any more than it needs to be. 

## Sources

As said, this is significantly based on kickstart.nvim, but I also draw significantly on several configs (especially with regard to research and writing specific elements of the configuration): 

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim)
- [jmbuhr's config](https://github.com/jmbuhr/nvim-config), especially as related to a number of the plugins he develops: 
    - [quarto-nvim](https://github.com/quarto-dev/quarto-nvim): [Quarto](quarto.org) mode for Neovim. 
    - [otter.nvim](https://github.com/jmbuhr/otter.nvim): LSP features (including code completion) for code embedded in other documents. 
    - [cmp-pandoc-references](https://github.com/jmbuhr/cmp-pandoc-references): an autocomplete source providing for bibliography, reference, and cross-ref items in Pandoc/Markdown. 
    - [telescope-zotero.nvim](https://github.com/jmbuhr/telescope-zotero.nvim): a telescope extension that allows you to search your local Zotero library and add refences to a bib file. 
- [pjphd's config](https://codeberg.org/pjphd/neovim_config), especially as relates to using R in Neovim. He gives a very helpful overview in [this blogpost](https://petejon.es/posts/2025-01-29-using-neovim-for-r/), was crucial for me in deciding to really plunge into Neovim, given that much of my work is is in R. 

## Personal Plugins

My config uses personal forks of both [cmp-pandoc-references](https://github.com/strophios/blink-cmp-pandoc-references) (renamed blink-cmp-pandoc-references) and [telescope-zotero.nvim](https://github.com/strophios/telescope-zotero.nvim), which have been rewritten to work with CSL-JSON instead of BibTeX (along with some other minor changes). These are currently just aimed at personal use, but I'm hoping to continue working on them and obviously feel free to use them as-is. 
