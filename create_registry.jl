# #This is how OkRegistry is created
# ## Create a local registry (only once)
using LocalRegistry
dirmain(args...) = joinpath(dirname(pwd()), args...) # i.e. raw"D:\GoogleDrive\1Programming\julia"
dir_myregistry = dirmain("OkRegistry")

create_registry(dir_myregistry, # name
    "https://github.com/okatsn/OkRegistry.git", # repository url that already exists
    ; description="A julia local registry", # optional
    push=true
)


# In cases you use `Pkg.develop("SomeNewPkg")` that was linked to the path such as "C:/Users//.julia/dev/SomeNewPkg", register the package like this (the following code don't work):

using LocalRegistry, SomeNewPkg
register(SomeNewPkg, "/home/tim/.julia/registries/HolyLabRegistry")

# See [this](https://github.com/HolyLab/HolyLabRegistry#using-localregistry) for more information

# Then git and push
