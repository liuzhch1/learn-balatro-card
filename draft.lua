local array = {1, 2, 3, 4, 5}

table.remove(array, 3)
for _, v in ipairs(array) do
    print(v)
end
