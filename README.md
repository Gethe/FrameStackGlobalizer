FrameStackGlobalizer
====================

In patch 8.2, a change was made to the FrameStackTooltip that resulted in it being unable to display the global name for most frames and regions. This addon is an attempt at restoring that key functionality.

![before and after comparison](https://i.imgur.com/eGxZydQ.png)


Update: There is a new cvar, `fstack_preferParentKeys`, that when set to `0` will perform a similar function to this addon. Credit to Leatrix for tipping me off to this.
