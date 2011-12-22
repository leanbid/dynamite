
(function(){
  var type = new DynamiteType();
  
  type.name = function(){
    return "textarea";
  };
  
  type.previewHtml = function(){
    return "<textarea cols=\"50\" rows=\"5\" disabled>(textarea)</textarea>";
  };
  
  Dynamite.addType(type);
})();
