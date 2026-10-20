local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

return {
    -- Main program
    s("main", {
        t("#include <stdio.h>"),
        t({ "", "", "int main(int argc, char** argv) {" }),
        t({ "", "    " }),
        i(1),
        t({ "", "", "    return 0;" }),
        t({ "", "}" }),
    }),

    -- printf
    s("printf", {
        t('printf("'),
        i(1),
        t('\\n");'),
    }),

    -- scanf
    s("scanf", {
        t('scanf("%'),
        i(1, "d"),
        t('", &'),
        i(2, "var"),
        t(");"),
    }),

    -- i loop
    s({ trig = "for", name = "For loop (custom)" }, {
        t("for (int "),
        i(1, "i"),
        t(" = "),
    	i(2, "0"),
    	t("; "),
    	rep(1),
    	t(" < "),
    	i(3, "n"),
    	t("; "),
    	rep(1),
    	t("++) {"),
    	t({ "", "    " }),
    	i(4),
    	t({ "", "}" }),
    }),

    -- Reverse for loop
    s("forr", {
        t("for (int "),
        i(1, "i"),
        t(" = "),
        i(2, "n - 1"),
        t("; "),
        rep(1),
        t(" >= 0; "),
        rep(1),
        t("--) {"),
        t({ "", "    " }),
        i(3),
        t({ "", "}" }),
    }),

    -- While loop
    s("while", {
        t("while ("),
        i(1, "condition"),
        t(") {"),
        t({ "", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- If
    s("if", {
        t("if ("),
        i(1, "condition"),
        t(") {"),
        t({ "", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- If-else
    s("ife", {
        t("if ("),
        i(1, "condition"),
        t(") {"),
        t({ "", "    " }),
        i(2),
        t({ "", "} else {" }),
        t("    "),
        i(3),
        t({ "", "}" }),
    }),

    -- Function
    s("func", {
        i(1, "int"),
        t(" "),
        i(2, "functionName"),
        t("("),
        i(3),
        t(") {"),
        t({ "", "    " }),
        i(4),
        t({ "", "}" }),
    }),

    -- Integer array
    s("arr", {
        t("int "),
        i(1, "arr"),
        t("["),
        i(2, "n"),
        t("];"),
    }),

    -- Array length
    s("arrlen", {
        t("sizeof("),
        i(1, "arr"),
        t(") / sizeof("),
        rep(1),
        t("[0])"),
    }),
}
