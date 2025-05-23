FROM ubuntu:24.04
ADD https://raw.githubusercontent.com/citation-style-language/styles/c7de5bedd4caf9c2ce193e4ccc536f8b5899707b/apa.csl /root/apa/apa.csl
# texlive-fonts-extra provides:
  # fourier.sty
# texlive-latex-base provides:
  # wrapfig.sty
# texlive-latex-extra provides:
  # biblatex.sty
# texlive-plain-generic provides:
  # ulem.sty
# texlive-science provides:
  # siunitx.sty
RUN apt-get update \
  && apt-get install \
    -y \
    --no-install-recommends \
      biber \
      ca-certificates \
      emacs \
      git \
      latexmk \
      openssl \
      texlive-bibtex-extra \
      texlive-fonts-extra \
      texlive-latex-base \
      texlive-latex-extra \
      texlive-plain-generic \
      texlive-science \
    && rm -rf /var/cache/apt/lists
RUN git clone https://github.com/hlissner/doom-emacs ~/.emacs.d \
    && ~/.emacs.d/bin/doom install --env --fonts --hooks -!

# Add org ref
RUN <<EOF cat >> /root/.doom.d/packages.el
(package! org-ref)
EOF

RUN ~/.emacs.d/bin/doom sync

RUN <<EOF cat >> /root/.doom.d/config.el
(setq user-full-name "Ash Caire"
      user-mail-address "acaire@users.noreply.github.com")

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t)

(after! org
  (require 'ox-extra)
  (require 'org-ref)
  (ox-extras-activate '(ignore-headlines))
  ;; Keep track of time but not notes of closed Org Items

  (setq org-log-done 'time
        org-latex-logfiles-extensions '("1aux" "1bcf" "1bbl" "1blg" "1fdb_latexmk" "1fls" "1log" "1out" "1toc" "1run.xml" "1tex"))

(use-package! org-ref
  :after org
  :defer t
  :config
  (setq bibtex-dialect 'biblatex
        org-ref-default-citation-link 'parencite
        org-latex-prefer-user-labels t
        org-latex-src-block-backend 'engraved
        org-latex-with-hyperref nil
        org-latex-pdf-process '("latexmk -pdflatex=pdflatex -f -pdf -interaction=nonstopmode -output-directory=%o %f")))
EOF

ENTRYPOINT ["emacs"]
