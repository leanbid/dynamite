
(function(){
  var type = new DynaformType();
  
  type.name = function(){
    return "email";
  };
  
  type.previewHtml = function(){
    return "<input type=\"text\" value=\"(email)\" disabled />";
  };
  
  Dynaform.addType(type);
})();
