/* This script Copyright (c) 2008 Collaborganize
* and distributed under the GPL (see below)
* 
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public License
* as published by the Free Software Foundation; either version 2
* of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details, published at 
* http://www.gnu.org/copyleft/gpl.html
* 
* Author: Eugen Mayer
*/
/* ******** Settings *********/
// TODO: provide settings for that
if(!window.SKIN) {
	window.SKIN = {};
}
window.SKIN.ajaxreqskin = "ajax,pattern";

if(!window.Foswiki.actionHandlers) {
	window.Foswiki.actionHandlers = {};
}
window.Foswiki.actionHandlers.login = "generalDialogActionHandler";
window.Foswiki.actionHandlers.attach = "generalDialogActionHandler";
window.Foswiki.actionHandlers.rename = "generalDialogActionHandler";
window.Foswiki.actionHandlers.rdiff = "generalDialogActionHandler";
window.Foswiki.actionHandlers.register = "generalDialogActionHandler";
window.Foswiki.actionHandlers.rest = "generalDialogActionHandler";
window.Foswiki.actionHandlers.search = "generalDialogActionHandler";
window.Foswiki.actionHandlers.changes = "generalDialogActionHandler";
window.Foswiki.actionHandlers.manage = "generalDialogActionHandler";
window.Foswiki.actionHandlers.oops = "generalDialogActionHandler";

window.Foswiki.actionHandlers.view = "generalActionHandler";