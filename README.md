<p align="center">
  <a href="#gh-dark-mode-only" target="_blank" rel="noopener noreferrer">
    <img src=".github/assets/ansi.sh-dark.svg" alt="ansi.sh">
  </a>

  <a href="#gh-light-mode-only" target="_blank" rel="noopener noreferrer">
    <img src=".github/assets/ansi.sh-light.svg" alt="ansi.sh">
  </a>
</p>

Write easily colored and styled texts in your terminal.

<hr>

## Preview (execute on your terminal)

![](.github/assets/preview.gif)

```bash
#!/usr/bin/env bash

eval "$(curl -sSL "raw.baliestri.dev/ansi.sh")" # use the script directly from the internet

ansi.sh "[red]This is red text[/]"
ansi.sh "[green]This is green text[/]"
ansi.sh "[yellow]This is yellow text[/]"
ansi.sh "[bg:blue]This is blue text[/]"
ansi.sh "[bg:magenta]This is magenta text[/]"
ansi.sh "[bg:cyan]This is cyan text[/]"
ansi.sh "[bold]This is bold text[/]"
ansi.sh "[underline]This is underlined text[/]"
ansi.sh "[blink]This is blinking text[/]"
ansi.sh "[reverse]This is reversed text[/]"
ansi.sh "[dim]This is dimmed text[/]"
ansi.sh "[italic]This is italic text[/]"
ansi.sh "[strikethrough]This is strikethrough text[/]"
ansi.sh "[hyperlink:uri(https://google.com)]This is a hyperlink[/]
```

## Installation

Download the `ansi.sh` script and put it in your project.

```bash
curl -sSL "raw.baliestri.dev/ansi.sh" > ansi.sh
curl -sSL "raw.baliestri.dev/ansi.sh" > ansi.zsh
```

Use directly from the internet:

```bash
eval "$(curl -sSL "raw.baliestri.dev/ansi.sh")"
```

Use an especific version:

```bash
curl -sSL "raw.baliestri.dev/ansi.sh/v2023.02.17" > ansi.sh
```

## Help

This is the help message for the `ansi.sh` script:

```text
Usage: ansi.sh [options] <message>

Options:
  -h, --help                    Show this help message and exit
  -v, --version                 Show version and exit
  --colorsheet <colorsheet>     List all colors in a colorsheet (available: ansi, rgb, hex)
  --hex-to-ansi <hex>           Convert a HEX color to 256 (example: #ff0000)
  --rgb-to-ansi <rgb>           Convert a RGB color to 256 (example: 255,0,0)
```

## Tags

> **PS**: you can use multiple tags until you close bracket.

```bash
ansi.sh "[fg:red bold hyperlink:uri(https://example.com)]Example Hyperlink[/]"
```

> **PS2**: you have to use the `[/]` tag to close the tag.

The following tags are supported:

| Tag                             | Description                                                | Note                                        |
| ------------------------------- | ---------------------------------------------------------- | ------------------------------------------- |
| `predefined_color`              | Set the foreground color                                   |                                             |
| `fg:predefined_color`           | Set the foreground color, see at `--colorsheet predefined` |                                             |
| `fg:ansi(number_from_0_to_255)` | Set the foreground color from the 256 color palette        |                                             |
| `fg:rgb(r,g,b)`                 | Set the foreground color from the RGB color palette        | Don't use `blank spaces` beetwen the values |
| `fg:hex(hex_color)`             | Set the foreground color from the hex color palette        | Don't use `#` in hex colors                 |
| `bg:predefined_color`           | Set the background color, see at `--colorsheet predefined` |                                             |
| `bg:ansi(number_from_0_to_255)` | Set the background color from the 256 color palette        |                                             |
| `bg:rgb(r,g,b)`                 | Set the background color from the RGB color palette        | Don't use `blank spaces` beetwen the values |
| `bg:hex(hex_color)`             | Set the background color from the hex color palette        | Don't use `#` in hex colors                 |
| `hyperlink:uri(some_uri)`       | Set the hyperlink                                          | The forward text will be the placeholder    |
| `bold`                          | Set the text to bold                                       |                                             |
| `dim/dimmed`                    | Set the text to dim                                        |                                             |
| `italic`                        | Set the text to italic                                     |                                             |
| `underline`                     | Set the text to underline                                  |                                             |
| `blink`                         | Set the text to blink                                      |                                             |
| `reverse`                       | Set the text to reverse                                    |                                             |
| `strikethrough/linethrough`     | Set the text to strikethrough                              |                                             |
