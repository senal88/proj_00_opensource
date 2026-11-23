#!/usr/bin/env python3
"""Validacao read-only da estrutura de proj_00_opensource.

Checa contrato de arquivos, taxonomia, consistencia do INDEX.md, fila de URLs,
segredos acidentais e pendencias de intake. Nao escreve nada no repositorio.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DOMAINS = ("claude_code", "engenharia_reversa", "ia_produtividade", "ia_radar", "marketing_trafego", "saas_alternativas")
REQUIRED = (
    "PROJECT.md", "README.md", "INDEX.md", "HANDOFF.md",
    ".env.example", ".gitignore", "urls.txt", "channels.txt",
    "docs/taxonomia.md", "scripts/sync_gdrive.sh", "scripts/validate_repo.py",
)
VIDEO_ID = re.compile(r"_([A-Za-z0-9_-]{11})\.md$")
NAME_VIDEO = re.compile(r"^[a-z0-9]+(?:_[a-z0-9]+)*_[A-Za-z0-9_-]{11}\.md$")
NAME_SOURCE = re.compile(r"^[a-z0-9]+(?:_[a-z0-9]+)*_(?:drive|skip|manual|site|doc)_[a-z0-9]+(?:_[a-z0-9]+)*\.md$")
SECRET_PATTERNS = (
    re.compile(r"AIza[0-9A-Za-z_-]{35}"),
    re.compile(r"\bsk-[A-Za-z0-9]{20,}"),
    re.compile(r"\bgh[pousr]_[A-Za-z0-9]{20,}"),
    re.compile(r"\bxox[baprs]-[A-Za-z0-9-]{10,}"),
    re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----"),
)

passes: list[str] = []
fails: list[str] = []
warns: list[str] = []


def ok(msg: str) -> None:
    passes.append(msg)


def fail(msg: str) -> None:
    fails.append(msg)


def warn(msg: str) -> None:
    warns.append(msg)


def check_required() -> None:
    for rel in REQUIRED:
        if (ROOT / rel).is_file():
            ok(f"arquivo obrigatorio: {rel}")
        else:
            fail(f"arquivo obrigatorio ausente: {rel}")


def check_domains() -> None:
    for domain in DOMAINS:
        d = ROOT / domain
        if not d.is_dir():
            fail(f"dominio ausente na taxonomia: {domain}/")
            continue
        docs = sorted(p for p in d.glob("*.md") if p.is_file())
        if not docs:
            warn(f"dominio previsto sem conteudo: {domain}/")
        for p in docs:
            if NAME_VIDEO.match(p.name) or NAME_SOURCE.match(p.name):
                ok(f"taxonomia: {domain}/{p.name}")
            else:
                fail(f"fora do padrao de nomenclatura (forma A ou B): {domain}/{p.name}")


def check_index() -> None:
    index = ROOT / "INDEX.md"
    if not index.is_file():
        return
    text = index.read_text(encoding="utf-8")
    for domain in DOMAINS:
        d = ROOT / domain
        if not d.is_dir():
            continue
        for p in sorted(d.glob("*.md")):
            if p.name in text:
                ok(f"indexado: {domain}/{p.name}")
            else:
                fail(f"documento fora do INDEX.md: {domain}/{p.name}")


def check_queue() -> None:
    urls = ROOT / "urls.txt"
    if not urls.is_file():
        return
    index_text = (ROOT / "INDEX.md").read_text(encoding="utf-8") if (ROOT / "INDEX.md").is_file() else ""
    processed = {p.name for domain in DOMAINS for p in (ROOT / domain).glob("*.md")} if all((ROOT / d).is_dir() for d in DOMAINS) else set()
    for lineno, raw in enumerate(urls.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        if len(parts) != 2 or not parts[1].startswith("https://"):
            fail(f"urls.txt linha {lineno}: formato invalido (<dominio> <url>)")
            continue
        domain, url = parts
        if domain not in DOMAINS:
            fail(f"urls.txt linha {lineno}: dominio desconhecido '{domain}'")
            continue
        match = re.search(r"[?&]v=([A-Za-z0-9_-]{11})", url)
        if not match:
            fail(f"urls.txt linha {lineno}: video id nao reconhecido")
            continue
        vid = match.group(1)
        if any(name.endswith(f"_{vid}.md") for name in processed):
            ok(f"fila processada: {vid}")
        elif vid in index_text:
            ok(f"fila pendente declarada no INDEX.md: {vid}")
        else:
            fail(f"video {vid} nem processado nem listado como pendente no INDEX.md")


def check_secrets() -> None:
    for path in ROOT.rglob("*"):
        if not path.is_file() or ".git" in path.parts:
            continue
        if path.suffix in {".docx", ".png", ".jpg", ".jpeg", ".pdf", ".zip", ".gz"}:
            continue
        try:
            text = path.read_text(encoding="utf-8", errors="ignore")
        except OSError:
            continue
        for pattern in SECRET_PATTERNS:
            if pattern.search(text):
                fail(f"possivel segredo em {path.relative_to(ROOT)}")
                break


SENSITIVE_KEY = re.compile(r"(KEY|TOKEN|SECRET|PASSWORD|PASSWD|CREDENTIAL|PRIVATE)", re.IGNORECASE)


def check_env_example() -> None:
    env = ROOT / ".env.example"
    if not env.is_file():
        return
    for lineno, raw in enumerate(env.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        value = value.strip().strip('"').strip("'")
        if not SENSITIVE_KEY.search(key):
            continue
        if not value or value.startswith("{{"):
            continue
        fail(f".env.example linha {lineno}: {key.strip()} precisa de placeholder {{{{...}}}}")


def check_intake() -> None:
    local_root = ROOT.parent / f"{ROOT.name}__local"
    intake = local_root / "_intake"
    if not intake.is_dir():
        return
    pending = [p for p in intake.rglob("*") if p.is_file() and not p.name.startswith(".")]
    if pending:
        warn(f"intake aguardando triagem: {len(pending)} arquivo(s) em {intake}")
    else:
        ok("intake sem pendencias")


def main() -> int:
    check_required()
    check_domains()
    check_index()
    check_queue()
    check_env_example()
    check_secrets()
    check_intake()

    print("=" * 70)
    print("RELATORIO DE VALIDACAO - proj_00_opensource (read-only)")
    print("=" * 70)
    print(f"  PASS : {len(passes)}")
    print(f"  FAIL : {len(fails)}")
    print(f"  WARN : {len(warns)}")
    print("-" * 70)
    for label, items in (("FALHAS", fails), ("AVISOS", warns)):
        if items:
            print(f"{label}:")
            for item in items:
                print(f"  [!] {item}")
            print("-" * 70)
    if fails:
        print("STATUS FINAL: REPROVADO")
        return 1
    print("STATUS FINAL: APROVADO")
    return 0


if __name__ == "__main__":
    sys.exit(main())
