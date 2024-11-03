;; extends


; URL link as textobject
;
; I'm mapping it to @link because it's already defined in the
; treesitter-text-objects plugin keymap for the letter l.
; WARN: should be working but doesn't. https://www.reddit.com/r/neovim/comments/12bqbll/unable_to_target_link_in_markdown_using_treesitter/
(inline_link (link_text) @my-link.name (link_destination) @loop.inner ) @loop.outer


; (inline_link (link_destination) @text.mylink)
