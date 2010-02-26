---+ NEW FOSWIKI SKIN - HTML PROTOTYPE

Version: 0.1    

Author: Carlo Schulz

Date: 23.02.2010


---++ HTML files:

   * the VIEW screen is the only exisiting screen so far

   * "empty_topic.html" contains a topic in an empty a.k.a. newly created state

   * "example_topic.html" contains real content from foswiki.org with meta data tabs being populated

   * usable components are:
      * the drop downs for topic interactions
      * the meta data tabs at the bottom
      * the sidebar

   * note: there is a lot of js code within just pasted in the html head 
      * as this is a prototype no thoughts about performance issues were spent.



---++ css directory:

   * the css responisble for layout, colors and stuff is in foswiki_screen

   * to allow better overview during devolpment the css is split into multiple files depending on purpose
      * eg. sidebar, header, footer, etc - need to merge them later if used for production

   * the are no naming conventions in place :(

   * all images are in foswiki_images - no naming conventions either :(

   * foswiki_patches contains css hacks for IE6

 

---++ yaml directory:

   * the prototype is based on the YAML framework
  
   * the "yaml" directory contains all yaml core files, doccu and additional java-script (jQuery + plugins)