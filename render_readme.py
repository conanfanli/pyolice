with open("README.template.md") as f:
    template = f.read()
    rendered = template.format(COMMAND_DOCS="HI")

with open("README.md", "w") as out:
    print(rendered, file=out)
