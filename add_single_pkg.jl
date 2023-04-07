# # Register/update a single local package
# ## Update the registry of one package
# register("/home/jovyan/swc-forecast-insider/temp/dev/Shorthands", registry = dir_myregistry, push=true) # for example
using LocalRegistry
a_single_pkg = "OkRegistrator"
register(joinpath(dirname(pwd()), a_single_pkg), registry=pwd(), push=true)
