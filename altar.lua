--+----------------------------------------------------------------------+--
--| BM Altar Automation                                                  |--
--|                                                                      |--
--| MIT License                                                          |--
--| Copyright (c) 2021 kobi32768                                         |--
--| https://github.com/kobi32768/BM-Altar-Automation/blob/master/LICENSE |--
--+----------------------------------------------------------------------+--

-- Variables
local altar   = peripheral.wrap("front")
local inChest = peripheral.wrap("top")
local dropCount           = 2
local droppedCount        = 0
local toProcessCount      = 0
local proceedCount        = 0
local processingItemName  = ""
local waitingLogDisplayed = false

-- Functions
function isExistItems(container)
    if next(container.list()) then
        return true
    else
        return false
    end
end

function tick(t)
    return t/20
end

function waitingLog()
    term.setTextColor(colors.lightGray)
    print("Waiting for Items...")
end

function importLog()
    term.setTextColor(colors.blue)
    term.write("Import")
    term.setTextColor(colors.white)
    term.write(" - ")
    term.setTextColor(colors.lightGray)
    print(turtle.getItemDetail(1)["count"].." "..turtle.getItemDetail(1)["name"])
end

function exportLog()
    term.setTextColor(colors.orange)
    term.write("Export")
    term.setTextColor(colors.white)
    term.write(" - ")
    term.setTextColor(colors.lightGray)
    print(turtle.getItemDetail(2)["count"].." "..turtle.getItemDetail(2)["name"])
end

-- Main
while true do
    -- 素材待機
    while (not isExistItems(inChest)) and (turtle.getItemDetail(1) == nil) do
        if not waitingLogDisplayed then
            waitingLog()
            waitingLogDisplayed = true
        end
        os.sleep(2)
    end
    waitingLogDisplayed = false

    -- 素材搬入
    turtle.select(1)
    if turtle.getItemDetail(1) == nil then
        turtle.suckUp()
        importLog()
        processingItemName = turtle.getItemDetail(1)["name"]
        toProcessCount     = turtle.getItemDetail(1)["count"]
    end

    if turtle.getItemDetail(1)["count"] >= dropCount then
        droppedCount = dropCount
    else
        droppedCount = turtle.getItemDetail(1)["count"]
    end

    turtle.drop(dropCount)

    -- 成果物搬出
    while true do
        if altar.getItemDetail(1)["name"] ~= processingItemName then
            turtle.select(2)
            turtle.suck()
            proceedCount = proceedCount + droppedCount

            if proceedCount == toProcessCount then
                turtle.turnRight()
                exportLog()
                turtle.drop()
                turtle.turnLeft()
                proceedCount = 0
            end

            break
        end
        os.sleep(tick(5))
    end
end
