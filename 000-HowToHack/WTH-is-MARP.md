# WTH is MARP?

[MARP](https://marp.app/) is a tool for converting Markdown into HTML slides.  It does not provide the same power or [WYSIWYG](https://en.wikipedia.org/wiki/WYSIWYG) tooling as Powerpoint, but instead trades it for simplicity.

# Why MARP?

Smaller Git repos make for easier cloning and better chance for contributions.

The issue with storing PPT files in this repo is because Git is optimized to see changes in text files.  If the file stored is binary (e.g. Powerpoint files), then git will create a copy of that file.  As of this writing, the Lectures.ppt file revisions accounts for 600+ MB in this repo.

# How to use MARP

Here's the three steps to getting started:
* Install MARP
* Create slides in Markdown
* Export Markdown to HTML

## Install MARP

The easiest way to get started is using [MARP in VSCode](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode).

## Create slides in Markdown

The easiest way to create is to start with an existing example.

### Examples

* [WTH Advanced Kubernetes Coach Slides](https://microsoft.github.io/WhatTheHack/023-AdvancedKubernetes/Coach/slides.html)
  * [Slide source file](https://raw.githubusercontent.com/microsoft/WhatTheHack/master/023-AdvancedKubernetes/Coach/slides.md)
* [MARP Example slides](https://speakerdeck.com/yhatt/marp-basic-example)
* [MARP themes](https://github.com/marp-team/marp-core/tree/main/themes) 

## Export Markdown to HTML

To export the content of active Markdown editor, open the quick pick from Marp icon on toolbar <img src="https://raw.githubusercontent.com/marp-team/marp-vscode/main/docs/toolbar-icon.png" width="16" height="16" /> and select **"Export slide deck..."**. (`markdown.marp.export`)

<p align="center">
  <img src="https://raw.githubusercontent.com/marp-team/marp-vscode/main/docs/export.gif" alt="Export slide deck" width="600" />
</p>


# FAQ

* Q: Why MARP vs Reveal.js? 
  * A: Reveal.js is great and powerful and complex.  It uses Javacript as a baseline, and we wanted to make this as easy on new developers who might not use JS or even have NPM installed.
* Q: How do I make MARP do what I want?
  * A: This will not have the same power or flexibility as Powerpoint.  
  * You can customize the presentation with [MARP directives](https://marpit.marp.app/directives).