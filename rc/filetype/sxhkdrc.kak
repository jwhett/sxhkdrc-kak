# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*(/?sxhkdrc) %{
    set-option buffer filetype sxhkdrc
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=sxhkdrc %{
    require-module sxhkdrc

    set-option window static_words %opt{sxhkdrc_static_words}

    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window sxhkdrc-.+ }
}

hook -group sxhkdrc-highlight global WinSetOption filetype=sxhkdrc %{
    add-highlighter window/sxhkdrc ref sxhkdrc
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/sxhkdrc }
}

provide-module sxhkdrc %{

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/sxhkdrc regions

add-highlighter shared/sxhkdrc/content default-region group
add-highlighter shared/sxhkdrc/comment region '#' '$' fill comment
add-highlighter shared/sxhkdrc/bracket region '\{' '\}' fill value
add-highlighter shared/sxhkdrc/singleq region "'" "'" fill value
add-highlighter shared/sxhkdrc/doubleq region '"' '"' fill value
add-highlighter shared/sxhkdrc/evaluate-commands region -recurse '\(' '\$\(' '\)' fill value

add-highlighter shared/sxhkdrc/content/ regex XF86[a-zA-Z0-9]* 0:operator
add-highlighter shared/sxhkdrc/content/ regex F[0-9]{1,2} 0:operator
add-highlighter shared/sxhkdrc/content/ regex "[&\|,+@;]" 0:operator

evaluate-commands %sh{
    # Grammar
    keywords="super|shift|alt|control|ctrl|space|Return|Print"

    # Add the language's grammar to the static completion list
    printf %s\\n "declare-option str-list sxhkdrc_static_words ${keywords}" | tr '|' ' '

    # Highlight keywords
    printf %s "add-highlighter shared/sxhkdrc/content/ regex \b(${keywords})\b 0:keyword"
}
}
