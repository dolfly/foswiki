
## Syntax

Pager elements are easy to use from either the server side or client side.  You can use current-page or current-offset, depending on your preference.

```
  <x-pager
    pages="10" 
    current-page="5"
    url="/articles?p={current-page}">
  </x-pager>
  
```

## Example

<x-pager
  pages="10" 
  current-page="5"
  url="/articles?p={current-page}">
</x-pager>


## Usage

```
  var pager = document.createElement('x-pager');
  pager.currentPage = 2;  // changes the page

  // or respond to a click/press
  pager.addEventListener('pagechanged', function(e){

    // e.target.href  == '/articles?p=1'
    // make ajax call with e.target.href

  });

```


