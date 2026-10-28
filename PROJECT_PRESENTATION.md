# How to Present: DevOps Project Generator

A presentation guide for this project: what to say, what to show, and what to avoid.
Target length is **12–15 minutes** (8–10 min of talk and demo plus Q&A). Trim the demo for a 5-minute slot.

---

## 1. The project in one sentence

> **"DevOps Project Generator turns a 2-minute questionnaire into a complete, production-style DevOps repository: CI/CD pipelines, Terraform, Docker/Kubernetes manifests, monitoring and security configs. You can use it from a Python CLI or from a browser-based studio."**

Memorize this. It's your opening line and your closing line.

---

## 2. What the project actually is (analysis)

### Two products, one idea

| Part | Tech | Size | What it does |
|------|------|------|--------------|
| **CLI** (`cli/`, `generator/`) | Python 3.8+, Typer, Rich, Jinja2, PyYAML | ~7,800 LOC, 20 commands | Renders Jinja2 templates into a real project folder on disk |
| **Templates** (`templates/`) | Jinja2 (`.j2`) | ~40 templates | CI (GitHub Actions, GitLab, Jenkins), Terraform/CloudFormation, Docker, K8s, blue-green, Prometheus, security policies |
| **Web UI Studio** (`web-ui/`) | Next.js 16, React 19, TypeScript, Tailwind 4, shadcn/ui, JSZip | ~13,800 LOC | 6 tools in the browser. Generates files client-side and downloads them as a ZIP |

### CLI commands worth knowing
`init` (interactive or flag-based), `list-options`, `validate`, `info`, `health`, `scan`, `audit` (compliance), `diagram` (Mermaid + ADR), `github` (repo push), `multi-env`, `backup`, `profile`, `template`, `test`, `cleanup`, `version`.

### Web UI tools
1. **Generator**: wizard → file preview → ZIP download or GitHub push
2. **Config Builder**: dependency graph, conflict detection, complexity score (0–100)
3. **Cost Advisor**: monthly cost estimate and savings suggestions
4. **Analytics**: local generation history (browser `localStorage`)
5. **Architecture Diagram**: SVG topology, Mermaid export, `ADR-001` download
6. **Security Scorecard**: CIS / SOC 2 / NIST / HIPAA / SLSA checklist gauge

### Architecture (draw this on one slide)

```
          ┌──────────────── User ────────────────┐
          │                                      │
     Terminal (CLI)                        Browser (Web UI)
          │                                      │
  Typer + Rich prompts                 React wizard (Next.js)
          │                                      │
  ProjectConfig (dataclass)            ProjectConfig (TS type)
          │                                      │
  Jinja2 TemplateEngine                TS generators in src/lib/generator
   + templates/*.j2                     (+ /api/generate route)
          │                                      │
  FileManager → project on disk        JSZip → .zip download / GitHub API
```

**Key design point to say out loud:** *"Both front ends share the same model. You pick an option in each category (CI, infra, deploy, environments, observability, security), and the generator composes the matching templates."*

---

## 3. Slide-by-slide outline (10 slides)

| # | Slide | What to say (talking points) | Time |
|---|-------|------------------------------|------|
| 1 | **Title**: name, your name, banner image (`public/banner.png`) | The one-sentence pitch | 0:30 |
| 2 | **The problem** | Every new service needs the same boilerplate: pipeline, Dockerfile, IaC, K8s manifests, monitoring, security scans. Teams copy-paste from old repos, which spreads drift, outdated practices and security gaps. Setting it up takes hours to days. | 1:00 |
| 3 | **The solution** | One tool, six decisions, a full repo in seconds. Opinionated defaults: multi-stage Docker, non-root containers, Trivy scans, multi-env configs. | 1:00 |
| 4 | **Supported options matrix** | Copy the "Supported Technology Matrix" table from the README. Emphasize *combinations*: 4 CI × 4 IaC × 3 deploy × 2 env × 3 observability × 3 security. | 0:45 |
| 5 | **Architecture** | The diagram above. Mention the template engine (Jinja2) and that the Web UI generates fully in the browser. | 1:00 |
| 6 | **Live demo: CLI** | See section 4 | 2:00 |
| 7 | **Live demo: Web UI** | See section 4 | 2:30 |
| 8 | **Generated output** | Show the folder tree: `.github/workflows`, `infra/`, `k8s/`, `monitoring/`, `security/`, `scripts/`, `docs/` | 0:45 |
| 9 | **Tech stack and engineering highlights** | Typer/Rich UX, Jinja2 templating, React 19 + Next 16, privacy-first (no backend DB, analytics in `localStorage`), error boundaries, validation layer | 1:00 |
| 10 | **Limitations, future work, thank you** | See section 6. End with the one-liner and the repo link. | 1:00 |

**Design tips for the slides**
- Match the project's own look: monochrome, serif headings, monospace code. That keeps the slides and the demo visually consistent.
- Keep no more than 3 bullets per slide. Put the detail in your speech, not on the slide.
- Use screenshots as a backup for every demo step (see the checklist).

---

## 4. Live demo script

### Demo A: CLI (about 2 min)

> ⚠️ **Run from source, not from a pip install.** `pyproject.toml` only packages `cli*` and `generator*`, so the `templates/` folder is not installed. Your own `devops-generator.log` shows a pip-installed run that found **0 templates** and produced empty folders. From the project root, use `python -m cli` instead:

```bash
cd devops-project-generator-master
pip install -r requirements.txt

# 1. Show what's available
python -m cli list-options

# 2. Generate a full stack in one command
python -m cli init \
  --name demo-stack \
  --ci github-actions \
  --infra terraform \
  --deploy kubernetes \
  --envs dev,stage,prod \
  --observability full \
  --security strict

# 3. Prove it's real
tree demo-stack -L 2          # or: ls -R demo-stack | head -50
cat demo-stack/.github/workflows/*.yml | head -40

# 4. Show the "extras"
python -m cli audit ./demo-stack
python -m cli diagram ./demo-stack --adr
```

**Narrate while it runs:** "Six decisions → about N files generated in under a second. Here's the GitHub Actions workflow: build, test, Trivy scan, deploy per environment."

### Demo B: Web UI (about 2.5 min)

```bash
cd web-ui
npm install      # do this BEFORE the presentation
npm run dev      # http://localhost:3000
```

Click path:
1. **Landing page** → scroll briefly to show the design → open the workspace
2. **Generator**: pick Node/TypeScript, GitHub Actions, AWS EKS, blue-green, Prometheus/Grafana, strict security
3. **Code & Manifest Viewer**: click through `Dockerfile` → `main.tf` → `deployment.yaml`. Show line numbers and the copy button
4. **Config Builder**: point at the complexity score and any conflict warnings
5. **Architecture Diagram**: show the SVG, then click *export Mermaid*
6. **Security Scorecard**: toggle a control (e.g. Cosign signing) and watch the gauge move. This is the most visual moment, so pause on it
7. **Download ZIP** → open it in Explorer to prove the files exist

---

## 5. Pre-presentation checklist

- [ ] `npm install` done and `npm run dev` tested on the **presentation machine**
- [ ] `python -m cli init ...` tested from the project root and the output folder contains files (not just empty dirs)
- [ ] Delete old output folders (`devops-project/`, `demo-stack/`) so the demo starts clean
- [ ] Close the noisy `.next/` folder in the IDE and use a large terminal font (≥18pt)
- [ ] Browser zoom at 125–150% so the audience can read the code viewer
- [ ] **Screenshots/recording of every demo step** in case the Wi-Fi, npm or a port fails
- [ ] Open the Analytics tab once beforehand. It reads `localStorage`, so it's empty on a fresh browser. Either generate 3–4 projects first or say "this fills as you use it"
- [ ] Skip the GitHub-push demo unless you have a token ready and a throwaway account. It is a real write to GitHub

---

## 6. Be accurate about these claims

Some README/CHANGELOG wording oversells what the code does. If an examiner or a technical audience opens the code, overclaiming hurts you. Say it this way instead:

| README says | What the code does | Say this instead |
|-------------|--------------------|------------------|
| "AI-powered recommendations" | Rule-based `if/else` logic in `optimizations.ts` and `analyze-dependencies.ts`. No AI or LLM calls | "Rule-based recommendations" |
| "Real provider pricing" | Hardcoded list-price estimates (e.g. EKS = $144/mo, `regionMultiplier = 1.0`) | "Approximate estimates based on public list prices" |
| "Active users / Countries" metrics | Derived from your own browser's local history | "Local usage history, nothing leaves the browser" |
| "Compliance audit (SOC 2, HIPAA…)" | A checklist score of which controls are present in the config | "A compliance-readiness checklist, not a certification" |
| "Production-ready" | Solid starting templates that still need secrets, real values and review | "A production-grade starting point" |

**Testing:** there are no automated tests (`test_*.py`) in the repo. If someone asks, be upfront and list it as future work.

### Attribution
This project was created by **Harshhaa Vardhan Reddy (@NotHarshhaa)** under the MIT License. If you are presenting it for a course, review or interview, **credit the original author on your title or final slide** and clearly state what *you* did (set it up, extended it, analyzed it, fixed something, deployed it). Presenting someone else's repo as entirely your own is the fastest way to lose credibility.

---

## 7. Limitations and future work (slide 10)

- Templates aren't bundled in the pip package (fix: add `templates/` as package data in `pyproject.toml`)
- No automated test suite: add `pytest` for the generator and snapshot tests for rendered templates
- Cost estimates are static: integrate the AWS/Azure/GCP pricing APIs
- Add Helm charts, ArgoCD/GitOps, and Pulumi as options
- Run the generated pipelines in CI to validate templates end to end (`terraform validate`, `kubeval`, `actionlint`)

---

## 8. Likely questions and answers

**Q: How is this different from cookiecutter or Yeoman?**
A: Those are generic scaffolding engines. This one is DevOps-specific: options are aware of each other (conflict detection, complexity score), and it adds analysis on top of generation (cost, compliance, architecture diagrams).

**Q: How do templates work?**
A: Jinja2 `.j2` files in `templates/`. The `ProjectConfig` object is passed in as variables, so, for example, the CI template adds a deploy stage per environment in `envs`.

**Q: Does the Web UI need a backend?**
A: No. Generation runs in the browser (TypeScript generators plus JSZip). There's an optional `/api/generate` route that returns the same output as JSON.

**Q: Is the generated code secure?**
A: Security level "strict" adds Trivy scans, non-root containers, RBAC, network policies and secret-scanning configs. It's a strong baseline, but you still need to manage real secrets and review the IAM policies.

**Q: How would you add a new technology, e.g. ArgoCD?**
A: Add a `.j2` template, register the option in `generator/config.py` (CLI) and `web-ui/src/lib/options` (UI), then map it in the generator.

**Q: What was the hardest part?**
A: Prepare your own honest answer. Good candidates: keeping the CLI and Web UI options in sync, or making template combinations valid together.

---

## 9. Closing line

> "Six choices, one command, a complete DevOps repo. It's a working pipeline, infrastructure, deployment, monitoring and security baseline, ready to customize. Thank you. Questions?"
