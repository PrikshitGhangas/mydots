local ls = require("luasnip")

local f = ls.function_node
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep

return {
    -- Full Java program
    s({ trig = "main", name = "Java Main (custom)" }, {
        t("import java.util.Scanner;"),
        t({ "", "", "public class " }),
    
        f(function()
            return vim.fn.expand("%:t:r")
        end),
    
        t(" {"),
        t({ "", "    public static void main(String[] args) {" }),
        t({ "", "        Scanner sc = new Scanner(System.in);" }),
        t({ "", "", "        " }),
        i(1),
        t({ "", "", "        sc.close();" }),
        t({ "", "    }" }),
        t({ "", "}" }),
    }),

    --class
    s({ trig = "class", name = "Class (custom)" }, {
        t("class "),
        i(1, "ClassName"),
        t(" {"),
        t({ "", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- println
    s({ trig = "sout", name = "System.out.println (custom)" }, {
        t("System.out.println("),
        i(1),
        t(");"),
    }),

    -- print
    s({ trig = "print", name = "System.out.print (custom)" }, {
        t("System.out.print("),
        i(1),
        t(");"),
    }),

    -- Scanner
    s({ trig = "scan", name = "Scanner (custom)" }, {
        t("Scanner sc = new Scanner(System.in);"),
    }),

    -- For loop
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
    s({ trig = "forr", name = "Reverse for loop (custom)" }, {
        t("for (int "),
        i(1, "i"),
        t(" = "),
        i(2, "n - 1"),
        t("; "),
        rep(1),
        t(" >= "),
        i(3, "0"),
        t("; "),
        rep(1),
        t("--) {"),
        t({ "", "    " }),
        i(4),
        t({ "", "}" }),
    }),

    -- Enhanced for loop
    s({ trig = "foreach", name = "Enhanced for loop (custom)" }, {
        t("for ("),
        i(1, "int"),
        t(" "),
        i(2, "item"),
        t(" : "),
        i(3, "array"),
        t(") {"),
        t({ "", "    " }),
        i(4),
        t({ "", "}" }),
    }),

    -- While loop
    s({ trig = "while", name = "While loop (custom)" }, {
        t("while ("),
        i(1, "condition"),
        t(") {"),
        t({ "", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- If
    s({ trig = "if", name = "If statement (custom)" }, {
        t("if ("),
        i(1, "condition"),
        t(") {"),
        t({ "", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- If / else
    s({ trig = "ife", name = "If else (custom)" }, {
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

    -- Method
    s({ trig = "method", name = "Method (custom)" }, {
        i(1, "public"),
        t(" "),
        i(2, "void"),
        t(" "),
        i(3, "methodName"),
        t("("),
        i(4),
        t(") {"),
        t({ "", "    " }),
        i(5),
        t({ "", "}" }),
    }),

    -- Constructor
    s({ trig = "ctor", name = "Constructor (custom)" }, {
        i(1, "ClassName"),
        t("() {"),
        t({ "", "    " }),
        i(2),
        t({ "", "}" }),
    }),

    -- Integer array
    s({ trig = "arr", name = "Integer array (custom)" }, {
        t("int[] "),
        i(1, "arr"),
        t(" = new int["),
        i(2, "n"),
        t("];"),
    }),

    -- Scanner integer input
    s({ trig = "nexti", name = "Scanner nextInt (custom)" }, {
        t("int "),
        i(1, "n"),
        t(" = sc.nextInt();"),
    }),

    -- Scanner double input
    s({ trig = "nextd", name = "Scanner nextDouble (custom)" }, {
        t("double "),
        i(1, "value"),
        t(" = sc.nextDouble();"),
    }),

    -- Scanner string input
    s({ trig = "nexts", name = "Scanner nextLine (custom)" }, {
        t("String "),
        i(1, "str"),
        t(" = sc.nextLine();"),
    }),
}
