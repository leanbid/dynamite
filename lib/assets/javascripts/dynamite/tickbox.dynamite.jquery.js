
(function(){
  var type = new DynamiteType();
  
  type.name = function(){
    return "tickbox";
  };
  
  type.previewHtml = function(){
    return "<input type=\"checkbox\" disabled /> (tickbox)";
  };
  
  Dynamite.addType(type);
})();
