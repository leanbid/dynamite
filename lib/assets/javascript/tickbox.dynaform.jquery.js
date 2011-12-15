
(function(){
  var type = new DynaformType();
  
  type.name = function(){
    return "tickbox";
  };
  
  type.previewHtml = function(){
    return "<input type=\"checkbox\" disabled /> (tickbox)";
  };
  
  Dynaform.addType(type);
})();
