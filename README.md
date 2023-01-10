<!--
This plugin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This plugin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this plugin.  If not, see <http://www.gnu.org/licenses/>.

Copyright © 2023 OOTA, Masato
-->

# Easy Mapping Plugin for Naev
This is a plugin for [Naev](https://github.com/naev/naev).

This plugin makes easy to determine whether or not you know the entire information in the local system map, and also you can get the local system map without a landable spob and a landing.

When you enter a system:
1. If there is neither hail nor message: you know already the entire information in the local system map (or you don't have enough credits).
1. If you receive either hail or message: you don't grasp the entire information in the local system map.
	1. If you receive a hail from a map seller: you can buy the local system map (even if the system has no landable spob) but, of course, it's expensive.
	1. If you receive the message "There seems to be no map seller in this system.": you have to discover the information by yourself.

# Translation?
Naev seems not to support a translation for a plugin. Japanese players should remove gettext/ja/LC_MESSAGES/naev.mo.
