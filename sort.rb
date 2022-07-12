array = [10, 8, 3, 5, 2, 4, 11, 18, 20, 33]
number = array.size
x=0

while x < number do
    for i in 0..number-2
        if array[i] < array[i+1]
            array[i] , array[i+1] = array[i+1], array[i]
        end
    end
    x += 1
end

p array


# for i in 0..8
#     if array[i] < array[i+1]
#         a = array[i] 
#         b = array[i+1]
#         a,b = b,a
#         array[i] = a
#         array[i+1] = b 
#     end
# end
# この時点で[10, 8, 5, 3, 4, 11, 18, 20, 33, 2]
# => 10回繰り返せばよい




