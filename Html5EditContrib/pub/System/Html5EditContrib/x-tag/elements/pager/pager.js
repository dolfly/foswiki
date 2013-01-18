(function(){

var getNavPositions = function(data){
    return { 'first': 1, 'prev': data.current_page - 1, 'next': data.current_page + 1, 'last': data.pages };
  },
  getAttributes = function(elem){
    return { 
      current_page: Number(elem.getAttribute('current-page')),
      current_offset: Number(elem.getAttribute('current-offset')),
      page_size: Number(elem.getAttribute('page-size') || 10),
      pages: Number(elem.getAttribute('pages') || 10),
      padding: Number(elem.getAttribute('page-padding')|| -1),
      prevnext: elem.hasAttribute('prevnext'),
      firstlast: elem.hasAttribute('firstlast'),
      preventDefault: elem.hasAttribute('prevent-default') 
    }
  };

xtag.register('x-pager', {
  content: '<a pager-element="first">first</a>' +
        '<a pager-element="prev">previous</a>' +
        '<a pager-element="next">next</a>' +
        '<a pager-element="last">last</a>',
  setters:{
    'currentPage': function(value){
      this.setAttribute('current-page', value);
      xtag.tags['x-pager'].onInsert.call(this);
    }
  },
  events: {
    'click:touch:delegate(a)': function(e){
      var data = getAttributes(this.parentElement);

      if (!data.current_page && data.current_offset && data.page_size){              
        data.current_page = data.current_offset / data.page_size;
      }

      var pos = getNavPositions(data);
      for (var z in pos){
        if (this.getAttribute('pager-element') == z) var isNum = data.current_page = pos[z];
      }
      
      if (!isNum) data.current_page = Number(this.innerHTML);
      xtag.fireEvent(this, 'pagechanged');      
      if(data.preventDefault){
        e.preventDefault();
      }
      this.parentElement.currentPage = data.current_page;
    }
  },
  onInsert: function(){           
    var self = this,
      data = getAttributes(this),
      populated = this.children.length > 4;

    if (!data.current_page && data.current_offset && data.page_size){              
      data.current_page = data.current_offset / data.page_size;
    }

    var getUrl = function(itr_page){
      var url = self.getAttribute('url');
      return (!url) ? '#' : url.replace('{current-page}', itr_page).replace('{current-offset}', data.page_size * (itr_page-1));
    }
    
    var createPageItem = function(page, selected, txt){
      var elem = document.createElement('a');  
      elem.setAttribute('href', getUrl(page));
      elem.innerHTML = txt || page;
      if (selected) elem.setAttribute('selected', true);
      return elem;
    }
    
    var pos = getNavPositions(data);
    xtag.query(this, '[pager-element]').forEach(function(element){
      element.href = getUrl(pos[element.getAttribute('pager-element')]);
    });
    
    data.padding = data.padding == -1 ? data.pages : data.padding;
    var startIdx = data.current_page-data.padding < 1 ? 
      1 : 
        data.current_page + data.padding > data.pages ? 
        data.pages - (data.padding*2) : 
        data.current_page-data.padding;

    var endIdx = data.current_page+data.padding > data.pages ? 
      data.pages : 
        data.current_page-data.padding < 1 ? 
        (data.padding * 2) + 1 :
        data.current_page+data.padding;

    for (var i = startIdx; i <= endIdx; i++){
      if(populated){
        var page = this.children[i+2-startIdx];
        page.setAttribute('href', getUrl(i));
        page.setAttribute('selected', data.current_page == i);
        page.innerHTML = i;
      }else{
        var item = createPageItem(i, data.current_page == i);
        this.insertBefore(item, this.children[this.children.length-2]);
      }
    }

    this.setAttribute('hidefirst', data.firstlast && data.current_page == 1);
    this.setAttribute('hidelast', data.firstlast && data.current_page == data.pages);
    this.setAttribute('hideprev', data.prevnext && data.current_page == 1);
    this.setAttribute('hidenext', data.prevnext && data.current_page == data.pages);

  }
});

})();