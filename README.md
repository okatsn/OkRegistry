
## Create registry and add local Package to the registry
Go to the script `add_local_pkg_to_registry.jl`.


## Applying your registry -- In a certain environment
### Adding an registry to the current environment
Do this only once per environment.
```julia
using Pkg
pkg"registry add https://github.com/okatsn/OkRegistry.git"
```

### Update existing registry

```julia-repl
pkg> registry up OkRegistry
```

> not tested yet; see https://pkgdocs.julialang.org/v1/registries/

# Reference


- [HolyLabRegistry](https://github.com/HolyLab/HolyLabRegistry)
- [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl)
- [Tips and tricks to register your first Julia package](https://www.juliabloggers.com/tips-and-tricks-to-register-your-first-julia-package/)
- [Developing Julia Packages by Chris Rackauckas](https://www.youtube.com/watch?v=QVmU29rCjaA)


## TODOs
### Create a git tag: 
- `git tag -a vX.X.X` (where this matches the version number you used in Project.toml)

### TagBot
See https://github.com/JuliaRegistries/TagBot

### CI
[Add Unregisted Package in julia with continious Integration(gitlab-ci)](https://stackoverflow.com/questions/70375922/how-to-add-unregisted-package-in-julia-with-continious-integrationgitlab-ci)

[How to Setup Travis CI with Coveralls for a Julia Package](https://www.youtube.com/watch?v=jFCIJbAQStA)

Travis CI with julia
- https://docs.travis-ci.com/user/languages/julia/
- https://travis-ci.community/t/example-using-travis-ci-for-julia/3306