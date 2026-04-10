import subprocess

if __name__ == "__main__":
    # fix for Open_SSL version conflict (installing specific python version before uv)
    subprocess.run(["uv", "python", "install", "{{ cookiecutter.python_version }}", "--managed-python"])
    iesopt_version = "{{ cookiecutter.iesopt_version }}"
    # init and sync uv
    iesopt = "iesopt" if iesopt_version == "latest" else "iesopt==" + iesopt_version
    subprocess.run(["uv", "add", iesopt])
    subprocess.run(["uv", "add", "pandas"])
    subprocess.run(["uv", "sync"])
    # init git
    subprocess.run(["git", "init", "--initial-branch=main"])
    subprocess.run(["git", "add", "."])
    subprocess.run(
        ["git", "commit", "--message", "chore(cookiecutter): initial commit", "--quiet"]
    )
    # add pre-commit and iesopt dependencies
    # subprocess.run(["uv", "tool", "install", "pre-commit", "--with", "pre-commit-uv"])
    subprocess.run(["uv", "pip", "install", "pre-commit"])
    subprocess.run(["uv", "run", "pre-commit", "install"])
    subprocess.run(["uv", "run", "python", "-c", "import iesopt"])
    subprocess.run(["git", "add", "."])
    subprocess.run(
        [
            "git",
            "commit",
            "--message",
            "chore(cookiecutter): initialize pre-commit and iesopt dependencies",
            "--quiet",
        ]
    )
    print("")
    print("IESopt project template setup complete for {{ cookiecutter.project_name }}!")
    print("")
    print("Consider adding a remote repository and pushing your changes:")
    print("  1. git remote add origin <your-repo-url>")
    print("  2. git push -u origin main")
