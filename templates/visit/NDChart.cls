% ---------------------------------------------------------------------
% LATEX class for the ND chart
% To install locally, do
% mkdir -p ~/Library/texmf/tex/latex/base
% cd ~/Library/texmf/tex/latex/base
% ln -s ~/Library/Application\ Support/Avian/Bundles/ND\ Chart.tmbundle/templates nd-chart-templates
% ---------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{NDChart}
\AtEndOfClass{\RequirePackage{microtype}}
\LoadClass[11pt]{article}

\RequirePackage{times}      % Loads the Times-Roman Fonts
\RequirePackage{mathptmx}   % Loads the Times-Roman Math Fonts
\RequirePackage{ifpdf}      % Needed to pick between latex and pdflatex

\RequirePackage{lipsum}

% ---------------------------------------------------------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage{titletoc}
\RequirePackage{fontenc,listings,ucs,hyperref}
\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage{graphicx,xcolor}
\RequirePackage[english]{babel}
\RequirePackage{etoolbox}

% ---------------------------------------------------------------------

% ---------------------------------------------------------------------
% margins
\RequirePackage[
		left=0.5in,%
                 right=0.5in,%
		top=1.25in,%
		headheight=0.75in,%
		headsep=0.1in,
		bottom=1.0in,%
		letterpaper]{geometry}%

\RequirePackage[
	        labelfont={bf,sf},%
                labelsep=period,%
                justification=raggedright]{caption}
% ---------------------------------------------------------------------
\RequirePackage{fancyhdr}  % Needed to define custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
\pagestyle{fancy}          % Enables the custom headers/footers
% Headers
\lhead{}%
\chead{}%
\rhead{}
% Footers
\lfoot{}%
\cfoot{}%
\rfoot{}%
\renewcommand{\headrulewidth}{1pt}
\renewcommand{\footrulewidth}{1pt}
% ---------------------------------------------------------------------
% IT would be better in many ways to use the builtin section commands,
% as defined below. However these seem to conflict with our use of wrapfig
% which is harder to replicate. I preserve the below configuration for posterity.
%
      % section/subsection/paragraph set-up
      %\RequirePackage[explicit]{titlesec}
      %\titleformat{\section}
      %  {\large\sffamily\bfseries}
      %  {}
      %  {0em}
      %  {#1}
      %  []
      %\titleformat{\subsection}
      %  {\sffamily\bfseries}
      %  {}
      %  {0em}
      %  {#1}
      %  []
      %\titleformat{\subsubsection}
      %  {\sffamily\small\bfseries}
      %  {}
      %  {0em}
      %  {#1}
      %  []
      %\titleformat{\paragraph}[runin]
      %  {\sffamily\small\bfseries}
      %  {}
      %  {0em}
      %  {#1}
      %\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{0pt}
      %\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
      %\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
      %\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{10pt}

\newif\iffirstsection
\firstsectiontrue
\renewcommand{\section}[1]{
  \iffirstsection
    \firstsectionfalse
  \else
    \noindent \hrulefill

  \fi
  \vspace{0.5em}
  \noindent {\textsf{\textbf{\large #1}}}
  \vspace{0.5em}

  \@afterindentfalse\@afterheading % No indent after headings
}

\renewcommand{\subsection}[1]{

  \vspace{0.5em}
  \noindent {\textsf{\textbf{\normalsize #1}}}
  \vspace{0.5em}

  \@afterindentfalse\@afterheading % No indent after headings
}



% ---------------------------------------------------------------------

\RequirePackage{enumitem}
% % a smaller bullet
\newcommand{\sbt}{\,\begin{picture}(-1,1)(-1,-3)\circle*{3}\end{picture}\ }
%
% %itemize inside boxes
\newlist{boxitemize}{itemize}{1}
\setlist[boxitemize]{
  itemsep=-0.2em,
  leftmargin=0.15in,
  label=\sbt,
  %these make ragged right
  before=\csname par\endcsname\raggedright,
  partopsep=0pt
}

%itemize outside boxes
\setlist[itemize]{
  topsep=0.2em,
  itemsep=.05em,
  leftmargin=0.25in,
  label=\sbt,
  before=\csname par\endcsname\raggedright,
  partopsep=0pt
}

%enumerate outside boxes
\setlist[enumerate]{
  topsep=0.2em,
  itemsep=.05em,
  leftmargin=0.25in,
  before=\csname par\endcsname\raggedright,
  partopsep=0pt
}

\newcommand*\NoIndentAfterEnv[1]{%
  \AfterEndEnvironment{#1}{\par\@afterindentfalse\@afterheading}}
\makeatother

\NoIndentAfterEnv{itemize}
\NoIndentAfterEnv{enumerate}

%-----------------------------------------------------------------
% Box environments
\usepackage{mdframed}
\usepackage{wrapfig}
\NoIndentAfterEnv{wrapfig}


\newmdenv[
frametitle=!!!ALERT,
linewidth = 1.5pt
]{alertbox}

\newmdenv[
linewidth = 1.5pt,
leftmargin= 0.2in,
skipabove=0in
]{sidebox}

\newenvironment{alert}
{ \begin{wrapfigure}{c}{\linewidth} \vspace{-5pt} \begin{alertbox}}
{ \end{alertbox} \end{wrapfigure} }

\NoIndentAfterEnv{wrapfigure}

