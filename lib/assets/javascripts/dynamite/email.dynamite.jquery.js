
(function(){
  var type = new DynamiteType();
  
  type.name = function(){
    return "email";
  };
  
  type.previewHtml = function(){
    return "<input type=\"text\" value=\"(email)\" disabled />";
  };
  
  Dynamite.addType(type);
})();
