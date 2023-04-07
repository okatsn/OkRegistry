# # This script works as pwd() is the directory to the local repository of OkRegistry (where you have Project.toml, Registry.toml, .gitignore, and etc..)
# Reference
# https://blog.devgenius.io/the-most-underrated-feature-of-the-julia-programming-language-the-package-manager-652065f45a3a
# Noted that the Project.toml and Registry.toml is not allowed in a registry folder; add LocalRegistry in @v1.6.

# Instruction:
# - `git clone https://github.com/okatsn/OkRegistry.git` to your dev folder
#
#
# Requirement:
# You'll need `registry add https://github.com/okatsn/OkRegistry.git` to use this script.



# # Add all local package to the registry created before
# - Update an already registered package like this
# - Add a newly created package in exactly the same way
#
# ## Register/update all local packages
using OkRegistrator
okciregister()
