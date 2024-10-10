## set in ~/.ipython/profile_default/startup/01-pandas-options.py
## See ipython --help-all to read about profiles.
## Also try `pd.describe_option()` in your repl

import pandas as pd, numpy as np, subprocess
twidth = int(subprocess.check_output("tput cols", shell=TRUE))-20

## pd.set_option("display.width",120) ## set this from what is reported by `tput cols`
pd.set_option("display.max_rows",6)
pd.set_option("display.max_colwidth", twidth)
pd.set_option("display.max_seq_items",20)
pd.set_option("display.html.table_schema",True)
pd.set_option("display.date_yearfirst",True)
pd.set_option("display.memory_usage","deep")
pd.set_option("display.precision",3)
pd.set_option("display.float_format",lambda x: f"{x:_}") ## aids me with larger numbers
pd.set_option("display.show_dimensions",True)
pd.set_option("mode.copy_on_write",True) ## introduced in pandas 2.0.0
np.set_printoptions(linewidth=twidth)
