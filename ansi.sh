#!/usr/bin/env bash

# Copyright (c) Bruno Sales <me@baliestri.dev>. Licensed under the MIT License.
# See the LICENSE file in the project root for full license information.

declare __CONSOLE_VERSION="v2023.02.18"
declare __CONSOLE_CODENAME="[fg:ansi(87)]flos[/]"

declare -A __CONSOLE_PREDEFINED_COLORS=(
  ["black"]=0
  ["red"]=196
  ["green"]=46
  ["yellow"]=226
  ["blue"]=27
  ["magenta"]=201
  ["cyan"]=51
  ["white"]=7
  ["gray"]=8
  ["bright-black"]=8
  ["bright-red"]=9
  ["bright-green"]=10
  ["bright-yellow"]=11
  ["bright-blue"]=12
  ["bright-magenta"]=13
  ["bright-cyan"]=14
  ["bright-white"]=15
)

function __ansi.sh:reset() {
  printf '\033[0m'
}

function __ansi.sh:rgb-to-ansi() {
  local -i r="$1"
  local -i g="$2"
  local -i b="$3"

  if [[ -z "${r}" || -z "${g}" || -z "${b}" ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "missing rgb color"
    return 1
  fi

  if [[ "${r}" -lt 0 || "${r}" -gt 255 || "${g}" -lt 0 || "${g}" -gt 255 || "${b}" -lt 0 || "${b}" -gt 255 ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid rgb color '[fg:yellow bold]${r},${g},${b}[/]'"
    return 1
  fi

  local -i ansi=16

  ansi+=$((r / 51 * 36))
  ansi+=$((g / 51 * 6))
  ansi+=$((b / 51))

  printf "%d" "${ansi}"
}

function __ansi.sh:hex-to-ansi() {
  local hex="$1"

  if [[ -z "${hex}" ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "missing hex color"
    return 1
  fi

  if [[ "${hex:0:1}" == "#" ]]; then
    hex="${hex:1}"
  fi

  if [[ "${#hex}" -lt 3 || "${#hex}" -gt 6 ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hex color '[fg:yellow bold]${hex}[/]'"
    return 1
  fi

  local -i r="$(printf '0x%s' "${hex:0:2}")"
  local -i g="$(printf '0x%s' "${hex:2:2}")"
  local -i b="$(printf '0x%s' "${hex:4:2}")"

  __ansi.sh:rgb-to-ansi "${r}" "${g}" "${b}"
}

function __ansi.sh:colorize() {
  local type="$1"
  local -i ansi="$2"

  if [[ -z "${type}" || -z "${ansi}" ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "missing color type or ansi color"
    return 1
  fi

  if [[ "${ansi}" -lt 0 || "${ansi}" -gt 255 ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid ansi color '[fg:yellow bold]${ansi}[/]'"
    return 1
  fi

  if [[ "${type}" =~ ^(foreground|fg)$ ]]; then
    printf "\033[38;5;%dm" "${ansi}"
  elif [[ "${type}" =~ ^(background|bg)$ ]]; then
    printf "\033[48;5;%dm" "${ansi}"
  else
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid color type '[fg:yellow bold]${type}[/]'"
    return 1
  fi

  return 0
}

function __ansi.sh:colorsheet-ansi() {
  local -i iter=0

  while [ ${iter} -lt 52 ]; do
    local -i second="${iter} + 48"
    local -i third="${second} + 36"
    local -i fourth="${third} + 36"
    local -i fifth="${fourth} + 36"
    local -i sixth="${fifth} + 36"
    local -i seventh="${sixth} + 36"

    if [[ ${seventh} -gt 255 ]]; then
      break
    fi

    echo -ne "\033[38;5;${iter}m█ "
    printf "%03d\t" ${iter}

    echo -ne "\033[38;5;${second}m█ "
    printf "%03d\t" ${second}

    echo -ne "\033[38;5;${third}m█ "
    printf "%03d\t" ${third}

    echo -ne "\033[38;5;${fourth}m█ "
    printf "%03d\t" ${fourth}

    echo -ne "\033[38;5;${fifth}m█ "
    printf "%03d\t" ${fifth}

    echo -ne "\033[38;5;${sixth}m█ "
    printf "%03d\t" ${sixth}

    echo -ne "\033[38;5;${seventh}m█ "
    printf "%03d\t" ${seventh}

    iter="${iter} + 1"

    printf '\r\n'
  done

  __ansi.sh:reset
}

function __ansi.sh:colorsheet-rgb() {
  local -i r=0
  local -i g=0
  local -i b=0

  while [ ${r} -lt 256 ]; do
    while [ ${g} -lt 256 ]; do
      while [ ${b} -lt 256 ]; do
        local -i ansi="$(__ansi.sh:rgb-to-ansi "${r}" "${g}" "${b}")"

        echo -ne "\033[38;5;${ansi}m█ "
        printf "rgb(%03d, %03d, %03d)\t" ${r} ${g} ${b}

        b="${b} + 51"
      done

      b=0
      g="${g} + 51"

      printf '\r\n'
    done

    g=0
    r="${r} + 51"

    printf '\r\n'
  done

  __ansi.sh:reset
}

function __ansi.sh:colorsheet-hex() {
  local -i r=0
  local -i g=0
  local -i b=0

  while [ ${r} -lt 256 ]; do
    while [ ${g} -lt 256 ]; do
      while [ ${b} -lt 256 ]; do
        local -i ansi="$(__ansi.sh:rgb-to-ansi ${r} ${g} ${b})"

        echo -ne "\033[38;5;${ansi}m█ "
        printf "#%02x%02x%02x\t" ${r} ${g} ${b}

        b="${b} + 51"
      done

      b=0
      g="${g} + 51"

      printf '\r\n'
    done

    g=0
    r="${r} + 51"

    printf '\r\n'
  done

  __ansi.sh:reset
}

function __ansi.sh:colorsheet-predefined() {
  if [[ -n "${ZSH_VERSION}" ]]; then
    for color in "${(k)__CONSOLE_PREDEFINED_COLORS[@]}"; do
      local -i ansi="${__CONSOLE_PREDEFINED_COLORS[${color}]}"

      echo -ne "\033[38;5;${ansi}m█ "
      printf "%s\t" "${color}"

      printf '\r\n'
    done

    __ansi.sh:reset

    return 0
  fi

  for color in "${!__CONSOLE_PREDEFINED_COLORS[@]}"; do
    local -i ansi="${__CONSOLE_PREDEFINED_COLORS[${color}]}"

    echo -ne "\033[38;5;${ansi}m█ "
    printf "%s\t" "${color}"

    printf '\r\n'
  done

  __ansi.sh:reset
}

function __ansi.sh:parse() {
  local message="$@"

  if [[ -z "${message}" ]]; then
    ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "message is empty"
    return 1
  fi

  local tags=$(printf "${message}" | grep -Eo '\[([a-z :\(#.,0-9a-zA-Z/@\)])+\]' | sed -e 's#\[\/\]##g' | sed -e '/^$/d')
  local message="$(printf "${message}" | sed -e "s#\[\/\]#$(__ansi.sh:reset)#g")"

  local -i counter=0
  while IFS="\n" read -r tag; do
    local -a tokens=($(printf "${tag}" | tr -d '[]'))
    message="$(printf "${message}" | sed -e "s#\[${tokens[*]}\]#r!${counter}#g")"
    local -a ansi=()

    local tmp_hyperlink=""

    for token in ${tokens[*]}; do
      case "${token}" in

      bold)
        ansi=("\033[1m ${ansi[*]}")
        ;;

      italic)
        ansi=("\033[3m ${ansi[*]}")
        ;;

      underline)
        ansi=("\033[4m ${ansi[*]}")
        ;;

      strikethrough | linethrough)
        ansi=("\033[9m ${ansi[*]}")
        ;;

      dim | dimmed)
        ansi=("\033[2m ${ansi[*]}")
        ;;

      blink)
        ansi=("\033[5m ${ansi[*]}")
        ;;

      reverse)
        ansi=("\033[7m ${ansi[*]}")
        ;;

      hyperlink:uri*)
        local uri="$(printf "${token}" | grep -Eo '\((http[s]://?|mailto:?|ftp://?){1}([-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#\?&//=]*))\)' | tr -d '()')"

        if [[ -z "${uri}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hyperlink uri for '[fg:yellow bold]${token}[/]"
          return 1
        fi

        local position="$(printf "${message}" | grep -oP "r!${counter}.+?\033\[0m")"

        if [[ -z "${position}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hyperlink placeholder for '[fg:yellow bold]${uri}[/]'"
          return 1
        fi

        message="${message//${position}/r!${counter}}"

        local target="$(printf "${position}" | sed -e "s#r!${counter}##g")"

        tmp_hyperlink="\e]8;;${uri}\a${target}\e]8;;\a"
        ;;

      fg:rgb*)
        local rgb="$(printf "${token}" | grep -Eo '\([0-9,]+\)' | tr -d '()')"

        if [[ -z "${rgb}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid rgb color '[fg:yellow bold]${rgb}[/]'"
          return 1
        fi

        local -i r="$(printf "${rgb}" | cut -d ',' -f 1)"
        local -i g="$(printf "${rgb}" | cut -d ',' -f 2)"
        local -i b="$(printf "${rgb}" | cut -d ',' -f 3)"

        local ansi_value="$(__ansi.sh:rgb-to-ansi "${r}" "${g}" "${b}")"

        if [[ -z "${ansi_value}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid rgb color '[fg:yellow bold]${rgb}[/]'"
          return 1
        fi

        ansi+=("$(__ansi.sh:colorize "fg" "${ansi_value}")")
        ;;

      fg:hex*)
        local hex="$(printf "${token}" | grep -Eo '\([0-9a-fA-F]+\)' | tr -d '()')"

        if [[ -z "${hex}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hex color '[fg:yellow bold]${hex}[/]'"
          return 1
        fi

        local ansi_value="$(__ansi.sh:hex-to-ansi "${hex}")"

        if [[ -z "${ansi_value}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hex color '[fg:yellow bold]${hex}[/]'"
          return 1
        fi

        ansi+=("$(__ansi.sh:colorize "fg" "${ansi_value}")")
        ;;

      fg:ansi*)
        local ansi_value="$(printf "${token}" | grep -Eo '\([0-9]+\)' | tr -d '()')"

        if [[ -z "${ansi_value}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid ansi color '[fg:yellow bold]${ansi_value}[/]'"
          return 1
        fi

        ansi+=("$(__ansi.sh:colorize "fg" "${ansi_value}")")
        ;;

      fg:*)
        local color_token="$(printf "${token}" | cut -d ':' -f 2 | grep -Eo '[a-z-]+' | cut -d ' ' -f 1)"

        if [[ -z "${color_token}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid color '[fg:yellow bold]${color_token}[/]'"
          return 1
        fi

        if [[ -v __CONSOLE_PREDEFINED_COLORS["${color_token}"] ]]; then
          ansi+=("$(__ansi.sh:colorize "fg" "${__CONSOLE_PREDEFINED_COLORS[${color_token}]}")")
        else
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid color '[fg:yellow bold]${color_token}[/]'"
          return 1
        fi
        ;;

      bg:rgb*)
        local rgb="$(printf "${token}" | grep -Eo '\([0-9,]+\)' | tr -d '()')"

        if [[ -z "${rgb}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid rgb value '[fg:yellow bold]${rgb}[/]'"
          return 1
        fi

        local -i r="$(printf "${rgb}" | cut -d ',' -f 1)"
        local -i g="$(printf "${rgb}" | cut -d ',' -f 2)"
        local -i b="$(printf "${rgb}" | cut -d ',' -f 3)"

        local ansi_value="$(__ansi.sh:rgb-to-ansi "${r}" "${g}" "${b}")"

        if [[ -z "${ansi_value}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid rgb value '[fg:yellow bold]${rgb}[/]'"
          return 1
        fi

        ansi+=("$(__ansi.sh:colorize "bg" "${ansi_value}")")
        ;;

      bg:hex*)
        local hex="$(printf "${token}" | grep -Eo '\([0-9a-fA-F]+\)' | tr -d '()')"

        if [[ -z "${hex}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hex value '[fg:yellow bold]${hex}[/]'"
          return 1
        fi

        local ansi_value="$(__ansi.sh:hex-to-ansi "${hex}")"

        if [[ -z "${ansi_value}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid hex value '[fg:yellow bold]${hex}[/]'"
          return 1
        fi

        ansi+=("$(__ansi.sh:colorize "bg" "${ansi_value}")")
        ;;

      bg:ansi*)
        local ansi_value="$(printf "${token}" | grep -Eo '\([0-9]+\)' | tr -d '()')"

        if [[ -z "${ansi_value}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid ansi color '[fg:yellow bold]${ansi_value}[/]'"
          return 1
        fi

        ansi+=("$(__ansi.sh:colorize "bg" "${ansi_value}")")
        ;;

      bg:*)
        local color_token="$(printf "${token}" | cut -d ':' -f 2 | grep -Eo '[a-z-]+' | cut -d ' ' -f 1)"

        if [[ -z "${color_token}" ]]; then
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid color '[fg:yellow bold]${color_token}[/]'"
          return 1
        fi

        if [[ -v __CONSOLE_PREDEFINED_COLORS["${color_token}"] ]]; then
          ansi+=("$(__ansi.sh:colorize "bg" "${__CONSOLE_PREDEFINED_COLORS[${color_token}]}")")
        else
          ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid color '[fg:yellow bold]${color_token}[/]'"
          return 1
        fi
        ;;

      *)
        if [[ -v __CONSOLE_PREDEFINED_COLORS["${token}"] ]]; then
          ansi+=("$(__ansi.sh:colorize "fg" "${__CONSOLE_PREDEFINED_COLORS[${token}]}")")
        else
          ansi+=("[${token}]")
        fi
        ;;

      esac
    done

    local new_ansi="$(printf "${ansi[*]}" | sed -e 's# ##g')"
    new_ansi+="$(printf "${tmp_hyperlink}")"

    message="$(printf "${message}" | sed -e "s#r!${counter}#${new_ansi}#g")"

    counter+=1
  done <<<"${tags}"

  printf "%s" "${message}"
}

function __ansi.sh:writeline() {
  local message="$1"

  printf "%s\n" "$(__ansi.sh:parse "${message}")"
}

function __ansi.sh:help() {
  __ansi.sh:writeline "Usage: [fg:blue]ansi.sh[/] [options] [fg:ansi(93)]<message>[/]"
  printf "\n"
  printf "Options:\n"
  __ansi.sh:writeline "  [fg:green]-h, --help[/]\t\t\tShow this help message and exit"
  __ansi.sh:writeline "  [fg:green]-v, --version[/]\t\t\tShow version and exit"
  __ansi.sh:writeline "  [fg:green]--colorsheet[/] [fg:ansi(93)]<colorsheet>[/]\tList all colors in a colorsheet (available: [fg:ansi(93)]ansi[/], [fg:ansi(93)]rgb[/], [fg:ansi(93)]hex[/], [fg:ansi(93)]predefined[/])"
  __ansi.sh:writeline "  [fg:green]--hex-to-ansi[/] [fg:ansi(93)]<hex>[/]\t\tConvert a HEX color to 256 (example: [fg:ansi(93)]#ff0000[/])"
  __ansi.sh:writeline "  [fg:green]--rgb-to-ansi[/] [fg:ansi(93)]<rgb>[/]\t\tConvert a RGB color to 256 (example: [fg:ansi(93)]255,0,0[/])"
}

function __ansi.sh:version() {
  local -i year=2023
  local -i current_year=$(date +%Y)
  local license_url="https://github.com/baliestri/ansi.sh/blob/main/LICENSE"
  local author_email="me@baliestri.dev"

  if [[ ${current_year} -gt ${year} ]]; then
    year="${year}-${current_year}"
  fi

  __ansi.sh:writeline "[fg:blue bold]ansi.sh[/]/[fg:ansi(99) bold]${__CONSOLE_VERSION}[/] ~ ${__CONSOLE_CODENAME}"
  printf "\n"
  __ansi.sh:writeline "A library for writing to the console with colors and styles, available for [fg:ansi(106)]Bash[/] and [fg:ansi(106)]Zsh[/]."
  __ansi.sh:writeline "Licensed under the [fg:ansi(209) bold]MIT[/] License. See the [fg:ansi(209) bold hyperlink:uri(${license_url})]LICENSE[/] file in the project root for full license information."
  __ansi.sh:writeline "Copyright (c) [blue]${year}[/] [fg:ansi(50)]Bruno Sales[/] <[fg:ansi(39) bold hyperlink:uri(mailto:${author_email})]${author_email}[/]>."
}

function ansi.sh() {
  SHORT="h,v"
  LONG="help,version,colorsheet:,hex-to-ansi:,rgb-to-ansi:"

  PARSED=$(getopt --options="${SHORT}" --longoptions="${LONG}" --name "ansi.sh" -- "$@")

  if [[ $? -ne 0 ]]; then
    return 1
  fi

  eval set -- "${PARSED}"

  while true; do
    case "$1" in
    -h | --help)
      __ansi.sh:help
      return 0
      ;;
    -v | --version)
      __ansi.sh:version
      return 0
      ;;
    --colorsheet)
      if [[ "$2" =~ ^(ansi|rgb|hex|predefined)$ ]]; then
        __ansi.sh:colorsheet-$2
      else
        ansi.sh "[fg:red]ansi.sh: [/]" "[fg:blue bold]ansi.sh[/]" "invalid colorsheet type '[fg:yellow bold]$2[/]'"
      fi

      return 0
      ;;
    --hex-to-ansi)
      __ansi.sh:hex-to-ansi "$2"
      return 0
      ;;
    --rgb-to-ansi)
      local r="$(printf "$2" | cut -d ',' -f 1)"
      local g="$(printf "$2" | cut -d ',' -f 2)"
      local b="$(printf "$2" | cut -d ',' -f 3)"

      __ansi.sh:rgb-to-ansi ${r} ${g} ${b}
      return 0
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
    esac
  done

  __ansi.sh:writeline "$@"
}
