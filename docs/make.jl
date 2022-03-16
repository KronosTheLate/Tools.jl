using Tools
using Documenter

DocMeta.setdocmeta!(Tools, :DocTestSetup, :(using Tools); recursive=true)

makedocs(;
    modules=[Tools],
    authors="KronosTheLate",
    repo="https://github.com/KronosTheLate/Tools.jl/blob/{commit}{path}#{line}",
    sitename="Tools.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://KronosTheLate.github.io/Tools.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/KronosTheLate/Tools.jl",
    devbranch="master",
)
