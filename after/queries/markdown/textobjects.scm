;extends

; My own text object for markdown
; You can see all default text objects here: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/markdown/textobjects.scm

; The area from a section markdown header and all its children
; maped to c for 'content chunk'
(section) @parameter.outer
(section) @parameter.inner

; markdown header
; Warning: the default text objects map headings to class.inner and class.outer
; I'm mapping them to h for header as that is more intuitive to me.
; (atx_heading
;   heading_content: (_) @parameter.inner) @parameter.outer

; (setext_heading
;   heading_content: (_) @parameter.inner) @parameter.outer

; (thematic_break) @parameter.outer

;; Select bullet point list items
;; Because in the treesitter-text-objects the `i` is already mapped to
;; `@conditional.outer` I'm using the same capture group name here even though it's
;; semantically different.
;; ['ai'] = { query = '@conditional.outer', desc = 'Select outer part of a conditional' },
;
; (list_item
;   (_) (_) @list_item.inner) @list_item.outer
(list_item
  (_) (_) @conditional.inner) @conditional.outer

; URL link as textobject
; (inline_link (link_text @link.name) (link_destination @link.inner)) @link.outer
; (inline_link 
;   (link_text @my-link.name) (link_destination @loop.inner)) @loop.outer
; (link)
