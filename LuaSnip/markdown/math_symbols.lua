local utils = require 'utils.luasnip-helper-funcs'
local merge = utils.merge_tables
local pipe = utils.pipe
local no_backslash = utils.no_backslash
local in_math = require('utils.treesitter-contexts').in_mathzone

local in_text = require('utils.treesitter-contexts').in_text
local line_begin = require('luasnip.extras.expand_conditions').line_begin
-- -- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- -- expand only in math contexts.
local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require('luasnip.extras.fmt').fmta

local default1 = { wordTrig = true, regTrig = false, snippetType = 'autosnippet', priority = 100 }
local default3 = { condition = pipe { in_math, no_backslash }, show_conditon = pipe { in_math, no_backslash } }

return {
  -- operators
  s(merge({ trig = '!=', name = '!=' }, default1), fmta(' \\neq <>', { i(0) }), default3),
  s(merge({ trig = '<=', name = '≤' }, default1), fmta(' \\leq <>', { i(0) }), default3),
  s(merge({ trig = '>=', name = '≥' }, default1), fmta(' \\geq <>', { i(0) }), default3),
  s(merge({ trig = '<<', name = '≪' }, default1), fmta(' \\ll <>', { i(0) }), default3),
  s(merge({ trig = '>>', name = '≫' }, default1), fmta(' \\gg <>', { i(0) }), default3), -- for some mysterious reason, this does not work
  s(merge({ trig = '~~', name = '~' }, default1), fmta(' \\sim <>', { i(0) }), default3),
  s(merge({ trig = '~=', name = '≈' }, default1), fmta(' \\approx <>', { i(0) }), default3),
  s(merge({ trig = '~%-', name = '≃' }, default1), fmta(' \\simeq <>', { i(0) }), default3),
  s(merge({ trig = '%-~', name = '⋍' }, default1), fmta(' \\backsimeq <>', { i(0) }), default3),
  s(merge({ trig = '%-=', name = '≡' }, default1), fmta(' \\equiv <>', { i(0) }), default3),
  s(merge({ trig = '=~', name = '≅' }, default1), fmta(' \\cong <>', { i(0) }), default3),
  s(merge({ trig = ':=', name = '≔' }, default1), fmta(' \\definedas <>', { i(0) }), default3),
  s(merge({ trig = '%*%*', name = '·' }, default1), fmta(' \\cdot <>', { i(0) }), default3),
  s(merge({ trig = 'xx', name = '×' }, default1), fmta(' \\times <>', { i(0) }), default3),
  s(merge({ trig = '!%+', name = '⊕' }, default1), fmta(' \\oplus <>', { i(0) }), default3), -- maybe use o+ ?
  s(merge({ trig = '!%*', name = '⊗' }, default1), fmta(' \\otimes <>', { i(0) }), default3),

  -- sets ===========================================================================================================
  s(merge({ trig = 'nn', name = 'ℕ' }, default1), fmta(' \\mathbb{N} <>', { i(0) }), default3),
  s(merge({ trig = 'zz', name = 'ℤ' }, default1), fmta(' \\mathbb{Z} <>', { i(0) }), default3),
  s(merge({ trig = 'qq', name = 'ℚ' }, default1), fmta(' \\mathbb{Q} <>', { i(0) }), default3),
  s(merge({ trig = 'rr', name = 'ℝ' }, default1), fmta(' \\mathbb{R} <>', { i(0) }), default3),
  s(merge({ trig = 'cc', name = 'ℂ' }, default1), fmta(' \\mathbb{C} <>', { i(0) }), default3),
  s(merge({ trig = 'oo', name = '∅' }, default1), fmta(' \\emptyset <>', { i(0) }), default3),
  s(merge({ trig = 'pwr', name = 'P' }, default1), fmta(' \\powerset <>', { i(0) }), default3),
  s(merge({ trig = 'cc', name = '⊂' }, default1), fmta(' \\subset <>', { i(0) }), default3),
  s(merge({ trig = 'cq', name = '⊆' }, default1), fmta(' \\subseteq <>', { i(0) }), default3),
  s(merge({ trig = 'qq', name = '⊃' }, default1), fmta(' \\supset <>', { i(0) }), default3),
  s(merge({ trig = 'qc', name = '⊇' }, default1), fmta(' \\supseteq <>', { i(0) }), default3),
  s(merge({ trig = '\\\\\\', name = '⧵' }, default1), fmta(' \\setminus <>', { i(0) }), default3),
  s(merge({ trig = 'Nn', name = '∩' }, default1), fmta(' \\cap <>', { i(0) }), default3), -- evesdropper used Nn
  s(merge({ trig = 'uu', name = '∪' }, default1), fmta(' \\cup <>', { i(0) }), default3), -- evesdropper used UU
  s(merge({ trig = '::', name = ':' }, default1), fmta(' \\colon <>', { i(0) }), default3),
  s(merge({ trig = 'aa', name = '∀' }, default1), fmta(' \\forall <>', { i(0) }), default3), -- evesdropper used AA
  s(merge({ trig = 'ee', name = '∃' }, default1), fmta(' \\exists <>', { i(0) }), default3), -- evesdropper used EE
  s(merge({ trig = 'inn', name = '∈' }, default1), fmta(' \\in <>', { i(0) }), default3), -- evesdropper used inn
  s(merge({ trig = 'notin', name = '∉' }, default1), fmta(' \\notin <>', { i(0) }), default3), -- evesdropper used notin
  s(merge({ trig = 'nin', name = '∉' }, default1), fmta(' \\notin <>', { i(0) }), default3), -- by me
  s(merge({ trig = '%.%.%.', name = '...' }, default1), fmta(' \\ldots <>', { i(0) }), default3), -- by me

  -- logic ==========================================================================================================
  s(merge({ trig = '!%-', name = '¬' }, default1), fmta(' \\lnot <>', { i(0) }), default3), -- evesdropper used !-
  s(merge({ trig = 'no', name = '¬' }, default1), fmta(' \\lnot <>', { i(0) }), default3), -- evesdropper used !-
  s(merge({ trig = 'vv', name = '∨' }, default1), fmta(' \\lor <>', { i(0) }), default3), -- evesdropper used VV
  s(merge({ trig = 'ww', name = '∧' }, default1), fmta(' \\land <>', { i(0) }), default3), -- evesdropper used WW
  s(merge({ trig = '!w', name = '∧' }, default1), fmta(' \\bigwedge <>', { i(0) }), default3), -- evesdropper used !W
  s(merge({ trig = 'WW', name = '∧' }, default1), fmta(' \\bigwedge <>', { i(0) }), default3), -- me
  s(merge({ trig = '=>', name = '⇒' }, default1), fmta(' \\implies <>', { i(0) }), default3), -- evesdropper used =>
  s(merge({ trig = '=<', name = '⇐' }, default1), fmta(' \\impliedby <>', { i(0) }), default3), -- evesdropper used =<\
  s(merge({ trig = 'iff', name = '⟺' }, default1), fmta(' \\iff <>', { i(0) }), default3), -- evesdropper used iff
  s(merge({ trig = '->', name = '→' }, default1), fmta(' \\to <>', { i(0) }), default3), -- evesdropper used ->
  s(merge({ trig = 'to', name = '→' }, default1), fmta(' \\to <>', { i(0) }), default3), -- me
  s(merge({ trig = '!>', name = '↦' }, default1), fmta(' \\mapsto <>', { i(0) }), default3), -- evesdropper used !>
  s(merge({ trig = '<%-', name = '←' }, default1), fmta(' \\gets <>', { i(0) }), default3), -- evesdropper used <-

  -- differentials ==================================================================================================
  s(merge({ trig = 'dp', name = '∂' }, default1), fmta(' \\partial <>', { i(0) }), default3), -- evesdropper used dp '⇐'
  s(merge({ trig = '%-%->', name = '⟶' }, default1), fmta(' \\longrightarrow <>', { i(0) }), default3), -- evesdropper used -->
  s(merge({ trig = '<%->', name = '↔' }, default1), fmta(' \\leftrightarrow <>', { i(0) }), default3), -- evesdropper used <->
  s(merge({ trig = '2>', name = '⇉' }, default1), fmta(' \\rightrightarrows <>', { i(0) }), default3), -- evesdropper used 2>
  s(merge({ trig = 'upar', name = '↑' }, default1), fmta(' \\uparrow <>', { i(0) }), default3), -- evesdropper used upar
  s(merge({ trig = 'dnar', name = '↓' }, default1), fmta(' \\downarrow <>', { i(0) }), default3), -- evesdropper used dnar
  -- etc
  s(merge({ trig = 'ooo', name = '∞' }, default1), fmta(' \\infty <>', { i(0) }), default3), -- evesdropper used ooo
  s(merge({ trig = 'lll', name = 'ℓ' }, default1), fmta(' \\ell <>', { i(0) }), default3), -- evesdropper used lll
  s(merge({ trig = 'dag', name = '†' }, default1), fmta(' \\dagger <>', { i(0) }), default3), -- evesdropper used dag
  s(merge({ trig = '%+%-', name = '±' }, default1), fmta(' \\pm <>', { i(0) }), default3), -- evesdropper used +-
  s(merge({ trig = '%-%+', name = '∓' }, default1), fmta(' \\mp <>', { i(0) }), default3), -- evesdropper used -+

  -- Advanced operators
  s(merge({ trig = 'sqrt', name = 'square root' }, default1), fmta(' \\sqrt{<>}<>', { i(1), i(0) }), { condition = in_math }),
  s(merge({ trig = 'sum', name = 'sum' }, default1), fmta(' \\sum_{<>}^{<>}<>', { i(1, 'n=1'), i(2, 'n'), i(0) }), { condition = in_math }),
  -- euler's number
  s(merge({ trig = 'eu', name = "Euler's number" }, default1), fmta(' e^{<>}', { i(0) }), { condition = in_math }),
  s(merge({ trig = 'lim', name = 'limit?' }, default1), fmta(' \\lim_{<>}^{<>}<>', { i(1), i(2, '\\infty'), i(0) }), { condition = in_math }),
  s(merge({ trig = 'int', name = 'integral' }, default1), fmta(' \\int_{<>}^{<>}<>', { i(1), i(2), i(0) }), { condition = in_math }),
}
