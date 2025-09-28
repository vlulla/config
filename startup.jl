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

if isfile(expanduser("~/code/vl-utils/julia-utils.jl"))
  include(expanduser("~/code/vl-utils/julia-utils.jl"))
end

PLOTS_DEFAULTS = Dict(:markersize=>10, :markeralpha=>0.6, :legend=>false)

atreplinit(repl_customize)
