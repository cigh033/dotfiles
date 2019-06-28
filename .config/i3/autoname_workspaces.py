# -*- coding: utf-8 -*-

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by inserting them into WINDOW_ICONS below.
#
# Dependencies
# * xorg-xprop - install through system package manager
# * i3ipc - install with pip


import i3ipc
import subprocess as proc
import re
import signal
import sys


# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names and the icons can be any text you want to display. However
# most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
MDI_TERMINAL = ''
MDI_CHROME = ''
MDI_CODE = ''
MDI_SPOTIFY = ''
MDI_PICTURE = ''
MDI_PDF = ''
MDI_FILES = ''
MDI_VIM = ''
MDI_ENPASS = ''
MDI_VOLUME = ''
MDI_VIDEO = ''
MDI_EMAIL = ''
MDI_STEAM = ''
MDI_CALENDAR = ''
MDI_SLACK = ''
MDI_ZOOM = ''

WINDOW_ICONS = {
    'gnome-terminal-server': MDI_TERMINAL,
    'google-chrome': MDI_CHROME,
    'sublime_text': MDI_CODE,
    'org.gnome.gedit': MDI_CODE,
    'spotify': MDI_SPOTIFY,
    'Spotify': MDI_SPOTIFY,
    'feh': MDI_PICTURE,
    'zathura': MDI_PDF,
    'nautilus': MDI_FILES,
    'vim': MDI_VIM,
    'gvim': MDI_VIM,
    'nvim': MDI_VIM,
    'neovim': MDI_VIM,
    'Enpass' : MDI_ENPASS,
    'Pavucontrol' : MDI_VOLUME,
    'vlc' : MDI_VIDEO,
    'mpv' : MDI_VIDEO,
    'feh' : MDI_PICTURE,
    'geary' : MDI_EMAIL,
    'Steam' : MDI_STEAM,
    'evolution' : MDI_CALENDAR,
    'slack' : MDI_SLACK,
    'zoom' : MDI_ZOOM
}


i3 = i3ipc.Connection()

# Returns an array of the values for the given property from xprop.  This
# requires xorg-xprop to be installed.
def xprop(win_id, property):
    try:
        prop = proc.check_output(['xprop', '-id', str(win_id), property], stderr=proc.DEVNULL)
        prop = prop.decode('utf-8')
        return re.findall('"([^"]+)"', prop)
    except proc.CalledProcessError as e:
        print("Unable to get property for window '%s'" % str(win_id))
        return None

def icon_for_window(window):
    classes = xprop(window.window, 'WM_CLASS')
    if classes != None and len(classes) > 0:
        for cls in classes:
            if cls in WINDOW_ICONS:
                return WINDOW_ICONS[cls]
        print('No icon available for window with classes: %s' % str(classes))
    return ''

# renames all workspaces based on the windows present
def rename():
    for workspace in i3.get_tree().workspaces():
        icons = [icon_for_window(w) for w in workspace.leaves()]
        icon_str = ' ' + ''.join(set(icons)) if len(icons) else ''
        new_name = str(workspace.num) + icon_str
        i3.command('rename workspace "%s" to "%s"' % (workspace.name, new_name))

rename()

# exit gracefully when ctrl+c is pressed
def signal_handler(signal, frame):
    # rename workspaces to just numbers on exit to indicate that this script is
    # no longer running
    for workspace in i3.get_tree().workspaces():
        i3.command('rename workspace "%s" to "%d"' % (workspace.name, workspace.num))
    i3.main_quit()
    sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)

# call rename() for relevant window events
def on_change(i3, e):
    if e.change in ['new', 'close', 'move']:
        rename()
i3.on('window', on_change)
i3.main()
