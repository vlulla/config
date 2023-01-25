## set in ~/.ipython/profile_default/startup/01-pandas-options.py
## See ipython --help-all to read about profiles.

import pandas as pd

pd.set_option("display.width",120)
pd.set_option("display.max_rows",6)
pd.set_option("display.max_colwidth",50)
pd.set_option("display.max_seq_items",20)
pd.set_option("display.html.table_schema",True)
