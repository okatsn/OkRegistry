[TOC]
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


#### Travis CI
[How to Setup Travis CI with Coveralls for a Julia Package](https://www.youtube.com/watch?v=jFCIJbAQStA)

Travis CI with julia
- https://docs.travis-ci.com/user/languages/julia/
- https://travis-ci.community/t/example-using-travis-ci-for-julia/3306

[An example](https://github.com/SciML/DiffEqDocs.jl/blob/master/.travis.yml) where:
```yaml
language: julia

notifications:
  email: false

jobs:
  include:
    - stage: "Documentation"
      julia: 1.5
      os: linux
      script:
        - julia --color=yes --project=docs/ -e 'using Pkg; Pkg.instantiate()'
        - julia --color=yes --project=docs/ docs/make.jl
      after_success: skip
```


#### Github Actions
[Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)

##### secrets
[Set it here as an example](https://github.com/okatsn/DataFrameTools.jl/settings/secrets/actions)


###### SSH KEYS

[SSH commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification)

- [Create a SSH key like this](https://www.inmotionhosting.com/support/server/ssh/how-to-add-ssh-keys-to-your-github-account/); in Git-bash, do:
  ```
  t2276@DESKTOP-800FKD5$ ssh-add -l
  Could not open a connection to your authentication agent.
  
  t2276@DESKTOP-800FKD5$ eval "$(ssh-agent)"
  Agent pid 1638
  
  t2276@DESKTOP-800FKD5$ ssh-add -l
  The agent has no identities.
  
  t2276@DESKTOP-800FKD5$ ssh-keygen -t rsa -b 4096 -C "okatsn@gmail.com"
  
  Generating public/private rsa key pair.
  Enter file in which to save the key (/c/Users/t2276/.ssh/id_rsa): 
  Created directory '/c/Users/t2276/.ssh'.
  Enter passphrase (empty for no passphrase):
  Enter same passphrase again: 
  Your identification has been saved in /c/Users/t2276/.ssh/id_rsa
  Your public key has been saved in /c/Users/t2276/.ssh/id_rsa.pub
  ```
  > or alternatively [like this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
  > Also see [Adding your SSH key to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) (this seems to be done only once?)
- Print the public key
  ```
  C:\Users\t2276> cat .ssh/id_rsa.pub
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKDGia2q0.......
  ......................................................
  ......................................................
  HGZOSEFXVP2FjesdBXEqnl8JbsQB4T7pLAw== okatsn@gmail.com
  ```
- [Add the public key to your Github account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).
- [Telling Git about your SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key)...TO_BE_CONTINUED

Also see [Signing tags](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-tags)

CHECKPOINT: 
- see the error message: [Error: Input required and not supplied: key](https://github.com/okatsn/DataFrameTools.jl/runs/8149226032?check_suite_focus=true)
- [GitHub Action YAML 撰寫技巧 - 環境變數(Environment Variables) 與 秘密 (Secrets)]https://ithelp.ithome.com.tw/articles/10263300?sc=iThomeR

##### Syntax
Trigger a workflow
- `on: events_that_trigger_workflows`
  - [on](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on) 
  - [events-that-trigger-workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
- run based on what file paths are changed
  - [on.<push|pull_request|pull_request_target>.<paths|paths-ignore>](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpull_request_targetpathspaths-ignore)
  


##### Julia Actions
An organisation to host and maintain GitHub Actions useful for Julia projects.
see https://github.com/julia-actions

### YAML script
What is YAML?
[Learn yaml in Y minutes](https://learnxinyminutes.com/docs/yaml/)

An example of Github actions (**NOT WORKING YET**)
```yaml
name: TagBot
on:
  issue_comment:
    types:
      - created
  # see https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#issue_comment
  workflow_dispatch:
  # see https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch
jobs:
  TagBot:
    if: github.event_name == 'workflow_dispatch' || github.actor == 'JuliaTagBot'
    runs-on: ubuntu-latest
    steps:
      - uses: JuliaRegistries/TagBot@v1
        with:
          ssh: ${{ secrets.DOCUMENTER_KEY }}
          token: ${{ secrets.GITHUB_TOKEN }}
          registry: okatsn/OkRegistry # for custom registry
          # If your registry is public, this is all you need to do. 
          # For more information, see [here](https://github.com/JuliaRegistries/TagBot#custom-registries)
```

## Register to the General registry
use [Registrator.jl](https://github.com/JuliaRegistries/Registrator.jl)