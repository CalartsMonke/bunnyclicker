local Debugchart = {}
Debugchart.chart = {}

function Debugchart:AddToChart(string)
    table.insert(Debugchart.chart, string)
end


function Debugchart:DrawDebugMessage(x, y, xsep, ysep)
    for i=1, #Debugchart.chart do
        love.graphics.print(Debugchart.chart[i], x + (xsep * i) - xsep, y + (ysep * i) - ysep)

        if i == #Debugchart.chart then
            --get rid of all strings in the table
            for y = #Debugchart.chart, 1, -1 do
                table.remove(Debugchart.chart, y)
            end
        end
    end
end

return Debugchart

