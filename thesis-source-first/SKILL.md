---
name: thesis-source-first
description: "Write or revise thesis, dissertation, graduation-project, or paper content with verified sources first. Use when the user explicitly says they are writing a thesis or paper, especially phrases such as '我在写论文', and also when the user asks to draft a section, supplement existing thesis content, expand an outline, add references, justify technical claims, or explain what should be written in a chapter. Keep the passive triggers too: Chinese requests such as '写论文', '补充论文内容', '这一节怎么写', '给我写一段', or similar academic-writing tasks that require factual grounding should also trigger this skill."
---

# Thesis Source First

Follow this workflow whenever the skill is triggered.

## 1. Build local context first

Read the user's existing thesis materials before writing.

- Inspect local outlines, chapter files, notes, and any thesis-related documents in the workspace.
- If the thesis is based on a code project, inspect the relevant code paths before making technical claims.
- Match the requested section to the surrounding chapter so the writing fits the thesis structure and avoids repetition.

## 2. Find at least one real source before drafting

Search for at least one source that directly supports the requested technical topic.

- Prioritize source fit over source type. The first question is whether the source directly and accurately supports the specific claim being written.
- Treat local bibliography files, prior drafts, opening reports, task books, and previously used references as candidate context only, not as authority. Re-verify each source claim by claim before reusing it.
- Do not mechanically treat papers as better than webpages. A highly relevant official or primary webpage is better than a weak or only loosely related paper.
- Do not keep an existing citation merely because it already appears in the workspace or in an earlier draft. If a newer, more direct, or otherwise better-matched source supports the claim more precisely, replace the weaker source.
- For related-work or related-technology sections in a thesis, use academic literature when it is both reliable and closely matched to the content being written, such as journal papers, conference papers, theses, books, or standards.
- For platform or framework definitions, prefer official documentation when it is the most accurate and best-matched source.
- Use the combination strategy only when it improves fit:
  official definition for platform-specific concepts when needed,
  plus academic literature as supplementary support when it genuinely matches the technical idea, method, value, or broader context.
- If an academic source is only tangentially related while an official or primary technical source is directly on point, prefer the better-matched source instead of forcing a paper citation.
- Do not rely on memory alone for factual technical statements when the user is asking for thesis content.

## 3. Verify the source

Check that the source is real and suitable before using it.

- Confirm the page exists and the domain or publisher is credible.
- Confirm the source actually supports the claim being made.
- If an existing local citation is stale, indirect, or less precise than a newly verified source, prefer the better source and update the citation instead of preserving the old one for consistency alone.
- Distinguish clearly between:
  project-specific facts from local code, and
  general technical facts from external sources.
- If the source is weak, vague, inaccessible, or unrelated, keep searching.
- If no reliable source is found, say so briefly and avoid fabricating citations or unsupported claims.

## 4. Write only after verification

Draft the response after local context and source verification are complete.

- First explain the content or give the requested thesis paragraph.
- Keep the writing aligned with the user's requested style, length, and chapter position.
- Base technical background statements on verified sources.
- Base implementation statements on the user's local code and thesis files.
- When useful, explicitly indicate which parts are inferred from code.
- Choose citations claim by claim based on best fit:
  use academic literature when it best supports the point,
  use official or primary technical documentation when that is the more precise match,
  and combine them only when the combination is genuinely stronger than either alone.

## 5. Use thesis-friendly output formatting

Format the output for users who write thesis content in Markdown and later convert it to LaTeX.

- Keep the main thesis content as plain text paragraphs whenever possible.
- Avoid fenced code blocks.
- Avoid bullet lists unless the user explicitly asks for a list.
- Avoid backticks unless they are absolutely necessary.
- Avoid Markdown headings unless the user explicitly asks for them.
- If the response includes thesis正文, 来源, 核实信息, or similar support sections, separate these sections with Markdown horizontal rules only.
- Use the horizontal rule line by itself, such as --- .
- Do not use other Markdown syntax just for visual decoration.

## 6. Prefer BibTeX output when the user uses a BibTeX workflow

When the user is maintaining references in BibTeX, treat BibTeX as the default citation-delivery format even if no local refs.bib file is present in the workspace.

- Do not require a local refs.bib or other .bib file to exist before choosing BibTeX output.
- If the user says their references are managed on a webpage or outside the current workspace, still provide BibTeX as the default citation format.
- When revising an existing thesis Markdown file, check whether the file already contains BibTeX entries, BibTeX citation keys, or BibTeX-oriented citation guidance, and continue that workflow if it is already in use.
- If the user is maintaining a BibTeX database, do not default to writing fully formatted plain-text reference entries in Markdown.
- Instead, provide:
  a suggested citation key,
  a ready-to-paste BibTeX entry,
  and brief guidance for how the key should be cited in the thesis body when needed.
- When academic literature is used, also provide the source location for that literature, such as a DOI URL, publisher page, journal page, or other verifiable access path, so the user can trace the paper source directly.
- When non-paper sources are used, also provide the concrete source location, such as the official page URL or primary documentation URL, so the provenance remains checkable.
- Only provide plain-text formatted bibliography entries if the user explicitly asks for them or if no .bib workflow is available.
- Generate BibTeX entries using verified source data only.
- Do not invent BibTeX fields such as volume, number, pages, publisher, institution, or year if they were not verified.
- Choose an appropriate BibTeX entry type such as @online, @article, @book, @inproceedings, @mastersthesis, or @phdthesis based on the verified source.

If the workspace contains a local thesis bibliography-format file such as a document named 参考文献格式, read it before writing citation entries.

- Prefer the local bibliography-format document over generic habits.
- If the file exists, use it to decide what source metadata must be present so the final rendered bibliography can satisfy the local rule.
- If the user asks for content that should be inserted directly into the thesis, provide ready-to-paste citation markers such as [1] in the body when appropriate.
- If no local bibliography-format document is found, say so briefly and fall back to a reasonable GB/T 7714-style entry for Chinese thesis writing.

## 7. Respect thesis-writing constraints

Keep the output suitable for academic drafting.

- Treat the target text as academic thesis prose rather than a technical report unless the user explicitly requests another style.
- Prefer formal, neutral, and academically conventional wording.
- Keep subject references explicit and consistent throughout the thesis text. Do not casually mix 本文, 本系统, 本课题, 本研究, or similar subjects in adjacent sentences without regard to what the sentence is actually about.
- Use 本文 for thesis-level actions and claims such as research purpose, research questions, chapter organization, methodological framing, contributions, conclusions, and statements about what the thesis discusses or argues.
- Use 本系统 for system-level actions and claims such as architecture, modules, interfaces, database design, indexing flow, retrieval behavior, UI interaction, implementation details, and test performance.
- Avoid 本课题 in the main thesis body unless the user explicitly wants that style or the surrounding department template strongly prefers it. In most thesis正文 contexts, prefer 本文 instead of 本课题.
- When introducing the implemented artifact for the first time, prefer phrasing such as “本文设计并实现的……系统”; after that, use 本系统 as the default short form when discussing the artifact itself.
- If a sentence is really about the implemented artifact, do not use 本文 as the grammatical subject just because the sentence appears in the thesis. For example, prefer “本系统实现了……” over “本文实现了……” when describing concrete system behavior.
- In thesis正文, avoid process-report phrasing such as “结合当前实现来看”, “在当前实现中”, “当前项目中”, “根据代码可知”, or similar wording that exposes the drafting or verification process. Rewrite these as direct academic statements about 本文 or 本系统 unless the user explicitly wants a notes-style explanation outside the body text.
- Avoid report-like phrases such as “根据某官方资料”, “查阅资料可知”, or similar sourcing language in the thesis body when a normal citation can carry the attribution.
- Prefer direct statement plus citation in the body, and keep source explanation, verification notes, or provenance discussion outside the thesis正文 unless the user explicitly wants them there.
- When the user asks whether figures, tables, or formulas should be added, judge this from the thesis content itself rather than answering abstractly. If a visual aid would materially improve clarity, identify the exact location and insert a concise placeholder directly into the original thesis text near the relevant paragraph.
- Prefer figure placeholders for architectures, workflows, process chains, interaction structures, technical relationships, and trend statistics; prefer table placeholders for literature comparison, module comparison, schema summaries, supported-type summaries, and other structured contrasts; prefer formula placeholders only when the section genuinely involves retrieval logic, metric definitions, set operations, scoring, or quantitative reasoning.
- Do not force formulas, figures, or tables into sections that do not naturally need them. If the surrounding prose already explains the point clearly and the visual adds little new information, do not add one just for completeness or appearance. Only add a figure, table, or formula when it materially improves explanation, comparison, structure, process understanding, or quantitative clarity. Keep placeholders short, thesis-appropriate, and consistent with the surrounding prose rather than turning the body into notes.
- In academic-thesis mode, prefer the most accurate and best-matched phrasing support rather than mechanically preferring literature-backed phrasing.
- Do not invent literature, publication details, page numbers, or quotations.
- Do not overstate capabilities that the local code does not actually implement.
- If the user's implementation differs from an idealized description, describe the implementation truthfully.

## 8. Perform a mandatory final bibliography-format check

Before finishing any thesis-writing response that includes sources or citation markers, perform a final check against the local bibliography-format requirements.

- Treat this as a hard requirement, not an optional polish step.
- Re-read the local 参考文献格式 document when needed before finalizing.
- Check that citation markers in the text match the required numbering style.
- If using BibTeX, check that the chosen entry type and populated fields are sufficient for the final rendered bibliography to match the local requirement.
- If not using BibTeX, check that bibliography entries match the required entry type and punctuation style.
- Check that the final output is consistent with the user's local thesis rules before returning it.
