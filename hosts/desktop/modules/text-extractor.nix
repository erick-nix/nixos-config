{ pkgs, ... }:

let
  ocrHelper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Aditya190803/TextExtractor/main/build/ocr_helper.py";
    sha256 = "1m324asrnwbbqwysnxfb6hppgr7zr55a1h2vja4q9223x1bfdfcv";
  };

  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.pytesseract
    ps.pillow
  ]);
in

{
  environment.systemPackages = [
    pkgs.gnomeExtensions.text-extractor

    (pkgs.writeShellScriptBin "text-extractor-ocr" ''
      export TESSDATA_PREFIX="${pkgs.tesseract}/share/tessdata"
      export PATH="${pkgs.tesseract}/bin:$PATH"
      exec ${pythonEnv}/bin/python3 ${ocrHelper} "$@"
    '')
  ];
}
