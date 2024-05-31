using InteractiveUtils, Pkg
## should go in ${HOME}/.julia/config/startup.jl

using DataFrames,StatsModels,GLM # some packages i use regularly

# some aliases...useful for interactive usage
q = quit = exit
dput = dump ## R's amazing dput!
ls = InteractiveUtils.varinfo
len = length ## so used to python's len

function update_pkgs()
  Pkg.update()
end

function repl_customize(repl)
  ## repl.hascolor = false
  ## repl.options.hascolor = false
  ## dump(repl)
end

atreplinit(repl_customize)
