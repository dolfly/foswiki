/*
  Copyright (C) 2010     Paul.W.Harvey@csiro.au, http://trin.org.au
  All Rights Reserved.                  http://www.anbg.gov.au/cpbr

  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version. For
  more details read LICENSE in the root of the Foswiki distribution.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  As per the GPL, removal of this notice is prohibited.
*/
'use strict';
(function() {
    tinymce.PluginManager.requireLangPack('tabletools');

    tinymce.create('tinymce.plugins.TableTools', {
        init: function(ed, url) {
            this._setupCleanButton(ed, url);
            //this._setupCopyButton(ed, url);
            this.stickybits = this._loadStickybits(ed);

            return;
        },

        _getPref: function (key) {
            return foswiki.getPreference('TinyMCETableToolsPlugin.' + key);
        },

        // Populates a single tag literal/pattern item with 
        // literal/pattern attributes
        _loadStickyAttributes: function(ed, index) {
            var stickyattributes = {
                    attributes: {},
                    attributesNotSticky: {},
                    attributePatterns: []
                },
                _getPref = ed.plugins.tabletools._getPref,
                attributeString = _getPref(index + '.attributes'),
                attributePatternsSize = 
                    _getPref(index + '.attributePatterns.size'),
                i = 0;
            
            if (attributeString) {
                jQuery.each(attributeString.split(/,\ */), function (index, value) {
                    stickyattributes.attributes[value] = value;
                });
            }
            if (attributePatternsSize) {
                for (i = 0; i < attributePatternsSize; i = i + 1) {
                    stickyattributes.attributePatterns.push(new
                        RegExp(_getPref(index + '.attributePatterns.' + i)));
                }
            }

            return stickyattributes;
        },

        // Populate the stickybits object with
        // literal tag names and pattern tags with their corresponding literal
        // attributes and pattern attributes
        _loadStickybits: function(ed) {
           var stickybits = { 
                   tags: {},
                   tagPatterns: [],
                   tagsPatternTested: {},
                   tagsNotSticky: {}
               },
               _getPref = ed.plugins.tabletools._getPref,
               size = _getPref('size'),
               i,
               tag,
               attributes;

           for (i = 0; i < size; i = i + 1) {
               tag = _getPref(i + '.tag');
               attributes =
                   ed.plugins.tabletools._loadStickyAttributes(ed, i);
               /* Populate literal tags */
               if (tag) {
                   stickybits.tags[tag] = attributes;
               } else {
                   /* Populate regex tags */
                   stickybits.tagPatterns.push({
                       pattern: new RegExp(_getPref(i + '.tagpattern')),
                       attributes: attributes.attributes,
                       attributePatterns: attributes.attributePatterns,
                       attributesNotSticky: attributes.attributesNotSticky
                   });
               }
           }

           return stickybits;
        },

        cleanbutton_state: 1, // Set an unrecognised state to force update

        getInfo: function() {
            return {
                longname: 'Table Tools Plugin',
                author: 'Paul.W.Harvey@csiro.au',
                authorurl: 'http://trin.org.au/HubRIS',
                infourl: 'http://foswiki.org/Extensions/TinyMCETableToolsPlugin',
                version: 1
            };
        },

        _setupCleanButton: function(ed, url) {
            /* Register a "is it a table?" format with TinyMCE's formatter,
            ** which isn't available during plugin init */
            ed.onInit.add(function(ed) {
                ed.formatter.register('TableToolsTable',
                    { selector: 'table,thead,tbody,tfoot,cols,td,th' });

                return;
            });
            ed.addCommand('tabletoolsclean', function() {
                this.plugins.tabletools.cleanTable(ed, this.selection.getNode());

                return;
            });
            ed.addButton('tabletoolsclean', {
                title: 'tabletools.clean_desc',
                cmd: 'tabletoolsclean',
                image: url + '/img/clean.png'
            });
            // Register nodeChange event to update button state
            ed.onNodeChange.add(this._nodeChangeClean, this);

            return;
        },

        /* Remove all sticky attributes from all nodes that are descendents
           of the table that is assumed to be an ancestor containing the node
           passed in
           SMELL: assumes node passed in is contained within a table!
           TODO: This doesn't need to be table-specific; make this a generic
                 clean method that can clean any valid selection
         */
        cleanTable: function(ed, node) {
            var tableNode = jQuery(node).closest('table')[0],
                valid_table_children = 'colgroup, thead, tbody, tfoot, col, tr';

            // Remove children of the <table> that WysiwygPlugin can't deal with
            jQuery(tableNode).children(':not(' + valid_table_children + ')').
                empty().remove();
            // Remove invalid children of the valid table children
            if ( jQuery(tableNode).children('tr').length > 0 ) {
                // No <tbody> tag, HTML3 style
                jQuery(tableNode).children('tr').children(':not(th,td)').
                    empty().remove();
            } else {
                jQuery(tableNode).children('tbody').children(':not(tr)').
                    empty().remove();
                jQuery(tableNode).children('tbody').children('tr').
                    children(':not(th,td)').empty().remove();
            }
            // Remove sticky attributes from what's left
            this._removeStickyAttributes(ed, tableNode);

            return;
        },

        // Remove sticky attributes from all descendent nodes and the node
        // passed in
        _removeStickyAttributes: function (ed, node) {
            ed.plugins.tabletools._removeStickyAttributesFromNode(
                ed, matchingNode);
            jQuery(node).find('*').each(function (index, matchingNode) {
                ed.plugins.tabletools._removeStickyAttributesFromNode(
                    ed, matchingNode);
            });

            return;
        },

        // Scan through a node's attributes and remove them if they are known to
        // be sticky
        _removeStickyAttributesFromNode: function(ed, node) {
            var tagName = node.nodeName.toLowerCase(),
                tabletools = ed.plugins.tabletools,
                nodeattr;
            for (i in node.attributes) {
                if (!isNaN(i)) {
                    nodeattr = node.attributes[i];
                    if (nodeattr && tabletools.stickybits.tags[tagName] &&
                        tabletools.stickybits.tags[tagName].
                        attributes[nodeattr.nodeName]) {
                        jQuery(node).removeAttr(nodeattr.nodeName);
                    }
                }
            }
        },

        _setupCopyButton: function(ed, url) {
            // Register commands
            ed.addCommand('tabletoolscopy', function() {

                return;
            });

            // Register buttons
            ed.addButton('tabletoolscopy', {
                title: 'tabletools.copy_desc',
                cmd: 'tabletoolscopy',
                image: url + '/img/copy.png'
            });

            return;
        },

        _nodeChangeClean: function(ed, cm, node, collapsed) {
            var is_clean_title = ed.getLang('tabletools.is_clean'),
                is_unclean_title = ed.getLang('tabletools.is_unclean'),
                clean_desc_title = ed.getLang('tabletools.clean_desc'),
                tabletools = cm.editor.plugins.tabletools;
            if (!node) return;

            if ( ed.formatter.match('TableToolsTable') ) {
                if ( tabletools.isSticky(ed, jQuery(node).closest('table')[0]) ) {
                    tabletools._setCleanButtonState(cm, false, false, false, 'tabletools.is_unclean');
                } else {
                    tabletools._setCleanButtonState(cm, true, true, true, 'tabletools.is_clean');
                }
            } else {
                tabletools._setCleanButtonState(cm, null, true, false, 'tabletools.clean_desc');
            }

            return true;

        },

        // Checks that a node and all its descendents are free of sticky
        // attributes
        isSticky: function (ed, node) {
            var isStickyNode = this.isStickyNode,
                descendents,
                sticky = false,
                i;

            // Check the node passed in
            if (isStickyNode(ed, node)) {
                return true;
            }
            // Check all descendents of the node passed in
            descendents = jQuery(node).find('*');
            for (i in descendents) {
                if (!isNaN(i) && isStickyNode(ed, descendents[i])) {
                    sticky = true;
                    break;
                }
            }

            return sticky;
        },
        
        // Check that just the node given is sticky
        isStickyNode: function (ed, node) {
            var tagName = node.nodeName.toLowerCase(),
                tabletools = ed.plugins.tabletools,
                sticky = false;

            if (tabletools._hasStickyNodeName(node, tagName) &&
                tabletools._hasStickyAttributes(node, tagName)) {
                sticky = true;
            }
            
            return sticky;
        },

        /* Check that a node/tag name should be checked for sticky attributes.
           SMELL: this method is tangled up with _hasStickyAttributes()
         */
        _hasStickyNodeName: function (node, tagName) {
            var stickybits = this.stickybits,
                sticky = false;

            if (!tagName) {
                tagName = node.nodeName.toLowerCase();
            }
            if (stickybits.tags[tagName]) {
                sticky = true;
            } else if (stickybits.tagsNotSticky[tagName]) {
                //sticky = false;
            }
            // if this tag hasn't been matched against the patterns before
            if (!stickybits.tagsPatternTested[tagName]) {
                // Remember
                stickybits.tagsPatternTested[tagName] = true;
                // try to match node name against the regexes
                jQuery(stickybits.tagPatterns).each(
                    function (index, tagPattern) {
                        if (tagPattern.pattern.exec(tagName)) {
                            // Cache this tag name as sticky
                            // Actually, this step is also necessary
                            // to get the (tag) pattern's attributes checked
                            if (typeof(stickybits.tags[tagName]) === 'object') {
                                jQuery.extend(true,
                                    stickybits.tags[tagName], tagPattern);
                            } else {
                                stickybits.tags[tagName] = tagPattern;
                            }
                            sticky = true;
                        }
                    }
                );
                if (!sticky) {
                    // Cache this tag name as not sticky
                    stickybits.tagsNotSticky[tagName] = true;
                    //sticky = false;
                }
            }

            return sticky;
        },

        /* Check a node for sticky attributes
           SMELL: _hasStickyNodeName() really must be called prior to this,
           in order to set up previously unencountered tag/node-names properly
         */
        _hasStickyAttributes: function (node, tagName) {
            var sticky = false,
                stickytag = this.stickybits.tags[tagName],
                i,
                nodeattr,
                checkPattern = function (index, pattern) {
                    if (pattern.exec && pattern.exec(nodeattr)) {
                        // Cache this attribute as sticky
                        stickytag.attributes[nodeattr] = nodeattr;
                        sticky = true;
                    }
                };

            /* For efficiency, assume that most nodes will have no attributes.
               Iterate over node attributes checking against sticky attributes

               If none of the attributes match any of the literal sticky
               attributes, then check against each of the sticky patterns.

               If the check matches, cache as a literal attribute so it's not
               pattern matched again in future.

               If the check doesn't match, cache it into attributesNotSticky
               for the same reason
            */
            if (!tagName) {
                tagName = node.nodeName.toLowerCase();
            }
            for (i in node.attributes) {
                /* After cleaning with jQuery.removeAttr(), node.attributes[i]
                   may still be enumerated but undefined */
                if (!isNaN(i) && node.attributes[i]) {
                    nodeattr = node.attributes[i].nodeName;
                    // If the literal attribute exists for the literal tagname
                    if (stickytag.attributes[nodeattr] !== undefined) {
                        sticky = true;
                        break;
                    } else if (stickytag.attributesNotSticky[nodeattr]) {
                        /* These are our attributes cached as not matching
                           any of this tag's attribute patterns */
                        break;
                    } else {
                        // else try to match the attribute against the regexes
                        if (stickytag.attributePatterns) {
                            jQuery(stickytag.attributePatterns).
                                each(checkPattern);
                        }
                        if (!sticky) {
                            // Cache this attribute as not sticky
                            stickytag.attributesNotSticky[nodeattr] = true;
                            break;
                        }
                    }
                }
            }

            return sticky;
        },

        _setCleanButtonState: function(cm, skipstate, disabled, active, title_key) {
            var buttonId, title_value;

            // Skip these checks if the state hasn't changed
            if ( (this.cleanbutton_state !== skipstate) ) {
                buttonId = '#' + cm.prefix + 'tabletoolsclean';
                title_value = cm.editor.getLang(title_key);
                this.cleanbutton_state = skipstate;
                cm.setDisabled('tabletoolsclean', disabled);
                cm.setActive('tabletoolsclean', active);
                jQuery(buttonId).attr('title', title_value);
                cm.controls[cm.prefix + 'tabletoolsclean'].settings.title = title_value;
            }

            return;
        }
    });

    // Register plugin
    tinymce.PluginManager.add('tabletools', tinymce.plugins.TableTools);
})();
