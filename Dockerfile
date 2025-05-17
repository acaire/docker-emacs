FROM ubuntu:24.04
ADD https://github.com/citation-style-language/styles/blob/c7de5bedd4caf9c2ce193e4ccc536f8b5899707b/apa.csl /root/apa/apa.csl
# texlive-latex-base provides:
  # wrapfig.sty
# texlive-latex-extra provides:
  # biblatex.sty
RUN apt-get update \
  && apt-get install \
    -y \
    --no-install-recommends \
      ca-certificates \
      emacs \
      git \
      openssl \
      texlive-bibtex-extra \
      texlive-latex-base \
      texlive-latex-extra \
    && rm -rf /var/cache/apt/lists
RUN git clone https://github.com/hlissner/doom-emacs ~/.emacs.d \
    && ~/.emacs.d/bin/doom install --env --fonts --hooks -!

# Add org ref
RUN <<EOF cat >> /root/.doom.d/packages.el
(package! org-ref)
EOF

RUN ~/.emacs.d/bin/doom sync

ENTRYPOINT ["emacs"]
