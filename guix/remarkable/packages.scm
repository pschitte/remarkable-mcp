(define-module (remarkable packages)
  #:use-module (guix)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages ebook)
  #:use-module (gnu packages ocr)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz))

(define-public python-rmscene
  (package
    (name "python-rmscene")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "rmscene" version))
       (sha256
        (base32 "1ldrlljpj6d8p26nl89w6kvx6yzyz4r7bhd1pd3bjyaagcciychy"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-packaging))
    (native-inputs (list python-poetry-core))
    (home-page "https://github.com/ricklupton/rmscene")
    (synopsis "Read v6 .rm files from the reMarkable tablet")
    (description "Read v6 .rm files from the @code{reMarkable} tablet.")
    (license license:expat)))

(define-public python-rmc
  (package
    (name "python-rmc")
    (version "0.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "rmc" version))
       (sha256
        (base32 "1jrxa7ba02lrh9mb2877jcgb4vmqny9jpal2lfv8ah39ar6y3bsp"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-click python-rmscene))
    (native-inputs (list python-poetry-core))
    (home-page "https://github.com/ricklupton/rmc")
    (synopsis "Convert to/from v6 .rm files from the reMarkable tablet")
    (description
     "Convert to/from v6 .rm files from the @code{reMarkable} tablet.")
    (license license:expat)))

(define-public python-pytesseract
  (package
    (name "python-pytesseract")
    (version "0.3.13")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/madmaze/pytesseract")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16arn7ygk7ain5j5ayjcy10y6yhwfcc090i3r8q553m89rr1w0w1"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:tests? #f  ; tests require running tesseract and setup.py test is broken
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-tesseract-path
            (lambda* (#:key inputs #:allow-other-keys)
              (substitute* "pytesseract/pytesseract.py"
                (("tesseract_cmd = 'tesseract'")
                 (string-append "tesseract_cmd = '"
                                (search-input-file inputs "bin/tesseract")
                                "'"))))))))
    (propagated-inputs (list python-packaging python-pillow tesseract-ocr))
    (native-inputs (list python-setuptools))
    (home-page "https://github.com/madmaze/pytesseract")
    (synopsis "Python wrapper for Google's Tesseract-OCR")
    (description
     "Python-tesseract is a Python wrapper for Google's Tesseract-OCR.")
    (license license:asl2.0)))

(define-public python-remarkable-mcp
  (package
    (name "python-remarkable-mcp")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "remarkable_mcp" version))
       (sha256
        (base32 "0cgwaardhal60by58pc719f7aybdgsijkp1mh1xlrixq4mmr8y59"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))  ; tests require network access
    (propagated-inputs (list python-beautifulsoup4
                             python-cairosvg
                             python-ebooklib
                             python-httpx-sse
                             python-jsonschema
                             python-mcp
                             python-pillow
                             python-pydantic-settings
                             python-pymupdf
                             python-pytesseract
                             python-requests
                             python-rmc
                             python-rmscene
                             python-sse-starlette
                             python-starlette
                             python-typer
                             python-typing-inspection
                             python-uvicorn))
    (native-inputs (list python-hatchling))
    (home-page "https://github.com/SamMorrowDrums/remarkable-mcp")
    (synopsis "MCP server for accessing reMarkable tablet data")
    (description "MCP server for accessing @code{reMarkable} tablet data.")
    (license license:expat)))
