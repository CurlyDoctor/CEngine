local MyUtil = {}

function MyUtil:addOn()

    return {
        function do(n)

            return n ^ 2
        end
    }
end

return MyUtil