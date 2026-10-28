;;; alabaster-refined-theme.el --- A theme based on Tonsky's syntax highlighting principles
;;
;; Inspired by https://tonsky.me/blog/syntax-highlighting/
;;
;; Core philosophy:
;;   - Minimal colors — only what you can remember
;;   - Green for strings & numbers (constants)
;;   - Blue/teal for top-level definitions (defun, defvar, class names)
;;   - Soft orange for control flow (if, when, cond, switch, for, while, etc.)
;;   - Muted yellow-brown for comments (visible but not glaring)
;;   - Purple for true constants (t, nil, keywords, symbols)
;;   - Dimmed punctuation / operators
;;   - Plain base text for variables, function calls — no color
;;   - NO color for generic keywords like function/let/do

(deftheme alabaster-refined
  "A restrained dark theme inspired by Tonsky's Alabaster principles.
Uses very few colors deliberately: green for literals, blue for
definitions, soft orange for control flow, muted comments, purple
for constants.  Everything else stays as base text.")

;;; ─── Palette ───────────────────────────────────────────────────────────────
;;
;;  bg          #1E1E1E   main background
;;  bg-subtle   #252526   slightly lighter bg (modeline, fringes)
;;  bg-sel      #264F78   selection / region
;;  border      #3C3C3C   borders, separators
;;
;;  base        #D4D4D4   primary text
;;  muted       #808080   dimmed text (punctuation, operators)
;;  very-muted  #555555   very dim (line numbers, inactive)
;;
;;  green       #6A9955   strings, numbers
;;  teal        #4EC9B0   top-level defs (function names, class names)
;;  orange      #CE9178   control-flow keywords (if, cond, for, while…)
;;  purple      #C586C0   constants: t nil keywords symbols
;;  comment     #6A7040   comments — olive/muted yellow-brown, readable but calm
;;
;;  red         #F44747   errors, warnings
;;  yellow      #DCDCAA   unused (reserved for later / your overrides)
;;
;;; ──────────────────────────────────────────────────────────────────────────

(let ((bg          "#000000")
      (bg-subtle   "#252526")
      (bg-sel      "#264F78")
      (bg-paren    "#2D2D30")
      (border      "#3C3C3C")

      (base        "#D4D4D4")
      (muted       "#777777")
      (very-muted  "#4A4A4A")

      (green       "#6A9955")
      (teal        "#4EC9B0")
      (orange      "#CE9178")
      (purple      "#C586C0")
      (comment     "#6A7040")

      (red         "#F44747")
      (cursor      "#AEAFAD"))

  (custom-theme-set-faces
   'alabaster-refined

   ;; ── Basics ──────────────────────────────────────────────────────────────
   `(default                    ((t :foreground ,base :background ,bg)))
   `(cursor                     ((t :background ,cursor)))
   `(region                     ((t :background ,bg-sel)))
   `(highlight                  ((t :background ,bg-paren)))
   `(fringe                     ((t :foreground ,very-muted :background ,bg-subtle)))
   `(vertical-border            ((t :foreground ,border)))
   `(minibuffer-prompt          ((t :foreground ,teal)))
   `(trailing-whitespace        ((t :background ,red)))
   `(link                       ((t :foreground ,teal :underline t)))
   `(link-visited               ((t :foreground ,purple :underline t)))
   `(match                      ((t :background ,bg-sel :foreground ,base)))
   `(isearch                    ((t :background ,bg-sel :foreground ,base :bold t)))
   `(lazy-highlight             ((t :background "#3A3D41")))
   `(secondary-selection        ((t :background "#3A3D41")))
   `(error                      ((t :foreground ,red)))
   `(warning                    ((t :foreground ,orange)))
   `(success                    ((t :foreground ,green)))

   ;; ── Line numbers ────────────────────────────────────────────────────────
   `(line-number                ((t :foreground ,very-muted :background ,bg)))
   `(line-number-current-line   ((t :foreground ,muted     :background ,bg)))

   ;; ── Mode line ───────────────────────────────────────────────────────────
   `(mode-line           ((t :foreground ,base       :background ,bg-subtle :box (:line-width 1 :color ,border))))
   `(mode-line-inactive  ((t :foreground ,muted      :background ,bg        :box (:line-width 1 :color ,border))))
   `(mode-line-buffer-id ((t :foreground ,teal       :bold t)))

   ;; ── Font-lock (the important stuff) ─────────────────────────────────────

   ;; Comments — muted olive/brown, calmer than bright yellow
   `(font-lock-comment-face           ((t :foreground ,comment)))
   `(font-lock-comment-delimiter-face ((t :foreground ,comment)))
   `(font-lock-doc-face               ((t :foreground "#7A8050")))   ;; slightly lighter than comments

   ;; Strings — green (same family as constants)
   `(font-lock-string-face            ((t :foreground ,green)))

   ;; Numbers — also green (they're constants too)
   `(font-lock-number-face            ((t :foreground ,green)))

   ;; True constants: t, nil, :keywords, #t, #f, None, True, False, NULL
   `(font-lock-constant-face          ((t :foreground ,purple)))

   ;; Top-level definitions — teal/cyan so you can spot structure fast
   `(font-lock-function-name-face     ((t :foreground ,teal :bold t)))
   `(font-lock-type-face              ((t :foreground ,teal)))
   `(font-lock-variable-name-face     ((t :foreground ,base)))   ;; declarations: base text, no color

   ;; Generic keywords (let, do, lambda, fn, def, begin, var, const, return…)
   ;; Per Tonsky: don't highlight — they're structural noise
   `(font-lock-keyword-face           ((t :foreground ,base)))

   ;; Builtin functions (print, len, map, filter…) — base text
   `(font-lock-builtin-face           ((t :foreground ,base)))

   ;; Function/method calls — base text (ubiquitous, no need to highlight)
   `(font-lock-function-call-face     ((t :foreground ,base)))

   ;; Punctuation / operators — dimmed
   `(font-lock-operator-face          ((t :foreground ,muted)))
   `(font-lock-punctuation-face       ((t :foreground ,muted)))
   `(font-lock-delimiter-face         ((t :foreground ,muted)))
   `(font-lock-bracket-face           ((t :foreground ,muted)))

   ;; Preprocessor / macros
   `(font-lock-preprocessor-face      ((t :foreground ,purple)))

   ;; Negation / special
   `(font-lock-negation-char-face     ((t :foreground ,red)))

   ;; Warnings in code
   `(font-lock-warning-face           ((t :foreground ,red)))

   ;; ── Parens / delimiters ─────────────────────────────────────────────────
   `(show-paren-match        ((t :background ,bg-paren :bold t)))
   `(show-paren-mismatch     ((t :background ,red      :bold t)))

   ;; ── Diffs ───────────────────────────────────────────────────────────────
   `(diff-added              ((t :foreground ,green  :background "#1E3A1E")))
   `(diff-removed            ((t :foreground ,red    :background "#3A1E1E")))
   `(diff-header             ((t :foreground ,muted)))
   `(diff-file-header        ((t :foreground ,teal)))

   ;; ── Magit ───────────────────────────────────────────────────────────────
   `(magit-branch-local      ((t :foreground ,teal)))
   `(magit-branch-remote     ((t :foreground ,green)))
   `(magit-tag               ((t :foreground ,purple)))
   `(magit-section-heading   ((t :foreground ,teal :bold t)))
   `(magit-diff-added        ((t :foreground ,green  :background "#1E3A1E")))
   `(magit-diff-removed      ((t :foreground ,red    :background "#3A1E1E")))

   ;; ── Company / corfu (completion) ────────────────────────────────────────
   `(company-tooltip                  ((t :foreground ,base    :background ,bg-subtle)))
   `(company-tooltip-selection        ((t :foreground ,base    :background ,bg-sel)))
   `(company-tooltip-annotation       ((t :foreground ,muted)))
   `(company-tooltip-common           ((t :foreground ,teal)))
   `(company-scrollbar-bg             ((t :background ,bg-subtle)))
   `(company-scrollbar-fg             ((t :background ,muted)))

   ;; ── Org mode ────────────────────────────────────────────────────────────
   `(org-level-1            ((t :foreground ,teal   :bold t)))
   `(org-level-2            ((t :foreground ,purple :bold t)))
   `(org-level-3            ((t :foreground ,orange)))
   `(org-level-4            ((t :foreground ,green)))
   `(org-code               ((t :foreground ,green)))
   `(org-verbatim           ((t :foreground ,purple)))
   `(org-block              ((t :foreground ,base   :background ,bg-subtle)))
   `(org-block-begin-line   ((t :foreground ,comment)))
   `(org-block-end-line     ((t :foreground ,comment)))
   `(org-tag                ((t :foreground ,muted)))
   `(org-date               ((t :foreground ,teal)))
   `(org-todo               ((t :foreground ,orange :bold t)))
   `(org-done               ((t :foreground ,green  :bold t)))

   ;; ── Flycheck / flymake ──────────────────────────────────────────────────
   `(flycheck-error          ((t :underline (:style wave :color ,red))))
   `(flycheck-warning        ((t :underline (:style wave :color ,orange))))
   `(flycheck-info           ((t :underline (:style wave :color ,teal))))
   `(flymake-error           ((t :underline (:style wave :color ,red))))
   `(flymake-warning         ((t :underline (:style wave :color ,orange))))
   `(flymake-note            ((t :underline (:style wave :color ,teal))))

   ;; ── Treesitter overrides ─────────────────────────────────────────────────
   ;; (These kick in when tree-sitter is active and provides finer-grained faces)
   `(treesit-font-lock-face  ((t :foreground ,base)))  ;; fallback

   ))  ; end custom-theme-set-faces

;; ── Control-flow keyword override ───────────────────────────────────────────
;;
;; Tonsky says "don't highlight keywords" — we partially agree.
;; Generic structural keywords (let, do, lambda, fn, def…) stay as base text.
;; But CONTROL FLOW keywords (if, when, cond, case, switch, for, while,
;; unless, until, match, loop, break, continue, return, yield, throw, raise,
;; try, catch, except, finally…) get a soft orange — they mark decision/flow
;; points which ARE worth finding quickly.
;;
;; Strategy: use font-lock-add-keywords to match them AFTER the main pass.

(defun alabaster-refined--add-control-flow-keywords ()
  "Add control-flow highlighting on top of the base theme."
  (font-lock-add-keywords
   nil
   `(;; Common control flow across C/JS/Python/Ruby/Rust/Go/Elisp/Clojure etc.
     (,(regexp-opt
        '(;; Conditionals
          "if" "else" "elif" "elsif" "unless" "when" "whenever"
          "cond" "case" "switch" "match" "guard"
          ;; Loops
          "for" "foreach" "while" "until" "loop" "do" "repeat"
          "break" "continue" "next" "redo"
          ;; Error handling
          "try" "catch" "except" "finally" "rescue" "ensure"
          "raise" "throw" "rethrow"
          ;; Return / yield
          "return" "yield" "await" "async"
          ;; Clojure/Lisp specific
          "if-let" "when-let" "if-not" "when-not" "condp" "case"
          "dotimes" "doseq" "doall" "dorun" "recur"
          ;; Rust specific
          "where" "impl" "trait" "pub" "mod" "use" "as"
          ;; Go specific
          "go" "select" "defer" "fallthrough" "chan" "range"
          ;; Python
          "with" "assert" "pass" "del" "global" "nonlocal" "lambda"
          ;; Other
          "and" "or" "not" "in" "is" "new" "delete" "typeof" "instanceof"
          "void" "null" "nil" "true" "false" "this" "self" "super")
        'words)
      1 '((t :foreground "#CE9178")) t))
   'end))  ; 'end = add at end so it runs after default font-lock

;; Wire it up for every programming mode
(add-hook 'prog-mode-hook #'alabaster-refined--add-control-flow-keywords)

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'alabaster-refined)

;;; alabaster-refined-theme.el ends here
