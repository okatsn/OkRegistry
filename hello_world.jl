# Reference
# https://blog.devgenius.io/the-most-underrated-feature-of-the-julia-programming-language-the-package-manager-652065f45a3a

# Noted that the Project.toml and Registry.toml is not required for a registry; they exist for executing this script.

dirmain(args...) = joinpath(dirname(pwd()), args...) # i.e. raw"D:\GoogleDrive\1Programming\julia"
dir_myregistry = dirmain("OkRegistry")

mypkgnames = [
    "DataFrameTools",
    "FileTools",
    "Shorthands",
    "HypertextTools",
]

localpkgpaths = dirmain.( mypkgnames.*".jl")

# Create a local registry (only once)
using LocalRegistry
create_registry(dir_myregistry, # name
    "https://github.com/okatsn/OkRegistry.git", # repository url that already exists
    ; description = "A julia local registry", # optional
    push=true
)


for pkgpath in localpkgpaths
    register(
        pkgpath, 
        registry = dir_myregistry,
        # push=true # optional
    )
end

register(raw"D:\GoogleDrive\1Programming\julia\Shorthands.jl", registry = dir_myregistry)

# Adding an registry to current environment
using Pkg
pkg"registry add https://github.com/okatsn/OkRegistry.git"



# Adding package to a registry (1)
## See https://github.com/GunnarFarneback/LocalRegistry.jl#add-registry
using Pkg, LocalRegistry


for myurl in mypkglist
    Pkg.add(url=myurl)
end











# Adding package to a registry
# see: https://github.com/HolyLab/HolyLabRegistry#using-localregistry
# using LocalRegistry, SomeNewPkg
# register(SomeNewPkg, "/home/tim/.julia/registries/HolyLabRegistry")

# where you replace the specific package name and path to the appropriate value on your system. This will add a new commit to the branch of HolyLabRegistry you just created

#     Submit the branch as a PR to HolyLabRegistry
#     Once the PR merges, from the HolyLabRegistry directory do

# $ git checkout master
# $ git pull
# $ git branch -D teh/SomeNewPkg



# Package management
# Create a git tag: 
# - git tag -a vX.X.X (where this matches the version number you used in Project.toml)



# TagBot
# See https://github.com/JuliaRegistries/TagBot