#!/usr/bin/gmake -f
#
# This plugin is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This plugin is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this plugin.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright © 2023 OOTA, Masato


LANGS=ja
XML=plugin.xml
LUA=events/local_system_map_seller.lua

GETTEXTDIR=gettext
ITS=$(GETTEXTDIR)/its/translation.its
POTFILE=$(GETTEXTDIR)/easy_mapping.pot
MOFILES=$(LANGS:%=$(GETTEXTDIR)/%/LC_MESSAGES/naev.mo)

pot: $(POTFILE)
mo: $(MOFILES)


$(POTFILE): $(XML) $(LUA) $(ITS)
	@( xgettext --its=$(ITS) $(XML) -o - ; echo ; \
	  ( xgettext --from-code UTF-8 $(LUA) -o - | sed '0,/^$$/d' ) ) > $@
	@echo Create $(LANGS:%=\"$(GETTEXTDIR)/%.po\") from \"$@\", and then run \"make mo\".


$(GETTEXTDIR)/%/LC_MESSAGES/naev.mo: $(GETTEXTDIR)/%.po
	mkdir -p $(dir $@)
	msgfmt $^ -o $@

clean:
	-rm $(POTFILE) $(MOFILES)
