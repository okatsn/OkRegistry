# Reference
# https://blog.devgenius.io/the-most-underrated-feature-of-the-julia-programming-language-the-package-manager-652065f45a3a

# Noted that the Project.toml and Registry.toml is not allowed in a registry folder; add LocalRegistry in @v1.6.

dirmain(args...) = joinpath(dirname(pwd()), args...) # i.e. raw"D:\GoogleDrive\1Programming\julia"
dir_myregistry = dirmain("OkRegistry")

mypkgnames = [
    "DataFrameTools",
    "FileTools",
    "Shorthands",
    "HypertextTools",
]

localpkgpaths = dirmain.(mypkgnames .* ".jl")

# Create a local registry (only once)
using LocalRegistry
create_registry(dir_myregistry, # name
    "https://github.com/okatsn/OkRegistry.git", # repository url that already exists
    ; description="A julia local registry", # optional
    push=true
)

# Add local package to the registry created before


for pkgpath in localpkgpaths
    register(
        pkgpath,
        registry=dir_myregistry,
        push=true # optional
    )
end

# In cases you use `Pkg.develop("SomeNewPkg")` that was linked to the path such as "C:/Users//.julia/dev/SomeNewPkg", register the package like this (the following code don't work):

using LocalRegistry, SomeNewPkg
register(SomeNewPkg, "/home/tim/.julia/registries/HolyLabRegistry")

# See [this](https://github.com/HolyLab/HolyLabRegistry#using-localregistry) for more information

# Then git and push