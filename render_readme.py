from pyolice.command_parser import get_parser

with open("README.template.md") as f:
    template = f.read()
    rendered = template.format(COMMAND_DOCS=get_parser().format_help()).strip()


with open("README.md", "w") as out:
    print(rendered, file=out)
