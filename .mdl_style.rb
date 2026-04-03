# Only enable rules relevant to inline formatting issues in blog posts.
# Run via: bin/lint
rule "MD011" # Reversed link syntax: (text)[url] instead of [text](url)
rule "MD037" # Spaces inside emphasis markers: _ text_ or *text *
rule "MD038" # Spaces inside code span elements: ` text`
rule "MD039" # Spaces inside link text: [ text ](url)
