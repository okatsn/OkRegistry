[TOC]
# OkRegistry
[How to read Compat.toml](https://github.com/JuliaLang/Pkg.jl/issues/1190)

See `add_local_pkg_to_registry.jl`

## Create registry and add local Package to the registry
> With this repo as an example

1. Go to the script `add_local_pkg_to_registry.jl`.

2. Using OkRegistrator.jl
```julia
(OkRegistry) pkg> up
julia> using OkRegistrator
julia> tryregisterat("../SmallDatasetMaker", pwd())
```


# Local registry
TODO: intro, docs, and etc.
- write a brief introduction for local registry.
  - how it works, when and why it is required

## Introduction

A registry is for registration of packages, it specify the following information:
- compatibility (`Compat.toml`)
- dependency    (`Deps.toml`)
- package       (`Package.toml`)
- versions      (`Versions.toml`)

Takes `YourPackage` as an exemplary package registered in the local registry `OkRegistry`.

`Compat.toml` specify version by version the compatibility between `YourPackage` and julia. For example, when you `pkg> add YourPackage` in a machine, only the version of `YourPackage` compatible with julia of that machine can be added.

`Deps.toml` specify what other packages `YourPackage` depends; noted that the version ranges stated inside `Deps.toml` are those of `YourPackage`. The version ranges of dependent packages of `YourPackage` is stated in the `[compat]` section in the `Project.toml` of `YourPackage`.

In final, `Package.toml` specify the uuid and the repository url (field `repo`) of `YourPackage`, and `Versions.toml` specify the `git-tree-sha` (commit hash) for each version of `YourPackage`.

With `reop` and `git-tree-sha`, we can have a specific and unique copy in the history of `YourPackage` cloned in our machine.

### Do I need my package to be registered?
A registered package (saying `YourPackage`) has its URL to repository stated in `Package.toml`, as well as version--commit-hash pair is stated in `Versions.toml`.

Without these information, `YourPackage` can only be added through `pkg> "https://github.com/okatsn/YourPackage.jl.git"` for example. 
Besides, you can only access the history (a different "version") by `git clone [URL]` and then `git checkout [commit-hash]`.
Furthermore, no compatibility check to prevent potential fail of a project relies on `YourPackage` and thus difficult to reproduce a certain state.

### When should I update my local registry?
You should update the registry when `YourPackage` has a **meaningful change that should be immediately applied by other** package/project depends on it **through `pkg> add`**.
"Meaningful change" is, for example, a new function, fixing a critical bug, redefine API, etc..

### When should I update the version number of my package registered in a local registry?
It is quite free to choose the timing, especially `YourPackage` is majorly for personal or small organizational use.
Conventionally, the time for updating version is likely to be a branch merged to main/master, or a pull request merge.

In general, update the version number of `YourPackage` as you want a copy in the history that can be easily accessed under the management of a local/general registry.

#### How to update the version number?
[Just manually edit `Project.toml`](https://stackoverflow.com/questions/67710714/proper-way-of-updating-a-version-number-for-self-developed-package-in-julia)

### Summary on updating version number and registry
Noted that `ERROR: Version x.x.x has already been registered and the content has changed.` will occurred if the content of `YourPackage` is changed BUT version number in its `Project.toml` doesn't.

**To avoid frequently updating your registry as well as version number, use `pkg> dev`** for establishing the dependency between `YourPackage` and a certain package or project (`YourProject` for example) relies on it.

Feel free to use `pkg> dev`. Everything is supposed to work fine if `[compat]` in every package is properly set.
For example, there is an other package, namely `WhatYourPackageDep` that `YourPackage` depends on via `pkg> dev`, and `YourProject` depends on `YourPackage`. 
In this case, `YourProject` can still use the latest functionality of `WhatYourPackageDep` via `YourProject`, as in `YourProject` environment, `using YourPackage` compile the code of `WhatYourPackageDep` at a local path instead (where you can see in the `Manifest.toml` of `YourPackage`, the `git-tree-sha` in `[[WhatYourPackageDep]]` is replaced by `path`, as [`dev` sticks a package to the "current state" while `add` sticks to "reproducible state"](https://pkgdocs.julialang.org/v1/managing-packages/#developing)).




## Applying your registry -- In a certain environment
### Adding an registry to the current environment
Do this only once per julia installation.
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


# Register to the General registry
use [Registrator.jl](https://github.com/JuliaRegistries/Registrator.jl)


# TODO: Try, organize and remove the followings
## Authentication
### SSH KEYS
SSH key always born into a pair, a public and private key.
The

[SSH commit signature verification](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification#ssh-commit-signature-verification)

[how-to-add-ssh-keys-to-your-github-account](https://www.inmotionhosting.com/support/server/ssh/how-to-add-ssh-keys-to-your-github-account/)
  
- [Manually start a ssh agent](https://docs.github.com/en/enterprise-cloud@latest/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) if `ssh-add -l` prints `Could not open a connection to your authentication agent. The agent has no identities.`
  ```bash
    t2276@DESKTOP-800FKD5$ eval "$(ssh-agent)"
    Agent pid 1638
  ```

- With an agent, you can generate a key pair
  ```bash 
    t2276@DESKTOP-800FKD5$ ssh-keygen -t rsa -b 4096 -C "okatsn@gmail.com"
    
    Generating public/private rsa key pair.
    Enter file in which to save the key (/c/Users/t2276/.ssh/id_rsa): 
  ```

- Enter `hello_ssh` for example, you'll get a public key `hello_ssh.pub` and a private key `hello_ssh`
  ```bash
    Created directory '/c/Users/t2276/.ssh'.
    Enter passphrase (empty for no passphrase):
    Enter same passphrase again: 
    Your identification has been saved in .ssh/id_rsa/hello_ssh
    Your public key has been saved in .ssh/hello_ssh.pub
  ```
  > or alternatively [like this](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
  > Also see [Adding your SSH key to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) (this seems to be done only once?)

- Print the public key and [Add the public key to your Github account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
  ```
  C:\Users\t2276> cat .ssh/hello_ssh.pub
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDKDGia2q0.......
  ......................................................
  ......................................................
  HGZOSEFXVP2FjesdBXEqnl8JbsQB4T7pLAw== okatsn@gmail.com
  ```
  or copy it to clipboard
  ```
  clip < ~/.ssh/hello_ssh.pub
  ```

- Tell [Telling Git about your (public) SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key)
  ```bash
  git config --global user.signingkey 'ssh-rsa AAAAB3Nza...pLAw== okatsn@gmail.com'
  ```

- Next, you have to [Adding your SSH Private key to the ssh-agent](https://docs.github.com/en/enterprise-cloud@latest/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent); check the list using the same `ssh-add -l`.
  ```bash
  ssh-add ~/.ssh/id_rsa/hello_ssh
  ```


- [Telling Git about your SSH key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-ssh-key)...TO_BE_CONTINUED

Also see [Signing tags](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-tags)

CHECKPOINT: 
- see the error message: [Error: Input required and not supplied: key](https://github.com/okatsn/DataFrameTools.jl/runs/8149226032?check_suite_focus=true)
- [GitHub Action YAML 撰寫技巧 - 環境變數(Environment Variables) 與 秘密 (Secrets)]https://ithelp.ithome.com.tw/articles/10263300?sc=iThomeR
- [Quickly set up GitHub SSH example](https://www.theserverside.com/blog/Coffee-Talk-Java-News-Stories-and-Opinions/GitHub-SSH-Key-Setup-Config-Ubuntu-Linux)
- [SSH Keys for GitHub](https://jdblischak.github.io/2014-09-18-chicago/novice/git/05-sshkeys.html)
- [設定 Github SSH 金鑰 feat. Github SSH、HTTPS 的差異](https://ithelp.ithome.com.tw/articles/10205988)

## Tag
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


### Github Actions
[Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)

#### secrets
[Set it here as an example](https://github.com/okatsn/DataFrameTools.jl/settings/secrets/actions)



#### Syntax
Trigger a workflow
- `on: events_that_trigger_workflows`
  - [on](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on) 
  - [events-that-trigger-workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows)
- run based on what file paths are changed
  - [on.<push|pull_request|pull_request_target>.<paths|paths-ignore>](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpull_request_targetpathspaths-ignore)
  


#### Julia Actions
An organisation to host and maintain GitHub Actions useful for Julia projects.
see https://github.com/julia-actions

#### YAML script
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


