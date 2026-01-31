import sys
try:
  import polars as pl

  pl.Config.set_tbl_column_data_type_inline(True)
  pl.Config.set_tbl_dataframe_shape_below(True)
  pl.Config.set_tbl_formatting(format="NOTHING")
  pl.Config.set_tbl_hide_column_data_types(True)
except ModuleNotFoundError as e:
  print(f"{e=}", file=sys.stderr)
