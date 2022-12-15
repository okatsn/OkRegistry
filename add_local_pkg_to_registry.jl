# Reference
# https://blog.devgenius.io/the-most-underrated-feature-of-the-julia-programming-language-the-package-manager-652065f45a3a
# Noted that the Project.toml and Registry.toml is not allowed in a registry folder; add LocalRegistry in @v1.6.

# Instruction:
# - `git clone https://github.com/okatsn/OkRegistry.git` to your dev folder
#
#
# Requirement:
# You'll need `registry add https://github.com/okatsn/OkRegistry.git` to use this script.
using LocalRegistry
"""
`folderlist(dir; join=true)` return the list of folder but no subfolder under `dir`. This function uses `walkdir`.
"""
function folderlist(dir; join=true)
    wd = walkdir(dir) # you cannot add topdown=false to walkdir; otherwise, popfirst! won't return the first level of target folders/files.
    allpaths = String[]
    (root, dir, file) = popfirst!(wd)
    ans = if join
        joinpath.(root, dir)
    else
        dir
    end
    return ans
end

"""
`folderlist(;kwargs...)` returns results in the current directory (`pwd`)
"""
function folderlist(;kwargs...)
    folderlist(pwd();kwargs...)
end

"""
`folderlist(expr::Regex, dir; join=true)` returns a vector of paths who match `expr`.
"""
function folderlist(expr::Regex, dir; join=true)
    allfolders = folderlist(dir; join = join)
    if join
        desired_ind = occursin.(expr, basename.(allfolders))
    else
        desired_ind = occursin.(expr, allfolders)
    end
    return allfolders[desired_ind]
end


dirmain(args...) = joinpath(dirname(pwd()), args...) # i.e. raw"D:\GoogleDrive\1Programming\julia"
dir_myregistry = dirmain("OkRegistry")

localpkgpaths = folderlist(r"^((?!OkRegistry).)*$", dirmain())


# # Update the registry of one package
# register("/home/jovyan/swc-forecast-insider/temp/dev/Shorthands", registry = dir_myregistry, push=true) # for example




# # Add all local package to the registry created before
# - Update an already registered package like this
# - Add a newly created package in exactly the same way
#
# ## Register/update a single local package
# register(dirmain("OkMLModels"), registry=dir_myregistry, push=true)
# ## Register/update all local packages
for pkgpath in localpkgpaths
    try
    register(
        pkgpath,
        registry=dir_myregistry,
        push=true # optional
    )
    catch e
        pkgname, pkgdir = map(f-> f(pkgpath), (basename, dirname))
        @warn "($(pkgname)) Error occurred in its registration to OkRegistry."
        @warn "Skipped (Error message: $e)"
    end
end
