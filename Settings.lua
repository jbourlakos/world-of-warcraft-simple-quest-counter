----
-- Settings
----

SimpleQuestCounter.Settings = {

    questMaxLimitColor = { 252/255, 10/255, 10/255 }, -- red
    questMidLimitColor = { 255/255, 255/255, 0/255}, -- yellow
    -- questMinLimitColor = { 255/255, 255/255, 255/255 }, -- pure white
    questMinLimitColor = { 10/255, 245/255, 10/255 }, -- green
    fontTemplate = "GameFontHighlightSmall",
    fontStringDepthLevel = "ARTWORK",
    fontStringAlpha = 1, -- 0.0 (transparent) to 1.0 (opaque),
    verticalOffsetToHeightFactor = 1.9,
    horizontalOffsetToWidthFactor = 0.15,
    shadowColor = {0, 0, 0, 0.75}, -- {r,g,b,a}
    shadowOffsetToFontHeightRatio = 0.15,
    fontStringTextFormat = "Quests: %d / %d", -- TODO: localize
    fontSizeAdjustment = 1.75, -- multiplier relative to parent's default font size
    tooltipTitle = "Quests per category", -- TODO: localize
    tooltipLineFormat = "%s |ce0dddd00(%d)|r", -- header (count)
    tooltipLineColor = {1, 1, 1}, -- white
    --
    backdropColor = { 255/255, 255/255, 255/255, 128/255},

    activateObjectiveTrackerLabel = true,
    activateQuestCounterFrame = true,
    activateQuestLogEntries = true,


}
