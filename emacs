
(require 'cl)
(require 'anything)

(setq backup-inhibited t)
(setq-default
 mode-line-format
 '(""
   mode-line-modified
   "[%b]"
   global-mode-string
   "%[("
   mode-name mode-line-process minor-mode-alist
   "%n" ")%]--"
   (line-number-mode "L%l--")
   (column-number-mode "C%c--")
   (-3 . "%p") ;; position
   " -- " (:eval buffer-file-truename)
   " %-"
   ))

(prefer-coding-system 'utf-8)
(fset 'yes-or-no-p 'y-or-n-p)

(defun toolbars-off ()
  (dolist (mode '(tool-bar-mode
		  ;; menu-bar-mode
		  scroll-bar-mode))
    (if (fboundp mode) (funcall mode -1)))
)

(defun insert-date ()
  "Inserts date (formatted: %Y-%m-%D) at the current cursor location."
  (interactive)
  (insert (format-time-string "%Y-%m-%d"))
)

(defun insert-timestamp ()
  "Inserts timestamp (formatted: %Y-%m-%dT%H:%M:%S) at current cursor location.
See ISO 8601 timestamp standard for more details."
  (interactive)
  (insert (format-time-string "%FT%T%z"))
)

(defun setup-keys ()
  (global-set-key "\C-x\C-m" 'execute-extended-command)
  (global-set-key "\C-c\C-m" 'execute-extended-command)
  (global-set-key "\C-w" 'backward-kill-word)
  (global-set-key "\C-x\C-k" 'kill-region)
  (global-set-key "\C-c\C-k" 'kill-region)
  (global-set-key (kbd "<f5>") 'call-last-kbd-macro)
  (global-set-key (kbd "<f7>") 'font-lock-mode)
  (global-set-key (kbd "<f9>") 'insert-date)
  (global-set-key (kbd "<f10>") 'insert-timestamp)

)

(defun setup-ESS ()
  (add-to-list 'load-path "~/code/elisp/ess-18.10.2/lisp")
  (load "ess-autoloads")
  (require 'ess-site)
  (setq-default inferior-R-args "-q")
  ;; (add-to-list 'auto-mode-alist '("\\.rd$" . Rd-mode))
  (message "ESS stuff setup...")
  )

;;; This is taken from
;;;   http://www.emacswiki.org/emacs-fr/JorgenSchaefersEmacsConfig
;;; on 2010-09-01
(defun fc-insert-latex-skeleton ()
  "Insert a LaTeX skeleton in an empty file."
  (when (and (eq major-mode 'latex-mode)
             (= (point-min) (point-max)))
    (insert
      "\\documentclass[letterpage,11pt]{article}\n"
      "\\usepackage[margin=1in]{geometry}\n"
      "%%\\usepackage[english]{babel}\n"
      "\\usepackage{graphicx}\n\n"
      "\\usepackage[utf8]{inputenc}\n"
      "\\usepackage{url}\n"
      "\\usepackage{microtype}\n\n"
      "\\usepackage{amsmath}\n"
      "\\usepackage{amssymb}\n\n"
      "%%\\usepackagep[draft,allpages,grayness=0.0]{draftmark}\n"
      "%%\\usepackage{lastpage}%for page # of ##\n"
      "%%\\usepackage{fancyhdr}\n"
      "%%\\pagestyle{fancy}\n"
      ;; "%%\\fancypagestyle{plain}{%\n"
      ;; "%%  \\fancyhf{} % clear headers and footers\n"
      ;; "%%  \\fancyfoot[C]{\\bfseries \\thepage} % This is the default\n"
      ;; "%%  \\fancyfoot[C]{\\bfseries \thepage of \pageref{LastPage}}\n"
      ;; "%%  \\renewcommand{\\headrulewidth}{0pt}\n"
      ;; "%%  \\renewcommand{\\footrulewidth}{0pt}}\n"
      "%%\\usepackage[backend=biber,natbib=true]{biblatex}\n"
      "%%\\addbibresource{bibfile.bib}% . bib extension is needed!!\n"
      "%%\\addbibresource{bibfile2.bib}% Require for multiple bibs\n\n"
      "%%\\usepackage{apacite}% Has to be before natbib!!\n"
      "%%\\usepackage{natbib}\n"
      "\\usepackage{array}\n"
      "\\usepackage{verbatim}\n"
      "%%\\usepackage{listings}\n"
      "\\usepackage[T1]{fontenc}\n"
      "%%\\usepackage{fouriernc}\n"
      "%%\\usepackage{Sweave}\n"
      "%%\\usepackage{tgschola}% Closest to Century Schoolbook font!\n\n"
      "%%\\usepackage{booktabs}\n"
      "%%\\usepackage[normalem]{ulem}%For underlining\n"
      "%%\\usepackage{setspace} % For doublespacing!\n"
      "%%\\usepackage{tikz}\n"
      "%%\\usepackage[font=small,labelfont=bf,labelsep=endash]{caption}\n"
      "\\usepackage{hyperref} % !!!!SHOULD BE LAST PACKAGE!!!!\n"
      "%%\\hypersetup{%\n"
      "%%  raiselinks=false\n"
      "%%  , breaklinks=true\n"
      "%%  %% , backref=true\n"
      "%%  , colorlinks=true\n"
      "%%  , linkcolor=blue\n"
      "%%  , urlcolor=blue\n"
      "%%  , citecolor=green\n"
      "%%  %% , hidelinks=true\n"
      "%%  pdfinfo={\n"
      "%%    Title={}\n"
      "%%    , Subject={}\n"
      "%%  }\n"
      "%%}\n\n"
      "\\title{}\n"
      "\\author{Vijay~Lulla\\\\\n"
      "   Department of Geography\\\\\n"
      "   Indiana University Purdue Univeristy Indianapolis\\\\"
      "   Indianapolis, IN 46202\\\\"
      "   \\href{mailto:vijaylulla@gmail.com}{vijaylulla@gmail.com}}\n"
      "\\date{}\n"
      "\\begin{document}\n"
      "\\maketitle\n"
      "%%For R + Sweave files.\n"
      "%%\\DeifneVerbatimEnvironment{Sinput}{Verbatim}{xleftmargin=2em}\n"
      "%%\\DefineVerbatimEnvironment{Soutput}{Verbatim}{xleftmargin=2em}\n"
      "%%\\DefineVerbatimEnvironment{Scode}{Verbatim}{xleftmargin=2em}\n"
      "%%\\fvset{listparameters={\\setlength{\\topsep}{0pt}}}\n"
      "%%\\renewenvironment{Schunk}{\\vspace{\\topsep}}{\\vspace{\\topsep}}\n"
      "%%<<echo=false>>=\n"
      "%% options(width=60, continue=\"  \",\n"
      "%%   SweaveHooks=list(fig=function() par(mar=c(5.1,4.1,1.1,2.1))))\n"
      "%%@\n\n"
      "\n\n"
      "%%\\printbibliography% for biblatex!!\n"
      "%%\\bibliographystyle{apacite}\n"
      "%%\\bibliography{}\n"
      "\\end{document}\n")
      (forward-line -6))
)

(defun setup-auctex ()
  (load "auctex.el" nil t t)
  ;; (load "preview-latex.el" nil t t)
  (require 'tex-mik) ;; For use with MikTeX Only

  (autoload 'LaTeX-mode "tex-site" "AucTeX mode." t)
  (add-to-list 'auto-mode-alist '("\\.tex$" . LaTeX-mode))

  ;; (add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
  (add-hook 'find-file-hook 'fc-insert-latex-skeleton)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode) ;; use ` in math mode

  (setq TeX-parse-self t ; Enable parse on load
        ; TeX-auto-save t ; Enable parse on save
        TeX-quote-after-quote nil
        LaTeX-german-quote-after-quote nil
        TeX-electric-sub-and-superscript t
        LaTeX-babel-hyphen nil)
  ;; (setq TeX-master nil)
  (message "AUCTeX stuff setup...")
)

(progn
  (toolbars-off)
  (setup-keys)
  (display-time)
  (setup-ESS)
  (setup-auctex)
  (column-number-mode 1)

  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (setq-default auto-fill-function 'do-auto-fill)
)

(custom-set-variables
 '(blink-cursor-mode nil)
 '(display-time-day-and-date t)
 '(display-time-format "[ %m-%d %I:%M ]")
 '(global-font-lock-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(make-backup-files nil)
 '(require-final-newline t)
 '(scroll-step 15)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(track-eol t)
 '(transient-mark-mode nil))

(custom-set-faces
 '(cursor ((t (:background "blue"))))
 '(trailing-whitespace ((((class color) (background light)) (:background "gray"))))
)
