# Refactoring Plan

## Overview

This refactoring plan aims to improve modularity, maintainability, test clarity, and automation of the `qa-fiware-tutorials` repository. The repository implements behavior-driven tests (BDD) for various FIWARE tutorials, with support for both NGSI-v2 and NGSI-LD APIs.

---

## 🔍 1. Project Analysis & Baseline

**Goal:** Understand current structure, execution flow, and test coverage.

- [ ] Run tests locally using `behave` and Docker Compose.

- Evaluate:
  - [ ] Test coverage & stability
  - [ ] Code duplication
  - [ ] Docker reliability
  - [ ] BDD feature file readability

- Missing tutorials:
  - NGSIv2:
    - [ ] 106. Subscribing to Changes in Context
  - NGSI-LD
    - [ ] 104. Concise Payloads
    - [ ] (@flopezag) 104. Entity Relationships refactor to 106. Entity Relationships 
    - [ ] (@flopezag) 105. Merge-Patch and Put
    - [ ] 106. Subscription  refactor to  107. Subscriptions
    - [ ] 108. Registrations
    - [ ] 109. Temporal Operations
    - [ ] 110. Extended Properties

---

## 📦 2. Modularize & Clarify Structure

**Goal:** Streamline code and separate concerns for clarity and reuse.

- [ ] Split `commons/`:
  - `docker_utils.py`, `http_utils.py`, `json_utils.py`, etc.
- Refactor `config/`:
  - [ ] NGSI-v2 and NGSI-LD split
  - [ ] Rename `config.json` → `ngsi_v2.json`, `ngsi_ld.json`
- [ ] Group `.feature` files:
    
    features/
    
    ├── ngsi_v2/
    
    └── ngsi_ld/

- [ ] Unify or reuse shared step definitions.

---

## 🔧 3. Clean & Simplify Shell Scripts

**Goal:** Improve automation, clarity, and reusability.

- [ ] Audit and clean: `ngsiv2.sh`, `ngsild.sh`, `generate_allure_documents.sh`
- [ ] Extract reusable logic (e.g., for cURL validation).
- Improve script UX:
    - [ ] Add CLI flags and help
    - [ ] Add error checking: `set -euo pipefail`
- [ ] Add `bootstrap.sh` or `init.sh` for local test setup.

---

## ⚙️ 4. Improve Configuration Management

**Goal:** Support flexible environments and secure sensitive data.

- Add `.env` support for:
    - [ ] `OPENWEATHER_API_KEY`
    - [ ] FIWARE service URLs
- [ ] Use sample config templates `config.sample.json`
- [ ] Centralize configuration parsing in Python.

---

## 🧪 5. Enhance BDD Tests & Data Management

**Goal:** Make feature files more reusable, modular, and clear.

- [ ] Refactor repetitive steps into `Scenario Outline`.
- [ ] Add reusable data fixtures:
    - [ ] Move JSON payloads to `features/data/`
    - [ ] Improve step reuse with shared libraries
- [ ] Add tags: `@ngsi_v2`, `@ngsi_ld`, `@weather`, etc.
- [ ] Add retry logic or health checks for dependent services.

---

## 🤖 6. GenAI-Assisted Feature File Generation

**Goal:** Automatically generate `.feature` files from HTML documentation using GenAI.

- **Use case:** HTML docs with `curl` examples (requests + responses).

- **Tooling:**
- Use ChatGPT API or local LLM to:
  1. [ ] Parse HTML documentation.
  2. [ ] Extract `curl` requests + responses.
  3. [ ] Generate `.feature` files in Gherkin syntax (with `Given`, `When`, `Then` steps).

- **Workflow:**
- [ ] Create `tools/genai_from_html.py`
- [ ] Input: URL or HTML file.
- [ ] Output: Suggested `.feature` files saved under `features/generated/`

- **Review process:**
- [ ] Generated scenarios reviewed by dev or QA before merge.

- **Benefits:**
- Fast onboarding for new tutorials.
- Coverage parity with updated FIWARE docs.

---

## 🧹 7. Code Cleanup & Linting

**Goal:** Enforce code style and readability.

- [ ] Use `black`, `flake8` (Python), and `shellcheck` (bash).
- [ ] Clean unused code, outdated data files.
- [ ] Add `.gitignore` to exclude:
- [ ] `.venv/`, `__pycache__/`, `.allure-results/`, Docker logs

---

## 🚀 8. CI/CD Enhancement

**Goal:** Ensure automated testing and build hygiene.

- Use GitHub Actions to:
    - [ ] Run `behave` tests for NGSI-v2 and NGSI-LD
    - [ ] Lint shell and Python code
    - [ ] Generate and upload Allure reports
    - [ ] Add badges to `README.md`:
    - [ ] Build status, code quality, Python version

---

## 📚 9. Documentation Improvements

**Goal:** Improve developer onboarding and usage clarity.

- Rewrite `README.md`:
    - [ ] Overview
    - [ ] Quickstart
    - [ ] Environment setup
    - [ ] Running tests
    - [ ] Add `CONTRIBUTING.md`
    - [ ] Document GenAI-assisted test generation
    - [ ] Optional: Generate Sphinx or MkDocs documentation

---

## 📦 10. Package & Distribute (Optional)

**Goal:** Allow reuse of helper modules via pip package.

- [ ] Add `setup.py` or `pyproject.toml`
- [ ] Versioning for releases
- [ ] Publish on PyPI (optional)

---

## 🧩 11. Final Review & Maintenance

**Goal:** Wrap up and ensure long-term quality.

- [ ] Peer review of refactored code
- [ ] Merge changes incrementally
- [ ] Document maintenance cycles and long-term goals

---

