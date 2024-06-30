# Deep Dive
# https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-5.1

# Array is collection of values or objects

# Empty array
$data = @()
$data.Count

# array
$data = @('zero', 'one', 'two', 'three')
$data.Count
$data

# other way of declaring
# author preferes this way as it is easier to read 
# and easire to compare in version control
$data = @(
  'zero'
  'one'
  'two'
)

# other way
$data = 'zero', 'one', 'two'

# accesing items 
$data[0]
$data[0,3]
$data[-1]
$data[0..1]
# Below is item 1, 0 and last item
$data[1..-1]

# Out of bounds
# other lang returns error, BUT PS returns nothing
$null -eq $data[5]

# get uppder bound
$data.GetUpperBound(0)
$data[$data.GetUpperBound(0)]

# updating items
$data[0] = 'Ziro'
$data[0]

# iteration

$data | ForEach-Object{"Item: $PSItem"}
# $PSItem above is same as $_

# foreach
foreach($item in $data)
{
  "Item: $item"
}

$data.ForEach({"$_"})

# For loop
for ($i=0; $i -lt $data.Count; $i++)
{
  "item: {0}" -f $data[$i]
}

# switch loop
switch ($data) {
  'one' { 'its one' }
  'two' { 'its two' }
  Default {'something else'}
}

# updating values to start
# https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-arrays?view=powershell-5.1#updating-values