return {
  s("func", { c(1, {
      sn(1, {
        t('func '), r(1, "user_text"), t({ '() {', '' }),
        t('  '), i(0, 'FunctionText'),
        t({ '', '}' })
      }),
      sn(2, {
        t('func('), i(2, "struct"), t(') '), r(1, "user_text"), t({ '() {', '' }),
        t('  '), i(0, 'FunctionText'),
        t({ '', '}' })
      }),
    }) },
    {
      stored = {
        ["user_text"] = i(1, "FunctionName"),
        ["function_text"] = i(0, "FunctionText")
      }
    })
}
