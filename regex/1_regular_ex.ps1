# literal
"kapilkathuria" -match "kapil"

# dot is single char
"kapilkathuria" -match "k..."
$Matches

# match anywhere, return true
"kapilkathuria" -match "kath[uri]a"

# match none of thes
"kapilkathuria" -match "kath[^uxy]ria"

# char range 
"kapilkathuria" -match "kath[u-z]r"
$Matches

# escape characters
# \ 
"kapil@gmail.com" -split "\."

# \w - word characters
"kapil@gmail.com" -match "\w"

# \W - non word char
"kapil@gmail.com" -match "\W"
$Matches[0]

# \s - space
"kapil@gmail .com" -match "\s"

# \d - digit
"kapil@gmail1.com" -match "\d"
$Matches

# {n} - returns first n values after word match
"asdf1234" -match '\w{3}'

# {n,} - at least n matches
"asdf1234" -match '\w{3,}'

# w+
"asdf1234" -match '\w+'
$Matches

# {n,m} - at least n but no more than m
"asdf1234" -match '\w{3,5}'

# csplit - case sensitive matches


## query group ##
"contoso\administartor" -match "(\w+)\\(\w+)"

# add the keys
"contoso\administartor" -match "(?<domain>\w+)\\(?<username>\w+)"

$str = "Kapil Kathuria"
$str -replace "(\w+)\s(\w+)", '$2 $1'

$str = "AK12 567"
$str -replace "(\w+)\s(\w+)", '$2 $1'

# regex advanced
# regex namespace from .net can be used
$data = "1abc234"
$pattern = "\d"
[regex]::Match($data, $pattern).value
[regex]::Matches($data, $pattern).value

# 
# * - zero or more
#  ? - zero or one
# \p{name} - special char like Greek, Cyrillic etc. 
# | : logical OR
"somebody@contoso.com" -match "\.(com|net)"
$Matches
# ^ : beginning character
"somebody contoso com" -match "^c(\w+)"

# $ : end characters

# Mode modifiers
# (?i): ignore case
# (?m): multi line - apply to multi line
# (?s): single line - apply to single line

# select string with regex - similar to grep in linux
# Select-String
Get-EventLog -LogName Application | Select-String -InputObject {$_.Message} -Pattern "\dx\w\d+" | Out-File .\logs\error.log
