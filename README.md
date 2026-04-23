# IESopt Project Template

> [!CAUTION]
> This is experimental and work-in-progress, so if you are just starting out consider doing the steps yourself/manually to get to know them once.

## Overview

This allows setting up pre-defined project structures for IESopt projects.

> [!IMPORTANT]
> This requires that `git` and `uv` are installed on your system. Consult the installation instructions for [uv](https://docs.astral.sh/uv/getting-started/installation/) or [git](https://git-scm.com/downloads/) if you don't have them installed yet.

## Using this template

Execute the following command in a terminal to create a new project (inside the current working directory) using this template

```bash
uvx cookiecutter gh:ait-energy/iesopt-project-template
```

and answer the questions in the terminal. For example, if you execute the command in `C:\Users\username\dev`, the new project will automatically be created in `C:\Users\username\dev\your_project_name`.

## Improving this template

Run 

```bash
uvx cookiecutter -f iesopt-project-template
```

inside the folder where you cloned this template. So if this is in `C:\Users\username\dev\iesopt-project-template`, execute the command in `C:\Users\username\dev`. Then open the created folder and inspect or test the results there. Using the `-f` option ensures that `cookiecutter` overwrites an already existing folder, which is what you (most likely) want while iteratively updating something.

## Explanations & Problems

#### Why does it ask for my name / an author?

> This is used to set the author of the project. It is usually your name, but it can be anything you want. This is a part of the standardized `pyproject.toml` file, which controls your environment.

#### What is the project slug?

> This is a short abbreviation of the project name, that is used in a few places where spaces, etc., are not allowed. It is usually the same as the project name, but with spaces replaced by underscores and all letters in lowercase.

#### How can I accept default values?

> Every question ends in a `(something written here)`, which is the default value. If you want to accept the default value, just press `Enter` without typing anything.

#### What if it opens a weird `.sh` file in VSCode (or any other editor)?

> Open the file location of the `.sh` file that VSCode opened, then right-click it, select `Open with...`, then `Choose another app`, and then select `Git Bash`. Make sure to check the box that says `Always use this app to open .sh files` and then click `OK`. This will make sure that `.sh` files are opened with `Git Bash` in the future. After that, remove the folder and start from scratch. This time, it should work without any issues.

## Connecting to a remote repository

If you want to connect your local project to a remote repository, you can do so by executing the following command in the terminal:

```bash
git remote add origin <your-repo-url>
git push -u origin main
```

This can be used to push your local contents, e.g., to an internal/private GitLab repository. `<your-repo-url>` should be replaced with the URL of your remote repository (= _"the one that you would normally use to clone from"_).

## Remarks

The template contains various `.gitkeep` files, which are used to keep empty directories in the repository. These files are not necessary for the project and can be removed if desired.

# Available code

## List of available addons
- FullLoadHours (minimum full load hours)
- XOR (exclusive operation of components)


## List of available templates
with investment
- CHPBackpressure
- GeothermalHeatSource
- HeatOnlyBoiler
- HeatPump
- HeatStorage

without investment