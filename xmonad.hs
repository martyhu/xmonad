-- Navigation:
-- Alt+F1..F10          switch to workspace
-- Ctrl+Alt+Left/Right  switch to previous/next workspace
-- Alt+Tab              focus next window
-- Alt+BackSpace        focus previous window (Meant to be in the CapsLock position but my layout is different)
-- Important: You will want to change this to xK_Caps_Lock if your Caps Lock key is in the NORMAL position.
--
-- Window management:
-- Win+F1..F10          move window to workspace
-- Win+Alt+F1..F10      move window to workspace and switch to that workspace
-- Win+Up/Down          move window up/down
-- Win+C                close window
-- Alt+ScrollUp/Down    move focused window up/down
-- Win+M                move window to master area
-- Win+N                refresh the current window
-- Alt+LMB              move floating window
-- Alt+MMB              resize floating window
-- Alt+RMB              unfloat floating window
-- Win+T                unfloat floating window
--
-- Layout management:
-- Win+Left/Right       shrink/expand master area
-- Win+W/V              move more/less windows into master area
-- Win+Space            cycle layouts
--
-- Other:
-- Win+Enter            start a terminal
-- Win+Q                restart XMonad
-- Win+I                opens your browser (currently set to 'google-chrome' which you can change)
-- Win+Shift+Q          display Gnome shutdown dialog

import XMonad
import XMonad.Config.Gnome
import qualified XMonad.StackSet as S
import qualified Data.Map as M
import XMonad.Actions.CycleWS
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders

-- display
-- replace the bright red border with a more stylish colour
myBorderWidth = 1
myNormalBorderColor = "#202030"
myFocusedBorderColor = "#A0A0D0"

-- terminal
myTerminal = "gnome-terminal --hide-menubar"

-- workspaces
myWorkspaces = ["web", "editor", "terms"] ++ (miscs 5) ++ ["fullscreen", "im"]
    where miscs = map (("misc" ++) . show) . (flip take) [1..]
isFullscreen = (== "fullscreen")

-- Mod4 is the Super / Windows key
myModMask = mod4Mask
altMask = mod1Mask

-- For the browser command.
browserCmd :: String
browserCmd = "google-chrome"

-- better keybindings for dvorak
myKeys conf = M.fromList $
    [ ((myModMask              , xK_Return), spawn $ XMonad.terminal conf)
    , ((myModMask              , xK_c     ), kill)
    , ((myModMask              , xK_space ), sendMessage NextLayout)
    , ((myModMask              , xK_n     ), refresh)
    , ((myModMask              , xK_m     ), windows S.swapMaster)
    , ((altMask                , xK_Tab   ), windows S.focusDown)
    , ((altMask .|. shiftMask  , xK_Tab   ), windows S.focusUp)
    , ((myModMask              , xK_Down  ), windows S.swapDown)
    , ((myModMask              , xK_Up    ), windows S.swapUp)
    , ((myModMask              , xK_Left  ), sendMessage Shrink)
    , ((myModMask              , xK_Right ), sendMessage Expand)
    , ((myModMask              , xK_t     ), withFocused $ windows . S.sink)
    , ((myModMask              , xK_w     ), sendMessage (IncMasterN 1))
    , ((myModMask              , xK_v     ), sendMessage (IncMasterN (-1)))
    , ((myModMask              , xK_q     ), broadcastMessage ReleaseResources >> restart "xmonad" True)
    -- Print Screen
    , ((myModMask              , xK_Print), spawn "gnome-screenshot")
    , ((myModMask .|. shiftMask, xK_Print), spawn "gnome-screenshot -a")
    -- Save Session
    , ((myModMask .|. shiftMask, xK_q), spawn "gnome-session-save --shutdown-dialog")
    , ((myModMask .|. shiftMask, xK_w), spawn "gnome-session-save --logout-dialog")
    -- Open Browser
    , ((myModMask              , xK_i), spawn browserCmd)
    , ((altMask .|. controlMask, xK_Left  ), prevWS)
    , ((altMask .|. controlMask, xK_Right ), nextWS)
    -- Volume control.
    , ((0, xK_F6), spawn "amixer --quiet set 'Master' 4-")
    , ((0, xK_F8), spawn "amixer --quiet set 'Master' 4+")
    ] ++
    -- Alt+F1..F10 switches to workspace
    -- (Alt is in a nicer location for the thumb than the Windows key,
    -- and 1..9 keys are already in use by Firefox, irssi, ...)
    [ ((altMask, k), windows $ S.greedyView i)
        | (i, k) <- zip myWorkspaces workspaceKeys
    ] ++
    -- mod+F1..F10 moves window to workspace and switches to that workspace
    [ ((myModMask, k), (windows $ S.shift i) >> (windows $ S.greedyView i))
        | (i, k) <- zip myWorkspaces workspaceKeys
    ]
    where workspaceKeys = [xK_F1 .. xK_F10]

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
    ])

myLayoutHook = noBorders Full ||| Tall 1 (3/100) (1/2)

main = xmonad gnomeConfig 
     { manageHook = myManageHook 
     , layoutHook = myLayoutHook
     , handleEventHook = fullscreenEventHook
     , terminal = myTerminal
     , borderWidth = myBorderWidth
     , normalBorderColor = myNormalBorderColor
     , focusedBorderColor = myFocusedBorderColor
     , modMask = myModMask
     , keys = myKeys
     }